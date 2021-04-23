/*TRIGGER DE INSTRUCCION PARA TODAS LAS TABLAS PARA QUE NO SE PUEDA REALIZAR NINGUNA OPERACIÓN ENTRE LAS 2 DE LA MAÑANA Y LAS 7 DE LA MAÑANA*/

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






























