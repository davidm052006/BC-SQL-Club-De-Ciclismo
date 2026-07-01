-- ============================================
-- PROYECTO SEMANAL: Subqueries
-- Semana 11 — Escalar, IN/NOT IN, EXISTS, Tabla derivada
-- Dominio: Club de Ciclismo
-- ============================================

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS resultados;
DROP TABLE IF EXISTS carreras;
DROP TABLE IF EXISTS corredores;
DROP TABLE IF EXISTS equipos;
DROP TABLE IF EXISTS categorias;

CREATE TABLE IF NOT EXISTS categorias (
    id          INTEGER PRIMARY KEY,
    nombre      TEXT    NOT NULL UNIQUE,
    descripcion TEXT    NOT NULL DEFAULT 'Sin descripción'
);
CREATE TABLE IF NOT EXISTS equipos (
    id              INTEGER PRIMARY KEY,
    nombre          TEXT    NOT NULL UNIQUE,
    pais            TEXT    NOT NULL,
    director        TEXT    NOT NULL,
    año_fundacion   INTEGER NOT NULL CHECK (año_fundacion >= 1900),
    activo          INTEGER NOT NULL DEFAULT 1
);
CREATE TABLE IF NOT EXISTS corredores (
    id           INTEGER PRIMARY KEY,
    nombre       TEXT    NOT NULL,
    nacionalidad TEXT    NOT NULL,
    edad         INTEGER NOT NULL CHECK (edad BETWEEN 16 AND 55),
    peso_kg      REAL,
    categoria_id INTEGER NOT NULL,
    activo       INTEGER NOT NULL DEFAULT 1,
    equipo_id    INTEGER NOT NULL,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    FOREIGN KEY (equipo_id)    REFERENCES equipos(id)
);
CREATE TABLE IF NOT EXISTS carreras (
    id              INTEGER PRIMARY KEY,
    nombre          TEXT    NOT NULL,
    pais            TEXT    NOT NULL,
    distancia_km    REAL    NOT NULL,
    tipo            TEXT    NOT NULL,
    año             INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS resultados (
    id               INTEGER PRIMARY KEY,
    corredor_id      INTEGER NOT NULL,
    carrera_id       INTEGER NOT NULL,
    posicion         INTEGER NOT NULL CHECK (posicion >= 1),
    tiempo_total_seg INTEGER NOT NULL,
    puntos           INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (corredor_id) REFERENCES corredores(id),
    FOREIGN KEY (carrera_id)  REFERENCES carreras(id)
);

INSERT INTO categorias (id, nombre, descripcion) VALUES
    (1, 'Élite',   'Profesionales mayores de 23 años'),
    (2, 'Sub-23',  'Corredores de 19 a 22 años'),
    (3, 'Júnior',  'Corredores de 17 a 18 años'),
    (4, 'Amateur', 'Corredores no profesionales'),
    (5, 'Máster',  'Corredores mayores de 40 años');

INSERT INTO equipos (id, nombre, pais, director, año_fundacion) VALUES
    (1,  'Ineos Grenadiers',      'Reino Unido',     'Rod Ellingworth',    2010),
    (2,  'UAE Team Emirates',     'Emiratos Árabes', 'Mauro Gianetti',     2017),
    (3,  'Jumbo-Visma',           'Países Bajos',    'Merijn Zeeman',      2018),
    (4,  'Movistar Team',         'España',          'Eusebio Unzué',      1980),
    (5,  'Trek-Segafredo',        'Estados Unidos',  'Luca Guercilena',    2012),
    (6,  'Soudal Quick-Step',     'Bélgica',         'Patrick Lefevere',   2003),
    (7,  'Alpecin-Deceuninck',    'Bélgica',         'Philip Roodhooft',   2015),
    (8,  'Groupama-FDJ',          'Francia',         'Marc Madiot',        1997),
    (9,  'EF Education-EasyPost', 'Estados Unidos',  'Jonathan Vaughters', 2011),
    (10, 'Bahrain Victorious',    'Baréin',          'Milan Erzen',        2017);

INSERT INTO corredores (id, nombre, nacionalidad, edad, peso_kg, categoria_id, activo, equipo_id) VALUES
    (1,  'Egan Bernal',          'Colombiana',      27, 60.5, 1, 1, 1),
    (2,  'Tadej Pogacar',        'Eslovena',        25, 66.0, 1, 1, 2),
    (3,  'Jonas Vingegaard',     'Danesa',          27, 60.0, 1, 1, 3),
    (4,  'Enric Mas',            'Española',        29, 64.0, 1, 1, 4),
    (5,  'Mads Pedersen',        'Danesa',          28, 82.0, 1, 1, 5),
    (6,  'Richard Carapaz',      'Ecuatoriana',     31, 62.0, 1, 1, 1),
    (7,  'Juan Ayuso',           'Española',        21, 65.0, 2, 1, 2),
    (8,  'Sepp Kuss',            'Estadounidense',  29, 61.0, 1, 1, 3),
    (9,  'Alejandro Valverde',   'Española',        43, 61.0, 5, 1, 4),
    (10, 'Bauke Mollema',        'Neerlandesa',     37, 71.0, 1, 1, 5),
    (11, 'Tom Pidcock',          'Británica',       24, 58.0, 2, 1, 1),
    (12, 'Primoz Roglic',        'Eslovena',        34, 65.0, 1, 1, 3),
    (13, 'Mikel Landa',          'Española',        35, 61.0, 1, 1, 4),
    (14, 'Carlos Rodriguez',     'Española',        23, 62.0, 2, 1, 1),
    (15, 'Mattias Skjelmose',    'Danesa',          23, 67.0, 2, 1, 5),
    (16, 'Remco Evenepoel',      'Belga',           24, 61.0, 2, 1, 6),
    (17, 'Wout van Aert',        'Belga',           29, 78.0, 1, 1, 3),
    (18, 'Mathieu van der Poel', 'Neerlandesa',     29, 75.0, 1, 1, 7),
    (19, 'Julian Alaphilippe',   'Francesa',        32, 62.0, 1, 1, 6),
    (20, 'Simon Yates',          'Británica',       31, 58.0, 1, 1, 9),
    (21, 'Geraint Thomas',       'Británica',       38, 71.0, 1, 1, 1),
    (22, 'Thibaut Pinot',        'Francesa',        34, 63.0, 1, 1, 8),
    (23, 'Rigoberto Uran',       'Colombiana',      37, 64.0, 1, 1, 9),
    (24, 'Ivan Sosa',            'Colombiana',      26, 56.0, 2, 1, 1),
    (25, 'Joao Almeida',         'Portuguesa',      25, 63.0, 2, 1, 2),
    (26, 'Felix Gall',           'Austriaca',       26, 65.0, 2, 1, 10),
    (27, 'Adam Yates',           'Británica',       31, 61.0, 1, 1, 2),
    (28, 'Marc Soler',           'Española',        30, 65.0, 1, 1, 2),
    (29, 'David Gaudu',          'Francesa',        27, 53.0, 1, 1, 8),
    (30, 'Ben O Connor',         'Australiana',     28, 64.0, 1, 1, 10);

WITH RECURSIVE gen(n) AS (
    SELECT 31 UNION ALL SELECT n + 1 FROM gen WHERE n < 80
)
INSERT INTO corredores (id, nombre, nacionalidad, edad, peso_kg, categoria_id, activo, equipo_id)
SELECT n, 'Corredor ' || n,
    CASE (n % 6) WHEN 0 THEN 'Española' WHEN 1 THEN 'Colombiana'
                 WHEN 2 THEN 'Italiana' WHEN 3 THEN 'Francesa'
                 WHEN 4 THEN 'Belga'    ELSE 'Australiana' END,
    18 + (n % 20), 55.0 + (n % 25), 1 + (n % 4), 1, 1 + (n % 10)
FROM gen;

INSERT INTO carreras (id, nombre, pais, distancia_km, tipo, año) VALUES
    (1,  'Tour de Francia',      'Francia',     3404.0, 'Montaña', 2023),
    (2,  'Giro de Italia',       'Italia',      3448.0, 'Montaña', 2023),
    (3,  'Vuelta a España',      'España',      3181.0, 'Montaña', 2023),
    (4,  'París-Roubaix',        'Francia',      259.0, 'Clásica', 2023),
    (5,  'Tour de Flandes',      'Bélgica',      273.0, 'Clásica', 2023),
    (6,  'Milán-San Remo',       'Italia',       298.0, 'Clásica', 2023),
    (7,  'Lieja-Bastoña-Lieja',  'Bélgica',      258.0, 'Clásica', 2023),
    (8,  'Il Lombardia',         'Italia',       238.0, 'Clásica', 2023),
    (9,  'Volta a Cataluña',     'España',       1200.0, 'Montaña', 2023),
    (10, 'Tirreno-Adriático',    'Italia',      1000.0, 'Montaña', 2023),
    (11, 'Critérium del Dauphiné','Francia',      950.0, 'Montaña', 2023),
    (12, 'Tour de Suiza',        'Suiza',       1100.0, 'Montaña', 2023),
    (13, 'Amstel Gold Race',     'Países Bajos', 254.0, 'Clásica', 2023),
    (14, 'Gante-Wevelgem',       'Bélgica',      250.0, 'Clásica', 2023),
    (15, 'E3 Saxo Classic',      'Bélgica',      204.0, 'Clásica', 2023),
    (16, 'Vuelta al País Vasco', 'España',       650.0, 'Montaña', 2023),
    (17, 'París-Niza',           'Francia',      950.0, 'Montaña', 2023),
    (18, 'Clásica de San Sebastián', 'España',   227.0, 'Clásica', 2023),
    (19, 'Vuelta a Burgos',      'España',       650.0, 'Montaña', 2023),
    (20, 'Tour de Vendée',       'Francia',      200.0, 'Clásica', 2023);

WITH RECURSIVE gen(n) AS (
    SELECT 1 UNION ALL SELECT n + 1 FROM gen WHERE n < 100
)
INSERT INTO resultados (id, corredor_id, carrera_id, posicion, tiempo_total_seg, puntos)
SELECT n, ((n * 3 - 1) % 60) + 1, ((n * 7 - 1) % 20) + 1,
    1 + (n % 15), 28800 + n * 180,
    CASE WHEN (n % 15) + 1 = 1 THEN 100
         WHEN (n % 15) + 1 <= 3 THEN 70
         WHEN (n % 15) + 1 <= 6 THEN 40
         ELSE 10 END
FROM gen;

-- ============================================
-- CONSULTA 1: Subquery escalar en WHERE
-- Corredores con puntos totales por encima del promedio general
-- ============================================

SELECT
    c.nombre     AS corredor,
    SUM(r.puntos) AS puntos_totales
FROM corredores c
INNER JOIN resultados r ON r.corredor_id = c.id
GROUP BY c.id, c.nombre
HAVING SUM(r.puntos) > (
    -- subquery escalar: promedio de puntos por corredor
    SELECT AVG(total)
    FROM (
        SELECT SUM(puntos) AS total
        FROM resultados
        GROUP BY corredor_id
    )
)
ORDER BY puntos_totales DESC;

-- ============================================
-- CONSULTA 2: Subquery escalar en SELECT
-- Promedio global de puntos mostrado junto a cada corredor
-- ============================================

SELECT
    c.nombre                                          AS corredor,
    SUM(r.puntos)                                     AS puntos_corredor,
    ROUND((SELECT AVG(puntos) FROM resultados), 1)    AS promedio_global
FROM corredores c
INNER JOIN resultados r ON r.corredor_id = c.id
GROUP BY c.id, c.nombre
ORDER BY puntos_corredor DESC
LIMIT 10;

-- ============================================
-- CONSULTA 3: NOT EXISTS — corredores sin ningún resultado
-- ============================================

SELECT
    c.nombre       AS corredor_sin_resultados,
    c.nacionalidad AS pais
FROM corredores c
WHERE NOT EXISTS (
    SELECT 1
    FROM resultados r
    WHERE r.corredor_id = c.id
)
ORDER BY c.nombre;

-- ============================================
-- CONSULTA 4: Tabla derivada en FROM
-- Equipos cuyo total de puntos supera el promedio por equipo
-- ============================================

SELECT
    stats.equipo,
    stats.total_puntos
FROM (
    SELECT
        e.nombre        AS equipo,
        SUM(r.puntos)   AS total_puntos
    FROM equipos e
    INNER JOIN corredores  c ON c.equipo_id    = e.id
    INNER JOIN resultados  r ON r.corredor_id  = c.id
    GROUP BY e.id, e.nombre
) AS stats
WHERE stats.total_puntos > (
    SELECT AVG(total_por_equipo)
    FROM (
        SELECT SUM(r2.puntos) AS total_por_equipo
        FROM equipos e2
        INNER JOIN corredores  c2 ON c2.equipo_id   = e2.id
        INNER JOIN resultados  r2 ON r2.corredor_id = c2.id
        GROUP BY e2.id
    )
)
ORDER BY stats.total_puntos DESC;
