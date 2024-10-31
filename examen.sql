-- MODELO 1
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

-- Insertar 5 Peliculas
INSERT INTO peliculas (id, nombre, anno) VALUES
(1, 'Star Wars: A New Hope', 1977),
(2, 'El Señor de los Anillos: La Comunidad del Anillo', 2001),
(3, 'The Matrix', 1999),
(4, 'Harry Potter y la Piedra Filosofal', 2001),
(5, 'Volver al Futuro', 1985)
RETURNING *;

-- Insertar 5 Tags
INSERT INTO tags (id, tag) VALUES
(1, 'Ciencia Ficción'),
(2, 'Fantasía'),
(3, 'Aventura'),
(4, 'Acción'),
(5, 'Viaje en el Tiempo')
RETURNING *;

-- Asociar 3 Tags a la Pelicula 1
INSERT INTO pelicula_tag (pelicula_id, tag_id) VALUES
(1, 1), -- Star Wars: Ciencia Ficción
(1, 3), -- Star Wars: Aventura
(1, 4) -- Star Wars: Acción
RETURNING *;

-- Asociar 2 Tags a la Pelicula 2
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

-- MODELO 2
CREATE TABLE preguntas(
    id INTEGER PRIMARY KEY,
    pregunta VARCHAR(255) NOT NULL,
    respuesta_correcta VARCHAR NOT NULL
)

CREATE TABLE usuarios(
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    edad INTEGER NOT NULL
)

CREATE TABLE respuestas(
    id INTEGER PRIMARY KEY,
    respuesta VARCHAR(255),
    pregunta_id INTEGER NOT NULL,
    usuario_id INTEGER NOT NULL,
    CONSTRAINT fk_pregunta FOREIGN KEY (pregunta_id) REFERENCES preguntas(id) ON DELETE CASCADE,
    CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
)

-- Insertar usuarios
INSERT INTO usuarios (id, nombre, edad) VALUES
(1, 'Rodrigo', 27),
(2, 'Camila', 25),
(3, 'Javier', 30),
(4, 'Ana', 22),
(5, 'Luis', 28)
RETURNING *;

-- Insertar preguntas
INSERT INTO preguntas (id, pregunta, respuesta_correcta) VALUES
(1, '¿Cuál es la capital de Francia?', 'París'),
(2, '¿Quién escribió "Cien años de soledad"?', 'Gabriel García Márquez'),
(3, '¿En qué año ocurrió la Revolución Francesa?', '1789'),
(4, '¿Cuál es el planeta más cercano al Sol?', 'Mercurio'),
(5, '¿Cuál es el océano más grande del mundo?', 'Océano Pacífico')
RETURNING *;

-- Insertar respuestas
-- Pregunta 1 respondida correctamente por dos usuarios diferentes
INSERT INTO respuestas (id, respuesta, pregunta_id, usuario_id) VALUES
(1, 'París', 1, 1),  
(2, 'París', 1, 2)
RETURNING *;  

-- Pregunta 2 respondida correctamente solo por un usuario
INSERT INTO respuestas (id, respuesta, pregunta_id, usuario_id) VALUES
(3, 'Gabriel García Márquez', 2, 3)
RETURNING *;  

-- Preguntas 3, 4, y 5 con respuestas incorrectas
INSERT INTO respuestas (id, respuesta, pregunta_id, usuario_id) VALUES
(4, '1790', 3, 4),     
(5, 'Venus', 4, 5),         
(6, 'Océano Atlántico', 5, 1)
RETURNING *; 

-- Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).
SELECT U.nombre AS usuario, COUNT(R.id) AS respuestas_correctas 
FROM respuestas R
INNER JOIN preguntas P
ON R.pregunta_id = P.id
INNER JOIN usuarios U
ON R.usuario_id = U.id
WHERE R.respuesta = P.respuesta_correcta
GROUP BY R.usuario_id, U.nombre
ORDER BY R.usuario_id ASC;

-- Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron correctamente.
SELECT P.pregunta, COALESCE(COUNT(R.usuario_id), 0) AS cantidad_usuarios
FROM preguntas P
LEFT JOIN respuestas R ON P.id = R.pregunta_id AND R.respuesta = P.respuesta_correcta
GROUP BY P.id, P.pregunta
ORDER BY P.id ASC;

-- Implementa un borrado en cascada de las respuestas al borrar un usuario. 
-- Prueba la implementación borrando el primer usuario
DELETE FROM usuarios WHERE id = 1;


-- Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos
ALTER TABLE usuarios
ADD CONSTRAINT chk_mayor_edad
CHECK (edad >= 18);

INSERT INTO usuarios (id, nombre, edad) VALUES (6, 'Rodrigo jr', 15)
RETURNING *;

-- Altera la tabla existente de usuarios agregando el campo email. Debe tener la
-- restricción de ser único.
ALTER TABLE usuarios
ADD COLUMN email VARCHAR(255) UNIQUE;

INSERT INTO usuarios (id, nombre, edad, email) VALUES (7, 'A', 25, 'a@a.a')
RETURNING *;