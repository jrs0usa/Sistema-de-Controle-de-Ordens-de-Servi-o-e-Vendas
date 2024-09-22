-- 1. Usar o banco de dados existente
USE controle_vendas;

-- 2. Criação das Tabelas (caso não existam)
CREATE TABLE IF NOT EXISTS Produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(255) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    quantidade_estoque INT NOT NULL
);

CREATE TABLE IF NOT EXISTS Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome_cliente VARCHAR(255) NOT NULL,
    contato_cliente VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS OrdensDeServico (
    id_ordem INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    descricao_servico TEXT NOT NULL,
    data_abertura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_fechamento TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Aberto',
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE IF NOT EXISTS Vendas (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT,
    id_cliente INT,
    data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    quantidade_vendida INT NOT NULL,
    valor_total DECIMAL(10, 2),
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE IF NOT EXISTS Tecnicos (
    id_tecnico INT AUTO_INCREMENT PRIMARY KEY,
    nome_tecnico VARCHAR(255) NOT NULL,
    especialidade VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS AtribuicoesTecnicos (
    id_atribuicao INT AUTO_INCREMENT PRIMARY KEY,
    id_tecnico INT,
    id_ordem INT,
    FOREIGN KEY (id_tecnico) REFERENCES Tecnicos(id_tecnico),
    FOREIGN KEY (id_ordem) REFERENCES OrdensDeServico(id_ordem)
);

-- 3. Inserção de Produtos (focados em hardwares)
INSERT INTO Produtos (nome_produto, preco, quantidade_estoque) 
VALUES 
('Roteador Wireless TP-Link', 159.90, 50),
('HD Externo Seagate 1TB', 299.90, 20),
('Placa de Vídeo GTX 1660', 1899.90, 10),
('Monitor Dell 24" Full HD', 749.90, 15),
('Notebook Lenovo Core i5', 3499.90, 8),
('Teclado Mecânico Razer', 499.90, 25),
('Mouse Gamer Logitech', 299.90, 30);

-- 4. Inserção de Clientes
INSERT INTO Clientes (nome_cliente, contato_cliente) 
VALUES 
('Carlos Silva', 'carlos.silva@email.com'),
('Ana Pereira', 'ana.pereira@email.com'),
('Lucas Moreira', 'lucas.moreira@email.com'),
('Beatriz Souza', 'beatriz.souza@email.com'),
('Fernando Oliveira', 'fernando.oliveira@email.com');

-- 5. Inserção de Técnicos
INSERT INTO Tecnicos (nome_tecnico, especialidade)
VALUES 
('Isabelle', 'Manutenção de Hardware'),
('Kailane', 'Suporte e Configuração de Redes'),
('Lukas', 'Suporte Técnico');

-- 6. Inserção de Ordens de Serviço (serviços de suporte)
INSERT INTO OrdensDeServico (id_cliente, descricao_servico)
VALUES 
(1, 'Configuração de rede local e suporte ao usuário.'),
(2, 'Instalação e configuração de software antivírus.'),
(3, 'Manutenção e limpeza de hardware.'),
(4, 'Diagnóstico de problemas em equipamentos.'),
(5, 'Suporte remoto para resolução de problemas.'),
(1, 'Treinamento em utilização de software.'),
(3, 'Atualização de drivers e firmware.'),
(2, 'Instalação de novos equipamentos.'),
(4, 'Consultoria em segurança da informação.'),
(5, 'Recuperação de dados de HDs danificados.');

-- 7. Atribuição de Técnicos às Ordens de Serviço
INSERT INTO AtribuicoesTecnicos (id_tecnico, id_ordem)
VALUES 
(1, 1), -- Isabelle na Ordem 1
(2, 2), -- Kailane na Ordem 2
(3, 3), -- Lukas na Ordem 3
(2, 4), -- Kailane na Ordem 4
(3, 5), -- Lukas na Ordem 5
(1, 6), -- Isabelle na Ordem 6
(3, 7), -- Lukas na Ordem 7
(2, 8), -- Kailane na Ordem 8
(1, 9), -- Isabelle na Ordem 9
(3, 10); -- Lukas na Ordem 10

-- 8. Registrar Vendas e Atualizar Estoque
-- Venda de 2 roteadores para Carlos Silva
INSERT INTO Vendas (id_produto, id_cliente, quantidade_vendida, valor_total)
VALUES (1, 1, 2, 319.80);

UPDATE Produtos
SET quantidade_estoque = quantidade_estoque - 2
WHERE id_produto = 1;

-- Venda de 1 Notebook para Ana Pereira
INSERT INTO Vendas (id_produto, id_cliente, quantidade_vendida, valor_total)
VALUES (5, 2, 1, 3499.90);

UPDATE Produtos
SET quantidade_estoque = quantidade_estoque - 1
WHERE id_produto = 5;

-- Venda de 3 Teclados Mecânicos para Lucas
INSERT INTO Vendas (id_produto, id_cliente, quantidade_vendida, valor_total)
VALUES (6, 3, 3, 1499.70);

UPDATE Produtos
SET quantidade_estoque = quantidade_estoque - 3
WHERE id_produto = 6;

-- Exemplo de Transação: Venda de 3 HDs para Beatriz Souza e Atualização de Estoque
START TRANSACTION;

INSERT INTO Vendas (id_produto, id_cliente, quantidade_vendida, valor_total)
VALUES (2, 4, 3, 899.70);

UPDATE Produtos
SET quantidade_estoque = quantidade_estoque - 3
WHERE id_produto = 2;

COMMIT;

-- 9. Consultas de Relatório

-- Consultar Produtos em Estoque
SELECT nome_produto, quantidade_estoque 
FROM Produtos;

-- Relatório de Ordens de Serviço e Técnicos Atribuídos
SELECT O.descricao_servico, O.data_abertura, O.status, T.nome_tecnico, T.especialidade
FROM OrdensDeServico O
JOIN AtribuicoesTecnicos A ON O.id_ordem = A.id_ordem
JOIN Tecnicos T ON A.id_tecnico = T.id_tecnico;

-- Relatório de Vendas por Cliente
SELECT C.nome_cliente, P.nome_produto, V.quantidade_vendida, V.valor_total, V.data_venda
FROM Vendas V
JOIN Clientes C ON V.id_cliente = C.id_cliente
JOIN Produtos P ON V.id_produto = P.id_produto;

