-- Adminer 4.8.1 MySQL 8.0.31 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP DATABASE IF EXISTS `access-control-component`;
CREATE DATABASE `access-control-component` /*!40100 DEFAULT CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `access-control-component`;

DELIMITER ;;

CREATE PROCEDURE `addUserToGroup`(IN `id_user` tinyint, IN `id_group` tinyint)
INSERT INTO group_members(id_user,id_group) VALUES( id_user, id_group );;

CREATE PROCEDURE `createGroup`(IN `name` varchar(45), IN `description` varchar(45))
INSERT INTO `group`(name,description) VALUES( name , description );;

CREATE PROCEDURE `createUser`(IN `name` varchar(45), IN `password` varchar(45))
BEGIN
    DECLARE id_user INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

    START TRANSACTION;
        INSERT INTO user(name,password) VALUES( name , password );

        SET id_user = LAST_INSERT_ID();

        CALL addUserToGroup(id_user, 3);
    COMMIT;
END;;

CREATE PROCEDURE `deleteGroup`(IN `id` int)
DELETE FROM `group` WHERE `group`.id = id;;

CREATE PROCEDURE `deleteUser`(IN `id` tinyint(45) unsigned)
DELETE FROM user WHERE user.id = id;;

CREATE PROCEDURE `deleteUserFromGroup`(IN `id` int)
DELETE FROM group_members WHERE group_members.id_user = id;;

CREATE PROCEDURE `editGroup`(IN `id` int, IN `description` varchar(45))
UPDATE `group` SET `group`.description = description WHERE `group`.id = id;;

CREATE PROCEDURE `editUser`(IN `id` int, IN `password` varchar(45))
UPDATE user SET user.password = password WHERE user.id = id;;

CREATE PROCEDURE `getAllGroupMembers`()
SELECT * from group_members;;

CREATE PROCEDURE `getAllGroups`()
SELECT * FROM `group`;;

CREATE PROCEDURE `getAllUsers`()
SELECT * FROM user;;

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

INSERT INTO `group` (`id`, `name`, `description`) VALUES
(1,	'nobody',	'Grupo ficticio que no otorga ningún permiso'),
(2,	'administrator',	'Grupo que habilita todos los permisos'),
(3,	'visitor',	'Grupo de permisos muy restringidos');

DROP TABLE IF EXISTS `group_accesses`;
CREATE TABLE `group_accesses` (
  `id_group` int NOT NULL,
  `id_action` int NOT NULL,
  KEY `id_group` (`id_group`),
  KEY `id_action` (`id_action`),
  CONSTRAINT `group_accesses_ibfk_1` FOREIGN KEY (`id_group`) REFERENCES `group` (`id`),
  CONSTRAINT `group_accesses_ibfk_2` FOREIGN KEY (`id_action`) REFERENCES `action` (`id`)
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
(10,	2),
(15,	3);

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `password` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

INSERT INTO `user` (`id`, `name`, `password`) VALUES
(10,	'ana',	'33155555a'),
(13,	'romina',	'zzzz'),
(14,	'martin',	'mm222'),
(15,	'juan',	'2525');

DROP TABLE IF EXISTS `users_information`;
CREATE TABLE `users_information` (
  `id_user` int NOT NULL,
  KEY `id_user` (`id_user`),
  CONSTRAINT `users_information_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;


-- 2022-11-15 19:43:37
