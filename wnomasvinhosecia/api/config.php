<?php
/**
 * WNO MAS - Configuração do Banco de Dados
 *
 * IMPORTANTE: Atualize os valores abaixo com suas credenciais da Hostinger
 */

// Configurações do Banco de Dados
define('DB_HOST', 'localhost');
define('DB_NAME', 'u123456789_wnomas_db');      // Substitua pelo nome real
define('DB_USER', 'u123456789_wnomas_user');    // Substitua pelo usuário real
define('DB_PASS', 'SUA_SENHA_AQUI');            // Substitua pela senha real
define('DB_CHARSET', 'utf8mb4');

// Configurações da API
define('API_VERSION', '1.0');
define('CORS_ORIGIN', '*'); // Em produção, especifique o domínio

// Headers CORS
header('Access-Control-Allow-Origin: ' . CORS_ORIGIN);
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json; charset=UTF-8');

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

/**
 * Classe de conexão com o banco de dados
 */
class Database {
    private static $instance = null;
    private $connection;

    private function __construct() {
        try {
            $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=" . DB_CHARSET;
            $options = [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
            ];
            $this->connection = new PDO($dsn, DB_USER, DB_PASS, $options);
        } catch (PDOException $e) {
            $this->sendError('Erro de conexão: ' . $e->getMessage(), 500);
        }
    }

    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function getConnection() {
        return $this->connection;
    }

    private function sendError($message, $code = 400) {
        http_response_code($code);
        echo json_encode(['error' => true, 'message' => $message]);
        exit();
    }
}

/**
 * Funções auxiliares
 */
function sendResponse($data, $code = 200) {
    http_response_code($code);
    echo json_encode([
        'success' => true,
        'data' => $data
    ]);
    exit();
}

function sendError($message, $code = 400) {
    http_response_code($code);
    echo json_encode([
        'error' => true,
        'message' => $message
    ]);
    exit();
}

function getRequestData() {
    $json = file_get_contents('php://input');
    return json_decode($json, true) ?? [];
}

function sanitize($input) {
    if (is_array($input)) {
        return array_map('sanitize', $input);
    }
    return htmlspecialchars(strip_tags(trim($input)), ENT_QUOTES, 'UTF-8');
}
