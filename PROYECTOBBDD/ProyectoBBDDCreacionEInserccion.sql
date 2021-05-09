DROP TABLE TIENE_DESCUENTO;
DROP TABLE REALIZA;
DROP TABLE SUMINISTRA;
DROP TABLE INCLUYE;
DROP TABLE PRODUCTO;
DROP TABLE VENTA;
DROP TABLE DEPARTAMENTO;
DROP TABLE EMPLEADO;
DROP TABLE SECCION;
DROP TABLE ENTIDAD_BANCARIA;
DROP TABLE PROVEEDOR;
DROP TABLE TIPO_CONTRATO;
DROP TABLE CLIENTE;
DROP TABLE CENTRO_COMERCIAL;
DROP TABLE AUDITORIA;

CREATE TABLE AUDITORIA
(
    USUARIO VARCHAR2(30),
    FECHA DATE,
    OPCION NUMBER(1),
    REGISTRO_ANTIGUO VARCHAR2(300),
    REGISTRO_NUEVO VARCHAR2(300)
);

CREATE TABLE CENTRO_COMERCIAL
(
    Nombre VARCHAR2(40) CONSTRAINT Nombre_Centro_Comercial_PK PRIMARY KEY
);

CREATE TABLE CLIENTE
(
    DNI CHAR(8) CONSTRAINT DNI_Cliente_PK PRIMARY KEY,
    Nombre VARCHAR2(40) NOT NULL,
    Apellido1 VARCHAR2(40) NOT NULL,
    Apellido2 VARCHAR2(40),
    Direccion VARCHAR2(40) NOT NULL,
    Telefono NUMBER(9)
);

CREATE TABLE TIPO_CONTRATO
(
    Nombre VARCHAR2(40) CONSTRAINT Nombre_Tipo_Contrato_PK PRIMARY KEY,
    Porcentaje_Ventas NUMBER (5,2) NOT NULL
);

CREATE TABLE PROVEEDOR
(
    Razon_Social CHAR(5) CONSTRAINT RSocial_Proveedor_PK PRIMARY KEY
);

CREATE TABLE ENTIDAD_BANCARIA
(
    Razon_Social CHAR(5) CONSTRAINT RSocial_EntidadBancaria_PK PRIMARY KEY
);

CREATE TABLE SECCION
(
    Denominacion_Seccion VARCHAR2(40),
    N_CComercial VARCHAR2(40),
    Planta NUMBER(2),
    CONSTRAINT DENNCC_SEC_PK PRIMARY KEY (Denominacion_Seccion, N_CComercial),
    CONSTRAINT NOM_CC_FK FOREIGN KEY (N_CComercial) REFERENCES CENTRO_COMERCIAL
);

CREATE TABLE EMPLEADO
(
    NumEmpleado CHAR(6) CONSTRAINT NumEmpleado_EMP_PK PRIMARY KEY,
    Nombre VARCHAR2(20) NOT NULL,
    Apellido1 VARCHAR2(40) NOT NULL ,
    Apellido2 VARCHAR2(40),
    Direccion VARCHAR2(40) NOT NULL,
    Telefono NUMBER(9),
    Nom_tipo_contrato VARCHAR2(40),
    CONSTRAINT NOM_TC_FK FOREIGN KEY (Nom_tipo_contrato) REFERENCES TIPO_CONTRATO
);

CREATE TABLE DEPARTAMENTO
(
    Nombre VARCHAR2(40),
    Denominacion_Seccion VARCHAR2(40),
    N_CComercial VARCHAR2(40),
    NumEmpleado CHAR(6) NOT NULL,
    CONSTRAINT NUMEMP_DEP_FK FOREIGN KEY (NumEmpleado) REFERENCES EMPLEADO,
    CONSTRAINT DENNCC_DEP_FK FOREIGN KEY (Denominacion_Seccion, N_CComercial) REFERENCES SECCION,
    CONSTRAINT NDN_DEP_PK PRIMARY KEY (Nombre, Denominacion_Seccion, N_CComercial)
);

CREATE TABLE VENTA
(
    NumOperacion CHAR(8),
    Fecha DATE,
    Forma_Pago VARCHAR2(40) NOT NULL,
    Importe NUMBER(10,2) NOT NULL,
    NumEmpleado CHAR(6)NOT NULL,
    Nombre_Departamento VARCHAR2(40),
    Denominacion_Seccion VARCHAR2(40),
    N_CComercial VARCHAR2(40),
    CONSTRAINT NUMEMP_VEN_FK FOREIGN KEY (NumEmpleado) REFERENCES EMPLEADO,
    CONSTRAINT DENNCC_VEN_FK FOREIGN KEY (Nombre_Departamento, Denominacion_Seccion, N_CComercial) REFERENCES DEPARTAMENTO,
    CONSTRAINT NOP_VEN_PK PRIMARY KEY (NumOperacion)
);

CREATE TABLE PRODUCTO
(
    Codigo_Prod CHAR(6),
    Precio NUMBER(9,2) NOT NULL,
    Denominacion_Producto VARCHAR2(40) NOT NULL,
    Stock NUMBER(10) NOT NULL,
    Nombre_Departamento VARCHAR2(40),
    Denominacion_Seccion VARCHAR2(40),
    N_CComercial VARCHAR2(40),
    CONSTRAINT DENNCC_PROD_FK FOREIGN KEY (Nombre_Departamento, Denominacion_Seccion, N_CComercial) REFERENCES DEPARTAMENTO,
    CONSTRAINT CODP_PROD_PK PRIMARY KEY (Codigo_Prod)
);

CREATE TABLE INCLUYE
(
    Codigo_Prod CHAR(6),
    NumOperacion CHAR(8),
    Cantidad NUMBER(10) NOT NULL,
    CONSTRAINT CODP_INC_FK FOREIGN KEY (Codigo_Prod) REFERENCES PRODUCTO,
    CONSTRAINT NOPV_INC_FK FOREIGN KEY (NumOperacion) REFERENCES VENTA,
    CONSTRAINT CODPNO_INC_PK PRIMARY KEY (Codigo_Prod, NumOperacion)
);

CREATE TABLE SUMINISTRA
(
    Codigo_Prod CHAR(6),
    Razon_Social CHAR(5),
    CONSTRAINT CP_SUM_FK FOREIGN KEY (Codigo_Prod) REFERENCES PRODUCTO,
    CONSTRAINT RS_SUM_FK FOREIGN KEY (Razon_Social) REFERENCES PROVEEDOR,
    CONSTRAINT RSCP_SUM_PK PRIMARY KEY (Codigo_Prod, Razon_Social)
);

CREATE TABLE REALIZA
(
    NumOperacion CHAR(8),
    Razon_Social CHAR(5),
    DNI_Cliente CHAR(8),
    CONSTRAINT NOP_REA_FK FOREIGN KEY (NumOperacion) REFERENCES VENTA,
    CONSTRAINT RS_REA_FK FOREIGN KEY (Razon_Social) REFERENCES ENTIDAD_BANCARIA,
    CONSTRAINT DNIC_REA_FK FOREIGN KEY (DNI_Cliente) REFERENCES CLIENTE,
    CONSTRAINT NOP_REA_PK PRIMARY KEY (NumOperacion)
);

CREATE TABLE TIENE_DESCUENTO
(
    Nombre_TC VARCHAR2(40), 
    Nombre_Departamento VARCHAR2(40),
    Denominacion_Seccion VARCHAR2(40),
    N_CComercial VARCHAR2(40),
    Porcentaje_Descuento NUMBER(5,2) NOT NULL,
    CONSTRAINT NTC_TDES_FK FOREIGN KEY(Nombre_TC) REFERENCES TIPO_CONTRATO,
    CONSTRAINT NDDENCC_TDES_FK FOREIGN KEY(Nombre_Departamento, Denominacion_Seccion, N_CComercial) REFERENCES DEPARTAMENTO,
    CONSTRAINT NTCNDDENCC_TDES_PK PRIMARY KEY (Nombre_TC, Nombre_Departamento, Denominacion_Seccion, N_CComercial)
);

INSERT INTO CENTRO_COMERCIAL VALUES ('Lagoh');
INSERT INTO CENTRO_COMERCIAL VALUES ('Nervion');
INSERT INTO CENTRO_COMERCIAL VALUES ('Torre Sevilla');

INSERT INTO CLIENTE VALUES ('84439394', 'David', 'Rodríguez', 'Cano', 'Avda. Venecia Nº 3', 694939434);
INSERT INTO CLIENTE VALUES ('93429344', 'Francisco', 'Serrano', 'González', 'Calle Miraflores Nº21', 645384448);
INSERT INTO CLIENTE VALUES ('54583984', 'Carlos', 'Asensio', 'Tabares', 'Avda. concordia Nº4', 694939322);
INSERT INTO CLIENTE VALUES ('45325884', 'Manolo', 'Porras', 'Díaz', 'Avda. Gloria Nº73', 654679352);
INSERT INTO CLIENTE VALUES ('77777774', 'Cristiano', 'Ronaldo', 'El Bicho', 'Madeira', 943939382);
INSERT INTO CLIENTE VALUES ('10101014', 'Lionel', 'Messi', 'Dios', 'Es de otro planeta', 910101010);
INSERT INTO CLIENTE VALUES ('43283484', 'Alejandro', 'Magno', null, 'Europa', 000000001);
INSERT INTO CLIENTE VALUES ('83284284', 'Daniel', 'Muñoz', 'Báez', 'Avda. Portugal Nº 33', 654762782);
INSERT INTO CLIENTE VALUES ('45345924', 'Irene', 'Montes', 'Gonzalez', 'Avda. Bélgica Nº34', 647838232) ;
INSERT INTO CLIENTE VALUES ('84345544', 'Carlos', 'García', 'Moral', 'Avda. Irlanda Nº6', 694564422);
INSERT INTO CLIENTE VALUES ('04309384', 'Antonio', 'Sánchez', 'Gómez', 'Avda. Letonia Nº89', 694742346);

INSERT INTO TIPO_CONTRATO VALUES ('Vendedor', 5.00);
INSERT INTO TIPO_CONTRATO VALUES ('Jefe de Planta', 7.00);
INSERT INTO TIPO_CONTRATO VALUES ('Administrativo', 6.00);
INSERT INTO TIPO_CONTRATO VALUES ('Jefe de Departamento', 6.50);
INSERT INTO TIPO_CONTRATO VALUES ('Director General', 10.00);
INSERT INTO TIPO_CONTRATO VALUES ('Trabajador en prácticas', 2.00);

INSERT INTO PROVEEDOR VALUES ('00001');
INSERT INTO PROVEEDOR VALUES ('00002');
INSERT INTO PROVEEDOR VALUES ('00003');
INSERT INTO PROVEEDOR VALUES ('00004');
INSERT INTO PROVEEDOR VALUES ('00005');
INSERT INTO PROVEEDOR VALUES ('00006');
INSERT INTO PROVEEDOR VALUES ('00007');

INSERT INTO ENTIDAD_BANCARIA VALUES ('00008');
INSERT INTO ENTIDAD_BANCARIA VALUES ('00009');
INSERT INTO ENTIDAD_BANCARIA VALUES ('00010');
INSERT INTO ENTIDAD_BANCARIA VALUES ('00011');
INSERT INTO ENTIDAD_BANCARIA VALUES ('00012');
INSERT INTO ENTIDAD_BANCARIA VALUES ('00013');
INSERT INTO ENTIDAD_BANCARIA VALUES ('00014');

INSERT INTO SECCION VALUES ('Vestimenta', 'Lagoh', 2);
INSERT INTO SECCION VALUES ('Restaurantes', 'Lagoh', 1);
INSERT INTO SECCION VALUES ('Ocio y tiendas varias', 'Lagoh', 0);
INSERT INTO SECCION VALUES ('Electrónica', 'Lagoh', 2);
INSERT INTO SECCION VALUES ('Cine', 'Lagoh', 2);
INSERT INTO SECCION VALUES ('Vestimenta', 'Nervion', 1);
INSERT INTO SECCION VALUES ('Restaurantes', 'Nervion', 1);
INSERT INTO SECCION VALUES ('Ocio y tiendas varias', 'Nervion', 0);
INSERT INTO SECCION VALUES ('Electrónica', 'Nervion', 1);
INSERT INTO SECCION VALUES ('Cine', 'Nervion', 2);
INSERT INTO SECCION VALUES ('Vestimenta', 'Torre Sevilla', 1);
INSERT INTO SECCION VALUES ('Hostelería y restaurantes', 'Torre Sevilla', 2);
INSERT INTO SECCION VALUES ('Ocio y tiendas varias', 'Torre Sevilla', 0);
INSERT INTO SECCION VALUES ('Electrónica', 'Torre Sevilla', 1);
INSERT INTO SECCION VALUES ('Gimnasio', 'Torre Sevilla', 3);

INSERT INTO EMPLEADO VALUES ('527345', 'Manuel', 'Sánchez', 'Herrera', 'Avda. Letonia Nº89', 648439320, 'Jefe de Planta');
INSERT INTO EMPLEADO VALUES ('523542', 'Sergio', 'Barea', 'García', 'Avda. Letonia Nº89', 634443256, 'Administrativo');
INSERT INTO EMPLEADO VALUES ('345236', 'Victor', 'Presa', 'Lordén', 'Avda. Letonia Nº89', 666433892, 'Jefe de Planta');
INSERT INTO EMPLEADO VALUES ('453534', 'Nicolas', 'Carmona', 'Díaz', 'Avda. Letonia Nº89', 678204957, 'Trabajador en prácticas');
INSERT INTO EMPLEADO VALUES ('123421', 'David', 'Romero', 'Requena', 'Avda. Letonia Nº89', 694444356, 'Trabajador en prácticas');
INSERT INTO EMPLEADO VALUES ('754355', 'Álvaro', 'Sánchez', 'Hernández', 'Avda. Letonia Nº89', 607900534, 'Administrativo');
INSERT INTO EMPLEADO VALUES ('111234', 'Sergio', 'Pinto', 'Blandón', 'Avda. Letonia Nº89', 655665345, 'Jefe de Planta');
INSERT INTO EMPLEADO VALUES ('534488', 'Manuel', 'García', 'Escobar', 'Avda. Letonia Nº89', 733254545, 'Jefe de Departamento');
INSERT INTO EMPLEADO VALUES ('854834', 'Máximo', 'Décimo', 'Meridio', 'Avda. Letonia Nº89', 694434536, 'Director General');
INSERT INTO EMPLEADO VALUES ('223455', 'Luke', 'Skywalker', 'Amidala', 'Avda. Letonia Nº89', 633355656, 'Trabajador en prácticas');

INSERT INTO DEPARTAMENTO VALUES ('Calzado','Vestimenta','Lagoh', '527345');
INSERT INTO DEPARTAMENTO VALUES ('Camisetas','Vestimenta','Lagoh', '527345');
INSERT INTO DEPARTAMENTO VALUES ('Calzoncillos','Vestimenta','Lagoh', '527345');
INSERT INTO DEPARTAMENTO VALUES ('Calcetines','Vestimenta','Lagoh', '527345');
INSERT INTO DEPARTAMENTO VALUES ('Pantalones','Vestimenta','Lagoh', '527345');
INSERT INTO DEPARTAMENTO VALUES ('Joyeria','Vestimenta','Lagoh', '527345');
INSERT INTO DEPARTAMENTO VALUES ('Gorras','Vestimenta','Lagoh', '527345');

INSERT INTO VENTA VALUES ('99999999','12/04/2020','PayPal',6000,'527345','Calzado','Vestimenta','Lagoh');
INSERT INTO VENTA VALUES ('99999998','13/03/2019','PayPal',7000,'527345','Calzado','Vestimenta','Lagoh');
INSERT INTO VENTA VALUES ('99999997','14/03/2019','PayPal',8000,'527345','Calzado','Vestimenta','Lagoh');
INSERT INTO VENTA VALUES ('99999996','15/03/2019','PayPal',9000,'527345','Calzado','Vestimenta','Lagoh');
INSERT INTO VENTA VALUES ('99999995','16/03/2019','PayPal',10000,'527345','Calzado','Vestimenta','Lagoh');

INSERT INTO PRODUCTO VALUES ('000001',50,'Nike AirMax', 40, 'Calzado','Vestimenta','Lagoh');
INSERT INTO PRODUCTO VALUES ('000002',70,'Nike Jordan', 40, 'Calzado','Vestimenta','Lagoh');
INSERT INTO PRODUCTO VALUES ('000003',60,'Nike Paco', 40, 'Calzado','Vestimenta','Lagoh');
INSERT INTO PRODUCTO VALUES ('000004',40,'Nike Luis', 40, 'Calzado','Vestimenta','Lagoh');
INSERT INTO PRODUCTO VALUES ('000005',90,'Nike David', 70, 'Calzado','Vestimenta','Lagoh');
INSERT INTO PRODUCTO VALUES ('000006',1000,'Nike God', 1, 'Calzado','Vestimenta','Lagoh');

INSERT INTO INCLUYE VALUES('000001', '99999999', 1);
INSERT INTO INCLUYE VALUES('000002', '99999999', 1);
INSERT INTO INCLUYE VALUES('000003', '99999999', 1);
INSERT INTO INCLUYE VALUES('000004', '99999999', 1);
INSERT INTO INCLUYE VALUES('000005', '99999999', 1);
INSERT INTO INCLUYE VALUES('000006', '99999998', 5);

INSERT INTO SUMINISTRA VALUES ('000001', '00001');
INSERT INTO SUMINISTRA VALUES ('000002', '00002');
INSERT INTO SUMINISTRA VALUES ('000003', '00003');
INSERT INTO SUMINISTRA VALUES ('000004', '00004');
INSERT INTO SUMINISTRA VALUES ('000004', '00005');
INSERT INTO SUMINISTRA VALUES ('000004', '00006');
INSERT INTO SUMINISTRA VALUES ('000005', '00007');

INSERT INTO REALIZA VALUES ('99999999', '00008', '84439394');
INSERT INTO REALIZA VALUES ('99999998', '00009', '84439394');
INSERT INTO REALIZA VALUES ('99999997', '00010', '84439394');
INSERT INTO REALIZA VALUES ('99999996', '00011', '84439394');
INSERT INTO REALIZA VALUES ('99999995', '00012', '84439394');

INSERT INTO TIENE_DESCUENTO VALUES ('Trabajador en prácticas', 'Calzado', 'Vestimenta', 'Lagoh' , 07.35);
INSERT INTO TIENE_DESCUENTO VALUES ('Jefe de Planta', 'Calzado', 'Vestimenta', 'Lagoh' , 15.75);
INSERT INTO TIENE_DESCUENTO VALUES ('Jefe de Departamento', 'Calzado', 'Vestimenta', 'Lagoh' , 10.65);
INSERT INTO TIENE_DESCUENTO VALUES ('Jefe de Departamento', 'Camisetas', 'Vestimenta', 'Lagoh' , 10.65);
INSERT INTO TIENE_DESCUENTO VALUES ('Jefe de Departamento', 'Calzoncillos', 'Vestimenta', 'Lagoh' , 10.65);
INSERT INTO TIENE_DESCUENTO VALUES ('Jefe de Departamento', 'Calcetines', 'Vestimenta', 'Lagoh' , 10.65);
INSERT INTO TIENE_DESCUENTO VALUES ('Jefe de Departamento', 'Pantalones', 'Vestimenta', 'Lagoh' , 10.65);
INSERT INTO TIENE_DESCUENTO VALUES ('Jefe de Departamento', 'Joyeria', 'Vestimenta', 'Lagoh' , 10.65);
INSERT INTO TIENE_DESCUENTO VALUES ('Jefe de Departamento', 'Gorras', 'Vestimenta', 'Lagoh' , 10.65);
INSERT INTO TIENE_DESCUENTO VALUES ('Director General', 'Calzado', 'Vestimenta', 'Lagoh' , 25.95);
INSERT INTO TIENE_DESCUENTO VALUES ('Director General', 'Camisetas', 'Vestimenta', 'Lagoh' , 25.95);
INSERT INTO TIENE_DESCUENTO VALUES ('Director General', 'Calzoncillos', 'Vestimenta', 'Lagoh' , 25.95);
INSERT INTO TIENE_DESCUENTO VALUES ('Director General', 'Calcetines', 'Vestimenta', 'Lagoh' , 25.95);
INSERT INTO TIENE_DESCUENTO VALUES ('Director General', 'Pantalones', 'Vestimenta', 'Lagoh' , 25.95);
INSERT INTO TIENE_DESCUENTO VALUES ('Director General', 'Joyeria', 'Vestimenta', 'Lagoh' , 25.95);
INSERT INTO TIENE_DESCUENTO VALUES ('Director General', 'Gorras', 'Vestimenta', 'Lagoh' , 25.95);
INSERT INTO TIENE_DESCUENTO VALUES ('Administrativo', 'Calzado', 'Vestimenta', 'Lagoh' , 25.95);
INSERT INTO TIENE_DESCUENTO VALUES ('Administrativo', 'Camisetas', 'Vestimenta', 'Lagoh' , 25.95);
INSERT INTO TIENE_DESCUENTO VALUES ('Administrativo', 'Calzoncillos', 'Vestimenta', 'Lagoh' , 15.35);
INSERT INTO TIENE_DESCUENTO VALUES ('Administrativo', 'Calcetines', 'Vestimenta', 'Lagoh' , 15.35);
INSERT INTO TIENE_DESCUENTO VALUES ('Administrativo', 'Pantalones', 'Vestimenta', 'Lagoh' , 15.35);
INSERT INTO TIENE_DESCUENTO VALUES ('Administrativo', 'Joyeria', 'Vestimenta', 'Lagoh' , 15.35);
INSERT INTO TIENE_DESCUENTO VALUES ('Administrativo', 'Gorras', 'Vestimenta', 'Lagoh' , 15.35);

COMMIT;