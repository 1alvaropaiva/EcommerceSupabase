// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import { serve } from "https://deno.land/std/http/server.ts";

serve(async (req) => {
  try {
    const body = await req.json();
    const { email, clienteNome, pedidoId, endereco } = body;

    if (!email || !clienteNome || !pedidoId || !endereco) {
      return new Response(
        JSON.stringify({ error: "Parâmetros incompletos" }),
        { status: 400 }
      );
    }

    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${Deno.env.get("RESEND_API_KEY")}`,
      },
      body: JSON.stringify({
        from: "delivery@resend.dev", 
        to: [email],
        subject: "Seu pedido foi confirmado!",
        html: `
          <p>Olá ${clienteNome},</p>
          <p>Seu pedido <strong>${pedidoId}</strong> foi confirmado!</p>
          <p>A entrega será feita no endereço: <strong>${endereco}</strong></p>
          <p>Obrigado por comprar conosco!</p>
        `,
      }),
    });

    const data = await res.json();
    return new Response(JSON.stringify({ success: true, data }), { status: 200 });

  } catch (err) {
    console.error("Erro ao enviar email:", err);
    return new Response(JSON.stringify({ error: err.message }), { status: 500 });
  }
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/email_boas_vindas' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/