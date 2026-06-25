-- ============================================
-- PROYECTO SEMANAL: JOINs aplicados al dominio
-- Semana 09 — INNER JOIN y LEFT JOIN
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
    activo          INTEGER NOT NULL DEFAULT 1 CHECK (activo IN (0, 1))
);

CREATE TABLE IF NOT EXISTS corredores (
    id           INTEGER PRIMARY KEY,
    nombre       TEXT    NOT NULL,
    nacionalidad TEXT    NOT NULL,
    edad         INTEGER NOT NULL CHECK (edad BETWEEN 16 AND 55),
    peso_kg      REAL             CHECK (peso_kg IS NULL OR peso_kg > 40),
    categoria_id INTEGER NOT NULL,
    activo       INTEGER NOT NULL DEFAULT 1 CHECK (activo IN (0, 1)),
    equipo_id    INTEGER NOT NULL,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    FOREIGN KEY (equipo_id)    REFERENCES equipos(id)
);

CREATE TABLE IF NOT EXISTS carreras (
    id              INTEGER PRIMARY KEY,
    nombre          TEXT    NOT NULL,
    pais            TEXT    NOT NULL,
    distancia_km    REAL    NOT NULL CHECK (distancia_km > 0),
    tipo            TEXT    NOT NULL CHECK (tipo IN ('Montaña','Clásica','Etapas','Contrarreloj')),
    año             INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS resultados (
    id               INTEGER PRIMARY KEY,
    corredor_id      INTEGER NOT NULL,
    carrera_id       INTEGER NOT NULL,
    posicion         INTEGER NOT NULL CHECK (posicion >= 1),
    tiempo_total_seg INTEGER NOT NULL CHECK (tiempo_total_seg > 0),
    puntos           INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (corredor_id) REFERENCES corredores(id),
    FOREIGN KEY (carrera_id)  REFERENCES carreras(id)
);

-- ============================================
-- DATOS: categorias y equipos
-- ============================================

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

-- ============================================
-- DATOS: 80 corredores (30 reales + 50 generados)
-- ============================================

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
    (30, 'Ben O Connor',         'Australiana',     28, 64.0, 1, 1, 10),
    (31, 'Filippo Ganna',        'Italiana',        27, 83.0, 1, 1, 1),
    (32, 'Kasper Asgreen',       'Danesa',          28, 78.0, 1, 1, 6),
    (33, 'Alberto Bettiol',      'Italiana',        30, 72.0, 1, 1, 9),
    (34, 'Nils Politt',          'Alemana',         29, 80.0, 1, 1, 7),
    (35, 'Stefan Küng',          'Suiza',           30, 77.0, 1, 1, 8),
    (36, 'Romain Bardet',        'Francesa',        33, 65.0, 1, 1, 9),
    (37, 'Pierre Latour',        'Francesa',        30, 65.0, 1, 1, 10),
    (38, 'Nicolas Roche',        'Irlandesa',       38, 68.0, 1, 1, 7),
    (39, 'Dylan Teuns',          'Belga',           31, 68.0, 1, 1, 10),
    (40, 'Jan Tratnik',          'Eslovena',        33, 68.0, 1, 1, 10),
    (41, 'Michael Woods',        'Canadiense',      36, 62.0, 1, 1, 9),
    (42, 'Rui Costa',            'Portuguesa',      37, 71.0, 1, 1, 2),
    (43, 'Patrick Konrad',       'Austriaca',       32, 74.0, 1, 1, 6),
    (44, 'Alexander Kristoff',   'Noruega',         36, 82.0, 1, 1, 2),
    (45, 'Pello Bilbao',         'Española',        33, 62.0, 1, 1, 10),
    (46, 'Aleksandr Vlasov',     'Rusa',            26, 64.0, 2, 1, 10),
    (47, 'Sergio Higuita',       'Colombiana',      26, 63.0, 2, 1, 9),
    (48, 'Santiago Buitrago',    'Colombiana',      25, 61.0, 2, 1, 10),
    (49, 'Einer Rubio',          'Colombiana',      24, 60.0, 2, 1, 4),
    (50, 'Georg Zimmermann',     'Alemana',         26, 72.0, 2, 1, 7),
    (51, 'Bruno Armirail',       'Francesa',        30, 74.0, 1, 1, 8),
    (52, 'Victor Lafay',         'Francesa',        28, 68.0, 1, 1, 6),
    (53, 'Benjamin Thomas',      'Francesa',        29, 72.0, 1, 1, 8),
    (54, 'Lorenzo Fortunato',    'Italiana',        29, 65.0, 2, 1, 9),
    (55, 'Filippo Zana',         'Italiana',        24, 65.0, 2, 1, 8),
    (56, 'Magnus Sheffield',     'Estadounidense',  22, 68.0, 2, 1, 1),
    (57, 'Ben Healy',            'Irlandesa',       23, 70.0, 2, 1, 9),
    (58, 'Antonio Tiberi',       'Italiana',        22, 62.0, 2, 1, 10),
    (59, 'Dani Martinez',        'Colombiana',      27, 63.0, 1, 1, 1),
    (60, 'Tao Geoghegan Hart',   'Británica',       28, 66.0, 1, 1, 1);

-- corredores 61-80 sin resultados (usados en LEFT JOIN huérfanos)
WITH RECURSIVE gen(n) AS (
    SELECT 61 UNION ALL SELECT n + 1 FROM gen WHERE n < 80
)
INSERT INTO corredores (id, nombre, nacionalidad, edad, peso_kg, categoria_id, activo, equipo_id)
SELECT
    n,
    'Corredor ' || n,
    CASE (n % 6)
        WHEN 0 THEN 'Española'   WHEN 1 THEN 'Colombiana'
        WHEN 2 THEN 'Italiana'   WHEN 3 THEN 'Francesa'
        WHEN 4 THEN 'Belga'      ELSE       'Australiana'
    END,
    18 + (n % 20),
    55.0 + (n % 25),
    1 + (n % 4),
    1,
    1 + (n % 10)
FROM gen;

-- ============================================
-- DATOS: 20 carreras
-- ============================================

INSERT INTO carreras (id, nombre, pais, distancia_km, tipo, año) VALUES
    (1,  'Tour de Francia',        'Francia',       3404.0, 'Montaña',      2023),
    (2,  'Giro de Italia',         'Italia',        3448.0, 'Montaña',      2023),
    (3,  'Vuelta a España',        'España',        3181.0, 'Montaña',      2023),
    (4,  'Milán-San Remo',         'Italia',         294.0, 'Clásica',      2023),
    (5,  'Tour de Flandes',        'Bélgica',        273.0, 'Clásica',      2023),
    (6,  'París-Roubaix',          'Francia',        259.0, 'Clásica',      2023),
    (7,  'Lieja-Bastonia-Lieja',   'Bélgica',        258.0, 'Clásica',      2023),
    (8,  'Il Lombardia',           'Italia',         238.0, 'Clásica',      2023),
    (9,  'Dauphiné',               'Francia',       1148.0, 'Etapas',       2023),
    (10, 'Tour de Romandía',       'Suiza',          788.0, 'Etapas',       2023),
    (11, 'Tirreno-Adriático',      'Italia',        1051.0, 'Etapas',       2023),
    (12, 'París-Niza',             'Francia',       1226.0, 'Etapas',       2023),
    (13, 'Strade Bianche',         'Italia',         184.0, 'Clásica',      2023),
    (14, 'Amstel Gold Race',       'Países Bajos',   255.0, 'Clásica',      2023),
    (15, 'La Flèche Wallonne',     'Bélgica',        198.0, 'Clásica',      2023),
    (16, 'Tour de Suisse',         'Suiza',         1257.0, 'Etapas',       2023),
    (17, 'Vuelta a Cataluña',      'España',        1162.0, 'Etapas',       2023),
    (18, 'País Vasco',             'España',         934.0, 'Etapas',       2023),
    (19, 'Vuelta a Burgos',        'España',         748.0, 'Etapas',       2023),
    (20, 'Clásica San Sebastián',  'España',         228.0, 'Clásica',      2023);

-- ============================================
-- DATOS: 100 resultados (corredores 1-60 con resultados)
-- ============================================

WITH RECURSIVE gen(n) AS (
    SELECT 1 UNION ALL SELECT n + 1 FROM gen WHERE n < 100
)
INSERT INTO resultados (id, corredor_id, carrera_id, posicion, tiempo_total_seg, puntos)
SELECT
    n,
    ((n * 3 - 1) % 60) + 1,
    ((n * 7 - 1) % 20) + 1,
    1 + (n % 15),
    28800 + n * 180,
    CASE
        WHEN (n % 15) + 1 = 1  THEN 100
        WHEN (n % 15) + 1 <= 3 THEN 70
        WHEN (n % 15) + 1 <= 6 THEN 40
        WHEN (n % 15) + 1 <= 10 THEN 20
        ELSE 5
    END
FROM gen;

-- ============================================
-- CONSULTA 1: INNER JOIN principal (corredores + equipos)
-- ============================================

SELECT
    c.nombre    AS corredor,
    e.nombre    AS equipo,
    e.pais      AS pais_equipo,
    c.edad      AS años
FROM corredores c
INNER JOIN equipos e ON c.equipo_id = e.id
ORDER BY e.nombre, c.nombre
LIMIT 20;

-- ============================================
-- CONSULTA 2: JOIN con tres tablas (corredor + equipo + categoría)
-- ============================================

SELECT
    c.nombre    AS corredor,
    cat.nombre  AS categoria,
    e.nombre    AS equipo,
    c.edad      AS años
FROM corredores c
INNER JOIN categorias cat ON c.categoria_id = cat.id
INNER JOIN equipos    e   ON c.equipo_id    = e.id
ORDER BY cat.nombre, c.nombre
LIMIT 20;

-- ============================================
-- CONSULTA 3: LEFT JOIN — todos los corredores con o sin resultados
-- ============================================

SELECT
    c.nombre        AS corredor,
    r.carrera_id    AS carrera,
    r.posicion      AS puesto
FROM corredores c
LEFT JOIN resultados r ON r.corredor_id = c.id
ORDER BY c.id
LIMIT 20;

-- ============================================
-- CONSULTA 4: Detectar corredores sin resultados (huérfanos)
-- ============================================

SELECT
    c.nombre AS corredor_sin_resultados,
    c.edad   AS años
FROM corredores c
LEFT JOIN resultados r ON r.corredor_id = c.id
WHERE r.id IS NULL
ORDER BY c.nombre;

-- ============================================
-- CONSULTA 5: Reporte agregado — resultados por corredor
-- ============================================

SELECT
    c.nombre        AS corredor,
    e.nombre        AS equipo,
    COUNT(r.id)     AS total_carreras,
    SUM(r.puntos)   AS puntos_totales,
    MIN(r.posicion) AS mejor_posicion
FROM corredores  c
INNER JOIN equipos    e ON c.equipo_id   = e.id
LEFT  JOIN resultados r ON r.corredor_id = c.id
GROUP BY c.id, c.nombre, e.nombre
ORDER BY puntos_totales DESC
LIMIT 15;
