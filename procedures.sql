-- Iniciaremos com uma QUEST / MISSÃO
-- O cliente Walter Paulo Costenaro quer 1 pizza de Atum e 2 napolitanas.
-- cliente_id 98
-- pizza_id 5, valor 32.29
-- pizza_id 28, valor 33.41
SELECT valor FROM pizzas WHERE pizza_id = 5;
SELECT valor FROM pizzas WHERE pizza_id = 28;

INSERT INTO pedidos VALUES
(default, 98, CURDATE(), NOW(), null);

SELECT * FROM pedidos ORDER BY pedido_id DESC LIMIT 1;
SELECT LAST_INSERT_ID();
-- pedido_id 27

INSERT INTO itens_pedido VALUES
(27,5,1,(SELECT valor FROM pizzas WHERE pizza_id = 5)),
(27,28,2,(SELECT valor FROM pizzas WHERE pizza_id = 28));

SELECT * FROM itens_pedido WHERE pedido_id = 27;

-- Calcular o valor do pedido e atualizar
SELECT sum(valor * quantidade) FROM itens_pedido WHERE pedido_id = 27;

UPDATE pedidos
    SET valor = (SELECT sum(valor * quantidade) FROM itens_pedido WHERE pedido_id = 27)
    WHERE pedido_id = 27;

SELECT * FROM pedidos WHERE pedido_id = 27;

-- Vamos criar uma PROCEDURE que calcule o valor total do pedido
DELIMITER $
CREATE PROCEDURE atulizaValorPedido(id int)
    BEGIN
        UPDATE pedidos
        SET valor = (SELECT sum(valor * quantidade) FROM itens_pedido WHERE pedido_id = id)
        WHERE pedido_id = id;
    END $
DELIMITER ;

-- Excluir e criar denovo a mesma PROCEDURE sem alterar os delimitadores
DROP PROCEDURE IF EXISTS atulizaValorPedido;
CREATE PROCEDURE atulizaValorPedido(id int)
UPDATE pedidos
    SET valor = (SELECT sum(valor * quantidade) FROM itens_pedido WHERE pedido_id = id)
    WHERE pedido_id = id;

-- Para testar
SELECT * FROM pedidos WHERE pedido_id = 27;
-- Alterar o valor para nulo
UPDATE pedidos SET valor = null WHERE pedido_id = 27;
SELECT * FROM pedidos WHERE pedido_id = 27;
-- Utilizar o Procedimento para alterar
CALL atulizaValorPedido(27);
SELECT * FROM pedidos WHERE pedido_id = 27;

-- Para ver quais procedimentos um Banco de dados possui armazenado.
SHOW PROCEDURE STATUS;
-- Missão 2: A Cliente Sara Luzia de Melo quer 2 pizzas Napolitanas
-- Registre este pedido:
SELECT * FROM clientes;
SELECT * FROM pizzas;
INSERT INTO pedidos VALUES (default, 91, CURDATE(), NOW(), null);
INSERT INTO itens_pedido VALUES (28,28, 2,(SELECT valor FROM pizzas WHERE pizza_id = 28));
SELECT * FROM pedidos WHERE pedido_id = 28;
CALL atulizaValorPedido(28);
SELECT * FROM pedidos WHERE pedido_id = 28;

 -- Procedimento armazenado pedido de um item
DELIMITER //

DROP PROCEDURE IF EXISTS pedidoDeUmItem//

CREATE PROCEDURE pedidoDeUmItem(IN p_cliente_id INT, IN p_pizza_id INT, IN p_qtd INT)
BEGIN
    DECLARE v_pedido_id INT;
    DECLARE v_valor_pizza DECIMAL(8,2);

    -- Busca o valor atual da pizza na tabela Pizzas
    SELECT valor INTO v_valor_pizza FROM Pizzas WHERE pizza_id = p_pizza_id;

    -- Insere o pedido com valor inicial 0.00
    INSERT INTO Pedidos (cliente_id, data, hora, valor) 
    VALUES (p_cliente_id, CURDATE(), CURTIME(), 0.00);
    SET v_pedido_id = LAST_INSERT_ID();
    INSERT INTO Itens_Pedido (pedido_id, pizza_id, quantidade, valor) 
    VALUES (v_pedido_id, p_pizza_id, p_qtd, v_valor_pizza);
    UPDATE Pedidos 
    SET valor = (SELECT SUM(valor * quantidade) FROM Itens_Pedido WHERE pedido_id = v_pedido_id)
    WHERE pedido_id = v_pedido_id;
END//
DELIMITER ;
SHOW PROCEDURE STATUS;

call pedidoDeUmItem(96, 41, 1);

DELIMITER //
DROP TRIGGER IF EXISTS trg_atualiza_valor_pedido //
CREATE TRIGGER trg_atualiza_valor_pedido
AFTER INSERT ON Itens_Pedido
FOR EACH ROW
BEGIN
    UPDATE Pedidos
    SET valor = (
        SELECT COALESCE(SUM(valor * quantidade), 0)
        FROM Itens_Pedido
        WHERE pedido_id = NEW.pedido_id
    )
    WHERE pedido_id = NEW.pedido_id;
END //

DELIMITER ;
SHOW TRIGGERS;

insert into itens_pedido values (LAST_INSERT_ID(), 2, 1, 32.93)
select * from pedidos order by pedido_id desc limit 1;