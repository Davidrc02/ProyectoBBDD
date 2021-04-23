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
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        