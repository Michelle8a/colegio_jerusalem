-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Sep 15, 2025 at 09:43 PM
-- Server version: 9.1.0
-- PHP Version: 8.3.14

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jerusalem_colegio`
--
CREATE DATABASE IF NOT EXISTS `jerusalem_colegio` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `jerusalem_colegio`;

-- --------------------------------------------------------

--
-- Table structure for table `alertas`
--

DROP TABLE IF EXISTS `alertas`;
CREATE TABLE IF NOT EXISTS `alertas` (
  `id_alerta` int NOT NULL AUTO_INCREMENT,
  `tipo` enum('Académica','Administrativa') DEFAULT NULL,
  `mensaje` text,
  `destinatario` varchar(100) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  PRIMARY KEY (`id_alerta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `alumnos`
--

DROP TABLE IF EXISTS `alumnos`;
CREATE TABLE IF NOT EXISTS `alumnos` (
  `id_alumno` int NOT NULL AUTO_INCREMENT,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `id_grado` int DEFAULT NULL,
  `id_responsable` int DEFAULT NULL,
  PRIMARY KEY (`id_alumno`),
  KEY `fk_alumnos_grados` (`id_grado`),
  KEY `fk_alumnos_responsables` (`id_responsable`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `asistencias`
--

DROP TABLE IF EXISTS `asistencias`;
CREATE TABLE IF NOT EXISTS `asistencias` (
  `id_asistencia` int NOT NULL AUTO_INCREMENT,
  `id_alumno` int DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `estado` enum('Presente','Ausente','Justificado') DEFAULT 'Ausente',
  PRIMARY KEY (`id_asistencia`),
  KEY `fk_asistencias_alumnos` (`id_alumno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `aulas`
--

DROP TABLE IF EXISTS `aulas`;
CREATE TABLE IF NOT EXISTS `aulas` (
  `id_aula` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `capacidad` int DEFAULT NULL,
  `id_grado` int DEFAULT NULL,
  PRIMARY KEY (`id_aula`),
  KEY `fk_aulas_grados` (`id_grado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE IF NOT EXISTS `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_group_id_b120cbf9` (`group_id`),
  KEY `auth_group_permissions_permission_id_84c5c92e` (`permission_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  KEY `auth_permission_content_type_id_2f476e4b` (`content_type_id`)
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE IF NOT EXISTS `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE IF NOT EXISTS `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_user_id_6a12ed8b` (`user_id`),
  KEY `auth_user_groups_group_id_97559544` (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE IF NOT EXISTS `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_user_id_a95ead1b` (`user_id`),
  KEY `auth_user_user_permissions_permission_id_1fbb5f2c` (`permission_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `calificaciones`
--

DROP TABLE IF EXISTS `calificaciones`;
CREATE TABLE IF NOT EXISTS `calificaciones` (
  `id_calificacion` int NOT NULL AUTO_INCREMENT,
  `id_alumno` int DEFAULT NULL,
  `id_materia` int DEFAULT NULL,
  `nota` decimal(5,2) DEFAULT NULL,
  `periodo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_calificacion`),
  KEY `fk_calificaciones_alumnos` (`id_alumno`),
  KEY `fk_calificaciones_materias` (`id_materia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
CREATE TABLE IF NOT EXISTS `categorias` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE IF NOT EXISTS `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint UNSIGNED NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(2, 'auth', 'permission'),
(3, 'auth', 'group'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE IF NOT EXISTS `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-09-08 03:22:38.678826'),
(2, 'auth', '0001_initial', '2025-09-08 03:22:39.794033'),
(3, 'admin', '0001_initial', '2025-09-08 03:22:40.059047'),
(4, 'admin', '0002_logentry_remove_auto_add', '2025-09-08 03:22:40.063851'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2025-09-08 03:22:40.070697'),
(6, 'contenttypes', '0002_remove_content_type_name', '2025-09-08 03:22:40.190667'),
(7, 'auth', '0002_alter_permission_name_max_length', '2025-09-08 03:22:40.261448'),
(8, 'auth', '0003_alter_user_email_max_length', '2025-09-08 03:22:40.329193'),
(9, 'auth', '0004_alter_user_username_opts', '2025-09-08 03:22:40.333259'),
(10, 'auth', '0005_alter_user_last_login_null', '2025-09-08 03:22:40.400790'),
(11, 'auth', '0006_require_contenttypes_0002', '2025-09-08 03:22:40.401956'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2025-09-08 03:22:40.406935'),
(13, 'auth', '0008_alter_user_username_max_length', '2025-09-08 03:22:40.479553'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2025-09-08 03:22:40.544864'),
(15, 'auth', '0010_alter_group_name_max_length', '2025-09-08 03:22:40.612071'),
(16, 'auth', '0011_update_proxy_permissions', '2025-09-08 03:22:40.617131'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2025-09-08 03:22:40.682336'),
(18, 'sessions', '0001_initial', '2025-09-08 03:22:40.761378');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('6sl1py7k1huez705zr53vxwd1sdzsejx', '.eJyrViotLk0sysyPz0xRsrLQgXOT84uKUvOVrJQSU3Iz8xzApF5yfq4SQklRfg5MXqkWANDfGiw:1uxAj3:2vykXXBiZ33IXGzHr6eGIFUgBYEA2cUYD3CEvRvvAr0', '2025-09-26 20:50:33.463401'),
('w9br6cs5h12xj7xd35r7egcgkonqn8xh', '.eJyrViotLk0sysyPz0xRsjI01IHzk_OLilLzlayUsoFch8SU3Mw8veT8XCWEiqL8HKA0WEapFgDEuxn0:1uxCNm:GqWhXI4WOLRD7NGqR-l88V8fo2Sfart7LOI9rdUJK-E', '2025-09-26 22:36:42.179384');

-- --------------------------------------------------------

--
-- Table structure for table `eventos`
--

DROP TABLE IF EXISTS `eventos`;
CREATE TABLE IF NOT EXISTS `eventos` (
  `id_evento` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `fecha` date DEFAULT NULL,
  PRIMARY KEY (`id_evento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grados`
--

DROP TABLE IF EXISTS `grados`;
CREATE TABLE IF NOT EXISTS `grados` (
  `id_grado` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `nivel` varchar(50) DEFAULT NULL,
  `seccion` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_grado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `horarios`
--

DROP TABLE IF EXISTS `horarios`;
CREATE TABLE IF NOT EXISTS `horarios` (
  `id_horario` int NOT NULL AUTO_INCREMENT,
  `dia` varchar(20) DEFAULT NULL,
  `hora_inicio` time DEFAULT NULL,
  `hora_fin` time DEFAULT NULL,
  `id_materia` int DEFAULT NULL,
  `id_aula` int DEFAULT NULL,
  PRIMARY KEY (`id_horario`),
  KEY `fk_horarios_materias` (`id_materia`),
  KEY `fk_horarios_aulas` (`id_aula`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `maestros`
--

DROP TABLE IF EXISTS `maestros`;
CREATE TABLE IF NOT EXISTS `maestros` (
  `id_maestro` int NOT NULL AUTO_INCREMENT,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `especialidad` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_maestro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `materias`
--

DROP TABLE IF EXISTS `materias`;
CREATE TABLE IF NOT EXISTS `materias` (
  `id_materia` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `id_maestro` int DEFAULT NULL,
  PRIMARY KEY (`id_materia`),
  KEY `fk_materias_maestros` (`id_maestro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `mensualidades`
--

DROP TABLE IF EXISTS `mensualidades`;
CREATE TABLE IF NOT EXISTS `mensualidades` (
  `id_pago` int NOT NULL AUTO_INCREMENT,
  `id_alumno` int DEFAULT NULL,
  `monto` decimal(10,2) DEFAULT NULL,
  `fecha_pago` date DEFAULT NULL,
  `estado` enum('Pendiente','Pagado') DEFAULT 'Pendiente',
  PRIMARY KEY (`id_pago`),
  KEY `fk_mensualidades_alumnos` (`id_alumno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `responsables`
--

DROP TABLE IF EXISTS `responsables`;
CREATE TABLE IF NOT EXISTS `responsables` (
  `id_responsable` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `relacion` varchar(50) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_responsable`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tareas`
--

DROP TABLE IF EXISTS `tareas`;
CREATE TABLE IF NOT EXISTS `tareas` (
  `id_tarea` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(100) NOT NULL,
  `descripcion` text,
  `fecha_entrega` date DEFAULT NULL,
  `id_materia` int DEFAULT NULL,
  PRIMARY KEY (`id_tarea`),
  KEY `fk_tareas_materias` (`id_materia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `rol` enum('admin','maestro','padre','alumno') DEFAULT NULL,
  `correo` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `usuario` (`correo`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `rol`, `correo`, `contrasena`) VALUES
(8, 'admin', 'padre', 'admin@admin.com', '$2b$12$XDKwHWSdZaLrHxDhGL5.Yu6fGnZLe/JsJizpjJ9LzuLffOUbWMwYK'),
(11, 'kari_admin', 'admin', 'kari@admin.com', '$2b$12$4k1Xrs.j3NB9ws5V0Eb4BOw8tUoXHhLPVqwUsRD.DvHd8YfZu5KO.'),
(15, 'kari_maestro', 'maestro', 'kari@maestro.com', '$2b$12$SPerYKfFQFaNFSgre6Qpk.HvDuz2iRp62X0ihug1kNxyp4vZxLyTW'),
(16, 'kari_alumno', 'alumno', 'kari@alumno.com', '$2b$12$0SqxkOtp6JaGUvlcTaHmDOlFP0ud6RQOifq2gH.IzWv1sjmB3MrOy'),
(17, 'kari_padre', 'padre', 'kari@padre.com', '$2b$12$T5W.RFoqDkw.aF3J9V6u/uXvuZOl9L6TCsSZhFlELG7HsFL7jkLJG');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `alumnos`
--
ALTER TABLE `alumnos`
  ADD CONSTRAINT `fk_alumnos_grados` FOREIGN KEY (`id_grado`) REFERENCES `grados` (`id_grado`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_alumnos_responsables` FOREIGN KEY (`id_responsable`) REFERENCES `responsables` (`id_responsable`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `asistencias`
--
ALTER TABLE `asistencias`
  ADD CONSTRAINT `fk_asistencias_alumnos` FOREIGN KEY (`id_alumno`) REFERENCES `alumnos` (`id_alumno`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `aulas`
--
ALTER TABLE `aulas`
  ADD CONSTRAINT `fk_aulas_grados` FOREIGN KEY (`id_grado`) REFERENCES `grados` (`id_grado`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `calificaciones`
--
ALTER TABLE `calificaciones`
  ADD CONSTRAINT `fk_calificaciones_alumnos` FOREIGN KEY (`id_alumno`) REFERENCES `alumnos` (`id_alumno`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_calificaciones_materias` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `horarios`
--
ALTER TABLE `horarios`
  ADD CONSTRAINT `fk_horarios_aulas` FOREIGN KEY (`id_aula`) REFERENCES `aulas` (`id_aula`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_horarios_materias` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `materias`
--
ALTER TABLE `materias`
  ADD CONSTRAINT `fk_materias_maestros` FOREIGN KEY (`id_maestro`) REFERENCES `maestros` (`id_maestro`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `mensualidades`
--
ALTER TABLE `mensualidades`
  ADD CONSTRAINT `fk_mensualidades_alumnos` FOREIGN KEY (`id_alumno`) REFERENCES `alumnos` (`id_alumno`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tareas`
--
ALTER TABLE `tareas`
  ADD CONSTRAINT `fk_tareas_materias` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON DELETE SET NULL ON UPDATE CASCADE;
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
