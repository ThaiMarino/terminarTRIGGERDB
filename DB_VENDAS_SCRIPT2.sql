-- 1 Crie um trigger para baixar o estoque de um PRODUTO
-- quando ele for vendido
-- teste para inserção de produto
-- INSERT INTO EX2_PEDIDO VALUES (7,1,'2012-04-01', '00001', 400.00);
DELIMITER //
CREATE TRIGGER baixaEstoque AFTER DELETE 
ON ex2_produto
FOR EACH ROW 
BEGIN
	if OLD.ex2_produto.codproduto = (select quantidade.codproduto from quantidade where quantidade.codproduto = OLD.ex2_produto.codproduto) THEN
		update quantidade set quantidade.qtde = (quantidade.qtde -old.quantidade)
		WHERE quantidade.codproduto = OLD.ex2_produto.codproduto;
	end if;
END //
DELIMITER ;


select * from ex2_itempedido;
select * from ex2_pedido;
select * from ex2_produto;
INSERT INTO EX2_PEDIDO VALUES (7,1,'2012-04-01', '00001', 400.00);


-- 2 Crie um trigger para criar um log dos CLIENTES inseridos
-- CRIANDO UM NOVO CLIENTE 
-- INSERT INTO EX2_CLIENTE  VALUES (8, 'José Adolfo', '1998-11-05', '55555555591'); 

DELIMITER $$
CREATE TRIGGER criaLogCliente AFTER INSERT
ON ex2_cliente
FOR EACH ROW
BEGIN
	INSERT INTO ex2_log (data, descricao) VALUES(current_date(), descricao);
END $$ 
DELIMITER ;

DROP TRIGGER criaLogCliente;
select * from ex2_cliente;
INSERT INTO ex2_cliente VALUES (9, 'André Marques', '1980-02-04', '77715541200');

select * from ex2_log;

-- 3) Crie um TRIGGER para criar um log dos PRODUTOS atualizados.
-- ATUALIZANDO UM PRODUTO 
-- UPDATE EX2_PRODUTO SET DESCRICAO=’MOUSEPAD’ WHERE CODPRODUTO =1; 
-- UPDATE EX2_PRODUTO SET quantidade = 20 WHERE CODPRODUTO = 1; 
CREATE TRIGGER produtos_Atualizados
AFTER UPDATE ON EX2_PRODUTO
FOR EACH ROW
BEGIN
    -- Verifica se houve alteração na descrição do produto
    IF NEW.DESCRICAO <> OLD.DESCRICAO THEN
        INSERT INTO log_produtos_atualizados (CODPRODUTO, ATRIBUTO, VALOR_ANTIGO, VALOR_NOVO, DATA_ATUALIZACAO)
        VALUES (NEW.CODPRODUTO, 'DESCRICAO', OLD.DESCRICAO, NEW.DESCRICAO, NEW.current_date());
	END IF;
    -- Verifica se houve alteração na quantidade do produto
    ELSE IF NEW.QUANTIDADE <> OLD.QUANTIDADE THEN
        INSERT INTO log_produtos_atualizados (CODPRODUTO, ATRIBUTO, VALOR_ANTIGO, VALOR_NOVO, DATA_ATUALIZACAO)
        VALUES (NEW.CODPRODUTO, 'QUANTIDADE', OLD.QUANTIDADE, NEW.QUANTIDADE, NOW());
    END IF;
END;


