/*Script para borrar tipos*/
DROP TYPE o_profesor;
DROP TYPE o_materia;
/*Eliminamos tablas*/
DROP TABLE profe CASCADE CONSTRAINTS PURGE;
DROP TABLE materia CASCADE CONSTRAINTS PURGE;
/
/*CREAR OBJETO PROFESOR*/
CREATE OR REPLACE TYPE o_profesor AS OBJECT(
    id_profesor         NUMBER,
    nombre              VARCHAR2(100),
    apellido            VARCHAR2(200),
    fecha_nacimiento    DATE,
    mail                VARCHAR2(100)
);
/
CREATE OR REPLACE TYPE o_materia AS OBJECT(
    id_materia  NUMBER,
    codigo      VARCHAR2(50),
    nombre      VARCHAR2(100),
    horas       NUMBER,
    ref_profesor    REF o_profesor /*Definimos una referencia a un objeto (profesor)*/
);
/
/*CREAMOS TABLAS A PARTIR DE OBJETOS*/
CREATE TABLE profe OF o_profesor(
    PRIMARY KEY (id_profesor)
);

CREATE TABLE materia OF o_materia(
    PRIMARY KEY (id_materia),
    SCOPE FOR (ref_profesor) IS profe /*ref_profesor es el atributo de o_profesor, profe es la tabla*/
);
/
/*COMPROBACION TABLAS*/
DESC profe;
DESC materia;

/*INSERTAMOS PROFESORES*/
INSERT INTO profe VALUES(1, 'Alex','Marin',TO_DATE('25/04/1982','DD/MM/YYYY'),'alex.marin@gmail.com');
INSERT INTO profe VALUES(2, 'Marcos','Venteo',TO_DATE('25/08/1981','DD/MM/YYYY'),'marcos.venteo@gmail.com');
INSERT INTO profe VALUES(3, 'Alejandra','De Vega',TO_DATE('10/04/1985','DD/MM/YYYY'),'ale.vega@gmail.com');

/*SELECTS y REF*/
SELECT * FROM profe;
SELECT p.nombre, p.apellido, REF(p) FROM profe p;

/*INSERTS CON REFERENCIAS*/
DESC materia;

INSERT INTO materia VALUES(1,'M02','Gestió de BBDD',165,null);

UPDATE materia SET ref_profesor = (SELECT REF (p) FROM profe p
                                    WHERE id_profesor = 1)
    WHERE id_materia = 1;

/*SELECT DE TESTEO*/
SELECT * FROM materia;

SELECT m.nombre, m.codigo, m.ref_profesor.nombre, m.ref_profesor.mail FROM materia m;

--Inserts con referéncias
-- Opción 1
INSERT INTO materia
    VALUES( 2,'M03','Programacion',198,
        (SELECT REF(p) FROM profe p 
            WHERE id_profesor = 3));

-- Opción 2 ????
    -- Previa (en una select puedes mostrar 
    -- datos de la tabla, información "fija". 
SELECT p.nombre, 'Lo que me da la gana',
    3, 2+2 AS suma_de_laureano
FROM profe p
WHERE id_profesor = 2;

-- Insert
INSERT INTO materia
    SELECT 3,'M04','Leng. Marcas',99,REF(p)
     FROM profe p WHERE id_profesor = 2;


--
SELECT nombre, codigo, 
    nombre||' lo imparte '||m.ref_profesor.nombre
FROM materia m;










