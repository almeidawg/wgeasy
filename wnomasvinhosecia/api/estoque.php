<?php
/**
 * WNO MAS - API de Estoque
 *
 * Endpoints:
 * GET    /estoque.php              - Lista estoque de todos os vinhos
 * GET    /estoque.php?baixo=1      - Lista apenas estoque baixo
 * PUT    /estoque.php?id=X         - Atualiza estoque
 * POST   /estoque.php/movimentar   - Registra movimentação
 */

require_once 'config.php';

$db = Database::getInstance()->getConnection();
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        getEstoque($db);
        break;
    case 'PUT':
        updateEstoque($db);
        break;
    case 'POST':
        movimentarEstoque($db);
        break;
    default:
        sendError('Método não permitido', 405);
}

/**
 * Lista estoque
 */
function getEstoque($db) {
    $baixo = isset($_GET['baixo']) && $_GET['baixo'] == '1';

    $sql = "
        SELECT
            e.id,
            e.vinho_id,
            v.nome as vinho_nome,
            v.slug as vinho_slug,
            c.nome as categoria,
            e.quantidade,
            e.quantidade_minima,
            e.localizacao,
            e.ultima_entrada,
            e.ultima_saida,
            v.custo_base,
            (e.quantidade * v.custo_base) as valor_estoque,
            CASE
                WHEN e.quantidade <= e.quantidade_minima THEN 'critico'
                WHEN e.quantidade <= (e.quantidade_minima * 1.5) THEN 'baixo'
                ELSE 'ok'
            END as status
        FROM estoque e
        JOIN vinhos v ON e.vinho_id = v.id
        LEFT JOIN categorias c ON v.categoria_id = c.id
        WHERE v.ativo = TRUE
    ";

    if ($baixo) {
        $sql .= " AND e.quantidade <= e.quantidade_minima";
    }

    $sql .= " ORDER BY e.quantidade ASC";

    try {
        $stmt = $db->query($sql);
        $estoque = $stmt->fetchAll();

        // Calcular totais
        $totalItens = array_sum(array_column($estoque, 'quantidade'));
        $valorTotal = array_sum(array_column($estoque, 'valor_estoque'));
        $alertas = count(array_filter($estoque, fn($e) => $e['status'] === 'critico'));

        sendResponse([
            'resumo' => [
                'total_garrafas' => $totalItens,
                'valor_total' => $valorTotal,
                'alertas_criticos' => $alertas
            ],
            'itens' => $estoque
        ]);
    } catch (PDOException $e) {
        sendError('Erro ao buscar estoque: ' . $e->getMessage(), 500);
    }
}

/**
 * Atualiza quantidade de estoque
 */
function updateEstoque($db) {
    $vinhoId = isset($_GET['id']) ? intval($_GET['id']) : null;
    if (!$vinhoId) {
        sendError('ID do vinho é obrigatório');
    }

    $data = getRequestData();

    try {
        $stmt = $db->prepare("
            UPDATE estoque
            SET quantidade = :quantidade,
                quantidade_minima = :quantidade_minima,
                localizacao = :localizacao
            WHERE vinho_id = :vinho_id
        ");

        $stmt->execute([
            ':vinho_id' => $vinhoId,
            ':quantidade' => intval($data['quantidade'] ?? 0),
            ':quantidade_minima' => intval($data['quantidade_minima'] ?? 6),
            ':localizacao' => sanitize($data['localizacao'] ?? 'A-01')
        ]);

        sendResponse(['message' => 'Estoque atualizado']);
    } catch (PDOException $e) {
        sendError('Erro ao atualizar estoque: ' . $e->getMessage(), 500);
    }
}

/**
 * Registra movimentação de estoque
 */
function movimentarEstoque($db) {
    $data = getRequestData();

    if (empty($data['vinho_id']) || empty($data['tipo']) || !isset($data['quantidade'])) {
        sendError('vinho_id, tipo e quantidade são obrigatórios');
    }

    $vinhoId = intval($data['vinho_id']);
    $tipo = $data['tipo']; // entrada, saida, ajuste
    $quantidade = intval($data['quantidade']);
    $motivo = sanitize($data['motivo'] ?? '');
    $usuario = sanitize($data['usuario'] ?? 'Sistema');

    if (!in_array($tipo, ['entrada', 'saida', 'ajuste'])) {
        sendError('Tipo deve ser: entrada, saida ou ajuste');
    }

    try {
        $db->beginTransaction();

        // Buscar quantidade atual
        $stmt = $db->prepare("SELECT quantidade FROM estoque WHERE vinho_id = :vinho_id");
        $stmt->execute([':vinho_id' => $vinhoId]);
        $estoqueAtual = $stmt->fetch();

        if (!$estoqueAtual) {
            sendError('Vinho não encontrado no estoque');
        }

        $quantidadeAnterior = $estoqueAtual['quantidade'];

        // Calcular nova quantidade
        switch ($tipo) {
            case 'entrada':
                $novaQuantidade = $quantidadeAnterior + $quantidade;
                $campoData = 'ultima_entrada';
                break;
            case 'saida':
                $novaQuantidade = $quantidadeAnterior - $quantidade;
                $campoData = 'ultima_saida';
                if ($novaQuantidade < 0) {
                    sendError('Quantidade insuficiente em estoque');
                }
                break;
            case 'ajuste':
                $novaQuantidade = $quantidade; // Ajuste define valor absoluto
                $campoData = null;
                break;
        }

        // Atualizar estoque
        $sqlUpdate = "UPDATE estoque SET quantidade = :quantidade";
        if ($campoData) {
            $sqlUpdate .= ", $campoData = CURDATE()";
        }
        $sqlUpdate .= " WHERE vinho_id = :vinho_id";

        $stmtUpdate = $db->prepare($sqlUpdate);
        $stmtUpdate->execute([
            ':quantidade' => $novaQuantidade,
            ':vinho_id' => $vinhoId
        ]);

        // Registrar movimentação
        $stmtMov = $db->prepare("
            INSERT INTO movimentacoes_estoque
            (vinho_id, tipo, quantidade, quantidade_anterior, quantidade_posterior, motivo, usuario)
            VALUES
            (:vinho_id, :tipo, :quantidade, :quantidade_anterior, :quantidade_posterior, :motivo, :usuario)
        ");
        $stmtMov->execute([
            ':vinho_id' => $vinhoId,
            ':tipo' => $tipo,
            ':quantidade' => $quantidade,
            ':quantidade_anterior' => $quantidadeAnterior,
            ':quantidade_posterior' => $novaQuantidade,
            ':motivo' => $motivo,
            ':usuario' => $usuario
        ]);

        $db->commit();

        sendResponse([
            'message' => 'Movimentação registrada',
            'quantidade_anterior' => $quantidadeAnterior,
            'quantidade_atual' => $novaQuantidade
        ]);
    } catch (PDOException $e) {
        $db->rollBack();
        sendError('Erro ao movimentar estoque: ' . $e->getMessage(), 500);
    }
}
