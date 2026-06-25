-- ============================================
-- PROYECTO SEMANAL: Consultas SELECT
-- Semana 04 — SELECT, WHERE, ORDER BY, LIMIT/OFFSET
-- Dominio: Club de Ciclismo
-- ============================================

PRAGMA foreign_keys = ON;

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
    activo          INTEGER NOT NULL DEFAULT 1 CHECK (activo IN (0, 1))
);

CREATE TABLE IF NOT EXISTS corredores (
    id           INTEGER PRIMARY KEY,
    nombre       TEXT    NOT NULL,
    nacionalidad TEXT    NOT NULL,
    edad         INTEGER NOT NULL CHECK (edad BETWEEN 16 AND 55),
    peso_kg      REAL             CHECK (peso_kg > 40),
    categoria_id INTEGER NOT NULL,
    activo       INTEGER NOT NULL DEFAULT 1 CHECK (activo IN (0, 1)),
    equipo_id    INTEGER NOT NULL,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    FOREIGN KEY (equipo_id)    REFERENCES equipos(id)
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

-- ============================================
-- CONSULTA 1: Listado con columnas explícitas y alias
-- ============================================

SELECT
    c.nombre       AS corredor,
    c.nacionalidad AS pais_origen,
    c.edad         AS años,
    c.peso_kg      AS peso_en_kg
FROM corredores c
ORDER BY c.nombre;

-- ============================================
-- CONSULTA 2: Filtro por condición simple (Élite activos)
-- ============================================

SELECT
    nombre       AS corredor,
    edad         AS años,
    categoria_id AS categoria
FROM corredores
WHERE categoria_id = 1
  AND activo = 1;

-- ============================================
-- CONSULTA 3: Filtro combinado (Sub-23 menores de 25)
-- ============================================

SELECT
    nombre       AS corredor,
    edad         AS años,
    nacionalidad AS pais
FROM corredores
WHERE categoria_id = 2
  AND edad < 25
ORDER BY edad ASC;

-- ============================================
-- CONSULTA 4: Top-5 corredores más pesados
-- ============================================

SELECT
    nombre   AS corredor,
    peso_kg  AS peso_en_kg,
    equipo_id AS equipo
FROM corredores
ORDER BY peso_kg DESC
LIMIT 5;

-- ============================================
-- CONSULTA 5: Paginación — corredores ordenados por nombre
-- ============================================

-- Página 1 (registros 1–5)
SELECT
    nombre AS corredor,
    edad   AS años
FROM corredores
ORDER BY nombre ASC
LIMIT 5 OFFSET 0;

-- Página 2 (registros 6–10)
SELECT
    nombre AS corredor,
    edad   AS años
FROM corredores
ORDER BY nombre ASC
LIMIT 5 OFFSET 5;
