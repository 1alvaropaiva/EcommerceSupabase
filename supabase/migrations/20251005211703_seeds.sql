
insert into clientes (nome, email, endereco) values
  ('Alvaro', '12alvaropaiva@gmail.com', 'Rua B, 13'),
  ('Mariazinha', 'mariazinha@email.com', 'Rua A, 12'),
  ('João Pedro', 'joaopedro@email.com', 'Av. Central, 45'),
  ('Ana Clara', 'ana.clara@email.com', 'Rua das Flores, 88'),
  ('Lucas Lima', 'lucas.lima@email.com', 'Rua Azul, 21');


insert into produtos (nome, tipo, quantidade, preco) values
  ('Camiseta', 'Roupas', 50, 59.90),
  ('Notebook', 'Eletrônicos', 10, 4999.00),
  ('Fone de ouvido', 'Acessórios', 30, 199.90),
  ('Tênis Esportivo', 'Calçados', 20, 349.90),
  ('Mochila', 'Acessórios', 15, 249.00);


insert into pedidos (cliente_id, status, criado_em)
values
  ((select id from clientes where nome = 'Alvaro'), 'pago', now() - interval '3 days'),
  ((select id from clientes where nome = 'Mariazinha'), 'enviado', now() - interval '1 day'),
  ((select id from clientes where nome = 'João Pedro'), 'enviado', now() - interval '5 days'),
  ((select id from clientes where nome = 'Ana Clara'), 'concluido', now() - interval '10 days'),
  ((select id from clientes where nome = 'Lucas Lima'), 'pago', now());


insert into pedido_itens (pedido_id, produto_id, quantidade)
values
  ((select id from pedidos where cliente_id = (select id from clientes where nome = 'Alvaro')), 
   (select id from produtos where nome = 'Camiseta'), 2),
  ((select id from pedidos where cliente_id = (select id from clientes where nome = 'Alvaro')), 
   (select id from produtos where nome = 'Fone de ouvido'), 1);

insert into pedido_itens (pedido_id, produto_id, quantidade)
values
  ((select id from pedidos where cliente_id = (select id from clientes where nome = 'Mariazinha')),
   (select id from produtos where nome = 'Mochila'), 1),
  ((select id from pedidos where cliente_id = (select id from clientes where nome = 'Mariazinha')),
   (select id from produtos where nome = 'Camiseta'), 3);

insert into pedido_itens (pedido_id, produto_id, quantidade)
values
  ((select id from pedidos where cliente_id = (select id from clientes where nome = 'João Pedro')),
   (select id from produtos where nome = 'Notebook'), 1),
  ((select id from pedidos where cliente_id = (select id from clientes where nome = 'João Pedro')),
   (select id from produtos where nome = 'Fone de ouvido'), 2);

insert into pedido_itens (pedido_id, produto_id, quantidade)
values
  ((select id from pedidos where cliente_id = (select id from clientes where nome = 'Ana Clara')),
   (select id from produtos where nome = 'Tênis Esportivo'), 1),
  ((select id from pedidos where cliente_id = (select id from clientes where nome = 'Ana Clara')),
   (select id from produtos where nome = 'Mochila'), 1);

insert into pedido_itens (pedido_id, produto_id, quantidade)
values
  ((select id from pedidos where cliente_id = (select id from clientes where nome = 'Lucas Lima')),
   (select id from produtos where nome = 'Camiseta'), 1),
  ((select id from pedidos where cliente_id = (select id from clientes where nome = 'Lucas Lima')),
   (select id from produtos where nome = 'Notebook'), 1);