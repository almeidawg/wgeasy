<?php
/**
 * WNO MAS - API de Clientes
 *
 * Endpoints:
 * GET    /clientes.php              - Lista clientes
 * GET    /clientes.php?id=X         - Retorna cliente específico
 * POST   /clientes.php              - Cria novo cliente
 * PUT    /clientes.php?id=X         - Atualiza cliente
 */

require_once 'config.php';

$db = Database::getInstance()->getConnection();
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        getClientes($db);
        break;
    case 'POST':
        createCliente($db);
        break;
    case 'PUT':
        updateCliente($db);
        break;
    default:
        sendError('Método não permitido', 405);
}

/**
 * Lista clientes
 */
function getClientes($db) {
    $id = isset($_GET['id']) ? intval($_GET['id']) : null;
    $email = isset($_GET['email']) ? sanitize($_GET['email']) : null;

    $sql = "
        SELECT
            c.*,
            COUNT(p.id) as total_pedidos,
            COALESCE(SUM(p.total), 0) as total_gasto
        FROM clientes c
        LEFT JOIN pedidos p ON c.id = p.cliente_id AND p.status != 'cancelado'
        WHERE c.ativo = TRUE
    ";

    $params = [];

    if ($id) {
        $sql .= " AND c.id = :id";
        $params[':id'] = $id;
    }

    if ($email) {
        $sql .= " AND c.email = :email";
        $params[':email'] = $email;
    }

    $sql .= " GROUP BY c.id ORDER BY c.nome ASC";

    try {
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        $clientes = $stmt->fetchAll();

        // Se buscou por ID ou email, retorna objeto único
        if (($id || $email) && count($clientes) === 1) {
            sendResponse($clientes[0]);
        }

        sendResponse($clientes);
    } catch (PDOException $e) {
        sendError('Erro ao buscar clientes: ' . $e->getMessage(), 500);
    }
}

/**
 * Cria novo cliente
 */
function createCliente($db) {
    $data = getRequestData();

    if (empty($data['nome']) || empty($data['email'])) {
        sendError('Nome e email são obrigatórios');
    }

    // Verificar se email já existe
    $stmtCheck = $db->prepare("SELECT id FROM clientes WHERE email = :email");
    $stmtCheck->execute([':email' => sanitize($data['email'])]);
    if ($stmtCheck->fetch()) {
        sendError('Email já cadastrado');
    }

    try {
        $stmt = $db->prepare("
            INSERT INTO clientes (
                nome, email, telefone, cpf,
                cep, endereco, numero, complemento, bairro, cidade, estado,
                preferencia_vinho, aceita_marketing
            ) VALUES (
                :nome, :email, :telefone, :cpf,
                :cep, :endereco, :numero, :complemento, :bairro, :cidade, :estado,
                :preferencia_vinho, :aceita_marketing
            )
        ");

        $stmt->execute([
            ':nome' => sanitize($data['nome']),
            ':email' => sanitize($data['email']),
            ':telefone' => sanitize($data['telefone'] ?? ''),
            ':cpf' => sanitize($data['cpf'] ?? ''),
            ':cep' => sanitize($data['cep'] ?? ''),
            ':endereco' => sanitize($data['endereco'] ?? ''),
            ':numero' => sanitize($data['numero'] ?? ''),
            ':complemento' => sanitize($data['complemento'] ?? ''),
            ':bairro' => sanitize($data['bairro'] ?? ''),
            ':cidade' => sanitize($data['cidade'] ?? ''),
            ':estado' => sanitize($data['estado'] ?? ''),
            ':preferencia_vinho' => $data['preferencia_vinho'] ?? 'Todos',
            ':aceita_marketing' => $data['aceita_marketing'] ?? false
        ]);

        $clienteId = $db->lastInsertId();

        sendResponse([
            'id' => $clienteId,
            'message' => 'Cliente criado com sucesso'
        ], 201);
    } catch (PDOException $e) {
        sendError('Erro ao criar cliente: ' . $e->getMessage(), 500);
    }
}

/**
 * Atualiza cliente
 */
function updateCliente($db) {
    $id = isset($_GET['id']) ? intval($_GET['id']) : null;
    if (!$id) {
        sendError('ID do cliente é obrigatório');
    }

    $data = getRequestData();

    $fields = [];
    $params = [':id' => $id];

    $allowedFields = [
        'nome', 'telefone', 'cpf',
        'cep', 'endereco', 'numero', 'complemento', 'bairro', 'cidade', 'estado',
        'preferencia_vinho', 'aceita_marketing', 'ativo'
    ];

    foreach ($allowedFields as $field) {
        if (isset($data[$field])) {
            $fields[] = "$field = :$field";
            $params[":$field"] = is_string($data[$field]) ? sanitize($data[$field]) : $data[$field];
        }
    }

    if (empty($fields)) {
        sendError('Nenhum campo para atualizar');
    }

    try {
        $sql = "UPDATE clientes SET " . implode(', ', $fields) . " WHERE id = :id";
        $stmt = $db->prepare($sql);
        $stmt->execute($params);

        sendResponse(['message' => 'Cliente atualizado com sucesso']);
    } catch (PDOException $e) {
        sendError('Erro ao atualizar cliente: ' . $e->getMessage(), 500);
    }
}
