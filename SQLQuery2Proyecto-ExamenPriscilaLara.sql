--Creating a database for a university--

Create database db_Universidad_Occidente 
go
--Code for using the University database--

Use db_Universidad_Occidente
go


--Code to create the tables that the University will have--
-- =====================
-- Faculty --
-- =====================

create table facultad (
codigo_facultad smallint primary key,
nombre varchar(50) not null,
decano varchar(80) not null,
edificio char(50) not null
);
go
 
-- =====================
-- Degree Program --
-- =====================

create table carrera (
codigo_carrera smallint primary key,
codigo_facultad int not null,
nombre varchar(60) not null,
duracion_carrera_años int not null,
modalidad char(15) not null
);
go
 
-- =====================
-- Professor --
-- =====================

create table profesor (
codigo_profesor int primary key,
codigo_carrera int not null,
nombre varchar(30) not null,
apellidos varchar(50) not null,
email varchar(80) not null,
telefono char(8) not null,
fecha_de_nacimiento date not null
);
go
 
-- =====================
-- Course --
-- =====================

create table curso (
codigo_curso smallint primary key,
codigo_profesor int not null,
nombre varchar(50) not null,
creditos int not null
);
go
 
-- =====================
-- Student --
-- =====================

create table estudiante (
codigo_estudiante int primary key,
codigo_carrera int not null,
identificacion char(9) not null,
nombre varchar(30) not null,
apellidos varchar(50) not null,
fecha_de_nacimiento date not null,
direccion varchar(120),
email varchar(80) not null,
telefono char(8),
fecha_de_ingreso date not null
);
go
 
-- =====================
-- Registration --
-- =====================

create table matricula (
codigo_matricula int primary key,
codigo_estudiante int not null,
codigo_curso int not null,
fecha_de_matricula date not null,
periodo char(6) not null,
calificaciones decimal (5,2)
);
go

-------------------------------------------------------------------------------------
-- VIEW 1--
-- Displays the faculties, the degree programs offered by each faculty, and the corresponding dean.

create view Vista_RelacionFacultadesCarreras
as select 
f.nombre as facultad,
c.nombre as carrera, 
f.decano
from facultad f 
inner join carrera c 
on c.codigo_facultad = f.codigo_facultad;
go 

select*from Vista_RelacionFacultadesCarreras;
go


-- VIEW 2--
-- Displays faculties, degree programs, and their corresponding students --

create view Vista_RelacionFacultadesCarrerasEstudiantes
as select 
f.nombre as facultad,
c.nombre as carrera, 
e.nombre,
e.apellidos
from estudiante e 
inner join carrera c 
on e.codigo_carrera = c.codigo_carrera
inner join facultad f 
on c.codigo_facultad = f.codigo_facultad;
go 

select*from Vista_RelacionFacultadesCarrerasEstudiantes;
go

-- VIEW 3--
-- Displays courses, their assigned professors, and the degree programs they belong to --

create view Vista_RelacionCursosProfesoresCarreras
as select 
cu.nombre as curso,
p.nombre,
p.apellidos,
c.nombre as carrera
from curso cu 
inner join profesor p
on cu.codigo_profesor = p.codigo_profesor
inner join carrera c
on p.codigo_carrera = c.codigo_carrera;
go 

select*from Vista_RelacionCursosProfesoresCarreras;
go

-- VIEW 4--
-- Displays the academic workload assigned to each professor --

create view Vista_CargaAcademicaProfesores
as select 
p.nombre, 
p.apellidos,
count (c.codigo_curso) as Cantidad_Cursos,
Sum (c.creditos) as Total_Creditos
from profesor p 
inner join curso c
on p.codigo_profesor = c.codigo_profesor
group by 
p.nombre, p.apellidos;
go 

select*from Vista_CargaAcademicaProfesores;
go

-- VIEW 5--
-- Displays each student's academic history --

create view Vista_HistorialAcademicoEstudiantes
as select 
e.nombre,
e.apellidos,
c.nombre as curso,
m.periodo,
m.calificaciones
from estudiante e 
inner join matricula m
on e.codigo_estudiante = m.codigo_estudiante
inner join curso c
on m.codigo_curso = c.codigo_curso;
go 

select*from Vista_HistorialAcademicoEstudiantes;
go

-- VIEW 6--
-- Displays students with pending grades in their enrolled courses --


create view vista_NotasPendientes
as select
e.nombre, e.apellidos,
c.nombre as curso,
m.periodo,
m.calificaciones
from estudiante e
inner join matricula m
on e.codigo_estudiante = m.codigo_estudiante
inner join curso c
on m.codigo_curso = c.codigo_curso
where m.calificaciones is null;
go

select*from vista_NotasPendientes;
go

-------------------------------------------------------------------------------------

-- SELECT--
-- Displays all records stored in the Faculty table --

select * from facultad 
go

-- Displays only the faculty code and dean records stored in the Faculty table --

select codigo_facultad,decano 
from facultad; 
go

-------------------------------------------------------------------------------------

-- Displays all records stored in the Degree Program table --

select * from carrera 
go

-- Displays only the career code and name records stored in the Degree Program table --

select codigo_carrera,nombre 
from carrera; 
go

-- DISTINCT --
-- Displays the available study options for each degree program --

select distinct modalidad
from carrera;
go

-- LIKE --
-- Displays degrees program that begins with 'Me' --

select nombre
from carrera
where nombre like 'Me%';
go

-------------------------------------------------------------------------------------

-- Displays all records stored in the Professor table --

select * from profesor 
go

-- Displays only the professor code and name records stored in the Professor table --

select codigo_profesor,nombre 
from profesor; 
go

-- TOP --
-- Displays the 5 youngest professors according to their date of birth --

select top 5 *
from profesor
order by fecha_de_nacimiento desc; 
go

-------------------------------------------------------------------------------------

-- Displays all records stored in the Course table --

select * from curso 
go

-- Displays only the course code and name records stored in the Course table --

select codigo_curso,nombre 
from curso; 
go

-- NOT --
-- Displays only the course code, name and credits of courses that do not have 4 credits --

select codigo_curso,nombre, creditos 
from curso
where not creditos = 4;
go

-- SUM --
--Displays the total number of credits taught by each professor --

select codigo_profesor,
sum (creditos) as Total_Creditos
from curso
group by codigo_profesor;
go


-------------------------------------------------------------------------------------

-- Displays all records stored in the student table --

select * from estudiante 
go

-- Displays only the id and name records stored in the student table --

select identificacion,nombre 
from estudiante;
go

-- WHERE --
-- Displays an ID and name that belongs to the student indicated in the code --

select identificacion, nombre
from estudiante
where nombre = 'Maria';
go

-- ORDER BY --
-- Displays name, last name and date of entry and groups the data by date of entry --

select nombre, apellidos, fecha_de_ingreso
from estudiante
order by fecha_de_ingreso desc;
go

-- LIKE --
-- Displays the names of students that end with 'N' --

select nombre
from estudiante
where nombre like '%N';
go

-- IN --
-- Displays name, last name and degree program code --
-- of those that have degree program code 109, 115 and 118 --

select nombre, apellidos, codigo_carrera
from estudiante
where codigo_carrera in (109,115,118);
go

-- AND --
-- Displays name, address and degree program code --
-- of those that have degree program code 109 and address is 'Heredia' --

select nombre, direccion, codigo_carrera
from estudiante
where codigo_carrera = 109 and direccion like '%Heredia%';
go

-- OR --
-- Displays name, address and degree program code --
-- of those that have degree program code 101 or degree program code 117 --

select nombre, direccion, codigo_carrera
from estudiante
where codigo_carrera = 101 or codigo_carrera = 117;
go

-- COUNT --
-- Displays the total number of students registered in the students table --

select count (*) as Total_Estudiantes
from estudiante;
go

-------------------------------------------------------------------------------------

-- Displays all records stored in the Registration table --

select * from matricula; 
go

-- Displays only the period and grades records stored in the Registration table --

select periodo,calificaciones 
from matricula;
go

-- IS NULL --
-- Displays an ID, name, and phone number from the table where the phone number is null --

select codigo_matricula, codigo_estudiante, calificaciones
from matricula
where calificaciones is null;
go

-- IS NOT NULL --
-- Displays an ID, name, and phone number from the table where the phone number is not null --

select codigo_matricula, codigo_estudiante, calificaciones
from matricula
where calificaciones is not null;
go

-- WHERE --
-- Displays registration code, registration date and grades where the grade is >= to 90 --

select codigo_matricula,fecha_de_matricula, calificaciones 
from matricula
where calificaciones >= 90;
go

-- NOT --
-- Displays registration code, registration date and grades where the grade is not 90 --

select codigo_matricula,fecha_de_matricula, calificaciones 
from matricula
where not calificaciones = 90;
go

-- BETWEEN --
-- Displays registration code, registration date and grades where the grades are between 70 and 75 --

select codigo_matricula,fecha_de_matricula, calificaciones 
from matricula
where calificaciones between 70 and 75;
go

-- GROUP BY --
-- Displays the total number of enrolled students, by course code --

select codigo_curso, 
count(*) as Total_Matriculados
from matricula
group by codigo_curso;
go


-- HAVING --
-- Displays courses that have more than 5 enrolled students --

select codigo_curso, 
count(*) as Total_Matriculados
from matricula
group by codigo_curso
having count (*) > 5;
go

-- AVG --
-- Displays the average grades obtained in each course -- 

select codigo_curso, 
avg(calificaciones) as Promedio_Notas_Curso
from matricula
group by codigo_curso;
go

-- MIN --
-- Displays the lowest grade obtained in each course --

select codigo_curso, 
min(calificaciones) as Notas_Minimas_Curso
from matricula
group by codigo_curso;
go

-- MAX --
-- Displays the highest grade obtained in each course --

select codigo_curso, 
max(calificaciones) as Notas_Maximas_Curso
from matricula
group by codigo_curso;
go

-------------------------------------------------------------------------------------
-- INNER JOIN --
-- Displays students the courses they are enrolled in and their grades --

select 
e.nombre, 
e.apellidos, 
c.nombre as Nombre_del_Curso, m.calificaciones
from estudiante e
inner join matricula m 
on e.codigo_estudiante = m.codigo_estudiante 
inner join curso c 
on m.codigo_curso = c.codigo_curso;
go

-- INNER JOIN --
-- Displays the professors and the degree program that they are assigned to --

select 
p.nombre,
p.apellidos, 
c.nombre as Carrera_Asignada
from profesor p
inner join carrera c
on p.codigo_carrera = c.codigo_carrera;
go

-------------------------------------------------------------------------------------
-- LEFT JOIN --
-- Displays students who do not have any registrations --

select 
e.nombre,
e.apellidos 
from estudiante e
left join matricula m
on e.codigo_estudiante = m.codigo_estudiante
where m.codigo_matricula is null;
go

-- LEFT JOIN -- 
-- Displays students enrolled in courses that do not yet have assigned grades --

select 
e.nombre,
e.apellidos, 
c.nombre as Nombre_de_Curso, M.calificaciones
from estudiante e
left join matricula m
on e.codigo_estudiante = m.codigo_estudiante
left join curso c
on m.codigo_curso = c.codigo_curso
where m.calificaciones is null;
go

-------------------------------------------------------------------------------------
-- RIGHT JOIN --
-- Displays all courses and the students enrolled in them --

select 
c.nombre as Nombre_de_Curso, 
e.nombre, 
e.apellidos
from estudiante e
right join matricula m
on e.codigo_estudiante = m.codigo_estudiante
right join curso c
on m.codigo_curso = c.codigo_curso
go

-------------------------------------------------------------------------------------
-- SUBQUERY --
-- Displays students that their grades are above the overall average --

select 
codigo_estudiante,
calificaciones
from matricula
where calificaciones >
(select avg(calificaciones)
from matricula); 
go

-- SUBQUERY --
-- Displays which students obtained the highest grade and in which course they obtained it --

select
e.nombre,
e.apellidos, 
c.nombre as Nombre_de_Curso, M.calificaciones
from estudiante e
inner join matricula m
on e.codigo_estudiante = m.codigo_estudiante
inner join curso c
on m.codigo_curso = c.codigo_curso
where calificaciones =
(select max(calificaciones)
from matricula);
go

-------------------------------------------------------------------------------------

-- Commands to insert data into table Faculty --

insert into facultad values
(1,'Facultad de Ingeniería','Carlos Rodríguez','Edificio A'),
(2,'Facultad de Ciencias Económicas','Ana Martínez','Edificio B'),
(3,'Facultad de Educación','Luis Vargas','Edificio C'),
(4,'Facultad de Ciencias de la Salud','María López','Edificio D'),
(5,'Facultad de Artes y Diseño','Pedro Jiménez','Edificio E'),
(6,'Facultad de Derecho','José Castro','Edificio F'),
(7,'Facultad de Arquitectura','Sofía Ramírez','Edificio G'),
(8,'Facultad de Turismo','Laura Méndez','Edificio H'),
(9,'Facultad de Idiomas','Andrés Vega','Edificio I'),
(10,'Facultad de Psicología','Patricia Solís','Edificio J');
go

-- Commands to insert data into table Degree Program --

insert into carrera values
(101,1,'Ingeniería en Sistemas',5,'Presencial'),
(102,1,'Ingeniería Industrial',5,'Presencial'),
(103,1,'Ingeniería Civil',5,'Presencial'),
(104,2,'Administración de Empresas',4,'Virtual'),
(105,2,'Contabilidad',4,'Presencial'),
(106,2,'Mercadeo',4,'Hibrida'),
(107,3,'Educación Primaria',4,'Presencial'),
(108,3,'Educación Preescolar',4,'Presencial'),
(109,4,'Enfermería',5,'Presencial'),
(110,4,'Medicina',7,'Presencial'),
(111,5,'Diseño Gráfico',4,'Hibrida'),
(112,5,'Diseño Publicitario',4,'Presencial'),
(113,6,'Derecho',5,'Presencial'),
(114,6,'Criminología',4,'Presencial'),
(115,7,'Arquitectura',5,'Presencial'),
(116,8,'Gestión Turística',4,'Hibrida'),
(117,8,'Hotelería',4,'Presencial'),
(118,9,'Inglés',4,'Presencial'),
(119,9,'Francés',4,'Presencial'),
(120,10,'Psicología',5,'Presencial');
go

-- Commands to insert data into table Professor --

insert into profesor values
(201,101,'Juan','Pérez','juan.perez@uo.ac.cr','88881111','1980-05-10'),
(202,101,'Laura','Gómez','laura.gomez@uo.ac.cr','88882222','1982-03-12'),
(203,102,'Carlos','Soto','carlos.soto@uo.ac.cr','88883333','1979-06-21'),
(204,102,'Daniela','Vega','daniela.vega@uo.ac.cr','88884444','1985-01-14'),
(205,103,'Mario','Jiménez','mario.jimenez@uo.ac.cr','88885555','1981-04-11'),
(206,104,'Sandra','Rojas','sandra.rojas@uo.ac.cr','88886666','1983-07-18'),
(207,105,'Roberto','Castro','roberto.castro@uo.ac.cr','88887777','1978-09-09'),
(208,106,'Patricia','León','patricia.leon@uo.ac.cr','88888888','1984-02-15'),
(209,107,'Fernando','Araya','fernando.araya@uo.ac.cr','89991111','1986-08-04'),
(210,108,'Gloria','Mora','gloria.mora@uo.ac.cr','89992222','1980-11-20'),
(211,109,'José','Navarro','jose.navarro@uo.ac.cr','89993333','1982-01-08'),
(212,110,'Paola','Solano','paola.solano@uo.ac.cr','89994444','1987-10-30'),
(213,111,'Ricardo','Salas','ricardo.salas@uo.ac.cr','89995555','1977-03-27'),
(214,112,'Andrea','Campos','andrea.campos@uo.ac.cr','89996666','1983-05-16'),
(215,113,'Víctor','Chaves','victor.chaves@uo.ac.cr','89997777','1981-12-09'),
(216,114,'Karen','Ramírez','karen.ramirez@uo.ac.cr','89998888','1985-06-02'),
(217,115,'David','Ortiz','david.ortiz@uo.ac.cr','81111111','1986-04-22'),
(218,116,'Adriana','Fonseca','adriana.fonseca@uo.ac.cr','82222222','1984-08-14'),
(219,117,'Gabriel','Valverde','gabriel.valverde@uo.ac.cr','83333333','1982-07-05'),
(220,118,'Mónica','Ruiz','monica.ruiz@uo.ac.cr','84444444','1980-09-17'),
(221,119,'Luis','Porras','luis.porras@uo.ac.cr','85555555','1983-11-01'),
(222,120,'Natalia','Murillo','natalia.murillo@uo.ac.cr','86666666','1986-02-28'),
(223,101,'Jorge','Vargas','jorge.vargas@uo.ac.cr','87777777','1981-10-10'),
(224,104,'Melissa','Arias','melissa.arias@uo.ac.cr','88889999','1987-01-19'),
(225,110,'Esteban','Méndez','esteban.mendez@uo.ac.cr','89990000','1979-05-30');
go


-- Commands to insert data into table Course --

insert into curso values
(301,201,'Programacion I',4),
(302,201,'Bases de Datos I',4),
(303,201,'Programacion II',4),
(304,203,'Estadistica',3),
(305,203,'Calculo I',4),
(306,206,'Administracion General',3),
(307,206,'Finanzas Empresariales',4),
(308,207,'Contabilidad General',4),
(309,207,'Auditoria I',4),
(310,208,'Mercadeo I',3),
(311,208,'Mercadeo Digital',4),
(312,209,'Didactica General',4),
(313,210,'Desarrollo Infantil',3),
(314,211,'Anatomia Humana',5),
(315,211,'Biologia General',4),
(316,212,'Fundamentos de Medicina',5),
(317,213,'Diseno Digital',4),
(318,214,'Publicidad Creativa',4),
(319,215,'Derecho Civil',4),
(320,216,'Criminologia General',4),
(321,217,'Diseno Arquitectonico',5),
(322,218,'Gestion Hotelera',4),
(323,219,'Administracion Turistica',4),
(324,220,'Ingles Conversacional',4),
(325,220,'Frances Basico',4);
go 

insert into curso values
(326,225,'Ecologia',4);
go


 -- Commands to insert data into table Student --

insert into estudiante values
(1001,101,'101000001','Maria','Porras','2003-01-10','Heredia','maria@correo.com','70000001','2023-02-01'),
(1002,101,'101000002','Ana','Rojas','2002-05-14','Alajuela','ana@correo.com','70000002','2023-02-01'),
(1003,101,'101000003','Luis','Mora','2001-03-12','Cartago','luis@correo.com','70000003','2022-02-01'),
(1004,102,'101000004','Carlos','Leon','2000-07-20','San Jose','carlos@correo.com','70000004','2021-02-01'),
(1005,102,'101000005','Laura','Campos','2003-08-25','Heredia','laura@correo.com','70000005','2023-02-01'),
(1006,103,'101000006','Jorge','Solis','2002-10-11','Alajuela','jorge@correo.com','70000006','2022-02-01'),
(1007,103,'101000007','Pamela','Vega','2001-06-19','Heredia','pamela@correo.com','70000007','2021-02-01'),
(1008,104,'101000008','Diego','Araya','2000-11-02','Cartago','diego@correo.com','70000008','2020-02-01'),
(1009,104,'101000009','Valeria','Jimenez','2003-12-05','San Jose','valeria@correo.com','70000009','2023-02-01'),
(1010,105,'101000010','Esteban','Castro','2002-04-15','Heredia','esteban@correo.com','70000010','2022-02-01'),
(1011,105,'101000011','Daniel','Ortiz','2001-01-01','Heredia','daniel@correo.com','70000011','2021-02-01'),
(1012,106,'101000012','Andrea','Ruiz','2002-02-02','Alajuela','andrea@correo.com','70000012','2022-02-01'),
(1013,106,'101000013','Fernanda','Salas','2000-09-09','Cartago','fernanda@correo.com','70000013','2020-02-01'),
(1014,107,'101000014','Kevin','Soto','2003-03-03','San Jose','kevin@correo.com','70000014','2023-02-01'),
(1015,107,'101000015','Gabriela','Mora','2001-08-08','Heredia','gabriela@correo.com','70000015','2021-02-01'),
(1016,108,'101000016','Cristian','Ramirez','2002-07-07','Alajuela','cristian@correo.com','70000016','2022-02-01'),
(1017,108,'101000017','Tatiana','Vargas','2000-10-10','Cartago','tatiana@correo.com','70000017','2020-02-01'),
(1018,109,'101000018','Miguel','Navarro','2003-05-05','Heredia','miguel@correo.com','70000018','2023-02-01'),
(1019,109,'101000019','Paola','Chaves','2002-06-06','San Jose','paola@correo.com','70000019','2022-02-01'),
(1020,110,'101000020','Ricardo','Perez','2001-04-04','Cartago','ricardo@correo.com','70000020','2021-02-01'),
(1021,110,'101000021','Melissa','Rojas','2002-11-11','Heredia','melissa@correo.com','70000021','2022-02-01'),
(1022,111,'101000022','Jose','Campos','2003-09-01','Alajuela','jose@correo.com','70000022','2023-02-01'),
(1023,111,'101000023','Carolina','Vega','2000-12-12','Cartago','carolina@correo.com','70000023','2020-02-01'),
(1024,112,'101000024','Andres','Leon','2001-07-17','San Jose','andres@correo.com','70000024','2021-02-01'),
(1025,112,'101000025','Natalia','Solano','2002-03-22','Heredia','natalia@correo.com','70000025','2022-02-01'),
(1026,113,'101000026','Julio','Castro','2002-01-15','Heredia','julio@correo.com','70000026','2022-02-01'),
(1027,113,'101000027','Sofia','Jimenez','2002-02-15','Alajuela','sofia@correo.com','70000027','2022-02-01'),
(1028,114,'101000028','Fernando','Ruiz','2001-03-14','Cartago','fernando@correo.com','70000028','2021-02-01'),
(1029,114,'101000029','Monica','Campos','2000-04-11','Heredia','monica@correo.com','70000029','2020-02-01'),
(1030,115,'101000030','David','Mendez','2003-05-02','San Jose','david@correo.com','70000030','2023-02-01'),
(1031,115,'101000031','Karen','Araya','2002-04-20','Heredia','karen@correo.com','70000031','2022-02-01'),
(1032,116,'101000032','Adriana','Salas','2001-07-18','Cartago','adriana@correo.com','70000032','2021-02-01'),
(1033,116,'101000033','Gabriel','Vargas','2000-08-18','Alajuela','gabriel@correo.com','70000033','2020-02-01'),
(1034,117,'101000034','Luis','Porras','2003-03-30','Heredia','luis@correo.com','70000034','2023-02-01'),
(1035,117,'101000035','Paula','Murillo','2002-10-01','San Jose','paula@correo.com','70000035','2022-02-01'),
(1036,118,'101000036','Oscar','Fonseca','2001-06-12','Cartago','oscar@correo.com','70000036','2021-02-01'),
(1037,118,'101000037','Melissa','Lopez','2000-04-25','Heredia','melissal@correo.com','70000037','2020-02-01'),
(1038,119,'101000038','Victor','Sanchez','2003-08-14','Alajuela','victor@correo.com','70000038','2023-02-01'),
(1039,119,'101000039','Daniela','Ramirez','2002-01-29','Heredia','daniela@correo.com','70000039','2022-02-01'),
(1040,120,'101000040','Ricardo','Jimenez','2001-09-11','San Jose','ricardoj@correo.com','70000040','2021-02-01'),
(1041,120,'101000041','Andrea','Arce','2002-07-03','Heredia','andreaa@correo.com','70000041','2022-02-01'),
(1042,101,'101000042','Javier','Vega','2003-10-08','Alajuela','javier@correo.com','70000042','2023-02-01'),
(1043,102,'101000043','Mariana','Soto','2002-09-01','Cartago','mariana@correo.com','70000043','2022-02-01'),
(1044,103,'101000044','Pablo','Mora','2001-12-16','San Jose','pablo@correo.com','70000044','2021-02-01'),
(1045,104,'101000045','Vanessa','Rojas','2000-05-20','Heredia','vanessa@correo.com','70000045','2020-02-01'),
(1046,105,'101000046','Mauricio','Campos','2003-11-11','Alajuela','mauricio@correo.com','70000046','2023-02-01'),
(1047,106,'101000047','Gabriela','Leiva','2002-04-28','Cartago','gabrielal@correo.com','70000047','2022-02-01'),
(1048,107,'101000048','Daniel','Valverde','2001-01-21','Heredia','danielv@correo.com','70000048','2021-02-01'),
(1049,108,'101000049','Carla','Ortiz','2000-02-01','San Jose','carla@correo.com','70000049','2020-02-01'),
(1050,109,'101000050','Steven','Arias','2003-06-06','Heredia','steven@correo.com','70000050','2023-02-01');
go

insert into estudiante values
(1051,101,'101000051','Kevin','Rojas','2003-03-15','Heredia','kevin@correo.com','70000051','2023-02-01'),
(1052,102,'101000052','Lucia','Vega','2002-08-20','Alajuela','lucia@correo.com','70000052','2023-02-01');
go


-- Commands to insert data into table Registration --

insert into matricula values
(5001,1001,301,'2026-01-15','I2026',95),
(5002,1001,302,'2026-01-15','I2026',88),
(5003,1002,301,'2026-01-16','I2026',78),
(5004,1002,303,'2026-01-16','I2026',84),
(5005,1003,302,'2026-01-17','I2026',91),
(5006,1003,304,'2026-01-17','I2026',86),
(5007,1004,303,'2026-01-18','I2026',72),
(5008,1004,305,'2026-01-18','I2026',89),
(5009,1005,304,'2026-01-19','I2026',96),
(5010,1005,306,'2026-01-19','I2026',92),
(5011,1006,305,'2026-01-20','I2026',81),
(5012,1006,307,'2026-01-20','I2026',85),
(5013,1007,306,'2026-01-21','I2026',90),
(5014,1007,308,'2026-01-21','I2026',87),
(5015,1008,307,'2026-01-22','I2026',76),
(5016,1008,309,'2026-01-22','I2026',79),
(5017,1009,308,'2026-01-23','I2026',93),
(5018,1009,310,'2026-01-23','I2026',95),
(5019,1010,309,'2026-01-24','I2026',82),
(5020,1010,311,'2026-01-24','I2026',88),
(5021,1011,310,'2026-01-25','I2026',NULL),
(5022,1011,312,'2026-01-25','I2026',91),
(5023,1012,311,'2026-01-26','I2026',74),
(5024,1012,313,'2026-01-26','I2026',80),
(5025,1013,312,'2026-01-27','I2026',85),
(5026,1013,314,'2026-01-27','I2026',90),
(5027,1014,313,'2026-01-28','I2026',98),
(5028,1014,315,'2026-01-28','I2026',93),
(5029,1015,314,'2026-01-29','I2026',78),
(5030,1015,316,'2026-01-29','I2026',82),
(5031,1016,315,'2026-01-30','I2026',88),
(5032,1016,317,'2026-01-30','I2026',84),
(5033,1017,316,'2026-01-31','I2026',69),
(5034,1017,318,'2026-01-31','I2026',76),
(5035,1018,317,'2026-02-01','I2026',91),
(5036,1018,319,'2026-02-01','I2026',89),
(5037,1019,318,'2026-02-02','I2026',75),
(5038,1019,320,'2026-02-02','I2026',87),
(5039,1020,319,'2026-02-03','I2026',94),
(5040,1020,321,'2026-02-03','I2026',90),
(5041,1021,320,'2026-02-04','I2026',83),
(5042,1021,322,'2026-02-04','I2026',85),
(5043,1022,321,'2026-02-05','I2026',97),
(5044,1022,323,'2026-02-05','I2026',96),
(5045,1023,322,'2026-02-06','I2026',71),
(5046,1023,324,'2026-02-06','I2026',78),
(5047,1024,323,'2026-02-07','I2026',86),
(5048,1024,325,'2026-02-07','I2026',89),
(5049,1025,324,'2026-02-08','I2026',92),
(5050,1025,301,'2026-02-08','I2026',90),
(5051,1026,325,'2026-02-09','I2026',88),
(5052,1026,302,'2026-02-09','I2026',84),
(5053,1027,301,'2026-02-10','I2026',79),
(5054,1027,303,'2026-02-10','I2026',81),
(5055,1028,302,'2026-02-11','I2026',85),
(5056,1028,304,'2026-02-11','I2026',87),
(5057,1029,303,'2026-02-12','I2026',73),
(5058,1029,305,'2026-02-12','I2026',80),
(5059,1030,304,'2026-02-13','I2026',95),
(5060,1030,306,'2026-02-13','I2026',98),
(5061,1031,305,'2026-02-14','I2026',82),
(5062,1031,307,'2026-02-14','I2026',84),
(5063,1032,306,'2026-02-15','I2026',76),
(5064,1032,308,'2026-02-15','I2026',79),
(5065,1033,307,'2026-02-16','I2026',91),
(5066,1033,309,'2026-02-16','I2026',93),
(5067,1034,308,'2026-02-17','I2026',89),
(5068,1034,310,'2026-02-17','I2026',87),
(5069,1035,309,'2026-02-18','I2026',65),
(5070,1035,311,'2026-02-18','I2026',72),
(5071,1036,310,'2026-02-19','I2026',94),
(5072,1036,312,'2026-02-19','I2026',96),
(5073,1037,311,'2026-02-20','I2026',77),
(5074,1037,313,'2026-02-20','I2026',80),
(5075,1038,312,'2026-02-21','I2026',86),
(5076,1038,314,'2026-02-21','I2026',88),
(5077,1039,313,'2026-02-22','I2026',90),
(5078,1039,315,'2026-02-22','I2026',92),
(5079,1040,314,'2026-02-23','I2026',84),
(5080,1040,316,'2026-02-23','I2026',81),
(5081,1041,315,'2026-02-24','I2026',96),
(5082,1041,317,'2026-02-24','I2026',98),
(5083,1042,316,'2026-02-25','I2026',70),
(5084,1042,318,'2026-02-25','I2026',75),
(5085,1043,317,'2026-02-26','I2026',82),
(5086,1043,319,'2026-02-26','I2026',86),
(5087,1044,318,'2026-02-27','I2026',91),
(5088,1044,320,'2026-02-27','I2026',94),
(5089,1045,319,'2026-02-28','I2026',87),
(5090,1045,321,'2026-02-28','I2026',85),
(5091,1046,320,'2026-03-01','I2026',90),
(5092,1046,322,'2026-03-01','I2026',88),
(5093,1047,321,'2026-03-02','I2026',78),
(5094,1047,323,'2026-03-02','I2026',82),
(5095,1048,322,'2026-03-03','I2026',93),
(5096,1048,324,'2026-03-03','I2026',95),
(5097,1049,323,'2026-03-04','I2026',84),
(5098,1049,325,'2026-03-04','I2026',86),
(5099,1050,324,'2026-03-05','I2026',89),
(5100,1050,301,'2026-03-05','I2026',91),
(5101,1001,323,'2026-03-06','I2026',92),
(5102,1002,321,'2026-03-06','I2026',85),
(5103,1003,325,'2026-03-06','I2026',89),
(5104,1004,307,'2026-03-07','I2026',81),
(5105,1005,308,'2026-03-07','I2026',94),
(5106,1006,320,'2026-03-08','I2026',NULL),
(5107,1007,321,'2026-03-08','I2026',88),
(5108,1008,322,'2026-03-08','I2026',74),
(5109,1009,323,'2026-03-09','I2026',97),
(5110,1010,324,'2026-03-09','I2026',91),
(5111,1011,325,'2026-03-10','I2026',NULL),
(5112,1012,301,'2026-03-10','I2026',83),
(5113,1013,302,'2026-03-10','I2026',87),
(5114,1014,303,'2026-03-11','I2026',99),
(5115,1015,304,'2026-03-11','I2026',80),
(5116,1016,305,'2026-03-12','I2026',86),
(5117,1017,306,'2026-03-12','I2026',NULL),
(5118,1018,307,'2026-03-12','I2026',90),
(5119,1019,308,'2026-03-13','I2026',78),
(5120,1020,309,'2026-03-13','I2026',95),
(5121,1021,310,'2026-03-14','I2026',88),
(5122,1022,311,'2026-03-14','I2026',97),
(5123,1023,312,'2026-03-14','I2026',NULL),
(5124,1024,313,'2026-03-15','I2026',91),
(5125,1025,314,'2026-03-15','I2026',84),
(5126,1026,315,'2026-03-16','I2026',86),
(5127,1027,316,'2026-03-16','I2026',79),
(5128,1028,317,'2026-03-16','I2026',93),
(5129,1029,318,'2026-03-17','I2026',75),
(5130,1030,319,'2026-03-17','I2026',98),
(5131,1031,320,'2026-03-18','I2026',89),
(5132,1032,321,'2026-03-18','I2026',NULL),
(5133,1033,322,'2026-03-18','I2026',95),
(5134,1034,323,'2026-03-19','I2026',87),
(5135,1035,324,'2026-03-19','I2026',72),
(5136,1036,325,'2026-03-20','I2026',97),
(5137,1037,301,'2026-03-20','I2026',81),
(5138,1038,302,'2026-03-20','I2026',90),
(5139,1039,303,'2026-03-21','I2026',93),
(5140,1040,304,'2026-03-21','I2026',85),
(5141,1041,305,'2026-03-22','I2026',99),
(5142,1042,306,'2026-03-22','I2026',76),
(5143,1043,307,'2026-03-22','I2026',88),
(5144,1044,308,'2026-03-23','I2026',94),
(5145,1045,309,'2026-03-23','I2026',82),
(5146,1046,310,'2026-03-24','I2026',91),
(5147,1047,311,'2026-03-24','I2026',77),
(5148,1048,312,'2026-03-24','I2026',96),
(5149,1049,313,'2026-03-25','I2026',85),
(5150,1050,314,'2026-03-25','I2026',92);
go
