-- ==============================================================================
-- Script DDL: Criação e Povoamento do Banco de Dados (CelticsTech / Clyvo Vet)
-- ==============================================================================
-- Este script cria as tabelas principais (CORE) da aplicação e insere registros
-- significativos para validação das operações de CRUD.

-- ------------------------------------------------------------------------------
-- TABELA: Tutor
-- Descrição: Armazena os dados dos clientes (tutores) da clínica veterinária.
-- ------------------------------------------------------------------------------
CREATE TABLE Tutor (
    -- Identificador único do tutor (Chave Primária)
    Id UUID PRIMARY KEY,
    -- Nome completo do tutor
    Nome VARCHAR(150) NOT NULL,
    -- CPF do tutor (deve ser único no sistema)
    Cpf VARCHAR(11) UNIQUE NOT NULL,
    -- Telefone de contato
    Telefone VARCHAR(20) NOT NULL,
    -- E-mail para comunicação (único)
    Email VARCHAR(100) UNIQUE NOT NULL,
    -- Data e hora em que o cadastro foi realizado (preenchimento automático)
    DataCadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------------------------
-- TABELA: Pet
-- Descrição: Armazena os dados dos animais vinculados aos tutores cadastrados.
-- ------------------------------------------------------------------------------
CREATE TABLE Pet (
    -- Identificador único do pet (Chave Primária)
    Id UUID PRIMARY KEY,
    -- Identificador do tutor dono do pet (Chave Estrangeira)
    TutorId UUID NOT NULL,
    -- Nome do animal
    Nome VARCHAR(100) NOT NULL,
    -- Espécie do animal (ex: Cachorro, Gato, Ave)
    Especie VARCHAR(50) NOT NULL,
    -- Raça do animal
    Raca VARCHAR(50),
    -- Data de nascimento do pet
    DataNascimento DATE NOT NULL,
    -- Peso do pet em quilogramas (ex: 25.50)
    Peso DECIMAL(5,2),
    -- Definição da Chave Estrangeira relacionando a tabela Pet à tabela Tutor
    -- A restrição ON DELETE CASCADE garante que se um tutor for excluído, 
    -- os pets associados a ele também serão removidos automaticamente.
    CONSTRAINT FK_Pet_Tutor FOREIGN KEY (TutorId) REFERENCES Tutor(Id) ON DELETE CASCADE
);

-- Inserindo 2 registros na tabela Tutor
INSERT INTO Tutor (Id, Nome, Cpf, Telefone, Email) 
VALUES ('d1b2a3c4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'Carlos Silva', '12345678901', '11999999999', 'carlos@email.com');

INSERT INTO Tutor (Id, Nome, Cpf, Telefone, Email) 
VALUES ('f6e5d4c3-b2a1-0f9e-8d7c-6b5a4f3e2d1c', 'Ana Souza', '10987654321', '11888888888', 'ana@email.com');

-- Inserindo 2 registros na tabela Pet vinculados aos tutores criados acima
INSERT INTO Pet (Id, TutorId, Nome, Especie, Raca, DataNascimento, Peso) 
VALUES ('a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'd1b2a3c4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'Rex', 'Cachorro', 'Labrador', '2022-05-10', 25.5);

INSERT INTO Pet (Id, TutorId, Nome, Especie, Raca, DataNascimento, Peso) 
VALUES ('b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e', 'f6e5d4c3-b2a1-0f9e-8d7c-6b5a4f3e2d1c', 'Mimi', 'Gato', 'Siames', '2023-01-20', 4.2);