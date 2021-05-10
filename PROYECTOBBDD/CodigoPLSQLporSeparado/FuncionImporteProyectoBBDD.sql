SET SERVEROUTPUT ON

--------------------------FUNCION 2-----------------------------

/*Esta funci�n recibe como parametro una fecha y verifica, que sea v�lida y ademas calcula el importe total de las ventas realizadas en dicha fecha*/

--Creamos la funci�n con su nombre correspondiente y su par�metro e indicamos que la funcion devuelve un n�mero
CREATE OR REPLACE FUNCTION F_Importe(FECHA_AUX VENTA.FECHA%TYPE) 
RETURN NUMBER IS
--Declaramos el importe
V_IMPORTE NUMBER;
BEGIN 
    --Establecemos una condicion para ver que la fecha sea igual o inferior a la actual
    IF FECHA_AUX > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-205507,'Oracle todav�a no ha desarrollado una funci�n para ver el futuro'); 
    END IF;
    
    --Seleccionamos el sumatorio del importe y lo introducimos en V_IMPORTE
    SELECT NVL((SUM(V.IMPORTE)),0) AS "IMPORTE TOTAL" INTO V_IMPORTE 
    FROM VENTA V 
    WHERE V.FECHA=FECHA_AUX;
    
    --Devolvemos el importe
    RETURN V_IMPORTE;
--Finalizamos la funci�n
END F_Importe;
/

-------------------------FIN FUNCION 2--------------------------