--tabla categorias
drop table if exists categorias;
create table categorias(
	codigo_cat serial  not null,
	nombre varchar(100) not null,
	categoria_padre int,
	constraint categorias_pk primary key (codigo_cat),
	constraint categorias_fk foreign key (categoria_padre)
	references categorias(codigo_cat)
);
insert into categorias(nombre,categoria_padre)
values('Materia Prima',null);
insert into categorias(nombre,categoria_padre)
values('Proteina',1);
insert into categorias(nombre,categoria_padre)
values('Salsas',1);
insert into categorias(nombre,categoria_padre)
values('Punto de Venta',null);
insert into categorias(nombre,categoria_padre)
values('Bebidas',4);
insert into categorias(nombre,categoria_padre)
values('Bebidas con alcohol',5);
insert into categorias(nombre,categoria_padre)
values('Bebidas sin alcohol',5);
select * from categorias

--tabla categorias_unidad_medida
drop table if exists categorias_unidad_medida;
create table categorias_unidad_medida(
	codigo char(1)  not null,
	nombre varchar(100) not null,
	constraint categorias_unidad_medida_pk primary key (codigo)
);
insert into categorias_unidad_medida(codigo,nombre)
values('U','Unidades');
insert into categorias_unidad_medida(codigo,nombre)
values('V','Volumen');
insert into categorias_unidad_medida(codigo,nombre)
values('P','Peso');

--select * from categorias_unidad_medida

--tabla unidades_de_medida
drop table if exists unidades_de_medida;
create table unidades_de_medida(
	codigo char(2)  not null,
	descripcion varchar(100) not null,
	categoria_udm char(1) not null,
	constraint unidades_de_medida_pk primary key (codigo),
	constraint unidades_de_medida_fk foreign key (categoria_udm)
	references categorias_unidad_medida(codigo)
);
insert into unidades_de_medida(codigo,descripcion,categoria_udm)
values('ml','mililitros','V');
insert into unidades_de_medida(codigo,descripcion,categoria_udm)
values('l','litros','V');
insert into unidades_de_medida(codigo,descripcion,categoria_udm)
values('u','unidad','U');
insert into unidades_de_medida(codigo,descripcion,categoria_udm)
values('d','docena','U');
insert into unidades_de_medida(codigo,descripcion,categoria_udm)
values('g','gramos','P');
insert into unidades_de_medida(codigo,descripcion,categoria_udm)
values('kg','kilogramos','P');
insert into unidades_de_medida(codigo,descripcion,categoria_udm)
values('lb','libras','P');


--select * from unidades_de_medida

--tabla tipo_de_documentos
drop table if exists tipo_de_documentos;
create table tipo_de_documentos(
	codigo char(1) not null,
	descripcion varchar(10) not null,
	constraint tipo_de_documentos_pk primary key (codigo)
);
insert into tipo_de_documentos(codigo,descripcion)
values('C','CEDULA');
insert into tipo_de_documentos(codigo,descripcion)
values('R','RUC');


--select * from tipo_de_documentos


--tabla productos
drop table if exists productos;
create table productos(
	codigo_producto serial not null,
	nombre varchar(50) not null,
	udm char(2) not null,
	precio_de_venta money not null,
	tiene_iva boolean not null,
	coste money not null,
	categoria int not null,
	stock int not null,
	constraint productos_pk primary key (codigo_producto),
	constraint productos_unidades_fk foreign key (udm)
	references unidades_de_medida(codigo),
	constraint productos_categorias_fk foreign key (categoria)
	references categorias(codigo_cat)
);
insert into productos(nombre,udm,precio_de_venta,tiene_iva,coste,categoria,stock)
values('Coca cola pequeña','u',0.5804,TRUE,0.3729,7,105);
insert into productos(nombre,udm,precio_de_venta,tiene_iva,coste,categoria,stock)
values('Salsa de tomate','kg',0.95,TRUE,0.8736,3,0);
insert into productos(nombre,udm,precio_de_venta,tiene_iva,coste,categoria,stock)
values('Mostaza','kg',0.95,TRUE,0.89,3,0);
insert into productos(nombre,udm,precio_de_venta,tiene_iva,coste,categoria,stock)
values('Fuze Tea','u',0.8,TRUE,0.7,7,49);


select * from productos

--tabla proveedores
drop table if exists proveedores;
create table proveedores(
	identificador varchar(13) not null,
	tipo_de_documento char(1) not null,
	nombre varchar(50) not null,
	telefono char(10) not null,
	correo varchar(50) not null,
	direccion varchar(100) not null,
	constraint proveedores_pk primary key (identificador),
	constraint proveedores_docuemnto_fk foreign key (tipo_de_documento)
	references tipo_de_documentos(codigo)
);
insert into proveedores(identificador,tipo_de_documento,nombre,telefono,correo,direccion)
values('1792285747','C','Santiago Mosquera','0992920306','zantycb89@gmail.com','Cumbayork');
insert into proveedores(identificador,tipo_de_documento,nombre,telefono,correo,direccion)
values('1792285747001','R','Snacks SA','0992928706','snacks@gmail.com','La Tola');

select * from proveedores


--tabla estados_pedido
drop table if exists estados_pedido;
create table estados_pedido(
	codigo char(1) not null,
	descripcion varchar(10) not null,
	constraint estados_pedido_pk primary key (codigo)
);
insert into estados_pedido(codigo,descripcion)
values('S','Solicitado');
insert into estados_pedido(codigo,descripcion)
values('R','Recibido');

--select * from estados_pedido


--tabla cabecera_pedido
drop table if exists cabecera_pedido;
create table cabecera_pedido(
	numero serial not null,
	proveedor varchar(13) not null,
	fecha date not null,
	estado char(1) not null,
	constraint cabecera_pedido_pk primary key (numero),
	constraint cabecera_pedido_estado_fk foreign key (estado)
	references estados_pedido(codigo)
);
insert into cabecera_pedido(proveedor,fecha,estado)
values('1792285747','20/11/2023','R');
insert into cabecera_pedido(proveedor,fecha,estado)
values('1792285747','20/11/2023','R');


select * from cabecera_pedido


--tabla detalle_pedido
drop table if exists detalle_pedido;
create table detalle_pedido(
	codigo serial not null,
	cabecera_pedido int not null,
	producto int not null,
	cantidad_solicitada int not null,
	cantidad_recibida int not null,
	subtotal money not null,
	constraint detalle_pedido_pk primary key (codigo),
	constraint detalle_pedido_cabecera_fk foreign key (cabecera_pedido)
	references cabecera_pedido(numero),
	constraint detalle_pedido_producto_fk foreign key (producto)
	references productos(codigo_producto)
);
insert into detalle_pedido(cabecera_pedido,producto,cantidad_solicitada,cantidad_recibida,subtotal)
values(1,1,100,100,37.29);
insert into detalle_pedido(cabecera_pedido,producto,cantidad_solicitada,cantidad_recibida,subtotal)
values(1,4,50,50,11.8);
insert into detalle_pedido(cabecera_pedido,producto,cantidad_solicitada,cantidad_recibida,subtotal)
values(2,1,10,10,3.73);



select * from detalle_pedido


--tabla cabecera_ventas
drop table if exists cabecera_ventas;
create table cabecera_ventas(
	codigo serial not null,
	fecha TIMESTAMP WITHOUT TIME ZONE not null,
	total_sin_iva money not null,
	iva money not null,
	total money not null,
	constraint cabecera_ventas_pk primary key (codigo)
);
insert into cabecera_ventas(fecha,total_sin_iva,iva,total)
values('20/11/2023 20:00:00',3.26,0.39,3.65);

select * from cabecera_ventas


--tabla detalle_ventas
drop table if exists detalle_ventas;
create table detalle_ventas(
	codigo serial not null,
	cabecera_ventas int not null,
	producto int not null,
	cantidad int not null,
	precio_venta money not null,
	subtotal money not null,
    subtotal_con_iva money not null,
	constraint detalle_ventas_pk primary key (codigo),
	constraint detalle_ventas_cabecera_fk foreign key (cabecera_ventas)
	references cabecera_ventas(codigo),
	constraint detalle_ventas_producto_fk foreign key (producto)
	references productos(codigo_producto)
);
insert into detalle_ventas(cabecera_ventas,producto,cantidad,precio_venta,subtotal,subtotal_con_iva)
values(1,1,5,0.58,2.9,3.25);
insert into detalle_ventas(cabecera_ventas,producto,cantidad,precio_venta,subtotal,subtotal_con_iva)
values(1,4,1,0.36,0.36,0.4);

select * from detalle_ventas


--tabla historial_stock
drop table if exists historial_stock;
create table historial_stock(
	codigo serial not null,
	fecha TIMESTAMP WITHOUT TIME ZONE not null,
	referencia varchar(10) not null,
	producto int not null,
	cantidad int not null,
	constraint historial_stock_pk primary key (codigo),
	constraint historial_stock_producto_fk foreign key (producto)
	references productos(codigo_producto)
);
insert into historial_stock(fecha,referencia,producto,cantidad)
values('20/11/2023 19:59:00','Pedido 1',1,100);
insert into historial_stock(fecha,referencia,producto,cantidad)
values('20/11/2023 19:59:00','Pedido 1',4,50);
insert into historial_stock(fecha,referencia,producto,cantidad)
values('20/11/2023 20:00:00','Pedido 2',1,10);
insert into historial_stock(fecha,referencia,producto,cantidad)
values('20/11/2023 20:00:00','Venta 1',1,-5);
insert into historial_stock(fecha,referencia,producto,cantidad)
values('20/11/2023 20:00:00','Venta 1',4,1);


select * from historial_stock
