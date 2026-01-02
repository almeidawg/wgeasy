// backend/src/server.ts
import express, { Request, Response, NextFunction } from "express";
import cors from "cors";
import dotenv from "dotenv";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;

// Simple in-memory rate limiter (replace with redis-backed in production)
const RATE_LIMIT_WINDOW_MS = Number(process.env.RATE_LIMIT_WINDOW_MS || 60000);
const RATE_LIMIT_MAX = Number(process.env.RATE_LIMIT_MAX || 30);
const rateMap = new Map<string, { count: number; reset: number }>();

function rateLimitMiddleware(req: Request, res: Response, next: NextFunction) {
  const key = (req.headers['x-internal-key'] as string) || req.ip || 'global';
  const now = Date.now();
  const entry = rateMap.get(key) || { count: 0, reset: now + RATE_LIMIT_WINDOW_MS };
  if (now > entry.reset) {
    entry.count = 0;
    entry.reset = now + RATE_LIMIT_WINDOW_MS;
  }
  entry.count++;
  rateMap.set(key, entry);
  if (entry.count > RATE_LIMIT_MAX) {
    return res.status(429).json({ error: 'Too many requests' });
  }
  next();
}

// Simple internal auth middleware — require INTERNAL_API_KEY in env and header `x-internal-key` or Bearer token
function requireInternalKey(req: Request, res: Response, next: NextFunction) {
  const expected = process.env.INTERNAL_API_KEY;
  if (!expected) {
    console.warn('No INTERNAL_API_KEY set — internal endpoints are not protected');
    return res.status(500).json({ error: 'Server misconfiguration' });
  }
  const token = (req.headers['x-internal-key'] as string) || (req.headers.authorization ? String(req.headers.authorization).split(' ')[1] : undefined);
  if (!token || token !== expected) return res.status(401).json({ error: 'Unauthorized' });
  next();
}

// Middleware
app.use(cors({
  origin: [
    "http://localhost:5173",
    "http://localhost:5174",
    "http://localhost:5175",
    "http://localhost:5176",
    "http://localhost:5177",
    "http://localhost:5178",
    "http://localhost:5179",
    "http://localhost:5180",
    "http://localhost:3000",
    "https://easy.wgalmeida.com.br"
  ],
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
}));
app.use(express.json({ limit: "10mb" }));

// Health check
app.get("/health", (_req: Request, res: Response) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

// Proxy para OpenAI Chat Completions
app.post("/api/openai/chat", requireInternalKey, rateLimitMiddleware, async (req: Request, res: Response) => {
  try {
    const apiKey = process.env.OPENAI_API_KEY;

    if (!apiKey) {
      return res.status(500).json({
        error: "OPENAI_API_KEY não configurada no servidor"
      });
    }

    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${apiKey}`,
      },
      body: JSON.stringify(req.body),
    });

    const data = await response.json();

    if (!response.ok) {
      return res.status(response.status).json(data);
    }

    res.json(data);
  } catch (error: any) {
    console.error("[OpenAI Proxy Error]:", error);
    res.status(500).json({
      error: "Erro ao conectar com OpenAI",
      message: error.message
    });
  }
});

// Proxy para Anthropic Claude
app.post("/api/anthropic/messages", requireInternalKey, rateLimitMiddleware, async (req: Request, res: Response) => {
  try {
    const apiKey = process.env.ANTHROPIC_API_KEY;

    if (!apiKey) {
      return res.status(500).json({
        error: "ANTHROPIC_API_KEY não configurada no servidor"
      });
    }

    const response = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-api-key": apiKey,
        "anthropic-version": "2023-06-01",
      },
      body: JSON.stringify(req.body),
    });

    const data = await response.json();

    if (!response.ok) {
      return res.status(response.status).json(data);
    }

    res.json(data);
  } catch (error: any) {
    console.error("[Anthropic Proxy Error]:", error);
    res.status(500).json({
      error: "Erro ao conectar com Anthropic",
      message: error.message
    });
  }
});

app.listen(PORT, () => {
  console.log(`[Server] Backend rodando em http://localhost:${PORT}`);
  console.log(`[Server] OpenAI proxy: POST /api/openai/chat`);
  console.log(`[Server] Anthropic proxy: POST /api/anthropic/messages`);
});
