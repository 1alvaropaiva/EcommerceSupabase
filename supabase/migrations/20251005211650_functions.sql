create or replace function calcular_total_pedido(pedido uuid)
returns numeric as $$
  select coalesce(sum(pi.quantidade * pr.preco),0)
  from pedido_itens pi
  join produtos pr on pr.id = pi.produto_id
  where pi.pedido_id = pedido;
$$ language sql;

create or replace function atualizar_status_pedido(pedido uuid, novo_status text)
returns void as $$
  update pedidos
  set status = novo_status
  where id = pedido;
$$ language sql;

create or replace function faturamento_total()
returns numeric as $$
  select coalesce(sum(calcular_total_pedido(p.id)),0)
  from pedidos p
  where p.status in ('pago','enviado','concluido');
$$ language sql;