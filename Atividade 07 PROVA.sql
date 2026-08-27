----------------------------------------------------------------------
-- 1. LIMPEZA (permite executar o script novamente)
----------------------------------------------------------------------
BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_ingresso_delete';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_ingresso_cancelamento';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_ingressos_id';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_sessoes_id';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_clientes_id';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_salas_id';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_filmes_id';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE realizar_venda';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE criar_sessao';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP PROCEDURE cadastrar_cliente';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE ingressos CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE sessoes CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE clientes CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE salas CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE filmes CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_ingressos';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_sessoes';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_clientes';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_salas';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_filmes';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

----------------------------------------------------
-- Fim da Limpeza e começo do código
----------------------------------------------------











CREATE TABLE filmes (
    id_filme NUMBER PRIMARY KEY,
    titulo VARCHAR2(150) NOT NULL,
    genero VARCHAR2(100),
    duracao_minutos NUMBER NOT NULL,
    classificacao VARCHAR2(10),

    CONSTRAINT uq_filmes_titulo UNIQUE (titulo),

    CONSTRAINT ck_filmes_titulo
        CHECK (TRIM(titulo) IS NOT NULL),

    CONSTRAINT ck_filmes_duracao
        CHECK (duracao_minutos > 0),

    CONSTRAINT ck_filmes_classificacao
        CHECK (classificacao IN ('Livre','10','12','14','16','18'))
);

CREATE TABLE salas (
    id_sala NUMBER PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    capacidade NUMBER NOT NULL,
    exibicoes_realizadas NUMBER,

    CONSTRAINT ck_salas_nome
        CHECK (TRIM(nome) IS NOT NULL),

    CONSTRAINT ck_salas_capacidade
        CHECK (capacidade BETWEEN 10 AND 500),

    CONSTRAINT ck_salas_exibicoes
        CHECK (exibicoes_realizadas >= 0)
);

CREATE TABLE clientes (
    id_cliente NUMBER PRIMARY KEY,
    nome VARCHAR2(150) NOT NULL,
    cpf VARCHAR2(14) NOT NULL,
    email VARCHAR2(150) NOT NULL,
    idade NUMBER,
    sexo CHAR(1),
    ingressos_comprados NUMBER DEFAULT 0 NOT NULL,
    cancelamentos NUMBER DEFAULT 0 NOT NULL,

    CONSTRAINT uq_clientes_cpf UNIQUE (cpf),
    CONSTRAINT uq_clientes_email UNIQUE (email),

    CONSTRAINT ck_clientes_nome
        CHECK (TRIM(nome) IS NOT NULL),

    CONSTRAINT ck_clientes_cpf
        CHECK (TRIM(cpf) IS NOT NULL),

    CONSTRAINT ck_clientes_email
        CHECK (TRIM(email) IS NOT NULL),

    CONSTRAINT ck_clientes_sexo
        CHECK (sexo IN ('M','F')),

    CONSTRAINT ck_clientes_ingressos
        CHECK (ingressos_comprados >= 0),

    CONSTRAINT ck_clientes_cancelamentos
        CHECK (cancelamentos >= 0)
);

CREATE TABLE sessoes (
    id_sessao NUMBER PRIMARY KEY,
    id_filme NUMBER NOT NULL,
    id_sala NUMBER NOT NULL,
    data_hora_inicio DATE NOT NULL,
    lugares_disponiveis NUMBER DEFAULT 100 NOT NULL,
    ingressos_vendidos NUMBER DEFAULT 0 NOT NULL,

    CONSTRAINT fk_sessoes_filme
        FOREIGN KEY (id_filme)
        REFERENCES filmes(id_filme),

    CONSTRAINT fk_sessoes_sala
        FOREIGN KEY (id_sala)
        REFERENCES salas(id_sala),

    CONSTRAINT ck_sessoes_lugares
        CHECK (lugares_disponiveis > 0),

    CONSTRAINT ck_sessoes_vendidos
        CHECK (ingressos_vendidos >= 0),

    CONSTRAINT ck_sessoes_limite
        CHECK (ingressos_vendidos <= lugares_disponiveis)
);

CREATE TABLE ingressos (
    id_ingresso NUMBER PRIMARY KEY,
    id_sessao NUMBER NOT NULL,
    id_cliente NUMBER NOT NULL,
    numero_assento NUMBER NOT NULL,
    tipo_ingresso NUMBER NOT NULL,
    status NUMBER DEFAULT 0 NOT NULL,

    CONSTRAINT fk_ingressos_sessao
        FOREIGN KEY (id_sessao)
        REFERENCES sessoes(id_sessao),

    CONSTRAINT fk_ingressos_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),

    CONSTRAINT ck_ingressos_assento
        CHECK (numero_assento > 0),

    CONSTRAINT ck_ingressos_tipo
        CHECK (tipo_ingresso IN (0,1)),

    CONSTRAINT ck_ingressos_status
        CHECK (status IN (0,1))
);

CREATE SEQUENCE seq_filmes
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE seq_salas
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE seq_clientes
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE seq_sessoes
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE seq_ingressos
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE OR REPLACE TRIGGER trg_filmes_id
BEFORE INSERT ON filmes
FOR EACH ROW
BEGIN
    IF :NEW.id_filme IS NULL THEN
        SELECT seq_filmes.NEXTVAL
        INTO :NEW.id_filme
        FROM dual;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_salas_id
BEFORE INSERT ON salas
FOR EACH ROW
BEGIN
    IF :NEW.id_sala IS NULL THEN
        SELECT seq_salas.NEXTVAL
        INTO :NEW.id_sala
        FROM dual;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_clientes_id
BEFORE INSERT ON clientes
FOR EACH ROW
BEGIN
    IF :NEW.id_cliente IS NULL THEN
        SELECT seq_clientes.NEXTVAL
        INTO :NEW.id_cliente
        FROM dual;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_sessoes_id
BEFORE INSERT ON sessoes
FOR EACH ROW
BEGIN
    IF :NEW.id_sessao IS NULL THEN
        SELECT seq_sessoes.NEXTVAL
        INTO :NEW.id_sessao
        FROM dual;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_ingressos_id
BEFORE INSERT ON ingressos
FOR EACH ROW
BEGIN
    IF :NEW.id_ingresso IS NULL THEN
        SELECT seq_ingressos.NEXTVAL
        INTO :NEW.id_ingresso
        FROM dual;
    END IF;
END;
/

INSERT INTO filmes
    (titulo, genero, duracao_minutos, classificacao)
VALUES
    ('Interestelar', 'Ficcao Cientifica', 170, '14');

INSERT INTO filmes
    (titulo, genero, duracao_minutos, classificacao)
VALUES
    ('Minions', 'Comedia', 175, 'Livre');

INSERT INTO filmes
    (titulo, genero, duracao_minutos, classificacao)
VALUES
    ('Toy Story', 'Animacao', 81, 'Livre');

INSERT INTO filmes
    (titulo, genero, duracao_minutos, classificacao)
VALUES
    ('Homem Aranha', 'Acao', 122, '14');

INSERT INTO filmes
    (titulo, genero, duracao_minutos, classificacao)
VALUES
    ('Coringa', 'Drama', 160, '16');
    
INSERT INTO salas
    (nome, capacidade, exibicoes_realizadas)
VALUES
    ('Sala 01 - IMAX', 300, 50);

INSERT INTO salas
    (nome, capacidade, exibicoes_realizadas)
VALUES
    ('Sala 02 - 3D', 200, 35);

INSERT INTO salas
    (nome, capacidade, exibicoes_realizadas)
VALUES
    ('Sala 03 - Convencional', 150, NULL);

INSERT INTO salas
    (nome, capacidade, exibicoes_realizadas)
VALUES
    ('Sala 04 - Premium', 100, 20);
    
INSERT INTO clientes
    (nome, cpf, email, idade, sexo)
VALUES
    ('Leonardo Cislaghi', '11111111111', 'leo@gmail.com', 25, 'M');

INSERT INTO clientes
    (nome, cpf, email, idade, sexo)
VALUES
    ('Miguel Braz', '22222222222', 'miguel@gmail.com', 22, 'M');

INSERT INTO clientes
    (nome, cpf, email, idade, sexo)
VALUES
    ('Luis Oliveira', '33333333333', 'luis@gmail.com', 31, 'M');

INSERT INTO clientes
    (nome, cpf, email, idade, sexo)
VALUES
    ('Ana Carolina', '44444444444', 'ana@gmail.com', 19, 'F');
    
INSERT INTO sessoes
    (id_filme, id_sala, data_hora_inicio, lugares_disponiveis, ingressos_vendidos)
VALUES
    (1, 1, TO_DATE('01/09/2026 19:30:00','DD/MM/YYYY HH24:MI:SS'), 300, 0);

INSERT INTO sessoes
    (id_filme, id_sala, data_hora_inicio, lugares_disponiveis, ingressos_vendidos)
VALUES
    (2, 2, TO_DATE('01/09/2026 20:00:00','DD/MM/YYYY HH24:MI:SS'), 200, 0);

INSERT INTO sessoes
    (id_filme, id_sala, data_hora_inicio, lugares_disponiveis, ingressos_vendidos)
VALUES
    (3, 3, TO_DATE('02/09/2026 15:00:00','DD/MM/YYYY HH24:MI:SS'), 150, 0);

INSERT INTO sessoes
    (id_filme, id_sala, data_hora_inicio, lugares_disponiveis, ingressos_vendidos)
VALUES
    (4, 1, TO_DATE('02/09/2026 21:00:00','DD/MM/YYYY HH24:MI:SS'), 300, 0);
    
CREATE OR REPLACE PROCEDURE cadastrar_cliente (
    p_nome IN VARCHAR2,
    p_cpf IN VARCHAR2,
    p_email IN VARCHAR2,
    p_idade IN NUMBER,
    p_sexo IN CHAR
)
IS
BEGIN
    INSERT INTO clientes
        (nome, cpf, email, idade, sexo)
    VALUES
        (p_nome, p_cpf, p_email, p_idade, p_sexo);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Cliente cadastrado com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE criar_sessao (
    p_id_filme IN NUMBER,
    p_id_sala IN NUMBER,
    p_data_hora_inicio IN DATE,
    p_lugares_disponiveis IN NUMBER,
    p_ingressos_vendidos IN NUMBER
)
IS
BEGIN
    INSERT INTO sessoes
        (
            id_filme,
            id_sala,
            data_hora_inicio,
            lugares_disponiveis,
            ingressos_vendidos
        )
    VALUES
        (
            p_id_filme,
            p_id_sala,
            p_data_hora_inicio,
            NVL(p_lugares_disponiveis, 100),
            NVL(p_ingressos_vendidos, 0)
        );

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Sessao criada com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE realizar_venda (
    p_id_sessao IN NUMBER,
    p_id_cliente IN NUMBER,
    p_numero_assento IN NUMBER,
    p_tipo_ingresso IN NUMBER,
    p_status IN NUMBER
)
IS
    v_lugares NUMBER;
    v_vendidos NUMBER;
BEGIN

    SELECT lugares_disponiveis, ingressos_vendidos
    INTO v_lugares, v_vendidos
    FROM sessoes
    WHERE id_sessao = p_id_sessao
    FOR UPDATE;

    IF v_vendidos >= v_lugares THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Nao existem lugares disponiveis nesta sessao.'
        );
    END IF;

    INSERT INTO ingressos
        (
            id_sessao,
            id_cliente,
            numero_assento,
            tipo_ingresso,
            status
        )
    VALUES
        (
            p_id_sessao,
            p_id_cliente,
            p_numero_assento,
            p_tipo_ingresso,
            p_status
        );

    UPDATE sessoes
    SET ingressos_vendidos = ingressos_vendidos + 1
    WHERE id_sessao = p_id_sessao;

    UPDATE clientes
    SET ingressos_comprados = ingressos_comprados + 1
    WHERE id_cliente = p_id_cliente;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Venda realizada com sucesso.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

CREATE OR REPLACE TRIGGER trg_ingresso_delete
AFTER DELETE ON ingressos
FOR EACH ROW
BEGIN

    UPDATE sessoes
    SET ingressos_vendidos =
        CASE
            WHEN ingressos_vendidos > 0
            THEN ingressos_vendidos - 1
            ELSE 0
        END
    WHERE id_sessao = :OLD.id_sessao;

    UPDATE clientes
    SET ingressos_comprados =
        CASE
            WHEN ingressos_comprados > 0
            THEN ingressos_comprados - 1
            ELSE 0
        END
    WHERE id_cliente = :OLD.id_cliente;

END;
/

CREATE OR REPLACE TRIGGER trg_ingresso_cancelamento
AFTER UPDATE OF status ON ingressos
FOR EACH ROW
BEGIN

    IF :OLD.status = 0 AND :NEW.status = 1 THEN

        UPDATE clientes
        SET cancelamentos = cancelamentos + 1
        WHERE id_cliente = :NEW.id_cliente;

    END IF;

END;
/

BEGIN
    cadastrar_cliente(
        'Carlos Moraes',
        '55555555555',
        'carlos@email.com',
        31,
        'M'
    );
END;
/

BEGIN
    criar_sessao(
        1,
        3,
        TO_DATE('03/09/2026 19:00:00','DD/MM/YYYY HH24:MI:SS'),
        NULL,
        NULL
    );
END;
/

BEGIN
    realizar_venda(
        1,
        5,
        30,
        0,
        0
    );
END;
/

SELECT * FROM filmes;

SELECT * FROM salas;

SELECT * FROM clientes;

SELECT * FROM sessoes;

SELECT * FROM ingressos;

COMMIT;
