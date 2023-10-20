-- Comandos SQL

-- Criação de Tabelas

CREATE TABLE Produto ( ID INTEGER PRIMARY KEY, CODIGO VARCHAR(255), NOME VARCHAR(255), PRECO FLOAT, DATA_ENTRADA_ESTOQUE DATE, QUANTIDADE_ESTOQUE INTEGER, CATEGORIA VARCHAR(255));
CREATE TABLE Cliente (ID INTEGER PRIMARY KEY, NOME VARCHAR(255), CPF VARCHAR(255), DATA_NASCIMENTO DATE);
CREATE TABLE Pedido (NUMERO INTEGER PRIMARY KEY, ID_CLIENTE INTEGER references Cliente(ID), ID_PRODUTO INTEGER references Produto(ID), DATA DATE, QUANTIDADE INTEGER);

-- Preenchimento das Tabelas

INSERT INTO Produto VALUES 
(1, '1A00001', 'Laranja', 3.56, '12/05/2022', 5, 'Fruta'), 
(2, '1A00002', 'Café', 8.99, '15/09/2022', 12, 'Grão'), 
(3, '13B0505', 'Água Mineral', 2.10, '11/01/2023', 8, 'Bebidas'), 
(4, '4E12122', 'Farinha', 5.00, '21/02/2023', 192, 'Grão');

INSERT INTO Cliente VALUES
(1, 'Marcos David', '011.011.011-12', '07/07/1970'),
(2, 'Daniel Lima', '012.012.012-13', '27/08/1994'),
(3, 'Brena Lima', '013.013.013-14', '12/11/2001'),
(4, 'Antonio Conrado', '014.014.014-15', '18/06/1987');

INSERT INTO Pedido VALUES
(1, 1, 2, '02/02/2023', 3),
(2, 1, 4, '27/01/2023', 5),
(3, 3, 2, '17/10/2022', 1),
(4, 2, 1, '20/12/2022', 2);

-- 1 - Retornar o código e nome dos produtos que entraram no estoque no ano de 2022, ordenados por quantidade em estoque DECRESCENTE.

SELECT * 
FROM Produto 
WHERE DATA_ENTRADA_ESTOQUE 
BETWEEN '01/01/2022' AND '31/12/2022' 
ORDER BY QUANTIDADE_ESTOQUE DESC;

-- 2 - Retornar o código de todos os produtos que não tiveram nenhum pedido.

SELECT CODIGO AS Código
FROM Produto
WHERE NOT EXISTS ( 
	SELECT ID_PRODUTO 
	FROM Pedido
	WHERE ID_PRODUTO = ID 
	);

-- 3 - Retornar o nome, CPF e IDADE de todos os clientes(a idade deve ser calculada), ordenando pela idade CRESCENTE.

SELECT NOME AS Nome_Cliente, AGE(CURRENT_DATE, DATA_NASCIMENTO) as Idade
FROM Cliente
ORDER BY IDADE ASC;

-- 4 - Retornar o nome e SOMA de produtos pedidos de todos os clientes(caso o cliente não tenha feito nenhum pedido, deve mostrar o valor zero).

SELECT Cliente.NOME AS Nome_Cliente, COALESCE(SUM(Pedido.QUANTIDADE), 0) AS Soma_de_Produtos_Pedidos
FROM Cliente
LEFT JOIN Pedido ON Cliente.ID = Pedido.ID_CLIENTE
LEFT JOIN Produto ON Pedido.ID_PRODUTO = Produto.ID
GROUP BY Cliente.NOME;

-- 5 - Retornar Nome do Cliente, Nome do Produto, e quantidade de pedidos feitos no ano de 2023.

SELECT Cliente.NOME AS Nome_Cliente, Produto.NOME AS Nome_Produto, Pedido.QUANTIDADE
FROM Pedido
INNER JOIN Cliente ON Pedido.ID_CLIENTE = Cliente.ID
INNER JOIN Produto ON Pedido.ID_PRODUTO = Produto.ID
WHERE EXTRACT(YEAR FROM Pedido.DATA) = 2023;

-- 6 - Retornar Código do Produto, Nome do Produto e Número de Pedidos feitos para esse produto, filtrando apenas produtos que tiveram no mínimo 3 unidades pedidas.

SELECT Produto.CODIGO as Código, Produto.NOME as Nome_Produto, Pedido.QUANTIDADE 
FROM Produto, Pedido 
WHERE Produto.ID = Pedido.ID_PRODUTO 
AND pedido.QUANTIDADE > 2;

-- 7 - Retornar o valor total(preço x quantidade) de pedidos feitos para produtos que entraram no estoque entre Junho de 2022 e Janeiro de 2023.

SELECT Pedido.NUMERO, Produto.NOME, Produto.PRECO * Pedido.QUANTIDADE AS Valor_total
FROM Produto, Pedido
WHERE Produto.DATA_ENTRADA_ESTOQUE > '01/06/2022' AND Produto.DATA_ENTRADA_ESTOQUE < '31/01/2023' AND Produto.ID = Pedido.ID_PRODUTO;

-- 8 - Retornar o nome do cliente, CPF e número de dias desde o último pedido dos clientes que possuem o sobrenome Lima.

SELECT Cliente.NOME AS Nome_Cliente, Cliente.CPF AS CPF, CURRENT_DATE - Pedido.DATA as Ultimo_pedido
FROM Cliente
INNER JOIN Pedido ON Cliente.ID = Pedido.ID_CLIENTE
WHERE Cliente.NOME LIKE '%Lima%';


-- 9 - Atualizar para 200 a quantidade em estoque dos produtos que tiveram pedidos feitos entre 01/12/2022 e 28/02/2023.

UPDATE Produto
SET QUANTIDADE_ESTOQUE = QUANTIDADE_ESTOQUE + 200 
FROM Pedido
WHERE Pedido.DATA > '01/12/2022' AND Pedido.DATA < '28/02/2023' AND Produto.ID = Pedido.ID_PRODUTO;

-- Checagem
SELECT NOME, QUANTIDADE_ESTOQUE FROM Produto ORDER BY ID ASC;

-- 10 - Excluir os pedidos dos produtos que tenham “00” no código.

DELETE FROM Pedido
WHERE ( SELECT Produto.CODIGO FROM PRODUTO WHERE Produto.ID = Pedido.ID_PRODUTO) LIKE '%00%';
