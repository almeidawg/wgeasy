<?php
/**
 * WNO MAS - API de Pedidos
 *
 * Endpoints:
 * GET    /pedidos.php              - Lista pedidos
 * GET    /pedidos.php?id=X         - Retorna pedido específico
 * POST   /pedidos.php              - Cria novo pedido
 * PUT    /pedidos.php?id=X         - Atualiza status do pedido
 */

require_once 'config.php';

$db = Database::getInstance()->getConnection();
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        getPedidos($db);
        break;
    case 'POST':
        createPedido($db);
        break;
    case 'PUT':
        updatePedido($db);
        break;
    default:
        sendError('Método não permitido', 405);
}

/**
 * Lista pedidos
 */
function getPedidos($db) {
    $id = isset($_GET['id']) ? intval($_GET['id']) : null;
    $status = isset($_GET['status']) ? sanitize($_GET['status']) : null;

    $sql = "
        SELECT
            p.id,
            p.numero,
            p.cliente_id,
            c.nome as cliente_nome,
            c.email as cliente_email,
            c.telefone as cliente_telefone,
            p.subtotal,
            p.desconto,
            p.frete,
            p.total,
            p.status,
            p.forma_pagamento,
            p.status_pagamento,
            p.endereco_entrega,
            p.data_envio,
            p.data_entrega,
            p.codigo_rastreio,
            p.observacoes,
            p.created_at,
            p.updated_at
        FROM pedidos p
        LEFT JOIN clientes c ON p.cliente_id = c.id
        WHERE 1=1
    ";

    $params = [];

    if ($id) {
        $sql .= " AND p.id = :id";
        $params[':id'] = $id;
    }

    if ($status) {
        $sql .= " AND p.status = :status";
        $params[':status'] = $status;
    }

    $sql .= " ORDER BY p.created_at DESC";

    try {
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        $pedidos = $stmt->fetchAll();

        // Buscar itens de cada pedido
        foreach ($pedidos as &$pedido) {
            $stmtItens = $db->prepare("
                SELECT
                    pi.id,
                    pi.vinho_id,
                    v.nome as vinho_nome,
                    v.slug as vinho_slug,
                    pi.quantidade,
                    pi.preco_unitario,
                    pi.subtotal
                FROM pedido_itens pi
                JOIN vinhos v ON pi.vinho_id = v.id
                WHERE pi.pedido_id = :pedido_id
            ");
            $stmtItens->execute([':pedido_id' => $pedido['id']]);
            $pedido['itens'] = $stmtItens->fetchAll();
        }

        // Se buscou por ID, retorna objeto único
        if ($id && count($pedidos) === 1) {
            sendResponse($pedidos[0]);
        }

        sendResponse($pedidos);
    } catch (PDOException $e) {
        sendError('Erro ao buscar pedidos: ' . $e->getMessage(), 500);
    }
}

/**
 * Cria novo pedido
 */
function createPedido($db) {
    $data = getRequestData();

    if (empty($data['itens']) || !is_array($data['itens'])) {
        sendError('Itens do pedido são obrigatórios');
    }

    try {
        $db->beginTransaction();

        // Gerar número do pedido
        $numero = 'WNO' . date('Ymd') . str_pad(rand(1, 9999), 4, '0', STR_PAD_LEFT);

        // Calcular totais
        $subtotal = 0;
        foreach ($data['itens'] as $item) {
            $subtotal += floatval($item['preco_unitario']) * intval($item['quantidade']);
        }
        $desconto = floatval($data['desconto'] ?? 0);
        $frete = floatval($data['frete'] ?? 0);
        $total = $subtotal - $desconto + $frete;

        // Inserir pedido
        $stmtPedido = $db->prepare("
            INSERT INTO pedidos (
                numero, cliente_id, subtotal, desconto, frete, total,
                status, forma_pagamento, status_pagamento, endereco_entrega, observacoes
            ) VALUES (
                :numero, :cliente_id, :subtotal, :desconto, :frete, :total,
                :status, :forma_pagamento, :status_pagamento, :endereco_entrega, :observacoes
            )
        ");
        $stmtPedido->execute([
            ':numero' => $numero,
            ':cliente_id' => $data['cliente_id'] ?? null,
            ':subtotal' => $subtotal,
            ':desconto' => $desconto,
            ':frete' => $frete,
            ':total' => $total,
            ':status' => 'pendente',
            ':forma_pagamento' => $data['forma_pagamento'] ?? null,
            ':status_pagamento' => 'pendente',
            ':endereco_entrega' => $data['endereco_entrega'] ?? null,
            ':observacoes' => $data['observacoes'] ?? null
        ]);

        $pedidoId = $db->lastInsertId();

        // Inserir itens
        $stmtItem = $db->prepare("
            INSERT INTO pedido_itens (pedido_id, vinho_id, quantidade, preco_unitario, subtotal)
            VALUES (:pedido_id, :vinho_id, :quantidade, :preco_unitario, :subtotal)
        ");

        foreach ($data['itens'] as $item) {
            $quantidade = intval($item['quantidade']);
            $precoUnitario = floatval($item['preco_unitario']);
            $subtotalItem = $quantidade * $precoUnitario;

            $stmtItem->execute([
                ':pedido_id' => $pedidoId,
                ':vinho_id' => intval($item['vinho_id']),
                ':quantidade' => $quantidade,
                ':preco_unitario' => $precoUnitario,
                ':subtotal' => $subtotalItem
            ]);

            // Baixar estoque
            $stmtEstoque = $db->prepare("
                UPDATE estoque
                SET quantidade = quantidade - :quantidade,
                    ultima_saida = CURDATE()
                WHERE vinho_id = :vinho_id
            ");
            $stmtEstoque->execute([
                ':quantidade' => $quantidade,
                ':vinho_id' => intval($item['vinho_id'])
            ]);
        }

        $db->commit();

        sendResponse([
            'id' => $pedidoId,
            'numero' => $numero,
            'total' => $total,
            'message' => 'Pedido criado com sucesso'
        ], 201);
    } catch (PDOException $e) {
        $db->rollBack();
        sendError('Erro ao criar pedido: ' . $e->getMessage(), 500);
    }
}

/**
 * Atualiza status do pedido
 */
function updatePedido($db) {
    $id = isset($_GET['id']) ? intval($_GET['id']) : null;
    if (!$id) {
        sendError('ID do pedido é obrigatório');
    }

    $data = getRequestData();

    $fields = [];
    $params = [':id' => $id];

    $allowedFields = [
        'status', 'status_pagamento', 'data_envio',
        'data_entrega', 'codigo_rastreio', 'observacoes'
    ];

    foreach ($allowedFields as $field) {
        if (isset($data[$field])) {
            $fields[] = "$field = :$field";
            $params[":$field"] = sanitize($data[$field]);
        }
    }

    if (empty($fields)) {
        sendError('Nenhum campo para atualizar');
    }

    try {
        $sql = "UPDATE pedidos SET " . implode(', ', $fields) . " WHERE id = :id";
        $stmt = $db->prepare($sql);
        $stmt->execute($params);

        sendResponse(['message' => 'Pedido atualizado com sucesso']);
    } catch (PDOException $e) {
        sendError('Erro ao atualizar pedido: ' . $e->getMessage(), 500);
    }
}
