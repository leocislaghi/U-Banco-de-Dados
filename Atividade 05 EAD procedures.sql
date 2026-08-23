CREATE TABLE tbmarca (

    pkcodmarca INTEGER PRIMARY KEY,

    nomemarca VARCHAR2(30) NOT NULL,

    quantveiculos INTEGER DEFAULT 0

);



CREATE TABLE tbtipodespesa (

    pktipodesp INTEGER PRIMARY KEY,

    descricaodesp VARCHAR2(30) NOT NULL,

    somatoriodesp NUMBER(15,2) DEFAULT 0,

    servicoproduto INTEGER

);



CREATE TABLE tbveiculo (

    pkcodveiculo INTEGER PRIMARY KEY,

    placa VARCHAR2(8) NOT NULL,

    modelo VARCHAR2(30),

    valorcompra NUMBER(15,2),

    valorvenda NUMBER(15,2),

    somatoriodespesa NUMBER(15,2) DEFAULT 0,

    quantdespesas INTEGER DEFAULT 0,

    mediapordespesa NUMBER(15,2) DEFAULT 0,

    lucrovenda NUMBER(15,2),

    fkcodmarca INTEGER,

    vendido INTEGER DEFAULT 0,



    FOREIGN KEY (fkcodmarca)

    REFERENCES tbmarca(pkcodmarca)

);



CREATE TABLE tbdespesasvei (

    pkcoddespvei INTEGER PRIMARY KEY,

    descricaodespesa VARCHAR2(60) NOT NULL,

    datalanc DATE,

    valordespesa NUMBER(15,2) NOT NULL,

    fkcodvei INTEGER NOT NULL,

    fktipodesp INTEGER NOT NULL,



    FOREIGN KEY (fkcodvei)

    REFERENCES tbveiculo(pkcodveiculo),

    

    FOREIGN KEY (fktipodesp)

	    REFERENCES tbtipodespesa(pktipodesp)

);



INSERT INTO tbmarca ( pkcodmarca, nomemarca, quantveiculos) VALUES ( 1, 'Toyota', 2);

INSERT INTO tbmarca ( pkcodmarca, nomemarca, quantveiculos) VALUES ( 2, 'Honda', 1);

INSERT INTO tbmarca ( pkcodmarca, nomemarca, quantveiculos) VALUES ( 3, 'Volkswagen', 0);



INSERT INTO tbtipodespesa ( pktipodesp, descricaodesp, somatoriodesp, servicoproduto) VALUES ( 1, 'Manutenção', 0, 1);

INSERT INTO tbtipodespesa ( pktipodesp, descricaodesp, somatoriodesp, servicoproduto) VALUES ( 2, 'Combustível', 0, 1);

INSERT INTO tbtipodespesa ( pktipodesp, descricaodesp, somatoriodesp, servicoproduto) VALUES ( 3, 'Documentação', 0, 1);



INSERT INTO tbveiculo ( pkcodveiculo, placa, modelo, valorcompra, valorvenda, somatoriodespesa, quantdespesas, mediapordespesa, lucrovenda, fkcodmarca, vendido) VALUES ( 1, 'ABC1234', 'Corolla', 80000, NULL, 0, 0, 0, NULL, 1, 0);

INSERT INTO tbveiculo ( pkcodveiculo, placa, modelo, valorcompra, valorvenda, somatoriodespesa, quantdespesas, mediapordespesa, lucrovenda, fkcodmarca, vendido) VALUES ( 2, 'DEF5678', 'Hilux', 120000, NULL, 0, 0, 0, NULL, 1, 0);

INSERT INTO tbveiculo ( pkcodveiculo, placa, modelo, valorcompra, valorvenda, somatoriodespesa, quantdespesas, mediapordespesa, lucrovenda, fkcodmarca, vendido) VALUES ( 3, 'GHI9012', 'Civic', 90000, NULL, 0, 0, 0, NULL, 2, 0);



INSERT INTO tbdespesasvei ( pkcoddespvei, descricaodespesa, datalanc, valordespesa, fkcodvei, fktipodesp) VALUES ( 1, 'Troca de óleo', DATE '2026-08-10', 500, 1, 1);

INSERT INTO tbdespesasvei ( pkcoddespvei, descricaodespesa, datalanc, valordespesa, fkcodvei, fktipodesp) VALUES ( 2, 'Abastecimento', DATE '2026-08-11', 300, 1, 2);

INSERT INTO tbdespesasvei ( pkcoddespvei, descricaodespesa, datalanc, valordespesa, fkcodvei, fktipodesp) VALUES ( 3, 'Revisão', DATE '2026-08-12', 700, 2, 1);



SELECT * FROM tbmarca;

SELECT * FROM tbveiculo;

SELECT * FROM tbtipodespesa;

SELECT * FROM tbdespesasvei;



CREATE OR REPLACE PROCEDURE cadastrar_marca (

    p_nomemarca IN VARCHAR2

)

AS

    v_codigo NUMBER;

BEGIN



    SELECT NVL(MAX(pkcodmarca),0) + 1

    INTO v_codigo

    FROM tbmarca;



    INSERT INTO tbmarca (

        pkcodmarca,

        nomemarca

    )

    VALUES (

        v_codigo,

        p_nomemarca

    );



    DBMS_OUTPUT.PUT_LINE('Marca cadastrada com sucesso!');

    DBMS_OUTPUT.PUT_LINE('Código: ' || v_codigo);

    DBMS_OUTPUT.PUT_LINE('Nome: ' || p_nomemarca);



END;

/



BEGIN

    cadastrar_marca('Ford');

END;

/



SELECT * FROM tbmarca;



CREATE OR REPLACE PROCEDURE cadastrar_veiculo (

    p_placa       IN VARCHAR2,

    p_modelo      IN VARCHAR2,

    p_valorcompra IN NUMBER,

    p_codmarca    IN NUMBER

)

AS

    v_codveiculo NUMBER;

    v_nomemarca VARCHAR2(30);

    v_quantveiculos NUMBER;

BEGIN



    SELECT NVL(MAX(pkcodveiculo), 0) + 1

    INTO v_codveiculo

    FROM tbveiculo;



    SELECT nomemarca, quantveiculos

    INTO v_nomemarca, v_quantveiculos

    FROM tbmarca

    WHERE pkcodmarca = p_codmarca;



    INSERT INTO tbveiculo (

        pkcodveiculo,

        placa,

        modelo,

        valorcompra,

        fkcodmarca

    )

    VALUES (

        v_codveiculo,

        p_placa,

        p_modelo,

        p_valorcompra,

        p_codmarca

    );



    DBMS_OUTPUT.PUT_LINE('Veiculo cadastrado!');

    DBMS_OUTPUT.PUT_LINE('Codigo: ' || v_codveiculo);

    DBMS_OUTPUT.PUT_LINE('Marca: ' || v_nomemarca);

    DBMS_OUTPUT.PUT_LINE('Veiculos atuais da marca: ' || v_quantveiculos);



    UPDATE tbmarca

    SET quantveiculos = quantveiculos + 1

    WHERE pkcodmarca = p_codmarca;



    DBMS_OUTPUT.PUT_LINE('Quantidade de veiculos atualizada!');



END;

/



EXEC cadastrar_veiculo('JKL3456', 'Onix', 75000, 3);



SELECT * FROM tbveiculo;

SELECT * FROM tbmarca;



CREATE OR REPLACE PROCEDURE prc_vender_veiculo (

    p_placa IN tbveiculo.placa%TYPE,

    p_novo_valorvenda IN tbveiculo.valorvenda%TYPE

) AS

    v_codveiculo tbveiculo.pkcodveiculo%TYPE;

    v_valorcompra tbveiculo.valorcompra%TYPE;

    v_somatoriodespesa tbveiculo.somatoriodespesa%TYPE;

    v_lucro tbveiculo.lucrovenda%TYPE;

BEGIN



    SELECT pkcodveiculo, valorcompra, NVL(somatoriodespesa, 0)

    INTO v_codveiculo, v_valorcompra, v_somatoriodespesa

    FROM tbveiculo

    WHERE placa = p_placa;



    v_lucro := p_novo_valorvenda - v_valorcompra - v_somatoriodespesa;



    UPDATE tbveiculo

    SET valorvenda = p_novo_valorvenda,

        lucrovenda = v_lucro,

        vendido = 1

    WHERE pkcodveiculo = v_codveiculo;



    DBMS_OUTPUT.PUT_LINE('Veículo de placa ' || p_placa || ' vendido com sucesso!');

    DBMS_OUTPUT.PUT_LINE('Valor de Venda: R$ ' || p_novo_valorvenda);

    DBMS_OUTPUT.PUT_LINE('Lucro Calculado: R$ ' || v_lucro);

    DBMS_OUTPUT.PUT_LINE('Status alterado para Vendido (1).');



EXCEPTION

    WHEN NO_DATA_FOUND THEN

        DBMS_OUTPUT.PUT_LINE('Erro: Nenhum veículo localizado com a placa ' || p_placa);

    WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('Erro ao realizar a venda: ' || SQLERRM);

END;

/



SET SERVEROUTPUT ON;



EXEC prc_vender_veiculo('ABC1234', 85000);



SELECT * FROM tbveiculo WHERE placa = 'ABC1234';</sql><current_tab id="0"/></tab_sql></sqlb_project>
