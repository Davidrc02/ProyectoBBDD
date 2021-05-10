------------------INICIO CONJUNTO DE DISPARADORES DE INSTRUCCION----------------

/*El conjunto de disparadores de instrucción que encontramos a continuación nos 
sirve para que no se pueda modificar la información de las tablas desde las 2am 
hasta las 7am, que es el horario en el que los centros comerciales de nuestra base
de datos se encuentran cerrados*/

--La estructura y función para los siguientes disparadores es identica, que consiste en la siguiente:

--Creación del disparador con su respectivo nombre
CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO00
    --Antes de modificar (ya sea inserción, actualización o borrado) la información en la tabla (en este caso producto) se ejecuta el disparador
    BEFORE INSERT OR UPDATE OR DELETE ON PRODUCTO 
    
    BEGIN
        --Establecemos la condición para que se ejecute un error si la hora está comprendida entre las 2 y las 7 de la mañana
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            --Lanzamos el error una vez cumplida la condición
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

--Hacemos lo mismo para los demás

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO01
    BEFORE INSERT OR UPDATE OR DELETE ON VENTA 
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO02
    BEFORE INSERT OR UPDATE OR DELETE ON REALIZA 
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO03
    BEFORE INSERT OR UPDATE OR DELETE ON AUDITORIA 
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO04
    BEFORE INSERT OR UPDATE OR DELETE ON CLIENTE
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO05
    BEFORE INSERT OR UPDATE OR DELETE ON EMPLEADO
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO06
    BEFORE INSERT OR UPDATE OR DELETE ON CENTRO_COMERCIAL
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO07
    BEFORE INSERT OR UPDATE OR DELETE ON DEPARTAMENTO
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO08
    BEFORE INSERT OR UPDATE OR DELETE ON ENTIDAD_BANCARIA
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO09
    BEFORE INSERT OR UPDATE OR DELETE ON INCLUYE
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO10
    BEFORE INSERT OR UPDATE OR DELETE ON PROVEEDOR
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO11
    BEFORE INSERT ON SECCION
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO12
    BEFORE INSERT OR UPDATE OR DELETE ON SUMINISTRA
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO13
    BEFORE INSERT OR UPDATE OR DELETE ON TIENE_DESCUENTO
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO14
    BEFORE INSERT OR UPDATE OR DELETE ON TIPO_CONTRATO
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') BETWEEN '2' AND '7') THEN
            RAISE_APPLICATION_ERROR (-2000001,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
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

------------------FIN CONJUNTO DE DISPARADORES DE INSTRUCCIÓN------------------