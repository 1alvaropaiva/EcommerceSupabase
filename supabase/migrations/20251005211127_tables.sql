create extension if not exists "pgcrypto";
create extension if not exists pg_net;

create table clientes (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  email text not null unique,
  endereco text
);

create table produtos (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  tipo text not null,
  quantidade integer not null default 0,
  preco numeric(10,2) not null default 0
);

create table pedidos (
  id uuid primary key default gen_random_uuid(),
  ordem_servico serial unique,
  cliente_id uuid not null references clientes(id) on delete cascade,
  status text not null default 'novo',
  criado_em timestamp default now()
);

create table pedido_itens (
  id uuid primary key default gen_random_uuid(),
  pedido_id uuid not null references pedidos(id) on delete cascade,
  produto_id uuid not null references produtos(id) on delete restrict,
  quantidade integer not null check (quantidade > 0)
);

create index idx_pedidos_cliente on pedidos(cliente_id);
create index idx_itens_pedido on pedido_itens(pedido_id);