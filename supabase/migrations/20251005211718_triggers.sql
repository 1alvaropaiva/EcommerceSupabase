
create or replace function reduzir_estoque()
returns trigger as $$
begin
    update produtos
    set quantidade = quantidade - new.quantidade
    where id = new.produto_id;

    return new;
end;
$$ language plpgsql;

create or replace function ajustar_estoque_update()
returns trigger as $$
begin
    update produtos
    set quantidade = quantidade + old.quantidade - new.quantidade
    where id = new.produto_id;

    return new;
end;
$$ language plpgsql;

create trigger trg_ajustar_estoque
after update on pedido_itens
for each row
execute function ajustar_estoque_update();

create trigger trg_reduzir_estoque
after insert on pedido_itens
for each row
execute function reduzir_estoque();