-- ============================================
-- PROYECTO SEMANAL: Análisis Temporal + Vistas
-- Semana 15 — LAG, LEAD, FIRST_VALUE, LAST_VALUE, CREATE VIEW
-- Motor: PostgreSQL 16
-- Dominio: Club de Ciclismo
-- ============================================

-- docker compose -f scripts/docker-compose.yml up -d
-- docker compose -f scripts/docker-compose.yml exec -T postgres \
--   psql -U bootcamp -d bootcamp_db < semanas/semana_15/proyecto.sql

DROP VIEW  IF EXISTS v_analisis_rendimiento CASCADE;
DROP TABLE IF EXISTS resultados_mensuales   CASCADE;
DROP TABLE IF EXISTS equipos               CASCADE;

CREATE TABLE equipos (
    id     SERIAL PRIMARY KEY,
    nombre TEXT   NOT NULL UNIQUE,
    pais   TEXT   NOT NULL
);

-- Métricas mensuales por equipo: puntos acumulados en carreras
CREATE TABLE resultados_mensuales (
    id          SERIAL          PRIMARY KEY,
    mes         DATE            NOT NULL,
    equipo_id   INT             NOT NULL REFERENCES equipos(id),
    puntos      NUMERIC(10, 2)  NOT NULL CHECK (puntos >= 0),
    carreras    INT             NOT NULL DEFAULT 0
);

-- ============================================
-- DATOS: 10 equipos
-- ============================================

INSERT INTO equipos (nombre, pais) VALUES
    ('Ineos Grenadiers',      'Reino Unido'),
    ('UAE Team Emirates',     'Emiratos Árabes'),
    ('Jumbo-Visma',           'Países Bajos'),
    ('Movistar Team',         'España'),
    ('Trek-Segafredo',        'Estados Unidos'),
    ('Soudal Quick-Step',     'Bélgica'),
    ('Alpecin-Deceuninck',    'Bélgica'),
    ('Groupama-FDJ',          'Francia'),
    ('EF Education-EasyPost', 'Estados Unidos'),
    ('Bahrain Victorious',    'Baréin');

-- 240 filas: 24 meses × 10 equipos (≥ 200 filas requeridas)
-- Puntos varían por equipo y por mes con tendencias simuladas
INSERT INTO resultados_mensuales (mes, equipo_id, puntos, carreras)
SELECT
    DATE_TRUNC('month', '2022-01-01'::DATE + ((gs - 1) / 10) * INTERVAL '1 month'),
    1 + ((gs - 1) % 10),
    -- Tendencia: equipos top tienen puntos más altos, con variación mensual
    ROUND(
        (CASE 1 + ((gs - 1) % 10)
            WHEN 1 THEN 800  WHEN 2 THEN 850  WHEN 3 THEN 780
            WHEN 4 THEN 500  WHEN 5 THEN 560  WHEN 6 THEN 720
            WHEN 7 THEN 640  WHEN 8 THEN 480  WHEN 9 THEN 530
            ELSE 490
        END
        + (gs % 17) * 15
        - (gs % 11) * 10
        )::NUMERIC, 2
    ),
    2 + (gs % 4)
FROM generate_series(1, 240) AS gs;

-- ============================================
-- CONSULTA 1: LAG — delta de puntos respecto al mes anterior
-- ============================================

SELECT
    e.nombre                                        AS equipo,
    rm.mes,
    rm.puntos,
    LAG(rm.puntos) OVER (
        PARTITION BY rm.equipo_id
        ORDER BY rm.mes
    )                                               AS puntos_mes_anterior,
    rm.puntos - LAG(rm.puntos) OVER (
        PARTITION BY rm.equipo_id
        ORDER BY rm.mes
    )                                               AS delta_puntos
FROM resultados_mensuales rm
INNER JOIN equipos e ON e.id = rm.equipo_id
WHERE rm.equipo_id IN (1, 2, 3)
ORDER BY rm.equipo_id, rm.mes
LIMIT 30;

-- ============================================
-- CONSULTA 2: FIRST_VALUE y LAST_VALUE por equipo
-- Mejor y peor mes histórico de cada equipo
-- ============================================

SELECT DISTINCT
    e.nombre                                    AS equipo,
    rm.mes,
    rm.puntos,
    FIRST_VALUE(rm.puntos) OVER w               AS mejor_mes_historico,
    LAST_VALUE(rm.puntos)  OVER w               AS peor_mes_historico
FROM resultados_mensuales rm
INNER JOIN equipos e ON e.id = rm.equipo_id
WHERE rm.equipo_id <= 5
WINDOW w AS (
    PARTITION BY rm.equipo_id
    ORDER BY rm.puntos DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
ORDER BY e.nombre, rm.mes
LIMIT 20;

-- ============================================
-- CONSULTA 3: CREATE VIEW — análisis de rendimiento completo
-- ============================================

CREATE OR REPLACE VIEW v_analisis_rendimiento AS
SELECT
    e.nombre                                            AS equipo,
    rm.mes,
    rm.puntos,
    rm.carreras,
    LAG(rm.puntos) OVER (
        PARTITION BY rm.equipo_id ORDER BY rm.mes
    )                                                   AS puntos_mes_anterior,
    rm.puntos - LAG(rm.puntos) OVER (
        PARTITION BY rm.equipo_id ORDER BY rm.mes
    )                                                   AS delta_puntos,
    FIRST_VALUE(rm.puntos) OVER (
        PARTITION BY rm.equipo_id
        ORDER BY rm.puntos DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )                                                   AS mejor_mes,
    ROUND(AVG(rm.puntos) OVER (
        PARTITION BY rm.equipo_id
        ORDER BY rm.mes
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2)                                               AS media_movil_3m
FROM resultados_mensuales rm
INNER JOIN equipos e ON e.id = rm.equipo_id;

-- Consulta a la vista: rendimiento del equipo Ineos Grenadiers
SELECT *
FROM   v_analisis_rendimiento
WHERE  equipo = 'Ineos Grenadiers'
ORDER BY mes;
