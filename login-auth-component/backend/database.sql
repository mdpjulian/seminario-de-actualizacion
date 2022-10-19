-- Adminer 4.8.1 MySQL 8.0.31 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

CREATE DATABASE `application-login` /*!40100 DEFAULT CHARACTER SET utf8mb3 COLLATE utf8_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `application-template`;

DELIMITER ;;

DROP PROCEDURE IF EXISTS `addUserToGroup`;;
CREATE PROCEDURE `addUserToGroup`(IN `id_user` tinyint, IN `id_target_group` tinyint)
INSERT INTO group_members(id_user,id_group) VALUES( id_user, id_target_group );;

DROP PROCEDURE IF EXISTS `auth_user`;;
CREATE PROCEDURE `auth_user`(IN `username` varchar(45))
SELECT id, password FROM user 
WHERE name = user.name;;

DROP PROCEDURE IF EXISTS `changeUserName`;;
CREATE PROCEDURE `changeUserName`(IN `id_user` tinyint(45), IN `id_name` varchar(45) CHARACTER SET 'utf8')
UPDATE user SET name = id_name WHERE id = id_user;;

DROP PROCEDURE IF EXISTS `changeUserPassword`;;
CREATE PROCEDURE `changeUserPassword`(IN `id_user` tinyint(45), IN `id_password` varchar(45) CHARACTER SET 'utf8')
UPDATE user SET password = id_password WHERE id = id_user;;

DROP PROCEDURE IF EXISTS `create_user_session`;;
CREATE PROCEDURE `create_user_session`(IN `token` varchar(256), IN `user_id` int)
BEGIN

INSERT INTO user_session(token,created,expires,user_id) 
VALUES (token,NOW(),DATE_ADD( NOW(), INTERVAL 10 DAY), user_id);

END;;

DROP PROCEDURE IF EXISTS `deleteUser`;;
CREATE PROCEDURE `deleteUser`(IN `id_user` tinyint(45) unsigned)
DELETE FROM user WHERE id = id_user;;

DROP PROCEDURE IF EXISTS `getAllUsers`;;
CREATE PROCEDURE `getAllUsers`()
SELECT * FROM user;;

DROP PROCEDURE IF EXISTS `getUser`;;
CREATE PROCEDURE `getUser`(IN `id_user` tinyint(45))
SELECT * FROM user WHERE id_user = id;;

DELIMITER ;

DROP TABLE IF EXISTS `action`;
CREATE TABLE `action` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;


DROP TABLE IF EXISTS `group`;
CREATE TABLE `group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

INSERT INTO `group` (`id`, `name`, `description`) VALUES
(1,	'nobody',	'Grupo ficticio que no otorga ningún permiso'),
(2,	'administrator',	'Grupo que habilita todos los permisos'),
(3,	'visitor',	'Grupo de permisos muy restringidos');

DROP TABLE IF EXISTS `group_access`;
CREATE TABLE `group_access` (
  `id_group` int NOT NULL,
  `id_action` int NOT NULL,
  KEY `id_group` (`id_group`),
  KEY `id_action` (`id_action`),
  CONSTRAINT `group_access_ibfk_1` FOREIGN KEY (`id_group`) REFERENCES `group` (`id`),
  CONSTRAINT `group_access_ibfk_2` FOREIGN KEY (`id_action`) REFERENCES `action` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;


DROP TABLE IF EXISTS `group_members`;
CREATE TABLE `group_members` (
  `id_user` int NOT NULL,
  `id_group` int NOT NULL,
  KEY `id_user` (`id_user`),
  KEY `id_group` (`id_group`),
  CONSTRAINT `group_members_ibfk_3` FOREIGN KEY (`id_user`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `group_members_ibfk_4` FOREIGN KEY (`id_group`) REFERENCES `group` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

INSERT INTO `group_members` (`id_user`, `id_group`) VALUES
(37,	3),
(38,	3);

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `password` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

INSERT INTO `user` (`id`, `name`, `password`) VALUES
(37,	'testHASH',	'$2y$10$PSwKwYmiK1B/trYupeJxcO1m1.9uzJoK2M0Q5Csg0TTE/kNCKPiAW'),
(38,	'bcrypt',	'$2y$10$HV17dmHvwUwpqnZtMdpJu.1fIPCt8f0rbeMoS66uJC1ahT3fIWNhW'),
(55,	'bcrypt3',	'carro25');

DROP TABLE IF EXISTS `user_information`;
CREATE TABLE `user_information` (
  `id_user` int NOT NULL,
  KEY `id_user` (`id_user`),
  CONSTRAINT `user_information_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;


DROP TABLE IF EXISTS `user_session`;
CREATE TABLE `user_session` (
  `id` int NOT NULL AUTO_INCREMENT,
  `token` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `expires` datetime NOT NULL,
  `id_user` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_user` (`id_user`),
  UNIQUE KEY `token` (`token`),
  CONSTRAINT `user_session_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;


-- 2022-10-19 19:22:34
