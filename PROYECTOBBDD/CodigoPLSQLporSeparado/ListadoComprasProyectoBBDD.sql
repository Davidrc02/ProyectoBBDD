SET SERVEROUTPUT ON

-------------------------------------INICIO LISTADO 2--------------------------------------

------------------------------------LISTADO DE COMPRAS-------------------------------------

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

---------------------------------------FIN LISTADO 2-----------------------------------------