-- ============================================
-- PROYECTO SEMANAL: Ranking con Window Functions
-- Semana 14 — ROW_NUMBER, RANK, DENSE_RANK
-- Motor: PostgreSQL 16
-- Dominio: Club de Ciclismo
-- ============================================

-- docker compose -f scripts/docker-compose.yml up -d
-- docker compose -f scripts/docker-compose.yml exec -T postgres \
--   psql -U bootcamp -d bootcamp_db < semanas/semana_14/proyecto.sql

DROP TABLE IF EXISTS resultados  CASCADE;
DROP TABLE IF EXISTS corredores  CASCADE;
DROP TABLE IF EXISTS equipos     CASCADE;
DROP TABLE IF EXISTS categorias  CASCADE;

CREATE TABLE categorias (
    id      SERIAL PRIMARY KEY,
    nombre  TEXT   NOT NULL UNIQUE
);

CREATE TABLE equipos (
    id              SERIAL  PRIMARY KEY,
    nombre          TEXT    NOT NULL UNIQUE,
    pais            TEXT    NOT NULL,
    año_fundacion   INT     NOT NULL
);

CREATE TABLE corredores (
    id           SERIAL  PRIMARY KEY,
    nombre       TEXT    NOT NULL,
    nacionalidad TEXT    NOT NULL,
    edad         INT     NOT NULL,
    categoria_id INT     NOT NULL REFERENCES categorias(id),
    equipo_id    INT     NOT NULL REFERENCES equipos(id)
);

CREATE TABLE resultados (
    id               SERIAL  PRIMARY KEY,
    corredor_id      INT     NOT NULL REFERENCES corredores(id),
    carrera          TEXT    NOT NULL,
    posicion         INT     NOT NULL CHECK (posicion >= 1),
    puntos           INT     NOT NULL DEFAULT 0
);

-- ============================================
-- DATOS: categorias y equipos
-- ============================================

INSERT INTO categorias (nombre) VALUES
    ('Élite'), ('Sub-23'), ('Júnior'), ('Amateur'), ('Máster');

INSERT INTO equipos (nombre, pais, año_fundacion) VALUES
    ('Ineos Grenadiers',      'Reino Unido',     2010),
    ('UAE Team Emirates',     'Emiratos Árabes', 2017),
    ('Jumbo-Visma',           'Países Bajos',    2018),
    ('Movistar Team',         'España',          1980),
    ('Trek-Segafredo',        'Estados Unidos',  2012),
    ('Soudal Quick-Step',     'Bélgica',         2003),
    ('Alpecin-Deceuninck',    'Bélgica',         2015),
    ('Groupama-FDJ',          'Francia',         1997),
    ('EF Education-EasyPost', 'Estados Unidos',  2011),
    ('Bahrain Victorious',    'Baréin',          2017);

-- 30 corredores reales
INSERT INTO corredores (nombre, nacionalidad, edad, categoria_id, equipo_id) VALUES
    ('Egan Bernal',          'Colombiana',     27, 1, 1),
    ('Tadej Pogacar',        'Eslovena',       25, 1, 2),
    ('Jonas Vingegaard',     'Danesa',         27, 1, 3),
    ('Enric Mas',            'Española',       29, 1, 4),
    ('Mads Pedersen',        'Danesa',         28, 1, 5),
    ('Richard Carapaz',      'Ecuatoriana',    31, 1, 1),
    ('Juan Ayuso',           'Española',       21, 2, 2),
    ('Sepp Kuss',            'Estadounidense', 29, 1, 3),
    ('Alejandro Valverde',   'Española',       43, 5, 4),
    ('Bauke Mollema',        'Neerlandesa',    37, 1, 5),
    ('Tom Pidcock',          'Británica',      24, 2, 1),
    ('Primoz Roglic',        'Eslovena',       34, 1, 3),
    ('Mikel Landa',          'Española',       35, 1, 4),
    ('Carlos Rodriguez',     'Española',       23, 2, 1),
    ('Mattias Skjelmose',    'Danesa',         23, 2, 5),
    ('Remco Evenepoel',      'Belga',          24, 2, 6),
    ('Wout van Aert',        'Belga',          29, 1, 3),
    ('Mathieu van der Poel', 'Neerlandesa',    29, 1, 7),
    ('Julian Alaphilippe',   'Francesa',       32, 1, 6),
    ('Simon Yates',          'Británica',      31, 1, 9),
    ('Geraint Thomas',       'Británica',      38, 1, 1),
    ('Thibaut Pinot',        'Francesa',       34, 1, 8),
    ('Rigoberto Uran',       'Colombiana',     37, 1, 9),
    ('Ivan Sosa',            'Colombiana',     26, 2, 1),
    ('Joao Almeida',         'Portuguesa',     25, 2, 2),
    ('Felix Gall',           'Austriaca',      26, 2, 10),
    ('Adam Yates',           'Británica',      31, 1, 2),
    ('Marc Soler',           'Española',       30, 1, 2),
    ('David Gaudu',          'Francesa',       27, 1, 8),
    ('Ben O Connor',         'Australiana',    28, 1, 10);

-- 170 corredores más vía generate_series (total ≥ 200)
INSERT INTO corredores (nombre, nacionalidad, edad, categoria_id, equipo_id)
SELECT
    'Corredor ' || gs,
    CASE gs % 8
        WHEN 0 THEN 'Española'   WHEN 1 THEN 'Colombiana'
        WHEN 2 THEN 'Italiana'   WHEN 3 THEN 'Francesa'
        WHEN 4 THEN 'Belga'      WHEN 5 THEN 'Australiana'
        WHEN 6 THEN 'Alemana'    ELSE        'Portuguesa'
    END,
    18 + (gs % 22),
    1 + (gs % 4),
    1 + (gs % 10)
FROM generate_series(31, 200) AS gs;

-- 300 resultados con empates intencionales para RANK vs DENSE_RANK
INSERT INTO resultados (corredor_id, carrera, posicion, puntos)
SELECT
    1 + (gs % 200),
    CASE gs % 5
        WHEN 0 THEN 'Tour de Francia'
        WHEN 1 THEN 'Giro de Italia'
        WHEN 2 THEN 'Vuelta a España'
        WHEN 3 THEN 'Tour de Flandes'
        ELSE        'París-Roubaix'
    END,
    1 + (gs % 20),
    CASE
        WHEN gs % 20 = 0  THEN 200
        WHEN gs % 20 <= 2 THEN 150
        WHEN gs % 20 <= 5 THEN 100
        WHEN gs % 20 <= 10 THEN 60
        ELSE 20
    END
FROM generate_series(1, 300) AS gs;

-- ============================================
-- CONSULTA 1: ROW_NUMBER — corredor único por posición
-- Elimina empates asignando posición única por orden de id
-- ============================================

WITH ranking_unico AS (
    SELECT
        c.nombre        AS corredor,
        e.nombre        AS equipo,
        SUM(r.puntos)   AS puntos_totales,
        ROW_NUMBER() OVER (ORDER BY SUM(r.puntos) DESC, c.id ASC) AS rn
    FROM corredores c
    INNER JOIN equipos    e ON c.equipo_id   = e.id
    INNER JOIN resultados r ON r.corredor_id = c.id
    GROUP BY c.id, c.nombre, e.nombre
)
SELECT rn AS posicion, corredor, equipo, puntos_totales
FROM   ranking_unico
WHERE  rn <= 15
ORDER BY rn;

-- ============================================
-- CONSULTA 2: RANK y DENSE_RANK por equipo
-- Visible: empates producen huecos con RANK, no con DENSE_RANK
-- ============================================

WITH puntos_corredor AS (
    SELECT
        c.id,
        c.nombre        AS corredor,
        e.nombre        AS equipo,
        e.id            AS equipo_id,
        SUM(r.puntos)   AS puntos
    FROM corredores c
    INNER JOIN equipos    e ON c.equipo_id   = e.id
    INNER JOIN resultados r ON r.corredor_id = c.id
    GROUP BY c.id, c.nombre, e.id, e.nombre
)
SELECT
    equipo,
    corredor,
    puntos,
    RANK()       OVER (PARTITION BY equipo_id ORDER BY puntos DESC) AS rank_posicion,
    DENSE_RANK() OVER (PARTITION BY equipo_id ORDER BY puntos DESC) AS dense_rank_posicion
FROM puntos_corredor
ORDER BY equipo, puntos DESC
LIMIT 30;

-- ============================================
-- CONSULTA 3: Top-3 por equipo con CTE + DENSE_RANK
-- ============================================

WITH puntos_por_corredor AS (
    SELECT
        c.id,
        c.nombre        AS corredor,
        e.nombre        AS equipo,
        e.id            AS equipo_id,
        SUM(r.puntos)   AS puntos
    FROM corredores c
    INNER JOIN equipos    e ON c.equipo_id   = e.id
    INNER JOIN resultados r ON r.corredor_id = c.id
    GROUP BY c.id, c.nombre, e.id, e.nombre
),
ranking_por_equipo AS (
    SELECT
        corredor,
        equipo,
        puntos,
        DENSE_RANK() OVER (PARTITION BY equipo_id ORDER BY puntos DESC) AS rnk
    FROM puntos_por_corredor
)
SELECT
    equipo,
    corredor,
    puntos,
    rnk AS posicion_en_equipo
FROM  ranking_por_equipo
WHERE rnk <= 3
ORDER BY equipo, rnk;
