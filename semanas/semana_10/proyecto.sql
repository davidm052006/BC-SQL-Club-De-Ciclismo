-- ============================================
-- PROYECTO SEMANAL: SELF JOIN
-- Semana 10 — Jerarquía de Disciplinas Ciclistas
-- Dominio: Club de Ciclismo
-- ============================================

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS disciplinas;

-- Tabla auto-referencial: disciplinas del ciclismo
-- parent_id = NULL indica la raíz (categoría raíz)
CREATE TABLE disciplinas (
    id          INTEGER PRIMARY KEY,
    nombre      TEXT    NOT NULL UNIQUE,
    descripcion TEXT,
    parent_id   INTEGER REFERENCES disciplinas(id)
);

-- ============================================
-- DATOS: jerarquía de 3 niveles
-- Nivel 1 (raíz): 1 disciplina madre
-- Nivel 2: 5 modalidades
-- Nivel 3: sub-disciplinas por modalidad
-- + generación hasta 80 filas con RECURSIVE
-- ============================================

-- Nivel 1 — raíz
INSERT INTO disciplinas (id, nombre, descripcion, parent_id) VALUES
    (1, 'Ciclismo', 'Deporte de competición sobre bicicleta', NULL);

-- Nivel 2 — modalidades principales (hijos de Ciclismo)
INSERT INTO disciplinas (id, nombre, descripcion, parent_id) VALUES
    (2, 'Ruta',    'Ciclismo en carretera',           1),
    (3, 'Pista',   'Ciclismo en velódromo',           1),
    (4, 'MTB',     'Mountain Bike',                   1),
    (5, 'BMX',     'Bicicleta Moto Cross',            1),
    (6, 'Gravel',  'Ciclismo en caminos mixtos',      1);

-- Nivel 3 — sub-disciplinas (hijos de cada modalidad)
INSERT INTO disciplinas (id, nombre, descripcion, parent_id) VALUES
    -- Ruta
    (7,  'Montaña',           'Etapas con puertos de montaña',  2),
    (8,  'Contrarreloj',      'Prueba contra el reloj',         2),
    (9,  'Sprinter de Ruta',  'Finales en pelotón al sprint',   2),
    -- Pista
    (10, 'Velocidad',         'Sprint en pista corta',          3),
    (11, 'Persecución',       'Dos equipos frente a frente',    3),
    (12, 'Keirin',            'Salida en grupo con moto guía',  3),
    -- MTB
    (13, 'Cross Country',     'Circuito mixto XCO',             4),
    (14, 'Descenso DH',       'Bajada cronometrada',            4),
    (15, 'Enduro MTB',        'Varias etapas DH con enlace',    4),
    -- BMX
    (16, 'BMX Race',          'Circuito de saltos cronometrado',5),
    (17, 'BMX Freestyle',     'Trucos en pista o calle',        5),
    -- Gravel
    (18, 'Gravel Racing',     'Competición en grava larga',     6),
    (19, 'Bikepacking',       'Aventura con carga',             6),
    (20, 'Gravel Enduro',     'Descensos en grava',             6);

-- Nivel 4 — categorías competitivas por sub-disciplina (generadas)
-- Cada sub-disciplina (ids 7-20 = 14 sub) tiene 4 categorías = 56 nodos extra
-- Total: 1 + 5 + 14 + 56 = 76 filas; se añaden 4 más para llegar a 80
WITH RECURSIVE gen(n) AS (
    SELECT 21 UNION ALL SELECT n + 1 FROM gen WHERE n < 80
)
INSERT INTO disciplinas (id, nombre, descripcion, parent_id)
SELECT
    n,
    CASE (n % 4)
        WHEN 0 THEN 'Élite — '
        WHEN 1 THEN 'Sub-23 — '
        WHEN 2 THEN 'Júnior — '
        ELSE        'Master — '
    END || (SELECT nombre FROM disciplinas WHERE id = 7 + ((n - 21) / 4)),
    'Categoría competitiva',
    7 + ((n - 21) / 4)
FROM gen
WHERE 7 + ((n - 21) / 4) <= 20;

-- ============================================
-- CONSULTA 1: SELF JOIN básico (INNER JOIN)
-- Muestra hijo → padre, excluye la raíz
-- ============================================

SELECT
    hijo.nombre    AS disciplina,
    padre.nombre   AS disciplina_padre
FROM disciplinas hijo
INNER JOIN disciplinas padre ON hijo.parent_id = padre.id
ORDER BY padre.nombre, hijo.nombre
LIMIT 25;

-- ============================================
-- CONSULTA 2: LEFT JOIN incluye la raíz + COALESCE
-- ============================================

SELECT
    hijo.nombre                              AS disciplina,
    COALESCE(padre.nombre, 'Deporte Raíz')   AS padre
FROM disciplinas hijo
LEFT JOIN disciplinas padre ON hijo.parent_id = padre.id
ORDER BY padre, hijo.nombre
LIMIT 25;

-- ============================================
-- CONSULTA 3: Contar sub-disciplinas por modalidad (HAVING)
-- ============================================

SELECT
    padre.nombre        AS modalidad,
    COUNT(hijo.id)      AS total_hijos
FROM disciplinas padre
LEFT JOIN disciplinas hijo ON hijo.parent_id = padre.id
GROUP BY padre.id, padre.nombre
HAVING COUNT(hijo.id) > 0
ORDER BY total_hijos DESC;

-- ============================================
-- CONSULTA 4: Dos niveles jerárquicos (hijo → padre → abuelo)
-- ============================================

SELECT
    nieto.nombre    AS sub_disciplina,
    hijo.nombre     AS modalidad,
    abuelo.nombre   AS deporte
FROM disciplinas nieto
LEFT JOIN disciplinas hijo   ON nieto.parent_id = hijo.id
LEFT JOIN disciplinas abuelo ON hijo.parent_id  = abuelo.id
WHERE abuelo.id IS NOT NULL
ORDER BY abuelo.nombre, hijo.nombre, nieto.nombre
LIMIT 20;
