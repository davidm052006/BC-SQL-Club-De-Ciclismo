-- ============================================
-- PROYECTO SEMANAL: NULL y Constraints
-- Semana 07 — NOT NULL, UNIQUE, CHECK, FK, COALESCE
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

-- peso_kg es opcional (puede ser NULL: datos no disponibles)
-- dorsal es UNIQUE por corredor activo
CREATE TABLE IF NOT EXISTS corredores (
    id           INTEGER PRIMARY KEY,
    nombre       TEXT    NOT NULL,
    nacionalidad TEXT    NOT NULL,
    edad         INTEGER NOT NULL CHECK (edad BETWEEN 16 AND 55),
    peso_kg      REAL             CHECK (peso_kg IS NULL OR peso_kg > 40),
    dorsal       INTEGER          UNIQUE,
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

-- Algunos corredores tienen peso_kg = NULL (dato no registrado)
-- Algunos no tienen dorsal asignado aún
INSERT INTO corredores (id, nombre, nacionalidad, edad, peso_kg, dorsal, categoria_id, activo, equipo_id) VALUES
    (1,  'Egan Bernal',          'Colombiana',      27, 60.5,  1,    1, 1, 1),
    (2,  'Tadej Pogacar',        'Eslovena',        25, 66.0,  2,    1, 1, 2),
    (3,  'Jonas Vingegaard',     'Danesa',          27, 60.0,  3,    1, 1, 3),
    (4,  'Enric Mas',            'Española',        29, 64.0,  4,    1, 1, 4),
    (5,  'Mads Pedersen',        'Danesa',          28, 82.0,  5,    1, 1, 5),
    (6,  'Richard Carapaz',      'Ecuatoriana',     31, 62.0,  6,    1, 1, 1),
    (7,  'Juan Ayuso',           'Española',        21, 65.0,  7,    2, 1, 2),
    (8,  'Sepp Kuss',            'Estadounidense',  29, NULL,   NULL, 1, 1, 3),
    (9,  'Alejandro Valverde',   'Española',        43, 61.0,  9,    5, 1, 4),
    (10, 'Bauke Mollema',        'Neerlandesa',     37, 71.0,  10,   1, 1, 5),
    (11, 'Tom Pidcock',          'Británica',       24, 58.0,  11,   2, 1, 1),
    (12, 'Primoz Roglic',        'Eslovena',        34, NULL,   NULL, 1, 1, 3),
    (13, 'Mikel Landa',          'Española',        35, 61.0,  13,   1, 1, 4),
    (14, 'Carlos Rodriguez',     'Española',        23, 62.0,  14,   2, 1, 1),
    (15, 'Mattias Skjelmose',    'Danesa',          23, 67.0,  15,   2, 1, 5),
    (16, 'Remco Evenepoel',      'Belga',           24, 61.0,  16,   2, 1, 6),
    (17, 'Wout van Aert',        'Belga',           29, 78.0,  17,   1, 1, 3),
    (18, 'Mathieu van der Poel', 'Neerlandesa',     29, NULL,   NULL, 1, 1, 7),
    (19, 'Julian Alaphilippe',   'Francesa',        32, 62.0,  19,   1, 1, 6),
    (20, 'Simon Yates',          'Británica',       31, 58.0,  20,   1, 1, 9),
    (21, 'Geraint Thomas',       'Británica',       38, 71.0,  21,   1, 1, 1),
    (22, 'Thibaut Pinot',        'Francesa',        34, NULL,   NULL, 1, 1, 8),
    (23, 'Rigoberto Uran',       'Colombiana',      37, 64.0,  23,   1, 1, 9),
    (24, 'Ivan Sosa',            'Colombiana',      26, 56.0,  24,   2, 1, 1),
    (25, 'Joao Almeida',         'Portuguesa',      25, 63.0,  25,   2, 1, 2),
    (26, 'Felix Gall',           'Austriaca',       26, 65.0,  26,   2, 1, 10),
    (27, 'Adam Yates',           'Británica',       31, 61.0,  27,   1, 1, 2),
    (28, 'Marc Soler',           'Española',        30, 65.0,  28,   1, 1, 2),
    (29, 'David Gaudu',          'Francesa',        27, 53.0,  29,   1, 1, 8),
    (30, 'Ben O Connor',         'Australiana',     28, NULL,   NULL, 1, 1, 10);

-- ============================================
-- CONSULTA 1: Corredores sin peso registrado (IS NULL)
-- ============================================

SELECT
    nombre       AS corredor,
    nacionalidad AS pais,
    edad         AS años
FROM corredores
WHERE peso_kg IS NULL
ORDER BY nombre;

-- ============================================
-- CONSULTA 2: COALESCE — mostrar "Sin dato" donde peso es NULL
-- ============================================

SELECT
    nombre                                   AS corredor,
    COALESCE(CAST(peso_kg AS TEXT), 'Sin dato') AS peso_kg,
    COALESCE(CAST(dorsal AS TEXT), 'Por asignar') AS dorsal
FROM corredores
ORDER BY nombre;

-- ============================================
-- CONSULTA 3: Corredores CON peso y dorsal registrados
-- ============================================

SELECT
    nombre  AS corredor,
    peso_kg AS peso,
    dorsal
FROM corredores
WHERE peso_kg IS NOT NULL
  AND dorsal  IS NOT NULL
ORDER BY peso_kg DESC;
