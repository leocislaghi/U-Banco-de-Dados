CREATE TABLE clientes (
  id INTEGER PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  idade INTEGER NOT NULL
);

CREATE OR REPLACE PROCEDURE cadastrar_cliente(
  p_id INTEGER,
  p_nome VARCHAR2,
  p_idade INTEGER
) AS
BEGIN
INSERT INTO clientes (id, nome, idade) VALUES (p_id, p_nome, p_idade);
DBMS_OUTPUT.PUT_LINE('Cadastrado com sucesso');
END;
/

SET SERVEROUTPUT ON ;
EXECUTE cadastrar_cliente(3, 'Leo', 18);

SELECT * FROM clientes;

SET SERVEROUTPUT ON ;


CREATE OR REPLACE PROCEDURE buscar_cliente (
  p_id IN INTEGER
) AS
  p_nome VARCHAR2(100);
BEGIN
  SELECT nome INTO p_nome FROM clientes WHERE id = p_id;
  DBMS_OUTPUT.PUT_LINE(p_nome);
END;


SET SERVEROUTPUT ON;
EXECUTE buscar_cliente(1);
/

EXCEPTION
  WHEN NO_DATA_FOUND THEN 
  DBMS_OUTPUT.PUT_LINE('Cliente nao cadastrado);
END;


