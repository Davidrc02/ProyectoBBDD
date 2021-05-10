SET SERVEROUTPUT ON

-----------------------------------------FUNCION 1-------------------------------------------

/*Esta función recibe como parámetro un número de empleado y devuelve 1 si el empleado existe y 0 si no existe*/

--Creamos la función con su nombre y su parámetro respectivo y indicamos que la funcion devuelve un número
CREATE OR REPLACE FUNCTION F_Puesto(NUMEMP EMPLEADO.NUMEMPLEADO%TYPE)
RETURN NUMBER IS 
    
    --Creamos un cursor explícito que se recorrerá en caso de que el empleado cuyo código hemos recibido como parámetro exista
    CURSOR C_EMPLEADOS IS
        SELECT E.NUMEMPLEADO FROM EMPLEADO E
        WHERE E.NUMEMPLEADO=NUMEMP;
    REG_EMPLEADOS C_EMPLEADOS%ROWTYPE;
    --Iniciamos una variable contador que nos indicará con un 0 si no existe el empleado y con un 1 en caso de que sí exista
    CONT NUMBER:=0;
BEGIN
    --Abrimos el cursor
    OPEN C_EMPLEADOS;
    LOOP
        FETCH C_EMPLEADOS INTO REG_EMPLEADOS;
        --Salimos del cursor cuando no encuentre registros
        EXIT WHEN C_EMPLEADOS%NOTFOUND; 
            --En caso de que encuentre al empleado el valor del contador se modificará a 1
            CONT:=CONT+1;
    END LOOP;
    --Cerramos el cursor
    CLOSE C_EMPLEADOS;
    --Devolvemos el contador
    RETURN CONT;
--Finalizamos la función
END;
/

------------------------FIN FUNCION 1---------------------------