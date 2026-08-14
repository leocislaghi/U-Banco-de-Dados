--1. Criando a tabela de moradores: Crie uma tabela chamada moradores contendo: id, nome, email, idade; 
CREATE TABLE moradores (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome TEXT NOT NULL,
	email TEXT,
	idade INTEGER
);
-- 2. Cadastrando os moradores da vila: Cadastre pelo menos 10 personagens. 
INSERT INTO moradores (nome, email, idade)
			   VALUES ("Chaves", "chaves@gmail.com", 25),
					  ("Chiquinha", "chiquinha@gmail.com", 15),
					  ("Bruxa do 71", "Bruxa@gmail.com", 10),
					  ("Seu Madruga", "SeuMadruga@gmail.com", 30),
					  ("Quico", "quico@gmail.com", 17),
					  ("Dona Florinda", "DonaFlorinda@gmail.com", 45),
					  ("Girafales", "girafales@gmail.com", 39),
					  ("Barriga", "Barriga@gmail.com", 43),
					  ("Clotilde", "clotilde@gmail.com", 12),
					  ("Davi", "davi@gmail.com", 51);
					  
--Mostre a todos os moradores.
SELECT * FROM moradores;
--Mostre somente o nome e o e-mail dos moradores.
SELECT nome, email FROM moradores;
--Mostre os moradores com idade maior que 20 anos.
SELECT * FROM moradores WHERE idade > 20;
--Mostre os moradores com idade maior que 20 e menor que 50.
SELECT * FROM moradores WHERE idade > 20 AND idade < 50;
--Mostre os moradores com idade menor que 18 ou maior que 40.
SELECT * FROM moradores WHERE idade < 18 OR idade > 40;
--Mostre os moradores cujo nome começa com a letra `C`.
SELECT * FROM moradores WHERE nome LIKE "C%";
--Mostre os moradores cujo nome termina com a letra `a`.
SELECT * FROM moradores WHERE nome LIKE "%A";
--Mostrar os moradores do mais jovem para o mais velho.
SELECT * FROM moradores ORDER BY idade ASC;
--Mostrar os moradores do mais velho para o mais jovem.
SELECT * FROM moradores ORDER BY idade DESC;
--Mostrar somente os 3 moradores mais jovens.
SELECT * FROM moradores ORDER BY idade ASC LIMIT 3;
--Mostrar somente os 3 moradores mais velhos.
SELECT * FROM moradores ORDER BY idade DESC LIMIT 3;

SELECT * FROM moradores;

-- 1. Alterar o e-mail do Chaves.
UPDATE moradores SET email = "chavinho@gmail.com" WHERE id = 1;
-- 2. Alterar a idade da Chiquinha.
UPDATE moradores SET idade = 11 WHERE id = 2;
--3. Alterar o nome e o e-mail da Bruxa do 71.
UPDATE moradores SET nome = "Bruxinha", email = "bruxinha@gmail.com" WHERE id = 3;
--4. Alterar a idade de um personagem Seu Madruga.
UPDATE moradores SET idade = 56 WHERE id = 4;
--6. Alguém deixou a vila! 
--Um personagem decidiu abandonar a vila. Faça 1 delete.
DELETE FROM moradores WHERE id = 10;

-- Cadastre o telefone de pelo menos 5 moradores.
ALTER TABLE moradores 
ADD COLUMN telefone TEXT;

--Agora vamos criar uma segunda tabela chamada “atividades”
--Ela deverá possuir: id, nome;
--Cadastre pelo menos 5 atividades.
CREATE TABLE atividades (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL
);

INSERT INTO atividades (nome) VALUES
	('Futebol'),
	('Aula de Matemática'),
	('Reunião da Vila'),
	('Festa'),
	('Estudo');

-- SELECT * FROM atividades;
--Crie uma tabela chamada: participacoes.
--Ela deverá possuir: id, morador_id, atividade_id.
--Utilize chaves estrangeiras para relacionar os moradores às atividades.
CREATE TABLE participacoes (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	morador_id INTEGER NOT NULL,
	atividade_id INTEGER NOT NULL,
	
	FOREIGN KEY (morador_id) 
		REFERENCES moradores(id),
		
	FOREIGN KEY (atividade_id) 
		REFERENCES atividades(id)
);
--Depois, cadastre 10 participações. 
INSERT INTO participacoes (morador_id, atividade_id)
VALUES
(1, 1), -- Chaves -> Futebol
(2, 1), -- Chiquinha -> Futebol
(3, 1), -- Quico -> Futebol
(3, 2), -- Quico -> Aula de Matemática
(4, 3), -- Seu Madruga -> Reunião da Vila
(5, 3), -- Dona Florinda -> Reunião da Vila
(6, 2), -- Professor Girafales -> Aula de Matemática
(7, 4), -- Dona Clotilde -> Festa
(8, 5), -- Senhor Barriga -> Estudo
(9, 4); -- Nhonho -> Festa

SELECT * FROM participacoes;
--Quais moradores participam de quais atividades?
SELECT
    moradores.nome AS Morador,
    atividades.nome AS Atividade
FROM participacoes
INNER JOIN moradores
    ON participacoes.morador_id = moradores.id
INNER JOIN atividades
    ON participacoes.atividade_id = atividades.id;

--Crie uma consulta que mostre somente os moradores que participam da atividade "Futebol".
--Depois faça outra consulta mostrando: Todos os moradores e suas respectivas atividades.
SELECT
    moradores.nome AS Morador
FROM participacoes
INNER JOIN moradores
    ON participacoes.morador_id = moradores.id
INNER JOIN atividades
    ON participacoes.atividade_id = atividades.id
WHERE atividades.nome = 'Futebol';

-- Todos os moradores e suas respectivas atividades
SELECT
    moradores.nome AS Morador,
    atividades.nome AS Atividade
FROM moradores
LEFT JOIN participacoes
    ON moradores.id = participacoes.morador_id
LEFT JOIN atividades
    ON participacoes.atividade_id = atividades.id
ORDER BY moradores.nome;

-- Quantos moradores existem?
SELECT COUNT(*) AS quantidade_moradores
FROM moradores;

-- Qual é o morador mais velho?
SELECT nome, idade
FROM moradores
WHERE idade = (
    SELECT MAX(idade)
    FROM moradores
);

-- Qual é a menor idade?
SELECT MIN(idade) AS menor_idade
FROM moradores;

-- Qual é a idade média dos moradores?
SELECT AVG(idade) AS idade_media
FROM moradores;

-- Qual é a soma das idades de todos os moradores?
SELECT SUM(idade) AS soma_das_idades
FROM moradores;

-- Quantos moradores possuem cada idade?
SELECT
    idade,
    COUNT(*) AS quantidade
FROM moradores
GROUP BY idade
ORDER BY idade;





