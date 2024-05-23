/*Eliminamos tablas*/
DROP TABLE profe CASCADE CONSTRAINTS PURGE;
DROP TABLE materia CASCADE CONSTRAINTS PURGE;

/*Script para borrar tipos*/
DROP TYPE o_materia;
DROP TYPE o_profesor;
/
/*CREAMOS OBJETO PROFESOR*/
CREATE OR REPLACE TYPE o_profesor AS OBJECT(
    id_profesor NUMBER,
    nombre      VARCHAR2(100),
    apellido    VARCHAR2(200),
    fecha_nacimiento    DATE,
    mail        VARCHAR2(100),
--Aqui se pueden definir las cabeceras de las funciones miembro

);
/
CREATE OR REPLACE TYPE o_materia AS OBJECT(
    id_materia  NUMBER,
    codigo      VARCHAR2(50),
    nombre      VARCHAR2(100),
    horas       NUMBER,
    ref_profesor    REF o_profesor 
    /*Definimos una referencia a un objeto (profesor)*/
);



/
/*CREAMOS TABLAS A PARTIR DE OBJETOS*/
CREATE TABLE profe OF o_profesor(
    PRIMARY KEY (id_profesor)
);

CREATE TABLE materia OF o_materia(
    PRIMARY KEY (id_materia),
    SCOPE FOR (ref_profesor) IS profe
    /*ref_profesor es el atributo de o_profesor, profe es la tabla*/
);


drop type o_aula;



//Exercici 1
CREATE OR REPLACE TYPE o_aula AS OBJECT(
      id_aula NUMBER,
      nom   VARCHAR2(100),
      capacitat   NUMBER
);
/
//Exercici2
CREATE OR REPLACE TYPE o_materia AS OBJECT(
    id_materia  NUMBER,
    codigo      VARCHAR2(50),
    nombre      VARCHAR2(100),
    horas       NUMBER,
    ref_profesor    REF o_profesor,
    ref_aula      REF o_aula
);
//Sino

delete from materia;

ALTER TYPE o_materia 
      ADD ATTRIBUTE ref_profesor CASCADE;

alter table materia ADD SCOPE FOR (ref_aula) IS aula;

      
//Exercici 3
/
CREATE TABLE aula OF o_aula(
      PRIMARY KEY (id_aula)
);

CREATE TABLE profe OF o_profesor(
    PRIMARY KEY (id_profesor)
);

CREATE TABLE materia OF o_materia(
    PRIMARY KEY (id_materia),
    SCOPE FOR (ref_profesor) IS profe,
    SCOPE FOR (ref_aula) IS aula
    /*ref_profesor es el atributo de o_profesor, profe es la tabla*/
);


INSERT INTO profe 
    VALUES(1, 'Alex','Marin',TO_DATE('25/04/1982','DD/MM/YYYY'),
            'alex.marin@gmail.com'); 
INSERT INTO profe 
    VALUES(2, 'Marcos','Venteo',TO_DATE('25/08/1981','DD/MM/YYYY'),
            'marcos.venteo@gmail.com');
INSERT INTO profe 
    VALUES(3, 'Alejandra','De Vega',TO_DATE('10/08/1985','DD/MM/YYYY'),
            'ale.vega@gmail.com');
            
INSERT INTO aula
      VALUES(1,'Aula Inforática',30);

INSERT INTO aula
      VALUES(2,'Aula Cocina',15);

            
INSERT INTO materia
      SELECT 1,'M02','Base de datos',200, REF(p), REF(a)
      FROM profe p, aula a
      where id_profesor=1 and id_aula=1;

INSERT INTO materia
      SELECT 2,'M01','Sistemas',180, REF(p), REF(a)
      FROM profe p, aula a
      where id_profesor=2 and id_aula=1;

INSERT INTO materia
      SELECT 3,'M03','Programacion',220, REF(p), REF(a)
      FROM profe p, aula a
      where id_profesor=3 and id_aula=2;
      
INSERT INTO materia
      SELECT 4,'M04','Lenguaje de Marcas',110, REF(p), REF(a)
      FROM profe p, aula a
            where id_profesor=2 and id_aula=2;
      
//Exercici 4

SELECT m.nombre, m.codigo, m.horas,m.ref_profesor.nombre,m.ref_profesor.apellido,
      m.ref_aula.nom, m.ref_aula.capacitat
            FROM materia m;
            
//Exercici 5
/
ALTER TYPE o_profesor
      ADD MEMBER FUNCTION say_hi RETURN VARCHAR2 CASCADE;
/
CREATE OR REPLACE TYPE BODY o_profesor AS 
      MEMBER FUNCTION say_hi RETURN VARCHAR2
      IS
      BEGIN
            return 'Hello World';
      END say_hi;
      END;
/
//Exercici 6
/
ALTER TYPE o_profesor
      ADD MEMBER FUNCTION hej RETURN VARCHAR2 CASCADE;
      
      
CREATE OR REPLACE TYPE BODY o_profesor AS 
      
      MEMBER FUNCTION say_hi RETURN VARCHAR2
      IS
      BEGIN
            return 'Hello World';
      END say_hi;
      
      
      MEMBER FUNCTION hej RETURN VARCHAR2
      IS
      
      BEGIN
                                          //Self sirve para referenciar una intancia del objeto (como el this en java) 
            RETURN 'Hej ' || self.nombre;
            
      END hej;
      
      END;
/
ALTER TYPE o_profesor
      ADD MEMBER FUNCTION edat RETURN NUMBER CASCADE;
/

   CREATE OR REPLACE TYPE BODY o_profesor AS 
      MEMBER FUNCTION edat RETURN NUMBER
      IS
      
      BEGIN
            RETURN TRUNC((sysdate-fecha_nacimiento)/365);//Aqui por si acaso poner el self.
      END edat;
      
      MEMBER FUNCTION say_hi RETURN VARCHAR2
      IS
      BEGIN
            return 'Hello World';
      END say_hi;
      
      
      MEMBER FUNCTION hej RETURN VARCHAR2
      IS
      
      BEGIN
            RETURN 'Hej ' || self.nombre;
            
      END hej;
      
      
      END;
/   
SELECT p.edat() FROM profe p;
