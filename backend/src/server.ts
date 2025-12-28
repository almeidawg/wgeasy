// backend/src/server.ts
import express, { Request, Response } from "express";
import cors from "cors";
import dotenv from "dotenv";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors({
  origin: ["http://localhost:5177", "http://localhost:5173", "http://localhost:3000"],
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
}));
app.use(express.json({ limit: "10mb" }));

// Health check
app.get("/health", (_req: Request, res: Response) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

// Proxy para OpenAI Chat Completions
app.post("/api/openai/chat", async (req: Request, res: Response) => {
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
app.post("/api/anthropic/messages", async (req: Request, res: Response) => {
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
