CREATE DATABASE desafio_rodrigo_valenzuela_003;

-- Setup 
CREATE TABLE usuarios(
	id SERIAL PRIMARY KEY,
	email VARCHAR(100) NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	apellido VARCHAR(50) NOT NULL,
	rol VARCHAR(20) NOT NULL
);

INSERT INTO usuarios (email, nombre, apellido, rol) VALUES
    ('juan.perez@example.com', 'Juan', 'Perez', 'usuario'),
    ('maria.gomez@example.com', 'Maria', 'Gomez', 'usuario'),
    ('pedro.lopez@example.com', 'Pedro', 'Lopez', 'usuario'),
    ('laura.martinez@example.com', 'Laura', 'Martinez', 'usuario'),
    ('admin.sanchez@example.com', 'Admin', 'Sanchez', 'administrador')
RETURNING *;

CREATE TABLE posts(
	id SERIAL PRIMARY KEY,
	titulo VARCHAR(100),
	contenido TEXT,
	destacado BOOLEAN DEFAULT false,
	fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	usuario_id BIGINT,
	CONSTRAINT fk_posts_usuario_id FOREIGN KEY(usuario_id) REFERENCES usuarios(id)
);

INSERT INTO posts (titulo, contenido, destacado, fecha_creacion, fecha_actualizacion, usuario_id) VALUES
    ('Primer Post', 'Contenido del primer post', false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 5), 
    ('Segundo Post', 'Contenido del segundo post', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 5), 
    ('Tercer Post', 'Contenido del tercer post', false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1),   
    ('Cuarto Post', 'Contenido del cuarto post', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 2),    
    ('Quinto Post', 'Contenido del quinto post', false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL)  
RETURNING *;

CREATE TABLE comentarios(
	id SERIAL PRIMARY KEY,
	contenido TEXT,
	fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	usuario_id BIGINT,
	post_id BIGINT,
	CONSTRAINT fk_comentarios_usuario_id FOREIGN KEY(usuario_id) REFERENCES usuarios(id),
	CONSTRAINT fk_comentarios_post_id FOREIGN KEY(post_id) REFERENCES posts(id)
)

INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
    ('Comentario 1 para el Post 1', CURRENT_TIMESTAMP, 1, 1),
    ('Comentario 2 para el Post 1', CURRENT_TIMESTAMP, 2, 1),  
    ('Comentario 3 para el Post 1', CURRENT_TIMESTAMP, 3, 1),  
    ('Comentario 4 para el Post 2', CURRENT_TIMESTAMP, 1, 2),  
    ('Comentario 5 para el Post 2', CURRENT_TIMESTAMP, 2, 2)   
RETURNING *;

/*
Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
nombre y email del usuario junto al título y contenido del post.
*/

SELECT U.nombre, U.email, P.titulo, P.contenido
FROM usuarios U
INNER JOIN posts P
ON u.id = P.usuario_id;

/*
Muestra el id, título y contenido de los posts de los administradores
El administrador puede ser cualquier id.
*/

SELECT P.id, P.titulo, P.contenido
FROM usuarios U
INNER JOIN posts P
ON U.id = P.usuario_id
WHERE U.rol = 'administrador';

/*
Cuenta la cantidad de posts de cada usuario:
La tabla resultante debe mostrar el id e email del usuario junto con la
cantidad de posts de cada usuario.
*/

SELECT U.id, U.email, COUNT(P.id) as cantidad_posts
FROM usuarios U
LEFT JOIN posts P
ON U.id = P.usuario_id
GROUP BY U.id
ORDER BY cantidad_posts DESC;

/*
Muestra el email del usuario que ha creado más posts.
Aquí la tabla resultante tiene un único registro y muestra solo el email.
*/

SELECT U.email
FROM usuarios U
LEFT JOIN posts P
ON U.id = P.usuario_id
GROUP BY U.id
ORDER BY COUNT(P.id) DESC 
LIMIT 1;

/*
Muestra la fecha del último post de cada usuario
*/

SELECT U.id AS usuario_id, MAX(P.fecha_creacion) AS fecha_ultimo_post
FROM posts P
RIGHT JOIN usuarios U
ON P.usuario_id = U.id
GROUP BY U.id
ORDER BY U.id;

/*
Muestra el título y contenido del post (artículo) con más comentarios.
*/

SELECT P.titulo, P.contenido
FROM posts P
INNER JOIN comentarios C
ON P.id = C.post_id
GROUP BY P.titulo, P.contenido
ORDER BY COUNT(C.id) DESC
LIMIT 1;


/*
Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
de cada comentario asociado a los posts mostrados, junto con el email del usuario
que lo escribió.
*/

SELECT 
P.titulo AS post_titulo, 
P.contenido AS post_contenido, 
C.contenido AS comentario_contenido, 
U.email AS comentario_email_usuario
FROM posts P
INNER JOIN comentarios C
ON P.id = C.post_id
INNER JOIN usuarios U
ON C.usuario_id = U.id
ORDER BY P.id;

/*
Muestra el contenido del último comentario de cada usuario.
*/

SELECT C.usuario_id, C.contenido
FROM comentarios C
INNER JOIN usuarios U ON C.usuario_id = U.id
WHERE C.fecha_creacion = (
	SELECT MAX(C2.fecha_creacion)
    FROM comentarios C2
    WHERE C2.usuario_id = C.usuario_id
	);

/*
Muestra los emails de los usuarios que no han escrito ningún comentario.
*/

SELECT U.email
FROM usuarios U
LEFT JOIN comentarios C ON C.usuario_id = U.id
WHERE C.id IS NULL
ORDER BY U.id;