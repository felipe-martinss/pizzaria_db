  
  -- atividade 1

   use Pizzaria;

   -- Quantas tables?
    show tables;

    -- Quantos Clientes cadastrados?
    select count(*) as 'total de clientes' from clientes;

  -- Quantas pizzas Cadastradas?
    select count(*) as 'total de pizzas' from pizzas;

        select * from itens_pedido where pedido_id = 3;
    select sum(quantidade) as 'total de pedidos' from itens_pedido where pedido_id = 3;

    -- quem fez o pedido numero 3?
    select * from pedidos where pedido_id = 3;
    --  Qual nome do cliente que fez o pedido nº 3? (feito com base no de cima)
    select * from clientes where cliente_id = 2;



-- Quais os nomes das pizzas do pedido nº 3?
    select c.nome as cliente, p.pedido_id from pedidos p join clientes c on p.cliente_id = c.cliente_id where p.pedido_id = 3;

    describe itens_pedido;
    select * from itens_pedido where pedido_id = 3;
    select * from pizzas where pizza_id in (7,5,8,9,3,10,16);


-- desafio 1

    -- Mostrar todos os pedidos, itens, nome dos - clientes e nome das pizzas.


  
  -- Calcular Subtotal
   select pedido_id, pizza_id, quantidade, valor as preco_unitario, (valor * quantidade) as subtotal from itens_pedido;

   -- Calcular total
   select pedido_id as pedido, sum(valor *quantidade) as 'valor total' from itens_pedido group by pedido_id;

   -- Agrupe os pedidos e conte quantas pizzas cada pedido possui
   select pedido_id as pedido, sum(quantidade) as total_pizzas from itens_pedido group by pedido_id;


   -- desafio 2 (dml)

    insert into Clientes(nome, logradouro, numero, complemento, bairro, referencia) values
    ("Gaspar Oliveira","Rua Alcides Postali",21, null,"São Dimas","Ao lado da igreja");

    insert into Telefones(cliente_id, Telefone) values
    (106,"19 99898-1141");


insert into Pedidos(cliente_id, data, hora) values(106, curdate(), curtime());

insert into Itens_Pedido(pedido_id, pizza_id, quantidade, valor) values(27,22,1, (select valor from Pizzas where pizza_id = 22));
insert into Itens_Pedido(pedido_id, pizza_id, quantidade, valor) values(27,28,2, (select valor from Pizzas where pizza_id = 28));

insert into Pizzas(nome, descricao, valor) values("A moda do chef","Molho de tomate, palmito macio em rodelas, coberto com catupiry,
frango desfiado, ovos, carne seca, oregano e azeitonas",41.09);

update Pedidos set valor=(select sum(quantidade * valor) from Itens_Pedido where pedido_id = 27) where pedido_id = 27;



-- duas pizzas a moda do chef
insert into Itens_Pedido(pedido_id, pizza_id, quantidade, valor) values(27,42,2, (select valor from Pizzas where pizza_id = 42));

--  Em tempo o cliente "Gaspar Oliveira" ligou e pediu para que seu pedido seja alterado para 3 pizzas "A moda do chef" e acrescentando uma pizza "Margherita" ao pedido.

-- alterar para 3 pizzas a moda do chef
update Itens_pedido set quantidade = 3 where pedido_id = 27 and pizza_id = 42;

-- adicionar uma de margherita
update Itens_pedido set quantidade = 2 where pedido_id = 27 and pizza_id = 22;
