-- ============================================
-- PROYECTO SEMANAL: CTEs y CASE WHEN
-- Semana 12 — WITH, CTEs encadenados, Clasificación
-- Dominio: Club de Ciclismo
-- ============================================

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS resultados;
DROP TABLE IF EXISTS carreras;
DROP TABLE IF EXISTS corredores;
DROP TABLE IF EXISTS equipos;
DROP TABLE IF EXISTS categorias;

CREATE TABLE IF NOT EXISTS categorias (
    id INTEGER PRIMARY KEY, nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT NOT NULL DEFAULT 'Sin descripción'
);
CREATE TABLE IF NOT EXISTS equipos (
    id INTEGER PRIMARY KEY, nombre TEXT NOT NULL UNIQUE,
    pais TEXT NOT NULL, director TEXT NOT NULL,
    año_fundacion INTEGER NOT NULL, activo INTEGER NOT NULL DEFAULT 1
);
CREATE TABLE IF NOT EXISTS corredores (
    id INTEGER PRIMARY KEY, nombre TEXT NOT NULL,
    nacionalidad TEXT NOT NULL, edad INTEGER NOT NULL,
    peso_kg REAL, categoria_id INTEGER NOT NULL,
    activo INTEGER NOT NULL DEFAULT 1, equipo_id INTEGER NOT NULL,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    FOREIGN KEY (equipo_id)    REFERENCES equipos(id)
);
CREATE TABLE IF NOT EXISTS carreras (
    id INTEGER PRIMARY KEY, nombre TEXT NOT NULL,
    pais TEXT NOT NULL, distancia_km REAL NOT NULL,
    tipo TEXT NOT NULL, año INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS resultados (
    id INTEGER PRIMARY KEY, corredor_id INTEGER NOT NULL,
    carrera_id INTEGER NOT NULL, posicion INTEGER NOT NULL,
    tiempo_total_seg INTEGER NOT NULL, puntos INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (corredor_id) REFERENCES corredores(id),
    FOREIGN KEY (carrera_id)  REFERENCES carreras(id)
);

INSERT INTO categorias (id, nombre, descripcion) VALUES
    (1,'Élite','Profesionales >23'),(2,'Sub-23','19-22 años'),
    (3,'Júnior','17-18 años'),(4,'Amateur','No profesional'),(5,'Máster','>40 años');

INSERT INTO equipos (id, nombre, pais, director, año_fundacion) VALUES
    (1,'Ineos Grenadiers','Reino Unido','Rod Ellingworth',2010),
    (2,'UAE Team Emirates','Emiratos Árabes','Mauro Gianetti',2017),
    (3,'Jumbo-Visma','Países Bajos','Merijn Zeeman',2018),
    (4,'Movistar Team','España','Eusebio Unzué',1980),
    (5,'Trek-Segafredo','Estados Unidos','Luca Guercilena',2012),
    (6,'Soudal Quick-Step','Bélgica','Patrick Lefevere',2003),
    (7,'Alpecin-Deceuninck','Bélgica','Philip Roodhooft',2015),
    (8,'Groupama-FDJ','Francia','Marc Madiot',1997),
    (9,'EF Education-EasyPost','Estados Unidos','Jonathan Vaughters',2011),
    (10,'Bahrain Victorious','Baréin','Milan Erzen',2017);

INSERT INTO corredores (id, nombre, nacionalidad, edad, peso_kg, categoria_id, activo, equipo_id) VALUES
    (1,'Egan Bernal','Colombiana',27,60.5,1,1,1),(2,'Tadej Pogacar','Eslovena',25,66.0,1,1,2),
    (3,'Jonas Vingegaard','Danesa',27,60.0,1,1,3),(4,'Enric Mas','Española',29,64.0,1,1,4),
    (5,'Mads Pedersen','Danesa',28,82.0,1,1,5),(6,'Richard Carapaz','Ecuatoriana',31,62.0,1,1,1),
    (7,'Juan Ayuso','Española',21,65.0,2,1,2),(8,'Sepp Kuss','Estadounidense',29,61.0,1,1,3),
    (9,'Alejandro Valverde','Española',43,61.0,5,1,4),(10,'Bauke Mollema','Neerlandesa',37,71.0,1,1,5),
    (11,'Tom Pidcock','Británica',24,58.0,2,1,1),(12,'Primoz Roglic','Eslovena',34,65.0,1,1,3),
    (13,'Mikel Landa','Española',35,61.0,1,1,4),(14,'Carlos Rodriguez','Española',23,62.0,2,1,1),
    (15,'Mattias Skjelmose','Danesa',23,67.0,2,1,5),(16,'Remco Evenepoel','Belga',24,61.0,2,1,6),
    (17,'Wout van Aert','Belga',29,78.0,1,1,3),(18,'Mathieu van der Poel','Neerlandesa',29,75.0,1,1,7),
    (19,'Julian Alaphilippe','Francesa',32,62.0,1,1,6),(20,'Simon Yates','Británica',31,58.0,1,1,9),
    (21,'Geraint Thomas','Británica',38,71.0,1,1,1),(22,'Thibaut Pinot','Francesa',34,63.0,1,1,8),
    (23,'Rigoberto Uran','Colombiana',37,64.0,1,1,9),(24,'Ivan Sosa','Colombiana',26,56.0,2,1,1),
    (25,'Joao Almeida','Portuguesa',25,63.0,2,1,2),(26,'Felix Gall','Austriaca',26,65.0,2,1,10),
    (27,'Adam Yates','Británica',31,61.0,1,1,2),(28,'Marc Soler','Española',30,65.0,1,1,2),
    (29,'David Gaudu','Francesa',27,53.0,1,1,8),(30,'Ben O Connor','Australiana',28,64.0,1,1,10);

WITH RECURSIVE gen(n) AS (SELECT 31 UNION ALL SELECT n+1 FROM gen WHERE n < 80)
INSERT INTO corredores (id, nombre, nacionalidad, edad, peso_kg, categoria_id, activo, equipo_id)
SELECT n,'Corredor '||n,
    CASE (n%6) WHEN 0 THEN 'Española' WHEN 1 THEN 'Colombiana' WHEN 2 THEN 'Italiana'
               WHEN 3 THEN 'Francesa' WHEN 4 THEN 'Belga' ELSE 'Australiana' END,
    18+(n%20), 55.0+(n%25), 1+(n%4), 1, 1+(n%10) FROM gen;

INSERT INTO carreras (id, nombre, pais, distancia_km, tipo, año) VALUES
    (1,'Tour de Francia','Francia',3404.0,'Montaña',2023),
    (2,'Giro de Italia','Italia',3448.0,'Montaña',2023),
    (3,'Vuelta a España','España',3181.0,'Montaña',2023),
    (4,'París-Roubaix','Francia',259.0,'Clásica',2023),
    (5,'Tour de Flandes','Bélgica',273.0,'Clásica',2023);

WITH RECURSIVE gen(n) AS (SELECT 1 UNION ALL SELECT n+1 FROM gen WHERE n < 100)
INSERT INTO resultados (id, corredor_id, carrera_id, posicion, tiempo_total_seg, puntos)
SELECT n, ((n*3-1)%60)+1, ((n*7-1)%5)+1, 1+(n%15), 28800+n*180,
    CASE WHEN (n%15)+1=1 THEN 100 WHEN (n%15)+1<=3 THEN 70
         WHEN (n%15)+1<=6 THEN 40 ELSE 10 END FROM gen;

-- ============================================
-- CONSULTA 1: CTE simple + CASE WHEN
-- Clasificar corredores por volumen de resultados acumulados
-- ============================================

WITH actividad_corredor AS (
    SELECT
        c.id,
        c.nombre,
        c.edad,
        cat.nombre          AS categoria,
        COUNT(r.id)         AS total_carreras,
        COALESCE(SUM(r.puntos), 0) AS puntos_acumulados
    FROM corredores c
    INNER JOIN categorias cat ON c.categoria_id = cat.id
    LEFT  JOIN resultados r   ON r.corredor_id  = c.id
    GROUP BY c.id, c.nombre, c.edad, cat.nombre
)
SELECT
    nombre,
    categoria,
    edad,
    total_carreras,
    puntos_acumulados,
    CASE
        WHEN puntos_acumulados >= 200 THEN 'Estrella'
        WHEN puntos_acumulados >= 80  THEN 'Regular'
        WHEN puntos_acumulados > 0    THEN 'Principiante'
        ELSE                               'Sin actividad'
    END AS nivel_actividad
FROM actividad_corredor
ORDER BY puntos_acumulados DESC
LIMIT 20;

-- ============================================
-- CONSULTA 2: Dos CTEs encadenados
-- CTE 1: puntos por equipo | CTE 2: equipos sobre el promedio
-- ============================================

WITH puntos_por_equipo AS (
    SELECT
        e.id            AS equipo_id,
        e.nombre        AS equipo,
        e.pais,
        SUM(r.puntos)   AS total_puntos
    FROM equipos e
    INNER JOIN corredores c ON c.equipo_id   = e.id
    INNER JOIN resultados r ON r.corredor_id = c.id
    GROUP BY e.id, e.nombre, e.pais
),
equipos_top AS (
    SELECT equipo_id
    FROM   puntos_por_equipo
    WHERE  total_puntos > (SELECT AVG(total_puntos) FROM puntos_por_equipo)
)
SELECT
    pp.equipo,
    pp.pais,
    pp.total_puntos
FROM puntos_por_equipo pp
WHERE pp.equipo_id IN (SELECT equipo_id FROM equipos_top)
ORDER BY pp.total_puntos DESC;

-- ============================================
-- CONSULTA 3: CTE con CASE WHEN y agregación condicional
-- Contar corredores por categoría de edad dentro de cada equipo
-- ============================================

WITH perfil_corredor AS (
    SELECT
        c.equipo_id,
        e.nombre AS equipo,
        CASE
            WHEN c.edad < 23 THEN 'Joven'
            WHEN c.edad < 30 THEN 'Maduro'
            WHEN c.edad < 38 THEN 'Veterano'
            ELSE                  'Master'
        END AS franja_edad
    FROM corredores c
    INNER JOIN equipos e ON c.equipo_id = e.id
    WHERE c.activo = 1
)
SELECT
    equipo,
    COUNT(CASE WHEN franja_edad = 'Joven'    THEN 1 END) AS jovenes,
    COUNT(CASE WHEN franja_edad = 'Maduro'   THEN 1 END) AS maduros,
    COUNT(CASE WHEN franja_edad = 'Veterano' THEN 1 END) AS veteranos,
    COUNT(CASE WHEN franja_edad = 'Master'   THEN 1 END) AS masters
FROM perfil_corredor
GROUP BY equipo
ORDER BY equipo;
