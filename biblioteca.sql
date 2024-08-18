-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS biblioteca;

-- Seleciona o banco de dados para uso
USE biblioteca;

-- Criação da tabela de autores
CREATE TABLE autores (
    autor_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    data_nascimento DATE,
    nacionalidade VARCHAR(100)
);

-- Criação da tabela de categorias
CREATE TABLE categorias (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- Criação da tabela de livros
CREATE TABLE livros (
    livro_id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    ano_publicacao YEAR,
    autor_id INT,
    categoria_id INT,
    FOREIGN KEY (autor_id) REFERENCES autores(autor_id) ON DELETE SET NULL,
    FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id) ON DELETE SET NULL
);

-- Criação da tabela de usuários
CREATE TABLE usuarios (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    data_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criação da tabela de empréstimos
CREATE TABLE emprestimos (
    emprestimo_id INT AUTO_INCREMENT PRIMARY KEY,
    livro_id INT,
    usuario_id INT,
    data_emprestimo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_devolucao DATE,
    FOREIGN KEY (livro_id) REFERENCES livros(livro_id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id) ON DELETE CASCADE
);

-- Inserindo alguns dados de teste

-- Autores
INSERT INTO autores (nome, data_nascimento, nacionalidade) VALUES ('J.K. Rowling', '1965-07-31', 'Britânica');
INSERT INTO autores (nome, data_nascimento, nacionalidade) VALUES ('George R.R. Martin', '1948-09-20', 'Americano');
INSERT INTO autores (nome, data_nascimento, nacionalidade) VALUES ('J.R.R. Tolkien', '1892-01-03', 'Britânico');

-- Categorias
INSERT INTO categorias (nome) VALUES ('Fantasia');
INSERT INTO categorias (nome) VALUES ('Ficção Científica');
INSERT INTO categorias (nome) VALUES ('Romance');

-- Livros
INSERT INTO livros (titulo, ano_publicacao, autor_id, categoria_id) VALUES ('Harry Potter e a Pedra Filosofal', 1997, 1, 1);
INSERT INTO livros (titulo, ano_publicacao, autor_id, categoria_id) VALUES ('A Guerra dos Tronos', 1996, 2, 1);
INSERT INTO livros (titulo, ano_publicacao, autor_id, categoria_id) VALUES ('O Senhor dos Anéis: A Sociedade do Anel', 1954, 3, 1);

-- Usuários
INSERT INTO usuarios (nome, email) VALUES ('João Silva', 'joao.silva@example.com');
INSERT INTO usuarios (nome, email) VALUES ('Maria Souza', 'maria.souza@example.com');

-- Empréstimos
INSERT INTO emprestimos (livro_id, usuario_id, data_devolucao) VALUES (1, 1, '2024-08-30');
INSERT INTO emprestimos (livro_id, usuario_id, data_devolucao) VALUES (2, 2, '2024-08-25');

-- Consultas de exemplo
-- Lista de todos os livros e seus autores
SELECT livros.titulo, autores.nome AS autor, categorias.nome AS categoria
FROM livros
INNER JOIN autores ON livros.autor_id = autores.autor_id
INNER JOIN categorias ON livros.categoria_id = categorias.categoria_id;

-- Lista de todos os empréstimos atuais
SELECT usuarios.nome AS usuario, livros.titulo AS livro, emprestimos.data_emprestimo, emprestimos.data_devolucao
FROM emprestimos
INNER JOIN usuarios ON emprestimos.usuario_id = usuarios.usuario_id
INNER JOIN livros ON emprestimos.livro_id = livros.livro_id;
