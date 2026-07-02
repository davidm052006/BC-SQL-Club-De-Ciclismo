-- ============================================
-- PROYECTO SEMANAL: Conoce tu Dominio
-- Semana 01 — Introducción a Bases de Datos Relacionales
-- Dominio: Club de Ciclismo
-- ============================================

-- ============================================
-- PASO 1: Crear la entidad de referencia — equipos
-- ============================================

CREATE TABLE equipos (
    id     INTEGER PRIMARY KEY,
    nombre TEXT    NOT NULL,
    pais   TEXT    NOT NULL
);

-- ============================================
-- PASO 2: Crear la entidad principal — corredores
-- ============================================

CREATE TABLE corredores (
    id           INTEGER PRIMARY KEY,
    nombre       TEXT    NOT NULL,
    nacionalidad TEXT    NOT NULL,
    edad         INTEGER NOT NULL,
    categoria    TEXT    NOT NULL,
    equipo_id    INTEGER
);

-- ============================================
-- PASO 3: Insertar datos de prueba
-- ============================================

-- 5 equipos (tabla secundaria)
INSERT INTO equipos (id, nombre, pais) VALUES
    (1, 'Ineos Grenadiers',  'Reino Unido'),
    (2, 'UAE Team Emirates', 'Emiratos Árabes'),
    (3, 'Jumbo-Visma',       'Países Bajos'),
    (4, 'Movistar Team',     'España'),
    (5, 'Trek-Segafredo',    'Estados Unidos');

-- 15 corredores (tabla principal)
INSERT INTO corredores (id, nombre, nacionalidad, edad, categoria, equipo_id) VALUES
    (1,  'Egan Bernal',       'Colombiana',      27, 'Élite',  1),
    (2,  'Tadej Pogacar',     'Eslovena',        25, 'Élite',  2),
    (3,  'Jonas Vingegaard',  'Danesa',          27, 'Élite',  3),
    (4,  'Enric Mas',         'Española',        29, 'Élite',  4),
    (5,  'Mads Pedersen',     'Danesa',          28, 'Élite',  5),
    (6,  'Richard Carapaz',   'Ecuatoriana',     31, 'Élite',  1),
    (7,  'Juan Ayuso',        'Española',        21, 'Sub-23', 2),
    (8,  'Sepp Kuss',         'Estadounidense',  29, 'Élite',  3),
    (9,  'Alejandro Valverde','Española',        43, 'Élite',  4),
    (10, 'Bauke Mollema',     'Neerlandesa',     37, 'Élite',  5),
    (11, 'Tom Pidcock',       'Británica',       24, 'Sub-23', 1),
    (12, 'Primoz Roglic',     'Eslovena',        34, 'Élite',  3),
    (13, 'Mikel Landa',       'Española',        35, 'Élite',  4),
    (14, 'Carlos Rodriguez',  'Española',        23, 'Sub-23', 1),
    (15, 'Mattias Skjelmose', 'Danesa',          23, 'Sub-23', 5);

-- ============================================
-- PASO 4: Consultas SELECT básicas
-- ============================================

-- Todos los corredores con todas sus columnas
SELECT *
FROM   corredores;

-- Solo el nombre de los corredores ordenados alfabéticamente
SELECT nombre
FROM   corredores
ORDER BY nombre;

-- Contar cuántos corredores hay en total
SELECT COUNT(*) AS total_corredores
FROM   corredores;
