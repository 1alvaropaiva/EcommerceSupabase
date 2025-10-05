alter table clientes enable row level security;
alter table produtos enable row level security;
alter table pedidos enable row level security;
alter table pedido_itens enable row level security;

create policy "Cada usuário só vê seus dados"
  on clientes for select
  using (id = auth.uid());
  
create policy "Cada usuário só pode atualizar seus dados"
  on clientes for update
  using (id = auth.uid());

create policy "Produtos visíveis a todos usuários autenticados"
  on produtos for select
  using (auth.role() = 'authenticated');

create policy "Usuário só vê seus próprios pedidos"
  on pedidos for select
  using (cliente_id = auth.uid());
create policy "Usuário só insere pedidos para si mesmo"
  on pedidos for insert
  with check (cliente_id = auth.uid());

create policy "Usuário só vê itens dos pedidos dele"
  on pedido_itens for select
  using (pedido_id in (
    select id from pedidos where cliente_id = auth.uid()
  ));

create policy "Usuário só insere itens em seus pedidos"
  on pedido_itens for insert
  with check (pedido_id in (
    select id from pedidos where cliente_id = auth.uid()
  ));