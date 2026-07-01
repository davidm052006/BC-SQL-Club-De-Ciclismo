-- ============================================
-- PROYECTO SEMANAL: Jerarquías con CTEs Recursivas
-- Semana 13 — WITH RECURSIVE
-- Motor: PostgreSQL 16
-- Dominio: Club de Ciclismo
-- ============================================

-- Levantar Docker antes de ejecutar:
-- docker compose -f scripts/docker-compose.yml up -d
-- docker compose -f scripts/docker-compose.yml exec -T postgres \
--   psql -U bootcamp -d bootcamp_db < semanas/semana_13/proyecto.sql

DROP TABLE IF EXISTS disciplinas CASCADE;

-- Tabla auto-referencial: jerarquía de disciplinas del ciclismo
CREATE TABLE disciplinas (
    id          SERIAL  PRIMARY KEY,
    nombre      TEXT    NOT NULL UNIQUE,
    descripcion TEXT,
    parent_id   INT     REFERENCES disciplinas(id)
);

-- ============================================
-- DATOS: jerarquía de 4 niveles
-- Nivel 1: 1 raíz (Ciclismo)
-- Nivel 2: 5 modalidades
-- Nivel 3: 3 sub-disciplinas por modalidad = 15
-- Nivel 4: 4 categorías por sub-disciplina = 60
-- Total: 21 + 60 (categorías) + 200 (regionales) = 281 filas ≥ 200
-- ============================================

-- Nivel 1 — raíz
INSERT INTO disciplinas (id, nombre, descripcion, parent_id) VALUES
    (1, 'Ciclismo', 'Deporte de competición sobre bicicleta', NULL);

-- Nivel 2 — modalidades
INSERT INTO disciplinas (id, nombre, descripcion, parent_id) VALUES
    (2, 'Ruta',   'Ciclismo en carretera',      1),
    (3, 'Pista',  'Ciclismo en velódromo',      1),
    (4, 'MTB',    'Mountain Bike',              1),
    (5, 'BMX',    'Bicicleta Moto Cross',       1),
    (6, 'Gravel', 'Caminos mixtos de grava',    1);

-- Nivel 3 — sub-disciplinas (3 por modalidad)
INSERT INTO disciplinas (id, nombre, descripcion, parent_id) VALUES
    (7,  'Montaña de Ruta',    'Etapas con grandes puertos',   2),
    (8,  'Contrarreloj',       'Prueba individual al crono',   2),
    (9,  'Sprinter de Ruta',   'Llegadas al sprint masivo',    2),
    (10, 'Velocidad en Pista', 'Sprint en pista corta',        3),
    (11, 'Persecución',        'Dos equipos frente a frente',  3),
    (12, 'Keirin',             'Sprint con moto guía',         3),
    (13, 'Cross Country XCO',  'Circuito mixto de MTB',        4),
    (14, 'Descenso DH',        'Bajada cronometrada',          4),
    (15, 'Enduro MTB',         'Etapas de descenso',           4),
    (16, 'BMX Race',           'Circuito de saltos cronometrado', 5),
    (17, 'BMX Freestyle Park', 'Trucos en pista o halfpipe',   5),
    (18, 'BMX Flatland',       'Trucos sobre superficie plana',5),
    (19, 'Gravel Racing',      'Competición en grava larga',   6),
    (20, 'Bikepacking',        'Aventura de larga distancia',  6),
    (21, 'Gravel Enduro',      'Descensos en grava',           6);

-- Nivel 4 — categorías por sub-disciplina (4 por cada una de las 15 = 60)
INSERT INTO disciplinas (nombre, descripcion, parent_id)
SELECT
    cat || ' — ' || d.nombre,
    'Categoría ' || cat || ' de ' || d.nombre,
    d.id
FROM disciplinas d
CROSS JOIN (VALUES ('Élite'), ('Sub-23'), ('Júnior'), ('Máster')) AS cats(cat)
WHERE d.id BETWEEN 7 AND 21;

-- Filas adicionales para asegurar ≥ 200: variaciones regionales
-- sobre las 5 modalidades (nivel 2) y las 15 sub-disciplinas (nivel 3) = 20 nodos x 10 = 200
INSERT INTO disciplinas (nombre, descripcion, parent_id)
SELECT
    'Regional ' || gs || ' — ' || d.nombre,
    'Competición regional nivel ' || gs,
    d.id
FROM disciplinas d
CROSS JOIN generate_series(1, 10) AS gs
WHERE d.id BETWEEN 2 AND 21;

-- ============================================
-- CONSULTA 1: Árbol completo con depth y path
-- ============================================

WITH RECURSIVE arbol AS (
    -- Caso base: nodos raíz
    SELECT
        id,
        nombre,
        parent_id,
        1        AS depth,
        nombre   AS path
    FROM disciplinas
    WHERE parent_id IS NULL

    UNION ALL

    -- Caso recursivo: nodos hijo
    SELECT
        d.id,
        d.nombre,
        d.parent_id,
        a.depth + 1,
        a.path || ' > ' || d.nombre
    FROM disciplinas d
    INNER JOIN arbol a ON d.parent_id = a.id
)
SELECT
    depth,
    REPEAT('  ', depth - 1) || nombre AS nombre_indentado,
    path
FROM arbol
ORDER BY path
LIMIT 40;

-- ============================================
-- CONSULTA 2: Nodos de nivel 3 solamente
-- ============================================

WITH RECURSIVE arbol AS (
    SELECT id, nombre, parent_id, 1 AS depth, nombre AS path
    FROM disciplinas WHERE parent_id IS NULL
    UNION ALL
    SELECT d.id, d.nombre, d.parent_id, a.depth + 1, a.path || ' > ' || d.nombre
    FROM disciplinas d INNER JOIN arbol a ON d.parent_id = a.id
)
SELECT nombre, depth, path
FROM   arbol
WHERE  depth = 3
ORDER BY path;

-- ============================================
-- CONSULTA 3: Hojas del árbol (nodos sin hijos)
-- ============================================

SELECT
    d.id,
    d.nombre AS hoja
FROM disciplinas d
WHERE NOT EXISTS (
    SELECT 1
    FROM disciplinas hijo
    WHERE hijo.parent_id = d.id
)
ORDER BY d.nombre
LIMIT 20;
