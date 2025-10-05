create or replace view vw_resumo_pedidos as
select 
    p.id as pedido_id,
    p.ordem_servico,
    c.nome as cliente,
    p.status,
    calcular_total_pedido(p.id) as total,
    p.criado_em
from pedidos p
join clientes c on c.id = p.cliente_id;

create or replace view vw_itens_pedidos as
select 
    pi.id as pedido_item_id,
    pi.pedido_id,
    pr.nome as produto,         
    pr.tipo as tipo_produto,
    pi.quantidade,
    pr.preco,
    (pi.quantidade * pr.preco) as subtotal
from pedido_itens pi
join produtos pr on pr.id = pi.produto_id
join pedidos p on p.id = pi.pedido_id;

create or replace view vw_estoque_produtos as
select 
    id as produto_id,
    nome,
    tipo,
    quantidade,
    preco,
    (quantidade * preco) as valor_total
from produtos;