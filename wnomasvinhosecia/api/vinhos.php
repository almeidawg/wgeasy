<?php
/**
 * WNO MAS - API de Vinhos
 *
 * Endpoints:
 * GET    /vinhos.php           - Lista todos os vinhos
 * GET    /vinhos.php?id=X      - Retorna um vinho específico
 * GET    /vinhos.php?slug=X    - Retorna vinho por slug
 * POST   /vinhos.php           - Cria novo vinho
 * PUT    /vinhos.php?id=X      - Atualiza vinho
 * DELETE /vinhos.php?id=X      - Remove vinho
 */

require_once 'config.php';

$db = Database::getInstance()->getConnection();
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        getVinhos($db);
        break;
    case 'POST':
        createVinho($db);
        break;
    case 'PUT':
        updateVinho($db);
        break;
    case 'DELETE':
        deleteVinho($db);
        break;
    default:
        sendError('Método não permitido', 405);
}

/**
 * Lista vinhos com filtros opcionais
 */
function getVinhos($db) {
    // Filtros
    $id = isset($_GET['id']) ? intval($_GET['id']) : null;
    $slug = isset($_GET['slug']) ? sanitize($_GET['slug']) : null;
    $categoria = isset($_GET['categoria']) ? sanitize($_GET['categoria']) : null;
    $pais = isset($_GET['pais']) ? sanitize($_GET['pais']) : null;
    $preco_min = isset($_GET['preco_min']) ? floatval($_GET['preco_min']) : null;
    $preco_max = isset($_GET['preco_max']) ? floatval($_GET['preco_max']) : null;

    // Query base
    $sql = "
        SELECT
            v.id,
            v.slug,
            v.nome,
            v.safra,
            v.corpo,
            v.acidez,
            v.taninos,
            v.teor_alcoolico,
            v.temperatura_ideal,
            v.metodo_producao,
            v.potencial_guarda,
            v.descricao,
            v.nota_wnomas,
            v.dica_sommelier,
            v.custo_base,
            v.margem_percentual,
            v.preco_venda,
            v.imagem_url,
            v.ativo,
            v.destaque,
            c.nome as categoria,
            r.nome as regiao,
            p.nome as pais,
            e.quantidade as estoque_quantidade,
            e.localizacao as estoque_localizacao,
            GROUP_CONCAT(DISTINCT u.nome SEPARATOR ', ') as uvas
        FROM vinhos v
        LEFT JOIN categorias c ON v.categoria_id = c.id
        LEFT JOIN regioes r ON v.regiao_id = r.id
        LEFT JOIN paises p ON r.pais_id = p.id
        LEFT JOIN estoque e ON v.id = e.vinho_id
        LEFT JOIN vinho_uvas vu ON v.id = vu.vinho_id
        LEFT JOIN uvas u ON vu.uva_id = u.id
        WHERE v.ativo = TRUE
    ";

    $params = [];

    // Filtro por ID
    if ($id) {
        $sql .= " AND v.id = :id";
        $params[':id'] = $id;
    }

    // Filtro por slug
    if ($slug) {
        $sql .= " AND v.slug = :slug";
        $params[':slug'] = $slug;
    }

    // Filtro por categoria
    if ($categoria && $categoria !== 'all') {
        $sql .= " AND c.nome = :categoria";
        $params[':categoria'] = $categoria;
    }

    // Filtro por país
    if ($pais && $pais !== 'all') {
        $sql .= " AND p.nome = :pais";
        $params[':pais'] = $pais;
    }

    // Filtro por preço
    if ($preco_min !== null) {
        $sql .= " AND v.preco_venda >= :preco_min";
        $params[':preco_min'] = $preco_min;
    }
    if ($preco_max !== null) {
        $sql .= " AND v.preco_venda <= :preco_max";
        $params[':preco_max'] = $preco_max;
    }

    $sql .= " GROUP BY v.id ORDER BY v.destaque DESC, v.nome ASC";

    try {
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        $vinhos = $stmt->fetchAll();

        // Buscar harmonizações para cada vinho
        foreach ($vinhos as &$vinho) {
            $stmtHarm = $db->prepare("
                SELECT h.nome, h.tipo
                FROM harmonizacoes h
                JOIN vinho_harmonizacoes vh ON h.id = vh.harmonizacao_id
                WHERE vh.vinho_id = :vinho_id
            ");
            $stmtHarm->execute([':vinho_id' => $vinho['id']]);
            $harmonizacoes = $stmtHarm->fetchAll();

            $vinho['harmonizacoes'] = [
                'pratos' => array_column(array_filter($harmonizacoes, fn($h) => $h['tipo'] === 'prato'), 'nome'),
                'momentos' => array_column(array_filter($harmonizacoes, fn($h) => $h['tipo'] === 'momento'), 'nome')
            ];

            // Converter uvas para array
            $vinho['uvas'] = $vinho['uvas'] ? explode(', ', $vinho['uvas']) : [];
        }

        // Se buscou por ID ou slug, retorna objeto único
        if (($id || $slug) && count($vinhos) === 1) {
            sendResponse($vinhos[0]);
        }

        sendResponse($vinhos);
    } catch (PDOException $e) {
        sendError('Erro ao buscar vinhos: ' . $e->getMessage(), 500);
    }
}

/**
 * Cria novo vinho
 */
function createVinho($db) {
    $data = getRequestData();

    // Validações básicas
    if (empty($data['nome']) || empty($data['slug'])) {
        sendError('Nome e slug são obrigatórios');
    }

    // Calcular preço de venda
    $custoBase = floatval($data['custo_base'] ?? 0);
    $margem = floatval($data['margem_percentual'] ?? 40);
    $custoOperacional = $custoBase * 0.10;
    $custoTotal = $custoBase + 15.00 + 5.00 + $custoOperacional; // embalagem + frete + operacional
    $precoVenda = ceil($custoTotal * (1 + ($margem / 100)));

    try {
        $db->beginTransaction();

        // Inserir vinho
        $sql = "
            INSERT INTO vinhos (
                slug, nome, categoria_id, regiao_id, safra,
                corpo, acidez, taninos, teor_alcoolico, temperatura_ideal,
                metodo_producao, potencial_guarda, descricao, nota_wnomas,
                dica_sommelier, custo_base, margem_percentual, preco_venda,
                imagem_url, ativo, destaque
            ) VALUES (
                :slug, :nome, :categoria_id, :regiao_id, :safra,
                :corpo, :acidez, :taninos, :teor_alcoolico, :temperatura_ideal,
                :metodo_producao, :potencial_guarda, :descricao, :nota_wnomas,
                :dica_sommelier, :custo_base, :margem_percentual, :preco_venda,
                :imagem_url, :ativo, :destaque
            )
        ";

        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':slug' => sanitize($data['slug']),
            ':nome' => sanitize($data['nome']),
            ':categoria_id' => $data['categoria_id'] ?? null,
            ':regiao_id' => $data['regiao_id'] ?? null,
            ':safra' => $data['safra'] ?? null,
            ':corpo' => $data['corpo'] ?? 'Médio',
            ':acidez' => $data['acidez'] ?? 'Média',
            ':taninos' => $data['taninos'] ?? null,
            ':teor_alcoolico' => $data['teor_alcoolico'] ?? null,
            ':temperatura_ideal' => $data['temperatura_ideal'] ?? null,
            ':metodo_producao' => $data['metodo_producao'] ?? 'Tradicional',
            ':potencial_guarda' => $data['potencial_guarda'] ?? null,
            ':descricao' => $data['descricao'] ?? null,
            ':nota_wnomas' => $data['nota_wnomas'] ?? null,
            ':dica_sommelier' => $data['dica_sommelier'] ?? 'Servir na temperatura ideal.',
            ':custo_base' => $custoBase,
            ':margem_percentual' => $margem,
            ':preco_venda' => $precoVenda,
            ':imagem_url' => $data['imagem_url'] ?? null,
            ':ativo' => $data['ativo'] ?? true,
            ':destaque' => $data['destaque'] ?? false
        ]);

        $vinhoId = $db->lastInsertId();

        // Criar registro de estoque
        $stmtEstoque = $db->prepare("
            INSERT INTO estoque (vinho_id, quantidade, quantidade_minima, localizacao)
            VALUES (:vinho_id, :quantidade, :quantidade_minima, :localizacao)
        ");
        $stmtEstoque->execute([
            ':vinho_id' => $vinhoId,
            ':quantidade' => $data['estoque_quantidade'] ?? 0,
            ':quantidade_minima' => $data['estoque_minimo'] ?? 6,
            ':localizacao' => $data['estoque_localizacao'] ?? 'A-01'
        ]);

        $db->commit();

        sendResponse(['id' => $vinhoId, 'message' => 'Vinho criado com sucesso'], 201);
    } catch (PDOException $e) {
        $db->rollBack();
        sendError('Erro ao criar vinho: ' . $e->getMessage(), 500);
    }
}

/**
 * Atualiza vinho existente
 */
function updateVinho($db) {
    $id = isset($_GET['id']) ? intval($_GET['id']) : null;
    if (!$id) {
        sendError('ID do vinho é obrigatório');
    }

    $data = getRequestData();

    // Recalcular preço se custo ou margem mudaram
    if (isset($data['custo_base']) || isset($data['margem_percentual'])) {
        $custoBase = floatval($data['custo_base'] ?? 0);
        $margem = floatval($data['margem_percentual'] ?? 40);
        $custoOperacional = $custoBase * 0.10;
        $custoTotal = $custoBase + 15.00 + 5.00 + $custoOperacional;
        $data['preco_venda'] = ceil($custoTotal * (1 + ($margem / 100)));
    }

    // Construir query dinâmica
    $fields = [];
    $params = [':id' => $id];

    $allowedFields = [
        'nome', 'slug', 'categoria_id', 'regiao_id', 'safra',
        'corpo', 'acidez', 'taninos', 'teor_alcoolico', 'temperatura_ideal',
        'metodo_producao', 'potencial_guarda', 'descricao', 'nota_wnomas',
        'dica_sommelier', 'custo_base', 'margem_percentual', 'preco_venda',
        'imagem_url', 'ativo', 'destaque'
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
        $sql = "UPDATE vinhos SET " . implode(', ', $fields) . " WHERE id = :id";
        $stmt = $db->prepare($sql);
        $stmt->execute($params);

        sendResponse(['message' => 'Vinho atualizado com sucesso']);
    } catch (PDOException $e) {
        sendError('Erro ao atualizar vinho: ' . $e->getMessage(), 500);
    }
}

/**
 * Remove vinho (soft delete)
 */
function deleteVinho($db) {
    $id = isset($_GET['id']) ? intval($_GET['id']) : null;
    if (!$id) {
        sendError('ID do vinho é obrigatório');
    }

    try {
        // Soft delete - apenas desativa
        $stmt = $db->prepare("UPDATE vinhos SET ativo = FALSE WHERE id = :id");
        $stmt->execute([':id' => $id]);

        sendResponse(['message' => 'Vinho removido com sucesso']);
    } catch (PDOException $e) {
        sendError('Erro ao remover vinho: ' . $e->getMessage(), 500);
    }
}
