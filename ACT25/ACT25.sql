/*Crea una col·lecció de 5 elements anomenada “col_llibres” de tipus varchar2.*/
CREATE OR REPLACE TYPE col_llibres AS VARRAY(5) OF VARCHAR2(30);
/
/*Crea una taula anomenada alumnes amb els camps: id_alumne, nom, cognom, 
curs i llibres. Defineix el camp llibre amb el tipus de la col·lecció anterior.*/
CREATE TABLE alumnes
(
    id_alumne   number,
    nom         varchar2(30),
    cognom      varchar2(30),
    curs        varchar2(30),
    llibres     col_llibres
);
/
/*Insereix 4 registres: 1 alumne amb 1 llibre, 1 alumne amb 2 llibres, 1 alumne 
amb 5 llibres, 1 alumne amb 6 llibres.*/
INSERT INTO alumnes VALUES(1,'Daniel','Olivares','3ESO',col_llibres('libro1'));
INSERT INTO alumnes VALUES(2,'Iker','Salinas','2ESO',col_llibres('libro1','libro2'));
INSERT INTO alumnes VALUES(3,'Aaron','Garcia','1ESO',col_llibres('libro1','libro2','libro3','libre4','libro5'));
--Sobrepasa el limit de la col·leccio que son 5 elements.
INSERT INTO alumnes VALUES(4,'Teo','Campos','4ESO',col_llibres('libro1','libro2','libro3','libro4','libro5','libro6'));
/
/*Mostra les dades de la taula alumnes.*/
SELECT * FROM alumnes;
/
/*Crea un tipus de dada tipus taula niuada anomenada “tab_llibres” de tipus 
varchar2.*/
CREATE OR REPLACE TYPE tab_llibres AS TABLE OF VARCHAR2(30);
/
/*Modifica la taula “alumnes” perquè el camp llibres sigui de tipus “tab_llibres”.*/
ALTER TABLE alumnes MODIFY llibres tab_llibres;
-- No podemos directamente porque ya hay datos y no son compatibles los tipos
--Hay dos opciones:
--Actualizar la tabla quitando col_llibres por tab_llibres manteniendo los inserts
ALTER TABLE alumne ADD col_llibres tab_llibres NESTED TABLE col_llibres STORE AS t_llibres_alumnes;

UPDATE alumnes SET col_llibres = tab_llibres('llibre1') WHERE id_alumne = 1;
--faltan mas inserts
INSERT INTO alumnes VALUES(4,'Teo','Campos','4ESO',null, tab_llibres('libro1','libro2','libro3','libro4','libro5','libro6'));
--Borrar la tabla y hacer los inserts de nuevo con tab_llibres o...

DROP TABLE alumnes CASCADE CONSTRAINTS PURGE;
/
CREATE TABLE alumnes
(
    id_alumne   number,
    nom         varchar2(30),
    cognom      varchar2(30),
    curs        varchar2(30),
    llibres     tab_llibres
)
NESTED TABLE llibres STORE AS t_llibres_alumnes;
/
/*Insereix ara el registre de l’alumne amb 6 llibres.*/
INSERT INTO alumnes VALUES(4,'Teo','Campos','4ESO', tab_llibres('libro1','libro2','libro3','libro4','libro5','libro6'));
/
/*Mostra el contingut de la taula alumnes.*/
SELECT * FROM alumnes;
/
/*Crea una col·lecció de tipus personalitzat, que contingui parelles de camps 
(correu, nom contacte).*/
CREATE OR REPLACE TYPE o_contacto AS OBJECT(
    correu  varchar2(30),
    nom     varchar2(30)
);
/
CREATE OR REPLACE TYPE col_correu AS VARRAY(6) OF o_contacto;
/
/*Modifica la taula alumnes per afegir el camp correu electrònic amb el tipus de la 
col·lecció anterior.*/
ALTER TABLE alumnes ADD correu col_correu;
/
DESC alumnes;
/*Actualitza les dades dels alumnes anteriors amb el seu correu personal, el del 
pare y el de la mare.*/
UPDATE alumnes SET correu = col_correu(o_contacto('alu@gmail.com','personal'),
                                        o_contacto('mama@gmail.com','mama'),
                                        o_contacto('papa@gmail.com','papa'))
WHERE id_alumne = 1;
/

UPDATE alumnes SET correu = col_correu(o_contacto('alu2@gmail.com','personal'),
                                        o_contacto('mama2@gmail.com','mama'),
                                        o_contacto('papa2@gmail.com','papa'))
WHERE id_alumne = 2;
/
COMMIT;
/*Mostra el contingut de la taula alumnes.*/
/
SELECT * FROM alumnes;
/*Mostra els objectes creats durant aquesta activitat.*/
/
SELECT * 
FROM user_objects
WHERE TO_CHAR(CREATED,'MM/YYYY') = '05/2024';