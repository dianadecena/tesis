CREATE TABLE IF NOT EXISTS meses(
    id_mes integer,
    nombre_mes varchar(40),
    primary key (id_mes)
);

CREATE TABLE IF NOT EXISTS tiempo_diario(
    id_tiempo serial, 
    dia integer, 
    mes integer, 
    semana integer,
    year integer,
    primary key (id_tiempo)
);

CREATE TABLE IF NOT EXISTS tiempo_mensual(
    id_tiempo serial, 
    id_mes integer,
    year integer, 
    primary key (id_tiempo),
    foreign key (id_mes) references meses
);

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

CREATE TABLE IF NOT EXISTS ataques_bloqueados(
    id_tiempo integer,
    id_caso integer,
    id_ataque integer,
    cant_mensual integer,
    primary key (id_tiempo, id_caso, id_ataque),
    foreign key (id_tiempo) references tiempo_mensual,
    foreign key (id_caso) references casos_seguridad,
    foreign key (id_ataque) references ataque_bloqueado
);

CREATE TABLE IF NOT EXISTS casos_operaciones(
    id_caso serial, 
    nombre_caso varchar(40), 
    primary key (id_caso)
);

CREATE TABLE IF NOT EXISTS operaciones(
    id_tiempo integer,
    id_caso integer,
    cant_mensual integer,
    primary key (id_tiempo, id_caso),
    foreign key (id_tiempo) references tiempo_mensual,
    foreign key (id_caso) references casos_operaciones
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

CREATE TABLE IF NOT EXISTS cambios_seguridad(
    id_tiempo integer,
    id_cambios integer,
    id_caso integer,
    cant_mensual integer,
    primary key (id_tiempo, id_cambios, id_caso),
    foreign key (id_tiempo) references tiempo_mensual,
    foreign key (id_cambios) references cambios,
    foreign key (id_caso) references casos_seguridad
);

CREATE TABLE IF NOT EXISTS incidente(
    id_incidente serial, 
    resuelto boolean, 
    primary key (id_incidente)
);

CREATE TABLE IF NOT EXISTS incidentes(
    id_tiempo integer,
    id_incidente integer,
    cant_mensual integer,
    primary key (id_tiempo, id_incidente),
    foreign key (id_tiempo) references tiempo_mensual,
    foreign key (id_incidente) references incidente
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

CREATE TABLE IF NOT EXISTS datos_tickets(
    id_dato integer,  
    primary key (id_dato)
);

CREATE TABLE IF NOT EXISTS tickets_cerrados(
    id_dato integer,
    id_tiempo integer, 
    id_area integer,
    tiempo_resolucion integer,
    primary key (id_dato, id_tiempo, id_area),
    foreign key (id_dato) references datos_tickets,
    foreign key (id_tiempo) references tiempo_diario,
    foreign key (id_area) references area
);

CREATE TABLE IF NOT EXISTS tickets(
    id_tiempo integer,
    id_area integer, 
    id_ticket integer,
    cant_mensual integer,
    primary key (id_tiempo, id_area, id_ticket),
    foreign key (id_tiempo) references tiempo_mensual,
    foreign key (id_area) references area,
    foreign key (id_ticket) references ticket
);

CREATE TABLE IF NOT EXISTS servidor(
    id_servidor serial, 
    nombre_servidor varchar(30), 
    disponible boolean,
    primary key (id_servidor)
);

CREATE TABLE IF NOT EXISTS disponibilidad_servidores(
    id_tiempo integer,
    id_servidor integer,
    cant_mensual integer,
    primary key (id_tiempo, id_servidor),
    foreign key (id_tiempo) references tiempo_mensual,
    foreign key (id_servidor) references servidor
);

CREATE TABLE IF NOT EXISTS datos_proyectos(
    id_dato integer,  
    primary key (id_dato)
);

CREATE TABLE IF NOT EXISTS proyectos_desarrollo(
    id_tiempo integer,
    id_caso integer,
    cant_mensual integer,
    primary key (id_tiempo, id_caso),
    foreign key (id_tiempo) references tiempo_mensual,
    foreign key (id_caso) references casos_desarrollo
);

CREATE TABLE IF NOT EXISTS proyectos_finalizados(
    id_tiempo integer,
    id_dato integer,
    tiempo_finalizacion integer,
    primary key (id_tiempo, id_dato),
    foreign key (id_tiempo) references tiempo_diario,
    foreign key (id_dato) references datos_proyectos
);

CREATE TABLE IF NOT EXISTS satisfaccion_usuarios(
    id_usuario integer,
    id_area integer, 
    id_tiempo integer,
    cant_mensual integer,
    primary key (id_usuario, id_area, id_tiempo),
    foreign key (id_usuario) references usuario,
    foreign key (id_area) references area,
    foreign key (id_tiempo) references tiempo_mensual
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

INSERT INTO meses (id_mes, nombre_mes) VALUES (1, 'enero');
INSERT INTO meses (id_mes, nombre_mes) VALUES (2, 'febrero');
INSERT INTO meses (id_mes, nombre_mes) VALUES (3, 'marzo');
INSERT INTO meses (id_mes, nombre_mes) VALUES (4, 'abril');
INSERT INTO meses (id_mes, nombre_mes) VALUES (5, 'mayo');
INSERT INTO meses (id_mes, nombre_mes) VALUES (6, 'junio');
INSERT INTO meses (id_mes, nombre_mes) VALUES (7, 'julio');
INSERT INTO meses (id_mes, nombre_mes) VALUES (8, 'agosto');
INSERT INTO meses (id_mes, nombre_mes) VALUES (9, 'septiembre');
INSERT INTO meses (id_mes, nombre_mes) VALUES (10, 'octubre');
INSERT INTO meses (id_mes, nombre_mes) VALUES (11, 'noviembre');
INSERT INTO meses (id_mes, nombre_mes) VALUES (12, 'diciembre');

