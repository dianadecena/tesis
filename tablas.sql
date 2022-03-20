CREATE TABLE IF NOT EXISTS area(
    id_area serial, 
    nombre_area varchar(40), 
    primary key (id_area)
);

CREATE TABLE IF NOT EXISTS ataque_bloqueado(
    id_ataque serial, 
    objetivo varchar(30),
    nivel_amenaza varchar(10),
    herramienta varchar(30),
    primary key (id_ataque)
);

CREATE TABLE IF NOT EXISTS casos_seguridad(
    id_caso serial, 
    nombre_caso varchar(40), 
    primary key (id_caso)
);

CREATE TABLE IF NOT EXISTS casos_operaciones(
    id_caso serial, 
    nombre_caso varchar(40), 
    primary key (id_caso)
);

CREATE TABLE IF NOT EXISTS casos_desarrollo(
    id_caso serial, 
    nombre_caso varchar(40), 
    primary key (id_caso)
);

CREATE TABLE IF NOT EXISTS cambios(
    id_cambios serial, 
    tipo_mesa varchar(40), 
    primary key (id_cambios)
);

CREATE TABLE IF NOT EXISTS incidente(
    id_incidente serial, 
    resuelto boolean, 
    primary key (id_incidente)
);

CREATE TABLE IF NOT EXISTS seguridad(
    id_seguridad serial,  
    id_caso integer,
    primary key (id_seguridad),
    foreign key (id_caso) references casos_seguridad
);

CREATE TABLE IF NOT EXISTS seg_cambios(
	id_seguridad integer,
	id_cambios integer, 
	primary key (id_seguridad, id_cambios),
    foreign key (id_seguridad) references seguridad,
    foreign key (id_cambios) references cambios
);

CREATE TABLE IF NOT EXISTS seg_ataque(
	id_seguridad integer,
	id_ataque integer, 
	primary key (id_seguridad, id_ataque),
    foreign key (id_seguridad) references seguridad,
    foreign key (id_ataque) references ataque_bloqueado
);

CREATE TABLE IF NOT EXISTS seg_incidente(
	id_seguridad integer,
	id_incidente integer, 
	primary key (id_seguridad, id_incidente),
    foreign key (id_seguridad) references seguridad,
    foreign key (id_incidente) references incidente
);

CREATE TABLE IF NOT EXISTS desarrollo(
    id_desarrollo serial, 
    id_caso integer,
    primary key (id_desarrollo),
    foreign key (id_caso) references casos_desarrollo
);

CREATE TABLE IF NOT EXISTS usuario(
    id_usuario serial, 
    nivel_satisfaccion integer, 
    primary key (id_usuario)
);

CREATE TABLE IF NOT EXISTS ticket(
    id_ticket serial, 
    cerrado boolean, 
    primary key (id_ticket)
);

CREATE TABLE IF NOT EXISTS servidor(
    id_servidor serial, 
    nombre_servidor varchar(30),  
    disponible boolean,
    primary key (id_servidor)
);

CREATE TABLE IF NOT EXISTS operaciones(
    id_operaciones serial,   
    id_caso integer,
    primary key (id_operaciones),
    foreign key (id_caso) references casos_operaciones
);

CREATE TABLE IF NOT EXISTS dato_indicador(
    id_dato serial, 
    fecha timestamp,
    fecha_carga timestamp default current_timestamp,  
    id_area integer,
    primary key (id_dato),
    foreign key (id_area) references area
);

CREATE TABLE IF NOT EXISTS dato_seg(
	id_dato integer,
	id_seguridad integer, 
	primary key (id_dato, id_seguridad),
    foreign key (id_dato) references dato_indicador,
    foreign key (id_seguridad) references seguridad
);

CREATE TABLE IF NOT EXISTS dato_des(
	id_dato integer,
	id_desarrollo integer, 
	primary key (id_dato, id_desarrollo),
    foreign key (id_dato) references dato_indicador,
    foreign key (id_desarrollo) references desarrollo
);

CREATE TABLE IF NOT EXISTS dato_op(
	id_dato integer,
	id_operaciones integer, 
	primary key (id_dato, id_operaciones),
    foreign key (id_dato) references dato_indicador,
    foreign key (id_operaciones) references operaciones
);

CREATE TABLE IF NOT EXISTS op_servidor(
	id_operaciones integer,
	id_servidor integer, 
	primary key (id_operaciones, id_servidor),
    foreign key (id_operaciones) references operaciones,
    foreign key (id_servidor) references servidor
);

CREATE TABLE IF NOT EXISTS op_ticket(
	id_operaciones integer,
	id_ticket integer, 
	primary key (id_operaciones, id_ticket),
    foreign key (id_operaciones) references operaciones,
    foreign key (id_ticket) references ticket
);

CREATE TABLE IF NOT EXISTS des_ticket(
	id_desarrollo integer,
	id_ticket integer, 
	primary key (id_desarrollo, id_ticket),
    foreign key (id_desarrollo) references desarrollo,
    foreign key (id_ticket) references ticket
);

CREATE TABLE IF NOT EXISTS op_us(
	id_operaciones integer,
	id_usuario integer, 
	primary key (id_operaciones, id_usuario),
    foreign key (id_operaciones) references operaciones,
    foreign key (id_usuario) references usuario
);

CREATE TABLE IF NOT EXISTS des_us(
	id_desarrollo integer,
	id_usuario integer, 
	primary key (id_desarrollo, id_usuario),
    foreign key (id_desarrollo) references desarrollo,
    foreign key (id_usuario) references usuario
);

CREATE TABLE IF NOT EXISTS seg_us(
	id_seguridad integer,
	id_usuario integer, 
	primary key (id_seguridad, id_usuario),
    foreign key (id_seguridad) references seguridad,
    foreign key (id_usuario) references usuario
);

INSERT INTO area (nombre_area) VALUES ('Desarrollo de Aplicaciones');
INSERT INTO area (nombre_area) VALUES ('Operaciones de Tecnologia');
INSERT INTO area (nombre_area) VALUES ('Seguridad de Informacion');

INSERT INTO casos_seguridad (nombre_caso) VALUES ('Ataque a la Red Bloqueado');
INSERT INTO casos_seguridad (nombre_caso) VALUES ('Ataque de Malware Bloqueado');
INSERT INTO casos_seguridad (nombre_caso) VALUES ('Ataque de Phishing Bloqueado');
INSERT INTO casos_seguridad (nombre_caso) VALUES ('Cambios Implantados');
INSERT INTO casos_seguridad (nombre_caso) VALUES ('Cambios Afectacion Usuarios');
INSERT INTO casos_seguridad (nombre_caso) VALUES ('Incidente de Seguridad');
INSERT INTO casos_seguridad (nombre_caso) VALUES ('Satisfaccion de usuarios');

INSERT INTO casos_operaciones (nombre_caso) VALUES ('Cantidad de tickets creados');
INSERT INTO casos_operaciones (nombre_caso) VALUES ('Cantidad de tickets cerrados');
INSERT INTO casos_operaciones (nombre_caso) VALUES ('Cantidad de impresiones B&N');
INSERT INTO casos_operaciones (nombre_caso) VALUES ('Cantidad de impresiones a color');
INSERT INTO casos_operaciones (nombre_caso) VALUES ('Cantidad de sensores operativos');
INSERT INTO casos_operaciones (nombre_caso) VALUES ('Disponibilidad de servidores');
INSERT INTO casos_operaciones (nombre_caso) VALUES ('Satisfaccion de usuarios');
INSERT INTO casos_operaciones (nombre_caso) VALUES ('Cantidad de sensores con fallas');

INSERT INTO casos_desarrollo (nombre_caso) VALUES ('Casos abiertos');
INSERT INTO casos_desarrollo (nombre_caso) VALUES ('Casos cerrados');
INSERT INTO casos_desarrollo (nombre_caso) VALUES ('Proyectos en desarrollo');
INSERT INTO casos_desarrollo (nombre_caso) VALUES ('Proyectos finalizados');
INSERT INTO casos_desarrollo (nombre_caso) VALUES ('Satisfaccion de usuarios');

INSERT INTO ataque_bloqueado (objetivo, nivel_amenaza, herramienta) VALUES ('Red Perimetral', 'Alto', 'Firewall a nivel de IPS');
INSERT INTO ataque_bloqueado (objetivo, nivel_amenaza, herramienta) VALUES ('Red Perimetral', 'Alto', 'Firewall');
INSERT INTO ataque_bloqueado (objetivo, nivel_amenaza, herramienta) VALUES ('Red Perimetral', 'Medio', 'Firewall a nivel de IPS');
INSERT INTO ataque_bloqueado (objetivo, nivel_amenaza, herramienta) VALUES ('Red Perimetral', 'Medio', 'Firewall');
INSERT INTO ataque_bloqueado (objetivo, nivel_amenaza, herramienta) VALUES ('Red Perimetral', 'Critico', 'Firewall a nivel de IPS');
INSERT INTO ataque_bloqueado (objetivo, nivel_amenaza, herramienta) VALUES ('Red Perimetral', 'Critico', 'Firewall');
INSERT INTO ataque_bloqueado (objetivo, nivel_amenaza, herramienta) VALUES ('Correo Electronico', 'Alto', 'Firewall a nivel de IPS');
INSERT INTO ataque_bloqueado (objetivo, nivel_amenaza, herramienta) VALUES ('Correo Electronico', 'Alto', 'Firewall');
INSERT INTO ataque_bloqueado (objetivo, nivel_amenaza, herramienta) VALUES ('Correo Electronico', 'Medio', 'Firewall a nivel de IPS');
INSERT INTO ataque_bloqueado (objetivo, nivel_amenaza, herramienta) VALUES ('Correo Electronico', 'Medio', 'Firewall');
INSERT INTO ataque_bloqueado (objetivo, nivel_amenaza, herramienta) VALUES ('Correo Electronico', 'Critico', 'Firewall a nivel de IPS');
INSERT INTO ataque_bloqueado (objetivo, nivel_amenaza, herramienta) VALUES ('Correo Electronico', 'Critico', 'Firewall');

INSERT INTO cambios (tipo_mesa) VALUES ('Mesa de Cambio Presencial');
INSERT INTO cambios (tipo_mesa) VALUES ('Mesa de Cambios Informativos');

INSERT INTO incidente (resuelto) VALUES (True);
INSERT INTO incidente (resuelto) VALUES (False);

INSERT INTO ticket (cerrado) VALUES (True);
INSERT INTO ticket (cerrado) VALUES (False);

INSERT INTO usuario (nivel_satisfaccion) VALUES (1);
INSERT INTO usuario (nivel_satisfaccion) VALUES (2);
INSERT INTO usuario (nivel_satisfaccion) VALUES (3);
INSERT INTO usuario (nivel_satisfaccion) VALUES (4);
INSERT INTO usuario (nivel_satisfaccion) VALUES (5);

INSERT INTO servidor (nombre_servidor, disponible) VALUES ('Servidor V1', True);
INSERT INTO servidor (nombre_servidor, disponible) VALUES ('Servidor V1', False);
INSERT INTO servidor (nombre_servidor, disponible) VALUES ('Servidor C1', True);
INSERT INTO servidor (nombre_servidor, disponible) VALUES ('Servidor C1', False);

