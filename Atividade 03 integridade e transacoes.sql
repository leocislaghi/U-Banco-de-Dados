CREATE TABLE destinos (
	id INTEGER PRIMARY KEY,
	nome TEXT NOT NULL UNIQUE
);

CREATE TABLE aeronaves (
	id INTEGER NOT NULL,
	ano_fabricacao INTEGER NOT NULL,
	modelo TEXT NOT NULL,
	numero_voos INTEGER DEFAULT 0,
	CHECK (numero_voos >= 0 AND numero_voos <= 40000)
);
CREATE TABLE voos (
    id INTEGER PRIMARY KEY,
    numero_voo INTEGER NOT NULL,
    origem_id INTEGER NOT NULL,
    destino_id INTEGER NOT NULL,
    data_hora_saida TEXT NOT NULL,
    data_hora_chegada TEXT NOT NULL,
    numero_poltronas INTEGER NOT NULL DEFAULT 120,
    lugares_ocupados INTEGER NOT NULL DEFAULT 0,

    FOREIGN KEY (origem_id) REFERENCES destinos(id) ON DELETE CASCADE,
    FOREIGN KEY (destino_id) REFERENCES destinos(id) ON DELETE CASCADE,

    CHECK (lugares_ocupados <= numero_poltronas)
);

CREATE TABLE clientes (
	id INTEGER PRIMARY KEY,
	nome TEXT NOT NULL,
	endereco TEXT,
	bairro TEXT,
	idade INTEGER,
	cpf TEXT NOT NULL,
	sexo TEXT NOT NULL CHECK (sexo IN ('M', 'F')),
	nome_mae TEXT,
	quantidade_reservas INTEGER NOT NULL DEFAULT 0 CHECK (quantidade_reservas >= 0),
	quantidade_cancelamentos INTEGER NOT NULL DEFAULT 0 CHECK (quantidade_cancelamentos >= 0)
);

CREATE TABLE reservas (
    id INTEGER PRIMARY KEY,
    voo_id INTEGER NOT NULL,
    numero_poltrona INTEGER NOT NULL,
    cliente_id INTEGER NOT NULL,
    nome_passageiro TEXT NOT NULL,
    idade_passageiro INTEGER NOT NULL,
    cpf_passageiro TEXT NOT NULL,
    status INTEGER NOT NULL CHECK (status IN (0, 1)),

    FOREIGN KEY (voo_id) REFERENCES voos(id) ON DELETE CASCADE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE
);

INSERT INTO destinos VALUES
(1, 'Porto Alegre'),
(2, 'São Paulo');

INSERT INTO clientes (
    id, nome, cpf, sexo
) VALUES (
    1, 'João', '12345678900', 'M'
);

INSERT INTO voos (
    id,
    numero_voo,
    origem_id,
    destino_id,
    data_hora_saida,
    data_hora_chegada
) VALUES (
    1,
    100,
    1,
    2,
    '2026-08-20 10:00',
    '2026-08-20 12:00'
);

BEGIN TRANSACTION;

INSERT INTO reservas (
    voo_id,
    numero_poltrona,
    cliente_id,
    nome_passageiro,
    idade_passageiro,
    cpf_passageiro,
    status
)
VALUES (
    1,
    10,
    1,
    'João',
    20,
    '12345678900',
    0
);

UPDATE voos
SET lugares_ocupados = lugares_ocupados + 1
WHERE id = 1;

UPDATE clientes
SET quantidade_reservas = quantidade_reservas + 1
WHERE id = 1;

COMMIT;

BEGIN TRANSACTION;

INSERT INTO reservas (
    voo_id,
    numero_poltrona,
    cliente_id,
    nome_passageiro,
    idade_passageiro,
    cpf_passageiro,
    status
)
VALUES (
    1,
    11,
    1,
    'João',
    20,
    '12345678900',
    0
);

SAVEPOINT s1;

UPDATE voos
SET lugares_ocupados = lugares_ocupados + 1
WHERE id = 1;

UPDATE clientes
SET quantidade_reservas = quantidade_reservas + 1
WHERE id = 1;

ROLLBACK TO s1;

UPDATE voos
SET lugares_ocupados = lugares_ocupados - 1
WHERE id = 1;

UPDATE clientes
SET quantidade_reservas = quantidade_reservas - 1
WHERE id = 1;

UPDATE clientes
SET quantidade_cancelamentos = quantidade_cancelamentos + 1
WHERE id = 1;

COMMIT;

