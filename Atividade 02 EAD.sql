--Criando Tabelas
CREATE TABLE clientes (
id INTEGER PRIMARY KEY,
nome TEXT NOT NULL,
cidade TEXT
);

CREATE TABLE produtos (
id INTEGER PRIMARY KEY,
nome TEXT NOT NULL,
categoria TEXT,
preco REAL
);

CREATE TABLE pedidos (
id INTEGER PRIMARY KEY,
cliente_id INTEGER,
produto_id INTEGER,
quantidade INTEGER,
FOREIGN KEY (cliente_id) REFERENCES clientes(id),
FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

--Inserindo os dados
INSERT INTO clientes VALUES
(1, "Ana", "Porto Alegre"),
(2, "Bruno", "Canoas"),
(3, "Carlos", "Gravataí"),
(4, "Daniela", "Porto Alegre"),
(5, "Eduardo", "Novo Hamburgo");

INSERT INTO produtos VALUES
(1, "Notebook", "Informática", 3500.00),
(2, "Mouse", "Informática", 80.00),
(3, "Teclado", "Informática", 150.00),
(4, "Cadeira Gamer", "Móveis", 1200.00),
(5, "Monitor", "Informática", 950.00);

INSERT INTO pedidos VALUES
(1, 1, 1, 1),
(2, 1, 2, 2),
(3, 2, 3, 1),
(4, 2, 5, 2),
(5, 3, 4, 1),
(6, 4, 1, 1),
(7, 4, 5, 1),
(8, 5, 2, 3),
(9, 5, 3, 2);

-- 1. Liste o nome dos clientes que compraram o produto Notebook.
SELECT nome FROM clientes WHERE id IN (
	SELECT cliente_id FROM pedidos WHERE produto_id = (
		SELECT id FROM produtos WHERE nome = "Notebook"
	)
);	
-- 2. Mostre os nomes dos produtos comprados pela cliente Ana.
SELECT nome FROM produtos WHERE id IN (
	SELECT produto_id FROM pedidos WHERE cliente_id = (
		SELECT id FROM clientes WHERE nome = "Ana"
	)
);

-- 3. Liste os nomes dos clientes que realizaram pedidos de produtos pertencentes à categoria Informática.
SELECT nome FROM clientes WHERE id IN (
	SELECT cliente_id FROM  pedidos WHERE produto_id IN (
		SELECT id FROM produtos WHERE categoria = "Informática"
	)
);

-- 4. Mostre os nomes dos produtos que não aparecem em nenhum pedido.
SELECT produto_id FROM pedidos;
	
	SELECT nome FROM produtos WHERE id NOT IN (
		SELECT produto_id FROM pedidos
	);

-- 5. Liste os clientes que compraram produtos cujo preço é maior que a média de preço de todos os produtos.
SELECT avg(preco) FROM produtos;

SELECT nome FROM clientes WHERE id IN (
	SELECT cliente_id FROM pedidos WHERE produto_id IN (
		SELECT id FROM produtos WHERE preco > (
			SELECT avg(preco) FROM produtos
		)
	)
);