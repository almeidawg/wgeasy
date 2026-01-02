import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { Resend } from "https://esm.sh/resend@3.0.0";

const resend = new Resend(Deno.env.get("RESEND_API_KEY"));

interface ConfirmationEmailRequest {
  email: string;
  token: string;
  tipoUsuario: string;
  nomeUsuario?: string;
}

serve(async (req: Request) => {
  // Handle CORS
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST",
        "Access-Control-Allow-Headers":
          "authorization, x-client-info, apikey, content-type",
      },
    });
  }

  try {
    const {
      email,
      token,
      tipoUsuario,
      nomeUsuario = "Usuário",
    }: ConfirmationEmailRequest = await req.json();

    if (!email || !token || !tipoUsuario) {
      return new Response(
        JSON.stringify({
          error: "Missing required fields: email, token, tipoUsuario",
        }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Build confirmation URL
    const confirmationUrl = `${Deno.env.get(
      "PUBLIC_URL"
    )}/auth/confirm-email/${token}`;

    // Map tipo_usuario to display name
    const tipoUsuarioMap: Record<string, string> = {
      MASTER: "Founder & CEO",
      ADMIN: "Administrador",
      CLIENTE: "Cliente",
      COLABORADOR: "Colaborador",
      FORNECEDOR: "Fornecedor",
      JURIDICO: "Setor Jurídico",
      FINANCEIRO: "Setor Financeiro",
    };

    const displayTipo = tipoUsuarioMap[tipoUsuario] || tipoUsuario;

    // Send email using Resend
    const response = await resend.emails.send({
      from: Deno.env.get("EMAIL_FROM") || "noreply@wgalmeida.com.br",
      to: email,
      subject: "Confirme seu cadastro - WG Almeida",
      html: `
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Confirmação de Email - WG Almeida</title>
</head>
<body style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', sans-serif; line-height: 1.6; color: #333;">
  <table style="max-width: 600px; margin: 0 auto; background-color: #fff;">
    <tr>
      <td style="padding: 30px 20px; text-align: center; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
        <h1 style="margin: 0; color: white; font-size: 28px;">WG Almeida</h1>
        <p style="margin: 5px 0 0 0; color: rgba(255,255,255,0.8);">Bem-vindo ao nosso sistema</p>
      </td>
    </tr>
    <tr>
      <td style="padding: 40px 20px;">
        <h2 style="margin-top: 0; color: #333;">Olá, ${nomeUsuario}!</h2>

        <p>Obrigado por se cadastrar no sistema WG Almeida.</p>

        <p style="margin: 20px 0;"><strong>Tipo de Acesso:</strong> ${displayTipo}</p>

        <p>Para confirmar seu cadastro e ativar sua conta, clique no botão abaixo:</p>

        <div style="text-align: center; margin: 30px 0;">
          <a href="${confirmationUrl}" style="display: inline-block; padding: 12px 30px; background-color: #667eea; color: white; text-decoration: none; border-radius: 5px; font-weight: 600; font-size: 16px;">
            Confirmar Meu Email
          </a>
        </div>

        <p style="font-size: 14px; color: #666;">
          Ou copie este link no seu navegador:<br>
          <a href="${confirmationUrl}" style="color: #667eea; word-break: break-all;">${confirmationUrl}</a>
        </p>

        <hr style="border: none; border-top: 1px solid #e0e0e0; margin: 30px 0;">

        <p style="font-size: 13px; color: #999;">
          Este link expira em 24 horas.<br>
          Se você não se cadastrou, ignore este email.
        </p>
      </td>
    </tr>
    <tr>
      <td style="padding: 20px; text-align: center; background-color: #f5f5f5; border-top: 1px solid #e0e0e0; font-size: 12px; color: #666;">
        <p style="margin: 0;">© 2026 WG Almeida. Todos os direitos reservados.</p>
        <p style="margin: 5px 0 0 0;">
          <a href="https://wgalmeida.com.br" style="color: #667eea; text-decoration: none;">wgalmeida.com.br</a>
        </p>
      </td>
    </tr>
  </table>
</body>
</html>
      `,
    });

    if (response.error) {
      console.error("Resend error:", response.error);
      return new Response(
        JSON.stringify({
          error: "Failed to send email",
          details: response.error,
        }),
        { status: 500, headers: { "Content-Type": "application/json" } }
      );
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: "Confirmation email sent successfully",
        emailId: response.data?.id,
      }),
      {
        status: 200,
        headers: { "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Error sending confirmation email:", error);
    return new Response(
      JSON.stringify({
        error: "Internal server error",
        message: error instanceof Error ? error.message : String(error),
      }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});
