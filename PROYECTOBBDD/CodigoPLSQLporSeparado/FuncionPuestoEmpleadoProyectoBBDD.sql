SET SERVEROUTPUT ON

-----------------------------------------FUNCION 1-------------------------------------------

/*Esta funci�n recibe como par�metro un n�mero de empleado y devuelve 1 si el empleado existe y 0 si no existe*/

--Creamos la funci�n con su nombre y su par�metro respectivo y indicamos que la funcion devuelve un n�mero
CREATE OR REPLACE FUNCTION F_Puesto(NUMEMP EMPLEADO.NUMEMPLEADO%TYPE)
RETURN NUMBER IS 
    
    --Creamos un cursor expl�cito que se recorrer� en caso de que el empleado cuyo c�digo hemos recibido como par�metro exista
    CURSOR C_EMPLEADOS IS
        SELECT E.NUMEMPLEADO FROM EMPLEADO E
        WHERE E.NUMEMPLEADO=NUMEMP;
    REG_EMPLEADOS C_EMPLEADOS%ROWTYPE;
    --Iniciamos una variable contador que nos indicar� con un 0 si no existe el empleado y con un 1 en caso de que s� exista
    CONT NUMBER:=0;
BEGIN
    --Abrimos el cursor
    OPEN C_EMPLEADOS;
    LOOP
        FETCH C_EMPLEADOS INTO REG_EMPLEADOS;
        --Salimos del cursor cuando no encuentre registros
        EXIT WHEN C_EMPLEADOS%NOTFOUND; 
            --En caso de que encuentre al empleado el valor del contador se modificar� a 1
            CONT:=CONT+1;
    END LOOP;
    --Cerramos el cursor
    CLOSE C_EMPLEADOS;
    --Devolvemos el contador
    RETURN CONT;
--Finalizamos la funci�n
END;
/

------------------------FIN FUNCION 1---------------------------