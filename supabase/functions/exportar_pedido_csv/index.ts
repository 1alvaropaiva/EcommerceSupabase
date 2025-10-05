// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import { serve } from "https://deno.land/std@0.203.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req: Request) => {
  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseKey);

    const url = new URL(req.url);
    const pedido_id = url.searchParams.get("pedido_id");
    if (!pedido_id) return new Response("Pedido_id não fornecido", { status: 400 });

    const { data: itens, error } = await supabase
      .from("vw_itens_pedidos")
      .select("*")
      .eq("pedido_id", pedido_id);

    if (error) return new Response(error.message, { status: 500 });
    if (!itens || itens.length === 0) return new Response("Pedido não encontrado", { status: 404 });

    const csvLines = itens.map(item => 
      `Produto: ${item.produto}\nTipo: ${item.tipo_produto}\nQuantidade: ${item.quantidade}\nPreço: ${item.preco}\n`
    );

    const csv = csvLines.join("\n\n");

    return new Response(csv, {
      status: 200,
      headers: {
        "Content-Type": "text/csv",
        "Content-Disposition": `attachment; filename=pedido_${pedido_id}.csv`
      }
    });

  } catch (err) {
    return new Response("Erro interno: " + err, { status: 500 });
  }
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/exportar_pedido_csv' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/