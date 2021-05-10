SET SERVEROUTPUT

----------------------------------DISPARADOR DE FILAS-------------------------------------

/* En concreto este disparador lo que realiza es una auditoria de los productos 
que se hayan insertado, actualizado o borrado en nuestra base de datos. */

-- Creamos o reemplazamos el disparador y le ponemos un nombre, en este caso,
-- al ser una auditoria de los productos lo llamaremos "AuditoriaProducto". 
CREATE OR REPLACE TRIGGER AuditoriaProducto
    --Aquí le indicamos al disparador cuando se va a ejecutar y sobre que tabla va a actuar.
    AFTER INSERT OR DELETE OR UPDATE ON PRODUCTO
    --El disparador se va a ejecutar para cada fila insertada, actualizada o borrada.
    FOR EACH ROW
    
    --Declaramos las variables del registro antiguo, el registro nuevo y la opción.
DECLARE
    --Registro antiguo.
    V_REGISTRO_OLD VARCHAR2(300);
    --Registro nuevo.
    V_REGISTRO_NEW VARCHAR2(300);
    --Opción.
    V_OPCION NUMBER(1);

BEGIN
    --Usamos una sentencia case para distinguir cuando insertemos, actualicemos o borremos un producto.
    CASE
    --Cuando inserte un producto:
    WHEN INSERTING THEN
        --Inicializamos la opción a 1 (inserción).
        V_OPCION:=1;
        --El registro antiguo queda como null debido a que no existía previamente.
        V_REGISTRO_OLD:=(NULL);
        --Establecemos los nuevos atributos que va a contener nuestro "V_REGISTRO_NEW" con el formato que deseemos.
        V_REGISTRO_NEW:=(:NEW.CODIGO_PROD||' # '||:NEW.PRECIO||' # '||:NEW.DENOMINACION_PRODUCTO||' # '||:NEW.STOCK||' # '||:NEW.NOMBRE_DEPARTAMENTO||' # '||:NEW.DENOMINACION_SECCION||' # '||:NEW.N_CCOMERCIAL);
            
    --Cuando actualicemos un producto: 
    WHEN UPDATING THEN
        --Inicializamos la opción a 2 (actualización).
        V_OPCION:=2;
        --Introducimos los atributos antiguos en el registro "V_REGISTRO_OLD" y los nuevos atributos en el registro "V_REGISTRO_NEW".
        V_REGISTRO_OLD:=(:OLD.CODIGO_PROD||' # '||:OLD.PRECIO||' # '||:OLD.DENOMINACION_PRODUCTO||' # '||:OLD.STOCK||' # '||:OLD.NOMBRE_DEPARTAMENTO||' # '||:OLD.DENOMINACION_SECCION||' # '||:OLD.N_CCOMERCIAL);
        V_REGISTRO_NEW:=(:NEW.CODIGO_PROD||' # '||:NEW.PRECIO||' # '||:NEW.DENOMINACION_PRODUCTO||' # '||:NEW.STOCK||' # '||:NEW.NOMBRE_DEPARTAMENTO||' # '||:NEW.DENOMINACION_SECCION||' # '||:NEW.N_CCOMERCIAL);
    
    --Cuando borremos un producto:            
    WHEN DELETING THEN
        --Inicializamos la opción a 3 (borrado).
        V_OPCION:=3;
        --El registro nuevo queda como null debido a que hemos borrado el que ya había.
        V_REGISTRO_NEW:=(NULL);
        --En el registro antiguo aparecerá el registro que se ha borrado.
        V_REGISTRO_OLD:=(:OLD.CODIGO_PROD||' # '||:OLD.PRECIO||' # '||:OLD.DENOMINACION_PRODUCTO||' # '||:OLD.STOCK||' # '||:OLD.NOMBRE_DEPARTAMENTO||' # '||:OLD.DENOMINACION_SECCION||' # '||:OLD.N_CCOMERCIAL);
        
    --Finalizamos la sentencia condicional case.
    END CASE; 
    --Insertamos el usuario, la fecha y hora, el tipo de modificación realizada y los dos registros (tanto antiguo como nuevo) en la tabla AUDITORIA.
    INSERT INTO AUDITORIA VALUES (USER, TO_DATE((SELECT TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') FROM DUAL),'DD/MM/YYYY HH24:MI:SS'), V_OPCION, V_REGISTRO_OLD, V_REGISTRO_NEW);
        
--Finalizamos el disparador.
END AuditoriaProducto;
/

/* Por defecto, al compilar un disparador se establecerá como habilitado, pero si queremos
podemos habilitarlos o deshabilitarlos con estos comandos: */

--Para habilitarlo
ALTER TRIGGER AuditoriaProducto ENABLE;

--Para deshabilitarlo
ALTER TRIGGER AuditoriaProducto DISABLE;

---------------------------FIN DISPARADOR DE FILAS------------------------------