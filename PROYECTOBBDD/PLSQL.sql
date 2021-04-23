/*LISTADO CON CURSORES*/

DECLARE 
    CURSOR CURSOR_CCOMERCIAL IS
        SELECT DISTINCT CC.NOMBRE 
        FROM CENTRO_COMERCIAL CC 
        ORDER BY CC.NOMBRE;

    CURSOR CURSOR_SECCION(V_NCC VARCHAR2) IS 
        SELECT DISTINCT S.DENOMINACION_SECCION 
        FROM SECCION S
        WHERE V_NCC=S.N_CCOMERCIAL
        ORDER BY S.DENOMINACION_SECCION;
    
    CURSOR CURSOR_DEP(V_DEN_SECC VARCHAR2, V_NCC VARCHAR2) IS
        SELECT D.NOMBRE 
        FROM DEPARTAMENTO D
        WHERE D.DENOMINACION_SECCION=V_DEN_SECC
        AND D.N_CCOMERCIAL=V_NCC;
        
    CURSOR CURSOR_VEN(V_NDEP VARCHAR2, V_DEN_SECC VARCHAR2, V_NCC VARCHAR2) IS
        SELECT V.NUMOPERACION, V.FECHA, V.IMPORTE
            FROM VENTA V
            WHERE V_NDEP=V.NOMBRE_DEPARTAMENTO
            AND V.DENOMINACION_SECCION=V_DEN_SECC
            AND V.N_CCOMERCIAL=V_NCC;

BEGIN
    FOR REG_NCC IN CURSOR_CCOMERCIAL LOOP
    
    DBMS_OUTPUT.PUT_LINE('CENTRO COMERCIAL: ' || REG_NCC.NOMBRE);
        FOR REG_SECC IN CURSOR_SECCION(REG_NCC.NOMBRE) LOOP 
        DBMS_OUTPUT.PUT_LINE('SECCION: ' || REG_SECC.DENOMINACION_SECCION);
        
            FOR REG_DEP IN CURSOR_DEP(REG_SECC.DENOMINACION_SECCION, REG_NCC.NOMBRE) LOOP
                DBMS_OUTPUT.PUT_LINE('DEPARTAMENTO: ' ||REG_DEP.NOMBRE);
                
                FOR REG_VENTA IN CURSOR_VEN(REG_DEP.NOMBRE, REG_SECC.DENOMINACION_SECCION, REG_NCC.NOMBRE) LOOP
                    DBMS_OUTPUT.PUT_LINE('NÚMERO DE VENTA: ' ||REG_VENTA.NUMOPERACION);
                    DBMS_OUTPUT.PUT_LINE('FECHA VENTA: ' ||REG_VENTA.FECHA);
                    DBMS_OUTPUT.PUT_LINE('IMPORTE VENTA: ' ||REG_VENTA.IMPORTE);
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
END;
/ 

/*DISPARADOR DE AUDITORIA*/

CREATE OR REPLACE TRIGGER AuditoriaProducto
    AFTER INSERT OR DELETE OR UPDATE ON PRODUCTO
    FOR EACH ROW
    DECLARE
        V_REGISTRO_OLD VARCHAR2(300);
        V_REGISTRO_NEW VARCHAR2(300);
        V_OPCION NUMBER(1);
    BEGIN
        CASE
        WHEN INSERTING THEN
            V_OPCION:=1;
            V_REGISTRO_OLD:=(NULL);
            V_REGISTRO_NEW:=(:NEW.CODIGO_PROD||' # '||:NEW.PRECIO||' # '||:NEW.DENOMINACION_PRODUCTO||' # '||:NEW.STOCK||' # '||:NEW.NOMBRE_DEPARTAMENTO||' # '||:NEW.DENOMINACION_SECCION||' # '||:NEW.N_CCOMERCIAL);
                
        WHEN UPDATING THEN
            V_OPCION:=2;
            V_REGISTRO_OLD:=(:OLD.CODIGO_PROD||' # '||:OLD.PRECIO||' # '||:OLD.DENOMINACION_PRODUCTO||' # '||:OLD.STOCK||' # '||:OLD.NOMBRE_DEPARTAMENTO||' # '||:OLD.DENOMINACION_SECCION||' # '||:OLD.N_CCOMERCIAL);
            V_REGISTRO_NEW:=(:NEW.CODIGO_PROD||' # '||:NEW.PRECIO||' # '||:NEW.DENOMINACION_PRODUCTO||' # '||:NEW.STOCK||' # '||:NEW.NOMBRE_DEPARTAMENTO||' # '||:NEW.DENOMINACION_SECCION||' # '||:NEW.N_CCOMERCIAL);
                
        WHEN DELETING THEN
            V_OPCION:=3;
            V_REGISTRO_NEW:=(NULL);
            V_REGISTRO_OLD:=(:OLD.CODIGO_PROD||' # '||:OLD.PRECIO||' # '||:OLD.DENOMINACION_PRODUCTO||' # '||:OLD.STOCK||' # '||:OLD.NOMBRE_DEPARTAMENTO||' # '||:OLD.DENOMINACION_SECCION||' # '||:OLD.N_CCOMERCIAL);

        END CASE;
        INSERT INTO AUDITORIA VALUES (USER, TO_DATE((SELECT TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') FROM DUAL),'DD/MM/YYYY HH24:MI:SS'), V_OPCION, V_REGISTRO_OLD, V_REGISTRO_NEW);
END AuditoriaProducto;
/

/*DISPARADORES DE INSTRUCCION*/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO00
    BEFORE INSERT ON PRODUCTO 
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') IN ('2','7')) THEN
            RAISE_APPLICATION_ERROR (-1199998,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO01
    BEFORE INSERT ON VENTA 
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') IN ('2','7')) THEN
            RAISE_APPLICATION_ERROR (-1199998,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO02
    BEFORE INSERT ON REALIZA 
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') IN ('2','7')) THEN
            RAISE_APPLICATION_ERROR (-1199998,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO03
    BEFORE INSERT ON AUDITORIA 
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') IN ('2','7')) THEN
            RAISE_APPLICATION_ERROR (-1199998,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO04
    BEFORE INSERT ON CLIENTE
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') IN ('2','7')) THEN
            RAISE_APPLICATION_ERROR (-1199998,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO05
    BEFORE INSERT ON EMPLEADO
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') IN ('2','7')) THEN
            RAISE_APPLICATION_ERROR (-1199998,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO06
    BEFORE INSERT ON CENTRO_COMERCIAL
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') IN ('2','7')) THEN
            RAISE_APPLICATION_ERROR (-1199998,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO07
    BEFORE INSERT ON DEPARTAMENTO
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') IN ('2','7')) THEN
            RAISE_APPLICATION_ERROR (-1199998,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO08
    BEFORE INSERT ON ENTIDAD_BANCARIA
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') IN ('2','7')) THEN
            RAISE_APPLICATION_ERROR (-1199998,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO09
    BEFORE INSERT ON INCLUYE
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') IN ('2','7')) THEN
            RAISE_APPLICATION_ERROR (-1199998,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO10
    BEFORE INSERT ON PROVEEDOR
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') IN ('2','7')) THEN
            RAISE_APPLICATION_ERROR (-1199998,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO11
    BEFORE INSERT ON SECCION
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') IN ('2','7')) THEN
            RAISE_APPLICATION_ERROR (-1199998,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO12
    BEFORE INSERT ON SUMINISTRA
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') IN ('2','7')) THEN
            RAISE_APPLICATION_ERROR (-1199998,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO13
    BEFORE INSERT ON TIENE_DESCUENTO
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') IN ('2','7')) THEN
            RAISE_APPLICATION_ERROR (-1199998,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CENTROCOMERCIALCERRADO14
    BEFORE INSERT ON TIPO_CONTRATO
    BEGIN
        IF (TO_CHAR(SYSDATE,'HH24') IN ('2','7')) THEN
            RAISE_APPLICATION_ERROR (-1199998,'En estos momentos el centro comercial está cerrado y por tanto no puede realizar ninguna transacción de ningún tipo');
    END IF;
END;
/


