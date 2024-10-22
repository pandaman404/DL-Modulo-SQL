CREATE DATABASE desafio_rodrigo_valenzuela_002;

CREATE TABLE INSCRITOS(cantidad INT, fecha DATE, fuente VARCHAR);
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 44, '2021-01-01', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 56, '2021-01-01', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 39, '2021-01-02', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 81, '2021-01-02', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 12, '2021-01-03', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 91, '2021-01-03', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 48, '2021-01-04', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 45, '2021-01-04', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 55, '2021-01-05', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 33, '2021-01-05', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 18, '2021-01-06', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 12, '2021-01-06', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 34, '2021-01-07', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 24, '2021-01-07', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 83, '2021-01-08', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 99, '2021-01-08', 'Página' );


-- ¿Cuántos registros hay? 
SELECT count(*) AS total_registros FROM inscritos;

-- ¿Cuántos inscritos hay en total?
SELECT SUM(cantidad) AS total_inscritos FROM inscritos;

-- ¿Cuál o cuáles son los registros de mayor antigüedad?
SELECT * FROM inscritos 
WHERE fecha = (SELECT MIN(fecha) FROM inscritos);

-- ¿Cuántos inscritos hay por día? (Indistintamente de la fuente de inscripción)
SELECT fecha, SUM(cantidad) AS total 
FROM inscritos 
GROUP BY fecha 
ORDER BY fecha;

-- ¿Cuántos inscritos hay por fuente?
SELECT fuente, SUM(cantidad) AS total 
FROM inscritos
GROUP BY fuente 
ORDER BY fuente;

-- ¿Qué día se inscribió la mayor cantidad de personas? Y ¿Cuántas personas se inscribieron en ese día?
SELECT fecha, SUM(cantidad) AS total 
FROM inscritos 
GROUP BY fecha 
ORDER BY total DESC 
LIMIT 1;

/* 
¿Qué día se inscribieron la mayor cantidad de personas utilizando el blog? ¿Cuántas
personas fueron? (si hay más de un registro con el máximo de personas, considera
solo el primero)
*/
SELECT fecha, SUM(cantidad) AS total 
FROM inscritos 
WHERE fuente ILIKE 'blog' 
GROUP BY fecha
ORDER BY total DESC
LIMIT 1;

/*
¿Cuál es el promedio de personas inscritas por día? Toma en consideración que la
base de datos tiene un registro de 8 días, es decir, se obtendrán 8 promedios.
*/
SELECT fecha, ROUND(AVG(cantidad), 2) AS total 
FROM inscritos 
GROUP BY fecha
ORDER BY fecha;

-- ¿Qué días se inscribieron más de 50 personas?
SELECT fecha, SUM(cantidad) as total FROM inscritos 
GROUP BY fecha 
HAVING SUM(cantidad) > 50 
ORDER BY fecha;

-- ¿Cuál es el promedio por día de personas inscritas? 
SELECT fecha, ROUND(AVG(cantidad), 2) as promedio 
FROM inscritos 
GROUP BY fecha 
ORDER BY fecha OFFSET 2;