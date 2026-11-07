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
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    embarcador_id UUID NOT NULL REFERENCES embarcador(id),
    origem_endereco_id UUID NOT NULL REFERENCES endereco(id),
    destino_endereco_id UUID NOT NULL REFERENCES endereco(id),
    categoria_carga_id SMALLINT NOT NULL REFERENCES categoria_carga(id) ON DELETE RESTRICT,
    tipo_carga VARCHAR(100) NOT NULL,
    peso_kg NUMERIC(10, 2) NOT NULL,
    dimensoes VARCHAR(100),
    valor_fixo NUMERIC(12, 2) NOT NULL CHECK (valor_fixo >= 0),
    status_frete status_frete_enum NOT NULL DEFAULT 'ABERTO',
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE viagem (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    frete_id UUID NOT NULL REFERENCES frete(id),
    motorista_id UUID NOT NULL REFERENCES motorista(id),
    veiculo_id UUID NOT NULL REFERENCES veiculo(id),
    valor_acordado NUMERIC(12, 2) NOT NULL CHECK (valor_acordado >= 0),
    status_viagem status_viagem_enum NOT NULL DEFAULT 'AGUARDANDO_PAGAMENTO',
    status_pagamento status_pagamento_enum NOT NULL DEFAULT 'PENDENTE',
    data_inicio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_fim TIMESTAMP
);

CREATE TABLE pagamento (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    viagem_id UUID NOT NULL REFERENCES viagem(id),
    valor NUMERIC(12, 2) NOT NULL CHECK (valor >= 0),
    forma_pagamento VARCHAR(40),
    id_externo VARCHAR(100),
    status_pagamento status_pagamento_enum NOT NULL DEFAULT 'PENDENTE'
);

CREATE TABLE comprovante_pod (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    viagem_id UUID NOT NULL REFERENCES viagem(id) ON DELETE CASCADE,
    tipo_comprovante tipo_comprovante_enum NOT NULL,
    url_arquivo TEXT NOT NULL,
    latitude NUMERIC(10, 7),
    longitude NUMERIC(10, 7),
    data_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE disputa (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    viagem_id UUID NOT NULL REFERENCES viagem(id),
    motivo TEXT NOT NULL,
    status_disputa status_disputa_enum NOT NULL DEFAULT 'ABERTA',
    data_abertura TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_encerramento TIMESTAMP
);

CREATE TABLE historico_status_viagem (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    viagem_id UUID NOT NULL REFERENCES viagem(id) ON DELETE CASCADE,
    status_anterior status_viagem_enum,
    status_novo status_viagem_enum NOT NULL,
    data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE mensagem_chat (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    viagem_id UUID NOT NULL REFERENCES viagem(id) ON DELETE CASCADE,
    remetente_id UUID NOT NULL REFERENCES usuario(id),
    mensagem TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE avaliacao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    viagem_id UUID NOT NULL REFERENCES viagem(id) ON DELETE CASCADE,
    avaliador_id UUID NOT NULL REFERENCES usuario(id),
    avaliado_id UUID NOT NULL REFERENCES usuario(id),
    nota SMALLINT NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,
    CONSTRAINT avaliacao_avaliador_diferente_avaliado CHECK (avaliador_id <> avaliado_id),
    CONSTRAINT avaliacao_unica_por_viagem UNIQUE (viagem_id, avaliador_id, avaliado_id)
);

CREATE INDEX idx_embarcador_endereco ON embarcador(endereco_id);
CREATE INDEX idx_transportadora_endereco ON transportadora(endereco_id);
CREATE INDEX idx_motorista_transportadora ON motorista(transportadora_id);
CREATE INDEX idx_motorista_categoria ON motorista(categoria_carga_preferencial_id);
CREATE INDEX idx_veiculo_motorista ON veiculo(motorista_id);
CREATE INDEX idx_documento_usuario ON documento(usuario_id);
CREATE INDEX idx_notificacao_usuario ON notificacao(usuario_id);
CREATE INDEX idx_frete_embarcador ON frete(embarcador_id);
CREATE INDEX idx_frete_origem ON frete(origem_endereco_id);
CREATE INDEX idx_frete_destino ON frete(destino_endereco_id);
CREATE INDEX idx_frete_categoria ON frete(categoria_carga_id);
CREATE INDEX idx_frete_status ON frete(status_frete);
CREATE INDEX idx_viagem_frete ON viagem(frete_id);
CREATE INDEX idx_viagem_motorista ON viagem(motorista_id);
CREATE INDEX idx_viagem_veiculo ON viagem(veiculo_id);
CREATE INDEX idx_viagem_status ON viagem(status_viagem);
CREATE INDEX idx_pagamento_viagem ON pagamento(viagem_id);
CREATE INDEX idx_comprovante_viagem ON comprovante_pod(viagem_id);
CREATE INDEX idx_disputa_viagem ON disputa(viagem_id);
CREATE INDEX idx_historico_viagem ON historico_status_viagem(viagem_id);
CREATE INDEX idx_mensagem_viagem ON mensagem_chat(viagem_id);
CREATE INDEX idx_mensagem_remetente ON mensagem_chat(remetente_id);
CREATE INDEX idx_avaliacao_viagem ON avaliacao(viagem_id);
CREATE INDEX idx_avaliacao_avaliado ON avaliacao(avaliado_id);
