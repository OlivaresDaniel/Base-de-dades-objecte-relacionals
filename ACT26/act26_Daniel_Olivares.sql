SET SERVEROUTPUT ON;

DROP TABLE profe CASCADE CONSTRAINTS PURGE;
DROP TABLE materia CASCADE CONSTRAINTS PURGE;

DROP TYPE o_materia;
DROP TYPE o_profe;
/

/*Creación objetos*/
CREATE OR REPLACE TYPE o_profe AS OBJECT(
    id_profe    NUMBER,
    nombre      VARCHAR2(100),
    apellidos   VARCHAR2(200),
    fecha_nacimiento    DATE,
    email       VARCHAR2(100),
    telefono    VARCHAR2(12)
);
/
CREATE OR REPLACE TYPE o_materia AS OBJECT(
    id_materia  NUMBER,
    nombre      VARCHAR2(100),
    nombre_corto    VARCHAR2(20),
    horas       NUMBER,
    ciclo       VARCHAR2(55),
    ref_profesor    REF o_profe
);
/

/*Creación tablas con objetos*/
CREATE TABLE profe OF o_profe(
    PRIMARY KEY (id_profe)
);
/
CREATE TABLE materia OF o_materia(
    PRIMARY KEY (id_materia),
    SCOPE FOR (ref_profesor) IS profe
);

/

/*INsertar profes (sin problemas pq no tienen referéncias)*/
INSERT INTO profe VALUES(
    1, 'Alex', 'Marin', '25/04/1982', 
    'alex.marin@jviladoms.cat', '345124512');

INSERT INTO profe VALUES(
    2, 'Sergi', 'Andres', '28/01/1979', 
    'sergi.andres@jviladoms.cat', '3422307856');

INSERT INTO profe VALUES(
    3, 'Raul', 'Dearriba', '12/03/1996', 
    'Raul.dearriba@jviladoms.cat', '523423562');

COMMIT;

/*Ejemplo de insertar con una select*/
INSERT INTO profe 
    SELECT 4, 'Lidia', 'Porcel',null,'lidia.porcel@jviladoms.cat',null 
    FROM dual;

/*Ejemplo de como extraer las referencias de los objetos (profe)*/
SELECT p.id_profe, p.nombre, REF(p)
FROM profe p;

/*ejemplo de como extraer la referéncia de 1 profe*/
SELECT REF(p) FROM profe p
WHERE p.id_profe = 1;

/*Ejemplo de insert cl?sico (no podemos insertar la REF del profe...*/
INSERT INTO materia
VALUES (1,'Disseny Web', 'M9', 99, 'DAW',null);
/
/*Ejemplo de como usar una select para extraer una REF y 
usarla para insertar la materia*/
INSERT INTO materia
    SELECT 1,'Disseny Web','M9',99,'DAW', REF(p)
    FROM profe p
    WHERE id_profe = 1;

INSERT INTO materia
    SELECT 2,'PHP', 'M7', 156, 'DAW', REF(pr)
     FROM profe pr
     WHERE pr.id_profe = 2;
     
INSERT INTO materia
    SELECT 3,'BBDD O-R', 'M2', 33, 'DAW', REF(pr)
     FROM profe pr
     WHERE pr.id_profe = 1;

COMMIT;

/*Ejemplos de selección*/
SELECT * 
 FROM materia;

SELECT ma.id_materia, 
        ma.nombre, 
        ma.ref_profesor.nombre,
        ma.ref_profesor.fecha_nacimiento
FROM materia ma;

/*Ejemplo de como seleccionar datos de varias tablas.*/
SELECT m.nombre,
    m.horas,
    m.ciclo,
    m.ref_profesor.nombre,
    m.ref_profesor.apellidos,
    m.ref_profesor.fecha_nacimiento   
FROM materia m;

INSERT INTO materia
    SELECT 1,'Disseny Web', 'M9', 99, 'DAW', REF(pr)
     FROM profe pr
     WHERE pr.id_profe = 1;

--------------------------------
/* EX1 */
/* Creación del tipo o_aula */
CREATE OR REPLACE TYPE o_aula AS OBJECT(
    id_aula     NUMBER,
    nom         VARCHAR2(100),
    capacitat   NUMBER
);
/

/* Creaci?n de la tabla aula */
CREATE TABLE aula OF o_aula(
    PRIMARY KEY (id_aula)
);
/
/* Inserci?n de datos en la tabla aula */
INSERT INTO aula VALUES(
    1, 'Aula 1', 30
);

INSERT INTO aula VALUES(
    2, 'Aula 2', 25
);

COMMIT;
/

/* Selecci?n de los datos de todas las materias, junto con los datos del profesor y del aula asignados */
SELECT m.nombre,
    m.horas,
    m.ciclo,
    m.ref_profesor.nombre,
    m.ref_profesor.apellidos,
    m.ref_profesor.fecha_nacimiento,
    m.ref_aula.nom,
    m.ref_aula.capacitat
FROM materia m;
/

/* Inserción de una materia junto con una referencia al profesor y al aula */
INSERT INTO materia 
    SELECT 4,'Programaci?n Java', 'M5', 120, 'DAW', REF(p), REF(a)
FROM profe p, aula a
WHERE p.id_profe = 3 AND a.id_aula = 1;
/

/* EX2 */
DROP TABLE materia CASCADE CONSTRAINTS PURGE;
-- DROP TYPE o_materia; Hacemos CREATE OR REPLACE así que no hace falta eliminar el o_materia
/
CREATE OR REPLACE TYPE o_materia AS OBJECT(
    id_materia  NUMBER,
    nombre      VARCHAR2(100),
    nombre_corto    VARCHAR2(20),
    horas       NUMBER,
    ciclo       VARCHAR2(55),
    ref_profesor    REF o_profe,
    ref_aula        REF o_aula
);

CREATE TABLE materia OF o_materia(
    PRIMARY KEY (id_materia),
    SCOPE FOR (ref_profesor) IS profe,
    SCOPE FOR (ref_aula) IS aula
);
/

/* EX3 */
DROP TABLE materia CASCADE CONSTRAINTS PURGE;
DROP TABLE profe CASCADE CONSTRAINTS PURGE;
DROP TABLE aula CASCADE CONSTRAINTS PURGE;
DROP TYPE o_materia;
DROP TYPE o_profe;
DROP TYPE o_aula;

/*Creació tipus*/
CREATE OR REPLACE TYPE o_profe AS OBJECT(
    id_profe    NUMBER,
    nombre      VARCHAR2(100),
    apellidos   VARCHAR2(200),
    fecha_nacimiento    DATE,
    email       VARCHAR2(100),
    telefono    VARCHAR2(12)
);
/
CREATE OR REPLACE TYPE o_materia AS OBJECT(
    id_materia  NUMBER,
    nombre      VARCHAR2(100),
    nombre_corto    VARCHAR2(20),
    horas       NUMBER,
    ciclo       VARCHAR2(55),
    ref_profesor    REF o_profe,
    ref_aula        REF o_aula
);
/
CREATE OR REPLACE TYPE o_aula AS OBJECT(
    id_aula     NUMBER,
    nom         VARCHAR2(100),
    capacitat   NUMBER
);
/

/*Creació taules*/
CREATE TABLE profe OF o_profe(
    PRIMARY KEY (id_profe)
);
/
CREATE TABLE materia OF o_materia(
    PRIMARY KEY (id_materia),
    SCOPE FOR (ref_profesor) IS profe,
    SCOPE FOR (ref_aula) IS aula
);
/
CREATE TABLE aula OF o_aula(
    PRIMARY KEY (id_aula)
);
/

/*Inserció de dades*/
INSERT INTO profe VALUES(1, 'Alex', 'Marin', '25/04/1982', 'alex.marin@jviladoms.cat', '345124512');
INSERT INTO profe VALUES(2, 'Sergi', 'Andres', '28/01/1979', 'sergi.andres@jviladoms.cat', '3422307856');
INSERT INTO profe VALUES(3, 'Raul', 'Dearriba', '12/03/1996', 'Raul.dearriba@jviladoms.cat', '523423562');

INSERT INTO aula VALUES(1, 'Aula 1', 30);
INSERT INTO aula VALUES(2, 'Aula 2', 25);

INSERT INTO materia VALUES(1,'Disseny Web', 'M9', 99, 'DAW', REF((SELECT p FROM profe p WHERE p.id_profe = 1)), REF((SELECT a FROM aula a WHERE a.id_aula = 1)));
INSERT INTO materia VALUES(2,'Programaci? Java', 'M7', 156, 'DAW', REF((SELECT p FROM profe p WHERE p.id_profe = 2)), REF((SELECT a FROM aula a WHERE a.id_aula = 2)));
INSERT INTO materia VALUES(3,'BBDD O-R', 'M2', 33, 'DAW', REF((SELECT p FROM profe p WHERE p.id_profe = 1)), REF((SELECT a FROM aula a WHERE a.id_aula = 1)));
INSERT INTO materia VALUES(4,'Disseny gr?fic', 'M10', 132, 'DAW', REF((SELECT p FROM profe p WHERE p.id_profe = 3)), REF((SELECT a FROM aula a WHERE a.id_aula = 2)));

-- INSERT DE ALEX
INSERT INTO materia 
    SELECT 1, 'Disseny Web', 'M9', 99, 'DAW',
            (SELECT REF(P) FROM profe p WHERE id_profe = 1),
            (SELECT REF(a) FROM aula a WHERE id_aula = 1)
    FROM dual;
INSERT INTO materia 
    SELECT 2, 'PHP', 'M7', 156, 'DAW', REF(p), REF(a)
        FROM profe p, aula a
        WHERE p.id_profe = 2
        AND a.id_aula = 1;

COMMIT;

/* EX4 */
SELECT m.nombre, m.nombre_corto, m.horas, p.nombre, p.apellidos, a.nom, a.capacitat
FROM materia m
INNER JOIN profe p ON m.ref_profesor = REF(p)
INNER JOIN aula a ON m.ref_aula = REF(a);

-- ALEX

/

/* EX5 */
CREATE OR REPLACE TYPE BODY o_profe AS 
  MEMBER FUNCTION hello_world RETURN VARCHAR2 IS 
  BEGIN 
    RETURN 'Hello World'; 
  END hello_world; 
END;
/
DECLARE 
  p o_profe := o_profe(1, 'John', 'Doe', SYSDATE, 'john.doe@example.com', '123456789');
  message VARCHAR2(100);
BEGIN 
  message := p.hello_world(); 
  DBMS_OUTPUT.PUT_LINE(message); -- Mostra "Hello World" a la sortida
END;
/

--ALEX
ALTER TYPE o_profe 
    ADD MEMBER FUNCTION say_hi RETURN VARCHAR2 CASCADE;
ALTER TYPE o_profe
    ADD MEMBER FUNCTION say_cust_hi RETURN VARCHAR2 CASCADE;
ALTER TYPE o_profe  
    ADD MEMBER FUNCTION years_old RETURN NUMBER CASCADE;
/

-- Si en el examen nos pide crear una tabla con funciones miembro si se puede. Pero si ya está creada la tabla, usamos alter
/*CREATE OR REPLACE TYPE o_profe AS OBJECT(
    id_profe    NUMBER,
    nombre      VARCHAR2(100),
    apellidos   VARCHAR2(100),
    fecha_nacimiento    DATE,
    email   VARCHAR2(100),
    telefono    VARCHAR2(12),
    MEMBER FUNCTION say_hi RETURN VARCHAR2,
    MEMBER FUNCTION say_cust_hi RETRUN VARCHAR2,
    MEMBER FUNCTION years_old RETURN NUMBER
);*/

/*
CREATE OR REPLACE TYPE BODY o_profe AS
    MEMBER FUNCTION say_hi RETURN VARCHAR2
    IS        
    BEGIN
        RETURN 'Hola';
    END say_hi;
    -- EX6
    MEMBER FUNCTION say_cust_hi RETURN VARCHAR2
    IS
    BEGIN
        RETURN 'Hola ' || self.nombre;
    END say_cust_hi;
    -- EX7
    MEMBER FUNCTION years_old RETURN NUMBER
    IS
        v_age NUMBER;
    BEGIN
        v_age := ROUND((SYSDATE-self.fecha_nacimiento)/365)
    END years_old;
END;
/

SELECT pr.nombre, pr.apellidos, pr.say_hi()
FROM profe pr;
*/

/* EX6 */
CREATE OR REPLACE TYPE BODY o_profesor AS
  MEMBER FUNCTION hello_message RETURN VARCHAR2 IS
  BEGIN
    RETURN 'Hello ' || self.nombre;
  END;
END;
/
SELECT p.nombre, p.hello_message()
FROM profe p;
/

/* EX7 */
CREATE OR REPLACE TYPE BODY o_profesor AS
  MEMBER FUNCTION get_edad RETURN NUMBER IS
    edad NUMBER;
  BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, fecha_nacimiento) / 12)
    INTO edad
    FROM profe
    WHERE id_profe = self.id_profe;
    RETURN edad;
  END get_edad;
END;
/
DECLARE
  p o_profesor;
BEGIN
  p := o_profesor(1, 'John', 'Doe', TO_DATE('1970-01-01', 'YYYY-MM-DD'));
  DBMS_OUTPUT.PUT_LINE('Edad del profesor ' || p.nombre || ': ' || p.get_edad);
END;
/