---------------------BLOQUE ANONIMO - PROGRAMA PRINCIPAL-------------------------

/*Para el desarrollo del programa principal disponemos de este menú que nos indicará la
función de cada una de las opciones que podemos ejecutar:

ATENCIÓN: antes de ejecutar el programa por primera vez es aconsejable leerlo bien para
entender su funcionalidad, además, el programa principal está diseñado para que funcione 
por lo que si cambia variables podría dar error.

1.- Recorrer el listado de centros comerciales, con sus respectivas secciones, departamentos
y ventas y de cada venta el producto estrella (producto que más cantidad se haya vendido).

2.- Recorre el listado de clientes con sus compras y productos respectivos 
al completo debido a que usa el DNI de un cliente que ha realizado compras con productos.

3.- Recorre el listado de clientes con sus compras y productos respectivos
de forma parcial debido a que usa el DNI de un cliente que no ha realizado compras con productos. 

4.- El objetivo de la opcion 4 será una función que le devolverá el puesto de un empleado, las posibles salidas son Director General, 
Jefe de Planta, Jefe de Departamento, Trabajador en practicas, Administrativo o un mensaje que diga "El codigo 
introducido no corresponde a ningún empleado". Para ello deberá introducir el número del empleado como parametro
a la función.

5.- La opción 5 se encarga de mostrar el importe total de las ventas realizadas en un día, mostrando un mensaje de error controlado 
si intenta averiguar como ganar una apuesta deportiva.

6.- La opción 6 insertará, modificará y borrara algunos productos, los cuales podrán verse en la tabla AUDITORIA gracias al disparador de AuditoriaProducto

7.- Para que la opción 7 muestre un resultado erróneo, tendrá que ejecutar la opción, bien entre las 2 y las 7 o subir en el script hasta la parte de disparadores de instrucción y modificar 
el horario para ver que su funcionalidad es correcta, en caso contrario se realizará una inserción de un producto.

*/

--Comenzamos el bloque anónimo con un DECLARE
DECLARE 

--Continuamos declarando todas las variables que vamos a utilizar en la aplicación
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
    --La primera opción ejecuta el procedimiento del listado de centros
    WHEN V_OPCION=1 THEN
        ListadoCentros;
        
    --La segunda opción inicializa un DNI de un cliente que ha hecho compras de productos y ejecuta el listado de ClientesConCompras
    WHEN V_OPCION=2 THEN
        V_DNICLIENTE:='84439394';
        ClientesConCompras(V_DNICLIENTE);
     
    --La tercera opción inicializa un DNI de un cliente que no ha hecho compras de productos y ejecuta el listado de ClientesConCompras   
    WHEN V_OPCION=3 THEN
        V_DNICLIENTE:='77777774';
        ClientesConCompras(V_DNICLIENTE);
    
    --La opción 4 inicializa un NUMEMPLEADO que nos ayudará a saber si el empleado existe o no existe    
    WHEN V_OPCION=4 THEN
        V_NUMEMP:='527345';
        
        --Aqui la opción de un empleado inexistente
        --V_NUMEMP:='522345';
        V_FUNCION:=F_Puesto(V_NUMEMP);
        
        --En caso de que exista creamos un cursor implícito que nos muestre su puesto de trabajo
        IF V_FUNCION=1 THEN
            SELECT E.NOM_TIPO_CONTRATO INTO V_PUESTO FROM EMPLEADO E WHERE E.NUMEMPLEADO=V_NUMEMP;
            SELECT E.NOMBRE INTO V_NOMBREEMP FROM EMPLEADO E WHERE E.NUMEMPLEADO=V_NUMEMP;
            DBMS_OUTPUT.PUT_LINE('El puesto de '||V_NOMBREEMP||' es: '||V_PUESTO);
        
        --En caso de que el empleado no exista se mostrará por pantalla a partir de una excepción controlada    
        ELSIF V_FUNCION=0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'El codigo introducido no corresponde a ningún empleado');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Error inesperado');
        END IF;
        
    -- La opción 5 inicializa una fecha y se la da a la función F_Importe que nos mostrará el importe total de las ventas de un día  
    WHEN V_OPCION=5 THEN
        V_FECHAVENTA:='12/04/2020';
        
        --Aqui fecha que devuelve error
        --V_FECHAVENTA:='15/05/2021';
        
        --Aquí fecha que devuelve importe=0
        --V_FECHAVENTA:='12/04/2019';
        
        V_FUNCION:=F_Importe(V_FECHAVENTA);
        DBMS_OUTPUT.PUT_LINE('El importe total en ventas de la fecha '||V_FECHAVENTA||' es: '||V_FUNCION);
    
    -- La opción 6 insertará, modificará y borrará productos que dejarán un registro guardado en la tabla AUDITORIA, 
    -- para ver los cambios ocasionados en la tabla hay dos sentencias SELECTS debajo del bloque anónimo
    WHEN V_OPCION=6 THEN
        INSERT INTO PRODUCTO VALUES ('000007',1500,'Nike REY', 2, 'Calzado','Vestimenta','Lagoh');
        UPDATE PRODUCTO SET DENOMINACION_PRODUCTO='Nike Dios' WHERE CODIGO_PROD = '000006';
        DELETE FROM INCLUYE WHERE CODIGO_PROD = '000005';
        DELETE FROM SUMINISTRA WHERE CODIGO_PROD = '000005';
        DELETE FROM PRODUCTO WHERE CODIGO_PROD = '000005';
     
    --La opción 7 insertará un producto, esta opción dará error si nos encontramos entre las 2 y las 7 de la mañana, a no
    --ser que se cambien los parametros del disparador   
    WHEN V_OPCION=7 THEN
        INSERT INTO PRODUCTO VALUES ('000008',1740,'Nike 2', 3, 'Calzado','Vestimenta','Lagoh');
    
    --Cerramos la sentencia condicional CASE
    END CASE;
--Finalizamos el bloque anónimo
END;
/

--Para comprobar que la opción 6 ha funcionado correctamente hacemos lo siguiente:
SELECT * FROM AUDITORIA;

--Si queremos que nos salga con formato de fecha y hora correctamente debemos escribir así la SELECT
SELECT USUARIO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS "FECHA", OPCION, REGISTRO_ANTIGUO, REGISTRO_NUEVO FROM AUDITORIA;


----------------------------------------FIN BLOQUE ANÓNIMO----------------------------------------------------------