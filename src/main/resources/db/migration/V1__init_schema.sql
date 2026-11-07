CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TYPE tipo_usuario_enum AS ENUM ('EMBARCADOR', 'TRANSPORTADORA', 'MOTORISTA', 'ADMIN');
CREATE TYPE status_conta_enum AS ENUM ('PENDENTE', 'ATIVA', 'SUSPENSA', 'BLOQUEADA');
CREATE TYPE tipo_documento_enum AS ENUM ('CNH', 'CRLV', 'CNPJ', 'RNTRC', 'COMPROVANTE_ENDERECO');
CREATE TYPE status_validacao_enum AS ENUM ('PENDENTE', 'APROVADO', 'REPROVADO');
CREATE TYPE status_frete_enum AS ENUM ('ABERTO', 'RESERVADO', 'EM_ANDAMENTO', 'CONCLUIDO', 'CANCELADO');
CREATE TYPE status_viagem_enum AS ENUM ('AGENDADA', 'AGUARDANDO_PAGAMENTO', 'AGUARDANDO_COLETA', 'EM_TRANSITO', 'FINALIZADA', 'EM_DISPUTA');
CREATE TYPE status_pagamento_enum AS ENUM ('PENDENTE', 'RETIDO', 'LIBERADO', 'ESTORNADO');
CREATE TYPE tipo_comprovante_enum AS ENUM ('COLETA', 'ENTREGA', 'CANHOTO');
CREATE TYPE status_disputa_enum AS ENUM ('ABERTA', 'EM_ANALISE', 'RESOLVIDA', 'ENCERRADA');

CREATE TABLE endereco (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    logradouro VARCHAR(255) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep VARCHAR(9) NOT NULL,
    latitude NUMERIC(10, 7),
    longitude NUMERIC(10, 7)
);

CREATE TABLE usuario (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    aceite_lgpd BOOLEAN NOT NULL DEFAULT FALSE,
    aceite_lgpd_em TIMESTAMP,
    tipo_usuario tipo_usuario_enum NOT NULL,
    status_conta status_conta_enum NOT NULL DEFAULT 'PENDENTE'
);

CREATE TABLE categoria_carga (
    id SMALLINT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE embarcador (
    id UUID PRIMARY KEY REFERENCES usuario(id) ON DELETE CASCADE,
    razao_social VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) NOT NULL UNIQUE,
    endereco_id UUID NOT NULL REFERENCES endereco(id)
);

CREATE TABLE transportadora (
    id UUID PRIMARY KEY REFERENCES usuario(id) ON DELETE CASCADE,
    razao_social VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) NOT NULL UNIQUE,
    rntrc VARCHAR(20) NOT NULL,
    endereco_id UUID NOT NULL REFERENCES endereco(id)
);

CREATE TABLE motorista (
    id UUID PRIMARY KEY REFERENCES usuario(id) ON DELETE CASCADE,
    nome_completo VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    cnh_numero VARCHAR(20) NOT NULL UNIQUE,
    cnh_validade DATE NOT NULL,
    status_bloqueio BOOLEAN NOT NULL DEFAULT FALSE,
    motivo_bloqueio TEXT,
    categoria_carga_preferencial_id SMALLINT REFERENCES categoria_carga(id) ON DELETE RESTRICT,
    transportadora_id UUID REFERENCES transportadora(id)
);

CREATE TABLE veiculo (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    motorista_id UUID NOT NULL REFERENCES motorista(id) ON DELETE CASCADE,
    placa VARCHAR(8) NOT NULL UNIQUE,
    tipo_veiculo VARCHAR(50) NOT NULL,
    crlv_validade DATE NOT NULL
);

CREATE TABLE documento (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuario(id) ON DELETE CASCADE,
    tipo_documento tipo_documento_enum NOT NULL,
    status_validacao status_validacao_enum NOT NULL DEFAULT 'PENDENTE',
    url_arquivo TEXT NOT NULL
);

CREATE TABLE notificacao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuario(id) ON DELETE CASCADE,
    tipo VARCHAR(50) NOT NULL,
    mensagem TEXT NOT NULL,
    lida BOOLEAN NOT NULL DEFAULT FALSE,
    data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE frete (
