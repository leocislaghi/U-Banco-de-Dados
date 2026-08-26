CREATE TABLE pacientes (
  pkcodpacientes INTEGER PRIMARY KEY,
  nome VARCHAR2(100) NOT NULL,
  cpf VARCHAR2(14) NOT NULL UNIQUE,
  telefone VARCHAR2(20),
  data_nascimento DATE,
  quantidade_consultas INTEGER DEFAULT 0 CHECK (quantidade_consultas >= 0)
);

CREATE TABLE medicos (
  pkcodmedico INTEGER PRIMARY KEY,
  nome VARCHAR2(100) NOT NULL,