-- ============================================
-- PROYECTO SEMANAL: DDL de tu Dominio
-- Semana 02 — Diseño de Esquemas
-- Dominio: Club de Ciclismo
-- ============================================

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS corredores;
DROP TABLE IF EXISTS equipos;
DROP TABLE IF EXISTS categorias;

-- ============================================
-- TABLA 1: categorias — entidad de clasificación
-- ============================================

CREATE TABLE IF NOT EXISTS categorias (
    id          INTEGER PRIMARY KEY,
    nombre      TEXT    NOT NULL UNIQUE,
    descripcion TEXT    NOT NULL DEFAULT 'Sin descripción'
);

-- ============================================
-- TABLA 2: equipos — entidad de referencia
-- ============================================

CREATE TABLE IF NOT EXISTS equipos (
    id              INTEGER PRIMARY KEY,
    nombre          TEXT    NOT NULL UNIQUE,
    pais            TEXT    NOT NULL,
    director        TEXT    NOT NULL,
    año_fundacion   INTEGER NOT NULL CHECK (año_fundacion >= 1900 AND año_fundacion <= 2030),
    activo          INTEGER NOT NULL DEFAULT 1 CHECK (activo IN (0, 1))
);

-- ============================================
-- TABLA 3: corredores — entidad principal
-- ============================================

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

-- ============================================
-- DATOS: categorias
-- ============================================

INSERT INTO categorias (id, nombre, descripcion) VALUES
    (1, 'Élite',   'Profesionales mayores de 23 años'),
    (2, 'Sub-23',  'Corredores de 19 a 22 años'),
    (3, 'Júnior',  'Corredores de 17 a 18 años'),
    (4, 'Amateur', 'Corredores no profesionales'),
    (5, 'Máster',  'Corredores mayores de 40 años');

-- ============================================
-- DATOS: equipos
-- ============================================

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

-- ============================================
-- DATOS: corredores (15 mínimo)
-- ============================================

INSERT INTO corredores (id, nombre, nacionalidad, edad, peso_kg, categoria_id, equipo_id) VALUES
    (1,  'Egan Bernal',          'Colombiana',     27, 60.5, 1, 1),
    (2,  'Tadej Pogacar',        'Eslovena',       25, 66.0, 1, 2),
    (3,  'Jonas Vingegaard',     'Danesa',         27, 60.0, 1, 3),
    (4,  'Enric Mas',            'Española',       29, 64.0, 1, 4),
    (5,  'Mads Pedersen',        'Danesa',         28, 82.0, 1, 5),
    (6,  'Richard Carapaz',      'Ecuatoriana',    31, 62.0, 1, 1),
    (7,  'Juan Ayuso',           'Española',       21, 65.0, 2, 2),
    (8,  'Sepp Kuss',            'Estadounidense', 29, 61.0, 1, 3),
    (9,  'Alejandro Valverde',   'Española',       43, 61.0, 5, 4),
    (10, 'Bauke Mollema',        'Neerlandesa',    37, 71.0, 1, 5),
    (11, 'Tom Pidcock',          'Británica',      24, 58.0, 2, 1),
    (12, 'Primoz Roglic',        'Eslovena',       34, 65.0, 1, 3),
    (13, 'Mikel Landa',          'Española',       35, 61.0, 1, 4),
    (14, 'Carlos Rodriguez',     'Española',       23, 62.0, 2, 1),
    (15, 'Mattias Skjelmose',    'Danesa',         23, 67.0, 2, 5);

-- ============================================
-- VERIFICACIÓN
-- ============================================

PRAGMA table_info(corredores);
PRAGMA table_info(equipos);
PRAGMA table_info(categorias);
