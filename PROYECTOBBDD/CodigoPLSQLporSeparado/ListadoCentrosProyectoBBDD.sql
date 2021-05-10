
-------------------------------------INICIO LISTADO 1----------------------------------------

--------------LISTADO DE CENTROS COMERCIALES, SECCIONES, DEPARTAMENTOS Y VENTAS--------------

/*Este listado NOS presenta los centros comerciales que tenemos en la base de datos, de cada centro comercial
se mostrarán las secciones que posee, de cada seccion el departamento, de cada departamento las ventas que
tiene asociada y de las ventas se mostrará su producto estrella*/

--Primero creamos o reemplazamos el procedimiento, el cual se llamará ListadoCentros
CREATE OR REPLACE PROCEDURE ListadoCentros IS 

    --Creamos el cursor que recorrerá los centros comerciales
    CURSOR C_CCOMERCIAL IS
        SELECT DISTINCT CC.NOMBRE 
        FROM CENTRO_COMERCIAL CC 
        ORDER BY CC.NOMBRE;
        
    --Guardamos los atributos del cursor en el registro R_CENTROS
    R_CENTROS C_CCOMERCIAL%ROWTYPE;

    --A continuación creamos el cursor que recorrerá de cada centro comercial, las secciones que tiene
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
    
    --Y por último un cursor que nos devolverá el producto estrella (producto más vendido) y la cantidad vendida de dicho producto
    CURSOR C_PRODUCTOS(NUM_OP CHAR) IS 
        SELECT A.PRODUCTO, A.CANTIDAD
            FROM (SELECT P.DENOMINACION_PRODUCTO AS "PRODUCTO", I.CANTIDAD AS "CANTIDAD"
                    FROM INCLUYE I, PRODUCTO P  
                    WHERE I.NUMOPERACION=NUM_OP AND P.CODIGO_PROD=I.CODIGO_PROD 
                    ORDER BY CANTIDAD DESC) A
            WHERE ROWNUM <= 1;
    
    --Guardamos el producto en R_PROD        
    R_PROD C_PRODUCTOS%ROWTYPE;

--Una vez terminada la creación de los cursores, comenzamos a recorrerlos y a mostrar la información
BEGIN
    --Cursor de centros comerciales y su respectiva información
    FOR R_NCENTROS IN C_CCOMERCIAL LOOP
    
    DBMS_OUTPUT.PUT_LINE('CENTRO COMERCIAL: ' || R_NCENTROS.NOMBRE);
    DBMS_OUTPUT.PUT_LINE('');
        
        --Cursor de secciones y su respectiva información
        FOR R_SECCIONES IN C_SECCION(R_NCENTROS.NOMBRE) LOOP 
        DBMS_OUTPUT.PUT_LINE('SECCION: ' || R_SECCIONES.DENOMINACION_SECCION);
        DBMS_OUTPUT.PUT_LINE('');
            
            --Cursor de departamentos y su respectiva información
            FOR R_DEPARTAMENTOS IN C_DEP(R_SECCIONES.DENOMINACION_SECCION, R_NCENTROS.NOMBRE) LOOP
                DBMS_OUTPUT.PUT_LINE('DEPARTAMENTO: ' ||R_DEPARTAMENTOS.NOMBRE);
                DBMS_OUTPUT.PUT_LINE('');
                
                --Cursor de ventas y su respectiva información
                FOR R_VENTAS IN C_VENTAS(R_DEPARTAMENTOS.NOMBRE, R_SECCIONES.DENOMINACION_SECCION, R_NCENTROS.NOMBRE) LOOP
                    DBMS_OUTPUT.PUT_LINE('NÚMERO DE VENTA: ' ||R_VENTAS.NUMOPERACION);
                    DBMS_OUTPUT.PUT_LINE('FECHA VENTA: ' ||R_VENTAS.FECHA);
                    DBMS_OUTPUT.PUT_LINE('IMPORTE VENTA: ' ||R_VENTAS.IMPORTE);
                    
                    --Cursor de productos y su respectiva información
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

--------------------------------FIN LISTADO 1----------------------------------

