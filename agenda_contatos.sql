-- Criação do banco de dados com charset UTF-8MB4
CREATE DATABASE IF NOT EXISTS agenda_contatos
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

-- Seleciona o banco de dados
USE agenda_contatos;

-- Criação da tabela de tipos de contato com charset UTF-8MB4
CREATE TABLE IF NOT EXISTS agenda_contatos.tipos_contato (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Inserção de tipos de contato padrão
INSERT INTO agenda_contatos.tipos_contato (descricao) VALUES 
('Pessoal'),
('Profissional'),
('Família'),
('Amigos');

-- Criação da tabela de contatos com charset UTF-8MB4
CREATE TABLE IF NOT EXISTS agenda_contatos.contatos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    id_tipo_contato INT,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_tipo_contato) REFERENCES agenda_contatos.tipos_contato(id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Criação da tabela de endereços com charset UTF-8MB4
CREATE TABLE IF NOT EXISTS agenda_contatos.enderecos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_contato INT,
    logradouro VARCHAR(100) NOT NULL,
    numero VARCHAR(10),
    complemento VARCHAR(50),
    bairro VARCHAR(50),
    cidade VARCHAR(50),
    estado VARCHAR(2),
    cep VARCHAR(10),
    FOREIGN KEY (id_contato) REFERENCES agenda_contatos.contatos(id) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Inserção de dados na tabela contatos
INSERT INTO agenda_contatos.contatos (nome, telefone, email, id_tipo_contato) VALUES ('João da Silva', '(11) 91234-5678', 'joao.silva@example.com', 1);

-- Inserção de dados na tabela enderecos
INSERT INTO agenda_contatos.enderecos (id_contato, logradouro, numero, bairro, cidade, estado, cep) VALUES (LAST_INSERT_ID(), 'Rua Exemplo', '123', 'Centro', 'São Paulo', 'SP', '01000-000');

-- Consultando contatos com seus endereços
SELECT
    c.id,
    c.nome,
    c.telefone,
    c.email,
    t.descricao AS tipo_contato,
    e.logradouro,
    e.numero,
    e.complemento,
    e.bairro,
    e.cidade,
    e.estado,
    e.cep
FROM agenda_contatos.contatos c
LEFT JOIN agenda_contatos.enderecos e ON c.id = e.id_contato
LEFT JOIN agenda_contatos.tipos_contato t ON c.id_tipo_contato = t.id;
