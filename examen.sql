-- Modelo 1
CREATE TABLE peliculas(
	id INTEGER PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    anno INTEGER NOT NULL
);

CREATE TABLE tags(
    id INTEGER PRIMARY KEY,
    tag VARCHAR(32) NOT NULL
);

CREATE TABLE pelicula_tag(
    pelicula_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    CONSTRAINT fk_pelicula FOREIGN KEY (pelicula_id) REFERENCES peliculas(id) ON DELETE CASCADE,
    CONSTRAINT fk_tag FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);

-- Insertamos 5 Peliculas
INSERT INTO peliculas (id, nombre, anno) VALUES
(1, 'Star Wars: A New Hope', 1977),
(2, 'El Señor de los Anillos: La Comunidad del Anillo', 2001),
(3, 'The Matrix', 1999),
(4, 'Harry Potter y la Piedra Filosofal', 2001),
(5, 'Volver al Futuro', 1985)
RETURNING *;

-- Insertamos 5 Tags
INSERT INTO tags (id, tag) VALUES
(1, 'Ciencia Ficción'),
(2, 'Fantasía'),
(3, 'Aventura'),
(4, 'Acción'),
(5, 'Viaje en el Tiempo')
RETURNING *;

-- Asociamos 3 Tags a la Pelicula 1
INSERT INTO pelicula_tag (pelicula_id, tag_id) VALUES
(1, 1), -- Star Wars: Ciencia Ficción
(1, 3), -- Star Wars: Aventura
(1, 4) -- Star Wars: Acción
RETURNING *;

-- Asociamos 2 Tags a la Pelicula 2
INSERT INTO pelicula_tag (pelicula_id, tag_id) VALUES
(2, 2), -- El Señor de los Anillos: Fantasía
(2, 3) -- El Señor de los Anillos: Aventura
RETURNING *;

-- Contar cantidad de tags por pelicula
SELECT P.nombre, COUNT(PT.tag_id) AS cantidad_tags
FROM pelicula_tag PT
RIGHT JOIN peliculas P
ON P.id = PT.pelicula_id
GROUP BY P.nombre;