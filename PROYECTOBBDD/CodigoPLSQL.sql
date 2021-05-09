
-----------------------------------------------TRABAJO PLSQL------------------------------------------------
-------------------------------------------David Rodr�guez Cano---------------------------------------------

/*Antes de empezar con la parte de gesti�n de codigo PLSQL del proyecto, ES NECESARIO QUE CREE LAS TABLAS Y LA INFORMACI�N QUE SE ENCUENTRAN EN EL ARCHIVO "ProyectoBBDDCreacionEInserccion.sql" QUE SE 
ENCUENTRA EN "https://github.com/Davidrc02/ProyectoBBDD" y que ejecute el comando que le aparece a continuaci�n para que la salida del b�fer de mensajes DBMS_OUTPUT se redirija a la salida est�ndar. */

SET SERVEROUTPUT ON

/*Una vez realizado ese comando podemos comenzar a compilar los distintos bloques PLSQL que 
se han desarrollado en el proyecto, para ello compilaremos primero los disparadores, tanto 
de filas como de instrucci�n, luego los listados, a continuaci�n las funciones y por �ltimo el 
bloque an�nimo que actuar� como programa principal. */

----------------------------------DISPARADOR DE FILAS-------------------------------------

/* En concreto este disparador lo que realiza es una auditoria de los productos 
que se hayan insertado, actualizado o borrado en nuestra base de datos. */

-- Creamos o reemplazamos el disparador y le ponemos un nombre, en este caso,
-- al ser una auditoria de los productos lo llamaremos "AuditoriaProducto". 
CREATE OR REPLACE TRIGGER AuditoriaProducto
    --Aqu� le indicamos al disparador cuando se va a ejecutar y sobre que tabla va a actuar.
    AFTER INSERT OR DELETE OR UPDATE ON PRODUCTO
    --El disparador se va a ejecutar para cada fila insertada, actualizada o borrada.
    FOR EACH ROW
    
    --Declaramos las variables del registro antiguo, el registro nuevo y la opci�n.
DECLARE
    --Registro antiguo.
    V_REGISTRO_OLD VARCHAR2(300);
    --Registro nuevo.
    V_REGISTRO_NEW VARCHAR2(300);
    --Opci�n.
    V_OPCION NUMBER(1);

BEGIN
    --Usamos una sentencia case para distinguir cuando insertemos, actualicemos o borremos un producto.
    CASE
    --Cuando inserte un producto:
    WHEN INSERTING THEN
        --Inicializamos la opci�n a 1 (inserci�n).
        V_OPCION:=1;
        --El registro antiguo queda como null debido a que no exist�a previamente.
        V_REGISTRO_OLD:=(NULL);
        --Establecemos los nuevos atributos que va a contener nuestro "V_REGISTRO_NEW" con el formato que deseemos.
        V_REGISTRO_NEW:=(:NEW.CODIGO_PROD||' # '||:NEW.PRECIO||' # '||:NEW.DENOMINACION_PRODUCTO||' # '||:NEW.STOCK||' # '||:NEW.NOMBRE_DEPARTAMENTO||' # '||:NEW.DENOMINACION_SECCION||' # '||:NEW.N_CCOMERCIAL);
            
    --Cuando actualicemos un producto: 
    WHEN UPDATING THEN
        --Inicializamos la opci�n a 2 (actualizaci�n).
        V_OPCION:=2;
        --Introducimos los atributos antiguos en el registro "V_REGISTRO_OLD" y los nuevos atributos en el registro "V_REGISTRO_NEW".
        V_REGISTRO_OLD:=(:OLD.CODIGO_PROD||' # '||:OLD.PRECIO||' # '||:OLD.DENOMINACION_PRODUCTO||' # '||:OLD.STOCK||' # '||:OLD.NOMBRE_DEPARTAMENTO||' # '||:OLD.DENOMINACION_SECCION||' # '||:OLD.N_CCOMERCIAL);
        V_REGISTRO_NEW:=(:NEW.CODIGO_PROD||' # '||:NEW.PRECIO||' # '||:NEW.DENOMINACION_PRODUCTO||' # '||:NEW.STOCK||' # '||:NEW.NOMBRE_DEPARTAMENTO||' # '||:NEW.DENOMINACION_SECCION||' # '||:NEW.N_CCOMERCIAL);
    
    --Cuando borremos un producto:            
    WHEN DELETING THEN
        --Inicializamos la opci�n a 3 (borrado).
        V_OPCION:=3;
        --El registro nuevo queda como null debido a que hemos borrado el que ya hab�a.
        V_REGISTRO_NEW:=(NULL);
        --En el registro antiguo aparecer� el registro que se ha borrado.
        V_REGISTRO_OLD:=(:OLD.CODIGO_PROD||' # '||:OLD.PRECIO||' # '||:OLD.DENOMINACION_PRODUCTO||' # '||:OLD.STOCK||' # '||:OLD.NOMBRE_DEPARTAMENTO||' # '||:OLD.DENOMINACION_SECCION||' # '||:OLD.N_CCOMERCIAL);
        
    --Finalizamos la sentencia condicional case.
    END CASE; 
    --Insertamos el usuario, la fecha y hora, el tipo de modificaci�n realizada y los dos registros (tanto antiguo como nuevo) en la tabla AUDITORIA.
    INSERT INTO AUDITORIA VALUES (USER, TO_DATE((SELECT TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') FROM DUAL),'DD/MM/YYYY HH24:MI:SS'), V_OPCION, V_REGISTRO_OLD, V_REGISTRO_NEW);
        
--Finalizamos el disparador.
END AuditoriaProducto;
/

/* Por defecto, al compilar un disparador se establecer� como habilitado, pero si queremos
podemos habilitarlos o deshabilitarlos con estos comandos: */

--Para habilitarlo
ALTER TRIGGER AuditoriaProducto ENABLE;

--Para deshabilitarlo
ALTER TRIGGER AuditoriaProducto DISABLE;

---------------------------FIN DISPARADOR DE FILAS------------------------------



------------------INICIO CONJUNTO DE DISPARADORES DE INSTRUCCION----------------

/*El conjunto de disparadores de instrucci�n que encontramos a continuaci�n nos 
sirve para que no se pueda modificar la informaci�n de las tablas desde las 2am 
hasta las 7am, que es el horario en el que los centros comerciales de nuestra base
de datos se encuentran cerrados*/

--La estructura y funci�n para los siguientes disparadores es identica, que consiste en la siguiente:

--Creaci�n del disparador con su respectivo nombre
CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO00
    --Antes de modificar (ya sea inserci�n, actualizaci�n o borrado) la informaci�n en la tabla (en este caso producto) se ejecuta el disparador
    BEFORE INSERT OR UPDATE OR DELETE ON PRODUCTO 
    
    BEGIN
        --Establecemos la condici�n para que se ejecute un error si la hora est� comprendida entre las 2 y las 7 de la ma�ana
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            --Lanzamos el error una vez cumplida la condici�n
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial est� cerrado y por tanto no puede realizar ninguna transacci�n de ning�n tipo');
    END IF;
END;
/

--Hacemos lo mismo para los dem�s

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO01
    BEFORE INSERT OR UPDATE OR DELETE ON VENTA 
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial est� cerrado y por tanto no puede realizar ninguna transacci�n de ning�n tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO02
    BEFORE INSERT OR UPDATE OR DELETE ON REALIZA 
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial est� cerrado y por tanto no puede realizar ninguna transacci�n de ning�n tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO03
    BEFORE INSERT OR UPDATE OR DELETE ON AUDITORIA 
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial est� cerrado y por tanto no puede realizar ninguna transacci�n de ning�n tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO04
    BEFORE INSERT OR UPDATE OR DELETE ON CLIENTE
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial est� cerrado y por tanto no puede realizar ninguna transacci�n de ning�n tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO05
    BEFORE INSERT OR UPDATE OR DELETE ON EMPLEADO
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial est� cerrado y por tanto no puede realizar ninguna transacci�n de ning�n tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO06
    BEFORE INSERT OR UPDATE OR DELETE ON CENTRO_COMERCIAL
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial est� cerrado y por tanto no puede realizar ninguna transacci�n de ning�n tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO07
    BEFORE INSERT OR UPDATE OR DELETE ON DEPARTAMENTO
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial est� cerrado y por tanto no puede realizar ninguna transacci�n de ning�n tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO08
    BEFORE INSERT OR UPDATE OR DELETE ON ENTIDAD_BANCARIA
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial est� cerrado y por tanto no puede realizar ninguna transacci�n de ning�n tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO09
    BEFORE INSERT OR UPDATE OR DELETE ON INCLUYE
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial est� cerrado y por tanto no puede realizar ninguna transacci�n de ning�n tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO10
    BEFORE INSERT OR UPDATE OR DELETE ON PROVEEDOR
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial est� cerrado y por tanto no puede realizar ninguna transacci�n de ning�n tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO11
    BEFORE INSERT ON SECCION
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial est� cerrado y por tanto no puede realizar ninguna transacci�n de ning�n tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO12
    BEFORE INSERT OR UPDATE OR DELETE ON SUMINISTRA
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial est� cerrado y por tanto no puede realizar ninguna transacci�n de ning�n tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO13
    BEFORE INSERT OR UPDATE OR DELETE ON TIENE_DESCUENTO
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial est� cerrado y por tanto no puede realizar ninguna transacci�n de ning�n tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO14
    BEFORE INSERT OR UPDATE OR DELETE ON TIPO_CONTRATO
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial est� cerrado y por tanto no puede realizar ninguna transacci�n de ning�n tipo');
    END IF;
END;
/

/*Para habilitarlos: */
ALTER TRIGGER CENTROCOMERCIALCERRADO00 ENABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO01 ENABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO02 ENABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO03 ENABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO04 ENABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO05 ENABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO06 ENABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO07 ENABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO08 ENABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO09 ENABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO10 ENABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO11 ENABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO12 ENABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO13 ENABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO14 ENABLE;

/*Para deshabilitarlos*/
ALTER TRIGGER CENTROCOMERCIALCERRADO00 DISABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO01 DISABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO02 DISABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO03 DISABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO04 DISABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO05 DISABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO06 DISABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO07 DISABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO08 DISABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO09 DISABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO10 DISABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO11 DISABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO12 DISABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO13 DISABLE;
ALTER TRIGGER CENTROCOMERCIALCERRADO14 DISABLE;

------------------FIN CONJUNTO DE DISPARADORES DE INSTRUCCI�N------------------

------------------------------INICIO LISTADO 1--------------------------------
-----------------------------LISTADO DE COMPRAS---------------------------------

/*Este listado presenta las compras de un cliente del cual se recibir� su DNI como par�metro.
ATENCI�N: EL PROCEDIMIENTO SOLO MOSTRAR� AQUELLOS CLIENTES QUE TENGAN COMPRAS CON PRODUCTOS ASOCIADOS*/


--Creamos o reemplazamos el procedimiento llamado ClientesConCompras y le introducimos como par�metro el DNI de un cliente
CREATE OR REPLACE PROCEDURE ClientesConCompras(DNI_CLI CLIENTE.DNI%TYPE) IS
    
    --Declaramos las variables que usaremos para gestionar el nombre y el numero de compras realizadas del cliente
    V_NOMBRECLIENTE CLIENTE.NOMBRE%TYPE;
    V_NUMCOMPRAS NUMBER;

    --Creamos el cursor que seleccionar� aquellas ventas realizadas al cliente del que se dispone su DNI
    CURSOR C_VENTAS IS
        SELECT V.NUMOPERACION, NVL((COUNT(I.CODIGO_PROD)),0) AS "RECUENTO"
            FROM INCLUYE I, VENTA V, REALIZA R
            WHERE R.DNI_CLIENTE= DNI_CLI
            AND R.NUMOPERACION=V.NUMOPERACION
            AND V.NUMOPERACION=I.NUMOPERACION
            GROUP BY V.NUMOPERACION;
            
    --Guardamos los atributos de las ventas en un registro llamado REG_VENTAS
    REG_VENTAS C_VENTAS%ROWTYPE;

    --Creamos el cursor que recorrer� aquellos productos incluidos en las ventas, para ello el cursor recibir� el numero de operacion de la venta
    CURSOR C_PRODUCTOS(NUMOPERACION_AUX INCLUYE.NUMOPERACION%TYPE) IS 
        SELECT DISTINCT P.DENOMINACION_PRODUCTO, NVL(I.CANTIDAD,0) AS "CANTIDAD"
            FROM PRODUCTO P, INCLUYE I
            WHERE NUMOPERACION_AUX=I.NUMOPERACION
            AND I.CODIGO_PROD=P.CODIGO_PROD;
            
    --Guardamos los atributos de los productos en un registro llamado REG_PRODUCTOS
    REG_PRODUCTOS C_PRODUCTOS%ROWTYPE;
    
    --Declaramos tambi�n un contador que nos ser� util m�s tarde para contar los productos de cada venta y as� enumerarlos
    CONT NUMBER:=0;

BEGIN
        --Creamos un cursor impl�cito que nos guarde en la variable V_NOMBRECLIENTE el nombre del cliente
        SELECT NOMBRE INTO V_NOMBRECLIENTE 
        FROM CLIENTE C WHERE C.DNI =DNI_CLI;
        
        --Creamos un cursor impl�cito que nos guardar� en la variable V_NUMCOMPRAS el numero de compras que tiene dicho cliente
        SELECT NVL((COUNT(V.NUMOPERACION)),0) INTO V_NUMCOMPRAS 
            FROM VENTA V, REALIZA R 
            WHERE V.NUMOPERACION=R.NUMOPERACION 
            AND R.DNI_CLIENTE = DNI_CLI;
        
        --Mostramos el cliente y el n�mero de ventas asociadas al cliente
        DBMS_OUTPUT.PUT_LINE('Cliente: '||V_NOMBRECLIENTE);
        DBMS_OUTPUT.PUT_LINE('N�mero de compras que ha realizado: '||V_NUMCOMPRAS);
        
            --Posteriormente abrimos los dos cursores y los recorremos, para dar variedad al c�digo y mostrar las dos posibilidades de hacerlo
            --he hecho uno con OPEN/FETCH/LOOP y el otro con un bucle FOR
            
            --Cursor de ventas mediante bucle OPEN/FETCH/LOOP
            OPEN C_VENTAS;
            LOOP
                FETCH C_VENTAS INTO REG_VENTAS;
                --Salimos del bucle cuando no encuentre ventas asociadas al cliente que tengan productos
                EXIT WHEN C_VENTAS%NOTFOUND;
                    --Mostramos el n�mero de productos de cada compra
                    DBMS_OUTPUT.PUT_LINE('N�mero de productos de la compra con numero de operaci�n "'||REG_VENTAS.NUMOPERACION||'": '||REG_VENTAS.RECUENTO);
                    DBMS_OUTPUT.PUT_LINE (' ---- ');
                    
                    --Iniciamos el contador a cero aqu� para que cada vez que iniciemos una venta empiece de nuevo la numeraci�n de los productos
                    CONT:=0;
                    
                --Cursor de productos mediante bucle FOR
                FOR REG_PRODUCTOS IN C_PRODUCTOS(REG_VENTAS.NUMOPERACION) LOOP
                    --Sumamos uno al contador y mostramos los productos y la cantidad de cada uno
                    CONT:=CONT+1;
                    DBMS_OUTPUT.PUT_LINE('Producto '||CONT||': '||REG_PRODUCTOS.DENOMINACION_PRODUCTO);
                    DBMS_OUTPUT.PUT_LINE('Cantidad: '||REG_PRODUCTOS.CANTIDAD);
                END LOOP;
            END LOOP;
    --Ponemos un bloque de excepciones por si ocurre alg�n error durante la ejecuci�n del procedimiento    
    EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
--Finalizamos el procedimiento
END ClientesConCompras;
/

---------------------------------------FIN LISTADO 1-----------------------------------------

-------------------------------------INICIO LISTADO 2----------------------------------------
--------------LISTADO DE CENTROS COMERCIALES, SECCIONES, DEPARTAMENTOS Y VENTAS--------------

/*Este listado NOS presenta los centros comerciales que tenemos en la base de datos, de cada centro comercial
se mostrar�n las secciones que posee, de cada seccion el departamento, de cada departamento las ventas que
tiene asociada y de las ventas se mostrar� su producto estrella*/

--Primero creamos o reemplazamos el procedimiento, el cual se llamar� ListadoCentros
CREATE OR REPLACE PROCEDURE ListadoCentros IS 

    --Creamos el cursor que recorrer� los centros comerciales
    CURSOR C_CCOMERCIAL IS
        SELECT DISTINCT CC.NOMBRE 
        FROM CENTRO_COMERCIAL CC 
        ORDER BY CC.NOMBRE;
        
    --Guardamos los atributos del cursor en el registro R_CENTROS
    R_CENTROS C_CCOMERCIAL%ROWTYPE;

    --A continuaci�n creamos el cursor que recorrer� de cada centro comercial, las secciones que tiene
    CURSOR C_SECCION(V_NCC VARCHAR2) IS 
        SELECT DISTINCT S.DENOMINACION_SECCION 
        FROM SECCION S
        WHERE V_NCC=S.N_CCOMERCIAL
        ORDER BY S.DENOMINACION_SECCION;
        
    --Guardamos los atributos del cursor en el registro R_SECCIONES
    R_SECCIONES C_SECCION%ROWTYPE;
    
    --Posteriormente sacamos los departamentos de cada seccion con otro cursor
    CURSOR C_DEP(V_DEN_SECC VARCHAR2, V_NCC VARCHAR2) IS
        SELECT D.NOMBRE 
        FROM DEPARTAMENTO D
        WHERE D.DENOMINACION_SECCION=V_DEN_SECC
        AND D.N_CCOMERCIAL=V_NCC;
        
    --Guardamos los atributos en R_DEPARTAMENTOS
    R_DEPARTAMENTOS C_DEP%ROWTYPE;
        
    --Creamos un cursor que recorra las ventas
    CURSOR C_VENTAS(V_NDEP VARCHAR2, V_DEN_SECC VARCHAR2, V_NCC VARCHAR2) IS
        SELECT V.NUMOPERACION, V.FECHA, V.IMPORTE
            FROM VENTA V
            WHERE V_NDEP=V.NOMBRE_DEPARTAMENTO
            AND V.DENOMINACION_SECCION=V_DEN_SECC
            AND V.N_CCOMERCIAL=V_NCC;
    
    --Guardamos las ventas
    R_VENTAS C_VENTAS%ROWTYPE;
    
    --Y por �ltimo un cursor que nos devolver� el producto estrella (producto m�s vendido) y la cantidad vendida de dicho producto
    CURSOR C_PRODUCTOS(NUM_OP CHAR) IS 
        SELECT A.PRODUCTO, A.CANTIDAD
            FROM (SELECT P.DENOMINACION_PRODUCTO AS "PRODUCTO", I.CANTIDAD AS "CANTIDAD"
                    FROM INCLUYE I, PRODUCTO P  
                    WHERE I.NUMOPERACION=NUM_OP AND P.CODIGO_PROD=I.CODIGO_PROD 
                    ORDER BY CANTIDAD DESC) A
            WHERE ROWNUM <= 1;
    
    --Guardamos el producto en R_PROD        
    R_PROD C_PRODUCTOS%ROWTYPE;

--Una vez terminada la creaci�n de los cursores, comenzamos a recorrerlos y a mostrar la informaci�n
BEGIN
    --Cursor de centros comerciales y su respectiva informaci�n
    FOR R_NCENTROS IN C_CCOMERCIAL LOOP
    
    DBMS_OUTPUT.PUT_LINE('CENTRO COMERCIAL: ' || R_NCENTROS.NOMBRE);
    DBMS_OUTPUT.PUT_LINE('');
        
        --Cursor de secciones y su respectiva informaci�n
        FOR R_SECCIONES IN C_SECCION(R_NCENTROS.NOMBRE) LOOP 
        DBMS_OUTPUT.PUT_LINE('SECCION: ' || R_SECCIONES.DENOMINACION_SECCION);
        DBMS_OUTPUT.PUT_LINE('');
            
            --Cursor de departamentos y su respectiva informaci�n
            FOR R_DEPARTAMENTOS IN C_DEP(R_SECCIONES.DENOMINACION_SECCION, R_NCENTROS.NOMBRE) LOOP
                DBMS_OUTPUT.PUT_LINE('DEPARTAMENTO: ' ||R_DEPARTAMENTOS.NOMBRE);
                DBMS_OUTPUT.PUT_LINE('');
                
                --Cursor de ventas y su respectiva informaci�n
                FOR R_VENTAS IN C_VENTAS(R_DEPARTAMENTOS.NOMBRE, R_SECCIONES.DENOMINACION_SECCION, R_NCENTROS.NOMBRE) LOOP
                    DBMS_OUTPUT.PUT_LINE('N�MERO DE VENTA: ' ||R_VENTAS.NUMOPERACION);
                    DBMS_OUTPUT.PUT_LINE('FECHA VENTA: ' ||R_VENTAS.FECHA);
                    DBMS_OUTPUT.PUT_LINE('IMPORTE VENTA: ' ||R_VENTAS.IMPORTE);
                    
                    --Cursor de productos y su respectiva informaci�n
                    FOR R_PROD IN C_PRODUCTOS(R_VENTAS.NUMOPERACION) LOOP
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('PRODUCTO ESTRELLA: ' ||R_PROD.PRODUCTO);
                        DBMS_OUTPUT.PUT_LINE('CANTIDAD VENDIDA: ' ||R_PROD.CANTIDAD);
                    --Y ahora procedemos a cerrar los cursores
                    END LOOP;
                    DBMS_OUTPUT.PUT_LINE('------------------');
                    DBMS_OUTPUT.PUT_LINE('');
                END LOOP;
                DBMS_OUTPUT.PUT_LINE('------------------');
                DBMS_OUTPUT.PUT_LINE('');
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('------------------');
            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('------------------');
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-------------------------');
    DBMS_OUTPUT.PUT_LINE('');
--Finalizamos el procedimiento
END ListadoCentros;
/

--------------------------FIN LISTADO----------------------------

---------------------------FUNCION 1-----------------------------

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

----------------------------------FIN FUNCION 2------------------------------------

---------------------BLOQUE ANONIMO - PROGRAMA PRINCIPAL-------------------------

/*Para el desarrollo del programa principal disponemos de este men� que nos indicar� la
funci�n de cada una de las opciones que podemos ejecutar:

ATENCI�N: antes de ejecutar el programa por primera vez es aconsejable leerlo bien para
entender su funcionalidad, adem�s, el programa principal est� dise�ado para que funcione 
por lo que si cambia variables podr�a dar error.

1.- Recorrer el listado de centros comerciales, con sus respectivas secciones, departamentos
y ventas y de cada venta el producto estrella (producto que m�s cantidad se haya vendido).

2.- Recorre el listado de clientes con sus compras y productos respectivos 
al completo debido a que usa el DNI de un cliente que ha realizado compras con productos.

3.- Recorre el listado de clientes con sus compras y productos respectivos
de forma parcial debido a que usa el DNI de un cliente que no ha realizado compras con productos. 

4.- El objetivo de la opcion 4 ser� una funci�n que le devolver� el puesto de un empleado, las posibles salidas son Director General, 
Jefe de Planta, Jefe de Departamento, Trabajador en practicas, Administrativo o un mensaje que diga "El codigo 
introducido no corresponde a ning�n empleado". Para ello deber� introducir el n�mero del empleado como parametro
a la funci�n.

5.- La opci�n 5 se encarga de mostrar el importe total de las ventas realizadas en un d�a, mostrando un mensaje de error controlado 
si intenta averiguar como ganar una apuesta deportiva.

6.- La opci�n 6 insertar�, modificar� y borrara algunos productos, los cuales podr�n verse en la tabla AUDITORIA gracias al disparador de AuditoriaProducto

7.- Para la opci�n 7 tendr� que ejecutar la opci�n, bien entre las 2 y las 7 o subir en el script hasta la parte de disparadores de instrucci�n y modificar 
el horario para ver que su funcionalidad es correcta.

*/

--Comenzamos el bloque an�nimo con un DECLARE
DECLARE 

--Continuamos declarando todas las variables que vamos a utilizar en la aplicaci�n
V_OPCION NUMBER:= &OPCION;
V_FUNCION NUMBER;
V_PUESTO EMPLEADO.NOM_TIPO_CONTRATO%TYPE;
V_NUMEMP EMPLEADO.NUMEMPLEADO%TYPE;
V_NOMBREEMP EMPLEADO.NOMBRE%TYPE;
V_FECHAVENTA VENTA.FECHA%TYPE;
V_DNICLIENTE CLIENTE.DNI%TYPE;

BEGIN 
    --Iniciamos una sentencia condicional CASE
    CASE
    --La primera opci�n ejecuta el procedimiento del listado de centros
    WHEN V_OPCION=1 THEN
        ListadoCentros;
        
    --La segunda opci�n inicializa un DNI de un cliente que ha hecho compras de productos y ejecuta el listado de ClientesConCompras
    WHEN V_OPCION=2 THEN
        V_DNICLIENTE:='84439394';
        ClientesConCompras(V_DNICLIENTE);
     
    --La tercera opci�n inicializa un DNI de un cliente que no ha hecho compras de productos y ejecuta el listado de ClientesConCompras   
    WHEN V_OPCION=3 THEN
        V_DNICLIENTE:='77777774';
        ClientesConCompras(V_DNICLIENTE);
    
    --La opci�n 4 inicializa un NUMEMPLEADO que nos ayudar� a saber si el empleado existe o no existe    
    WHEN V_OPCION=4 THEN
        V_NUMEMP:='522345';
        V_FUNCION:=F_Puesto(V_NUMEMP);
        
        --En caso de que exista creamos un cursor impl�cito que nos muestre su puesto de trabajo
        IF V_FUNCION=1 THEN
            SELECT E.NOM_TIPO_CONTRATO INTO V_PUESTO FROM EMPLEADO E WHERE E.NUMEMPLEADO=V_NUMEMP;
            SELECT E.NOMBRE INTO V_NOMBREEMP FROM EMPLEADO E WHERE E.NUMEMPLEADO=V_NUMEMP;
            DBMS_OUTPUT.PUT_LINE('El puesto de '||V_NOMBREEMP||' es: '||V_PUESTO);
        
        --En caso de que el empleado no exista se mostrar� por pantalla a partir de una excepci�n controlada    
        ELSIF V_FUNCION=0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'El codigo introducido no corresponde a ning�n empleado');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Error inesperado');
        END IF;
        
    -- La opci�n 5 inicializa una fecha y se la da a la funci�n F_Importe que nos mostrar� el importe total de las ventas de un d�a  
    WHEN V_OPCION=5 THEN
        V_FECHAVENTA:='12/04/2020';
        V_FUNCION:=F_Importe(V_FECHAVENTA);
        DBMS_OUTPUT.PUT_LINE('El importe total en ventas de la fecha '||V_FECHAVENTA||' es: '||V_FUNCION);
    
    -- La opci�n 6 insertar�, modificar� y borrar� productos que dejar�n un registro guardado en la tabla AUDITORIA, 
    -- para ver los cambios ocasionados en la tabla hay dos sentencias SELECTS debajo del bloque an�nimo
    WHEN V_OPCION=6 THEN
        INSERT INTO PRODUCTO VALUES ('000007',1500,'Nike REY', 2, 'Calzado','Vestimenta','Lagoh');
        UPDATE PRODUCTO SET DENOMINACION_PRODUCTO='Nike Dios' WHERE CODIGO_PROD = '000006';
        DELETE FROM INCLUYE WHERE CODIGO_PROD = '000005';
        DELETE FROM SUMINISTRA WHERE CODIGO_PROD = '000005';
        DELETE FROM PRODUCTO WHERE CODIGO_PROD = '000005';
     
    --La opci�n 7 insertar� un producto, esta opci�n dar� error si nos encontramos entre las 2 y las 7 de la ma�ana, a no
    --ser que se cambien los parametros del disparador   
    WHEN V_OPCION=7 THEN
        INSERT INTO PRODUCTO VALUES ('000008',1740,'Nike 2', 3, 'Calzado','Vestimenta','Lagoh');
    
    --Cerramos la sentencia condicional CASE
    END CASE;
--Finalizamos el bloque an�nimo
END;
/

--Para comprobar que la opci�n 6 ha funcionado correctamente hacemos lo siguiente:
SELECT * FROM AUDITORIA;

--Si queremos que nos salga con formato de fecha y hora correctamente debemos escribir as� la SELECT
SELECT USUARIO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS "FECHA", OPCION, REGISTRO_ANTIGUO, REGISTRO_NUEVO FROM AUDITORIA;


-------------------------------------------FIN DE CODIGO PLSQL------------------------------------------
