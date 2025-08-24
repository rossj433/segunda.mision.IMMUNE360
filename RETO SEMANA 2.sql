DROP DATABASE IF EXISTS GuardianesSQL;

CREATE DATABASE guardianessql;

-- En vez En vez de usar los comandos de CREATE TABLE para cada tabla (credits, títulos y personas),
-- usé la opción TABLE DATA WIZARD IMPORT para importar los datos, columnas y tablas desde la tabla de Excel, 
-- no sin antes convertirlos de .XLS a .CVS para poder importarlos a MySQL. Debes subirlos en el siguiente orden: 1. personas, 2. titulos y 3. Credits. 
-- Y debes indicarles las caracteristicas correspondientes que encontrarás en el pdf

-- 1.	Actores que aparecen en más de 5 películas
SELECT p.nombre, COUNT(c.id) AS total_apariciones
FROM credits c
JOIN personas1 p ON c.person_id = p.person_id
WHERE c.role = 'Actor'
GROUP BY p.nombre
HAVING total_apariciones > 5
ORDER BY total_apariciones DESC;

-- 2. Directores con películas por encima de 8.0
SELECT p.nombre AS director, t.titulo, t.imdb_score
FROM credits c
JOIN personas1 p ON c.person_id = p.person_id
JOIN titulos t ON c.id = t.id
WHERE c.role = 'Director' AND t.imdb_score > 8
ORDER BY t.imdb_score DESC;

-- 3. top 3 películas o series del 2009 con mejor puntuación
SELECT titulo, tipo, año_lanzamiento, imdb_score
FROM titulos
WHERE año_lanzamiento = 2009
ORDER BY imdb_score DESC
LIMIT 5;

-- 4. Actores que trabajaron con más de 2 directores diferentes
SELECT p.nombre, COUNT(DISTINCT c2.person_id) AS directores
FROM credits c
JOIN personas1 p ON c.person_id = p.person_id
JOIN credits c2 ON c.id = c2.id AND c2.role = 'Director'
WHERE c.role = 'Actor'
GROUP BY p.nombre
HAVING directores > 20
ORDER BY directores DESC;

-- 5. Películas por certificación de edad
SELECT certificacion_edad, COUNT(*) AS total
FROM titulos
GROUP BY certificacion_edad
ORDER BY total DESC;

-- 6. promedio de IMDb por director
SELECT p.nombre AS director, ROUND(AVG(t.imdb_score),2) AS promedio_imdb
FROM credits c
JOIN personas1 p ON c.person_id = p.person_id
JOIN titulos t ON c.id = t.id
WHERE c.role = 'Director'
GROUP BY p.nombre
ORDER BY promedio_imdb DESC;

-- 7. top 15 de actores con mejor promedio de IMDb, 
SELECT p.nombre AS actor, ROUND(AVG(t.imdb_score),2) AS promedio_imdb, COUNT(t.id) AS total_peliculas
FROM credits c
JOIN personas1 p ON c.person_id = p.person_id
JOIN titulos t ON c.id = t.id
WHERE c.role = 'Actor'
GROUP BY p.nombre
HAVING total_peliculas > 2
ORDER BY promedio_imdb DESC
LIMIT 15;