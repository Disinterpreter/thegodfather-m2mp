/*
MySQL Data Transfer
Source Host: localhost
Source Database: m2mp
Target Host: localhost
Target Database: m2mp
Date: 04.07.2013 0:02:11
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for accounts
-- ----------------------------
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `ID` int(50) NOT NULL AUTO_INCREMENT,
  `Name` varchar(24) COLLATE utf8_bin NOT NULL,
  `Password` varchar(50) COLLATE utf8_bin NOT NULL,
  `Skin` int(3) NOT NULL,
  `Admin` int(2) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `accounts` VALUES ('1', 'Debug', 'e10adc3949ba59abbe56e057f20f883e', '1', '1');
