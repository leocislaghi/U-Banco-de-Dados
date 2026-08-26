CREATE TABLE especialidades (
    id INTEGER PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL UNIQUE,
    valor_consulta NUMBER(10,2) DEFAULT 250.00 CHECK (valor_consulta >= 0)
);

CREATE TABLE pacientes (
  pkcodpacientes INTEGER PRIMARY KEY,
  nome VARCHAR2(100) NOT NULL,
  cpf VARCHAR2(14) NOT NULL UNIQUE,
  telefone VARCHAR2(20),
  data_nascimento DATE,
  quantidade_consultas INTEGER DEFAULT 0 CHECK (quantidade_consultas >= 0)
);

CREATE TABLE medicos (
    id INTEGER PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    crm VARCHAR2(20) NOT NULL UNIQUE,
    telefone VARCHAR2(20),
    id_especialidade INTEGER NOT NULL,

    CONSTRAINT fk_medico_especialidade
        FOREIGN KEY (id_especialidade)
        REFERENCES especialidades(id)
        ON DELETE CASCADE
);

CREATE TABLE convenios (
    id INTEGER PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL UNIQUE,
    telefone VARCHAR2(20),
    percentual_desconto NUMBER(5,2) DEFAULT 0
        CHECK (percentual_desconto BETWEEN 0 AND 100)
);

CREATE TABLE consultas (
    id INTEGER PRIMARY KEY,
    id_paciente INTEGER NOT NULL,
    id_medico INTEGER NOT NULL,
    data_consulta DATE NOT NULL,
    horario VARCHAR2(5) NOT NULL,
    valor NUMBER(10,2) DEFAULT 250.00
        CHECK (valor >= 0),
    status VARCHAR2(10) DEFAULT 'Agendada' NOT NULL
        CHECK (status IN ('Agendada', 'Realizada', 'Cancelada')),

    CONSTRAINT fk_consulta_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES pacientes(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_consulta_medico
        FOREIGN KEY (id_medico)
        REFERENCES medicos(id)
        ON DELETE CASCADE
);