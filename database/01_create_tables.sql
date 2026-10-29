-- =====================================================================
-- Projeto: UPA Monitor de Porto Velho - Modelo Relacional
-- Banco de Dados: SQL Server
-- =====================================================================

CREATE DATABASE UpaMonitorDB;
GO

USE UpaMonitorDB;
GO

-- Tabela: UPA (Unidades de Pronto Atendimento)
CREATE TABLE UPA (
    id_upa INT IDENTITY(1,1) PRIMARY KEY,
    nome_upa VARCHAR(100) NOT NULL UNIQUE,
    endereco VARCHAR(255) NOT NULL,
    status_operacional VARCHAR(50) DEFAULT 'ATIVO'
);
GO

-- Tabela: SETOR (Ambientes de atendimento interno)
CREATE TABLE SETOR (
    id_setor INT IDENTITY(1,1) PRIMARY KEY,
    id_upa INT NOT NULL,
    nome_setor VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    CONSTRAINT FK_Setor_Upa FOREIGN KEY (id_upa) REFERENCES UPA(id_upa)
);
GO

-- Tabela: CLASSIFICACAO_RISCO (Protocolo de Manchester)
CREATE TABLE CLASSIFICACAO_RISCO (
    id_classificacao INT IDENTITY(1,1) PRIMARY KEY,
    cor_risco VARCHAR(30) NOT NULL UNIQUE,
    descricao_fluxo VARCHAR(100),
    tempo_max_espera_minutos INT NOT NULL
);
GO

-- Tabela: PACIENTE
CREATE TABLE PACIENTE (
    id_paciente INT IDENTITY(1,1) PRIMARY KEY,
    cartao_sus VARCHAR(50) UNIQUE,
    nome_completo VARCHAR(150) NOT NULL,
    data_nascimento DATE NOT NULL,
    sexo CHAR(1)
);
GO

-- Tabela: ATENDIMENTO (Transacional)
CREATE TABLE ATENDIMENTO (
    id_atendimento INT IDENTITY(1,1) PRIMARY KEY,
    id_upa INT NOT NULL,
    id_paciente INT NOT NULL,
    id_setor INT NOT NULL,
    id_classificacao INT NOT NULL,
    data_hora_chegada DATETIME DEFAULT GETDATE(),
    data_hora_inicio_atendimento DATETIME NULL,
    data_hora_alta DATETIME NULL,
    status_atendimento VARCHAR(30) DEFAULT 'AGUARDANDO',
    CONSTRAINT FK_Atendimento_Upa FOREIGN KEY (id_upa) REFERENCES UPA(id_upa),
    CONSTRAINT FK_Atendimento_Paciente FOREIGN KEY (id_paciente) REFERENCES PACIENTE(id_paciente),
    CONSTRAINT FK_Atendimento_Setor FOREIGN KEY (id_setor) REFERENCES SETOR(id_setor),
    CONSTRAINT FK_Atendimento_Classificacao FOREIGN KEY (id_classificacao) REFERENCES CLASSIFICACAO_RISCO(id_classificacao)
);
GO

-- Tabela: MEDICAO (Séries temporais e métricas de painel)
CREATE TABLE MEDICAO (
    id_medicao INT IDENTITY(1,1) PRIMARY KEY,
    id_upa INT NOT NULL,
    id_setor INT NOT NULL,
    timestamp_medicao DATETIME DEFAULT GETDATE(),
    qtd_pacientes_aguardando INT DEFAULT 0,
    tempo_medio_espera_minutos DECIMAL(10,2) DEFAULT 0.00,
    tempo_medio_atendimento_minutos DECIMAL(10,2) DEFAULT 0.00,
    CONSTRAINT FK_Medicao_Upa FOREIGN KEY (id_upa) REFERENCES UPA(id_upa),
    CONSTRAINT FK_Medicao_Setor FOREIGN KEY (id_setor) REFERENCES SETOR(id_setor)
);
GO
