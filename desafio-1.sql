
CREATE DATABASE desafio_rodrigo_valenzuela_001;

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    email VARCHAR(50),
    nombre VARCHAR,
    telefono VARCHAR(16),
    empresa VARCHAR(50),
    prioridad SMALLINT CHECK (prioridad BETWEEN 1 AND 10)
);

INSERT INTO clientes (email, nombre, telefono, empresa, prioridad) VALUES
('a@a.a', 'AA AA', '999999999', 'Empresa A', 10),
('b@b.b', 'BB BB', '888888888', 'Empresa B', 5),
('c@c.c', 'CC CC', '777777777', 'Empresa C', 3),
('d@d.d', 'DD DD', '666666666', 'Empresa D', 8),
('e@e.e', 'EE EE', '555555555', 'Empresa E', 2),
('f@f.f', 'FF FF', '444444444', 'Empresa F', 6),
('g@g.g', 'GG GG', '333333333', 'Empresa G', 9),
('h@h.h', 'HH HH', '222222222', 'Empresa H', 1),
('i@i.i', 'II II', '111111111', 'Empresa I', 4),
('j@j.j', 'JJ JJ', '000000000', 'Empresa J', 7)
RETURNING *;

SELECT * FROM clientes ORDER BY prioridad DESC limit 3;

SELECT * FROM clientes WHERE prioridad > 5;

DROP TABLE clientes;

DROP DATABASE desafio_rodrigo_valenzuela_001;