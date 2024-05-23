-- EXERCICI 1
CREATE OR REPLACE TYPE col_idiomes AS VARRAY(5) OF VARCHAR2(30);

CREATE OR REPLACE TYPE tab_mails AS TABLE OF VARCHAR2(30);

CREATE OR REPLACE TYPE o_telefons AS OBJECT(
    id_telefons    NUMBER,
    nom      VARCHAR2(100)
);

-- EXERCICI 2
CREATE TABLE candidat 
(
    id_candidat     NUMBER,
    nom     VARCHAR2(100),
    idiomes col_idiomes,
    mails   tab_mails,
    telefon   o_telefons,
    
    CONSTRAINT pk_candidat PRIMARY KEY(id_candidat)
)
NESTED TABLE mails STORE AS nt_mails;

DROP TABLE candidat CASCADE CONSTRAINTS PURGE;

-- EXERCICI 3
INSERT INTO candidat VALUES
    (
    1,'Nico', 
    col_idiomes('Angles', 'Catala'), 
    tab_mails('nicolau.humet@gmailcom', 'adora.saez@gmail.com'), 
    o_telefons(123456789, 'Sergi')
);

INSERT INTO candidat VALUES
    (
    1,'Nico', 
    col_idiomes('Angles', 'Catala'), 
    tab_mails('nicolau.humet@gmailcom', 'adora.saez@gmail.com'), 
    o_telefons(123456789, 'Sergi')
);

INSERT INTO candidat VALUES
    (
    1,'Nico', 
    col_idiomes('Angles', 'Catala'), 
    NULL,
    NULL
);



-- EXERCICI 4
CREATE OR REPLACE TYPE o_persona AS OBJECT(
    id_persona    NUMBER,
    nom      VARCHAR2(100),
    cognom   VARCHAR2(200),
    fecha_nacimiento    DATE,
    DNI       VARCHAR2(100),
    MEMBER FUNCTION edat RETURN NUMBER,
    MEMBER FUNCTION num_mascotes RETURN NUMBER
);

CREATE OR REPLACE TYPE o_mascota AS OBJECT(
    id_mascota    NUMBER,
    nom      VARCHAR2(100),
    especie   VARCHAR2(200),
    pes       NUMBER,
    ref_persona    REF o_persona
);

-- EXERCICI 5
CREATE TABLE mascota OF o_mascota(
    PRIMARY KEY (id_mascota),
    SCOPE FOR (ref_persona) IS persona
);

CREATE TABLE persona OF o_persona(
    PRIMARY KEY (id_persona)
);

-- EXERCICI 6
INSERT INTO persona VALUES(
    1, 'Raul', 'Dearriba', '12/03/1996', '523423562');

INSERT INTO persona VALUES(
    2, 'Alex', 'Marin', '15/05/1987', '173924563');
COMMIT;

INSERT INTO mascota
    SELECT 1,'Roc','Gos',20,
    (SELECT REF(p) FROM persona p WHERE id_persona = 1)
    FROM dual;

INSERT INTO mascota
    SELECT 2,'Firulais','Gat',12, REF(p)
    FROM persona p
    WHERE p.id_persona = 2;

INSERT INTO mascota
    SELECT 3,'Blau','Ocell',5, REF(p)
    FROM persona p
    WHERE p.id_persona = 1;
COMMIT;

-- EXERCICI 7
ALTER TYPE o_persona
    ADD MEMBER FUNCTION edat RETURN NUMBER CASCADE;
    
ALTER TYPE o_persona
    ADD MEMBER FUNCTION num_mascotes RETURN NUMBER CASCADE;

ALTER TYPE o_persona
    ADD MEMBER FUNCTION full_name RETURN VARCHAR2 CASCADE;
    
CREATE OR REPLACE TYPE BODY o_persona AS
    MEMBER FUNCTION edat RETURN NUMBER
    IS
        v_age NUMBER;
    BEGIN
        v_age := ROUND((SYDATE - SELF.fecha_nacimiento)/365);
        RETURN v_age;
    END edat;
    
    MEMBER FUNCTION full_name RETURN VARCHAR2
    IS
    
    BEGIN
        RETURN SELF.nom || ' ' || SELF.cognom;
    END full_name;
    
    MEMBER FUNCTION num_mascotes RETURN NUMBER
    IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT (*) INTO v_count
        FROM mascota m
        WHERE m.ref_persona.id_persona = SELF.id_persona;
        
        RETURN v_count;
    END num_mascotes;
END;