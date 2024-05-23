//Exercici 1
ALTER TYPE o_aula
      ADD MEMBER FUNCTION numMateria RETURN NUMBER CASCADE;
      
/      
CREATE OR REPLACE TYPE BODY o_aula AS
 MEMBER FUNCTION numMateria RETURN NUMBER
      IS
      v_number    NUMBER;
      BEGIN
            
            Select COUNT(m.ref_aula.id_aula) into v_number
            FROM materia m
            WHERE m.ref_aula.id_aula = self.id_aula;
            
            return v_number;
            
      END numMateria;
      
END;
/

SELECT a.nom,a.numMateria()
from aula a;

//Exercici 2

/
ALTER TYPE o_profesor
      ADD MEMBER FUNCTION aula_assig RETURN NUMBER CASCADE;

/
CREATE OR REPLACE TYPE BODY o_profesor AS 
      MEMBER FUNCTION aula_assig RETURN NUMBER
      IS
      v_number NUMBER;
      v_materias NUMBER;
      BEGIN
      
            Select COUNT(m.id_materia) into v_materias
            FROM materia m
            WHERE m.ref_profesor.id_profesor = self.id_profesor;
            
      IF(v_materias=0)THEN
            RETURN -1;
      END IF;
      
            Select COUNT(m.ref_aula.id_aula) into v_number
            FROM materia m
            WHERE m.ref_profesor.id_profesor = self.id_profesor;
            
            
      
      IF(v_number<v_materias)THEN
            RETURN 0;
      END IF;
      
      RETURN 1;
      
      END aula_assig;
      
      MEMBER FUNCTION edat RETURN NUMBER
      IS
      
      BEGIN
            RETURN TRUNC((sysdate-fecha_nacimiento)/365);
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

SELECT p.nombre, p.aula_assig()
FROM profe p;

