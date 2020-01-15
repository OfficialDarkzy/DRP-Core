-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.1.37-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win32
-- HeidiSQL Version:             10.3.0.5771
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table drp.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `age` int(255) NOT NULL,
  `gender` varchar(255) NOT NULL,
  `cash` bigint(20) NOT NULL,
  `bank` bigint(20) NOT NULL,
  `dirtyCash` bigint(20) NOT NULL,
  `paycheck` bigint(11) NOT NULL,
  `licenses` text NOT NULL,
  `phonenumber` mediumint(11) NOT NULL,
  `isDead` int(11) NOT NULL DEFAULT '0',
  `lastLocation` varchar(255) DEFAULT '{433.42, -628.88, 28.72}',
  `playerid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `player_id` (`playerid`) USING BTREE,
  CONSTRAINT `characters_ibfk_1` FOREIGN KEY (`playerid`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- Dumping structure for table drp.character_clothing
CREATE TABLE IF NOT EXISTS `character_clothing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `clothing_drawables` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `clothing_textures` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `clothing_palette` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `props_drawables` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `props_textures` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `overlays_drawables` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `overlays_opacity` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `overlays_colours` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `char_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_character_clothing_characters` (`char_id`),
  CONSTRAINT `FK_character_clothing_characters` FOREIGN KEY (`char_id`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Dumping structure for table drp.character_inventory
CREATE TABLE IF NOT EXISTS `character_inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `charid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_character_inventory_characters` (`charid`),
  KEY `FK_character_inventory_inventory_items` (`item`),
  CONSTRAINT `FK_character_inventory_characters` FOREIGN KEY (`charid`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_character_inventory_inventory_items` FOREIGN KEY (`item`) REFERENCES `inventory_items` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Dumping data for table drp.character_inventory: ~0 rows (approximately)
/*!40000 ALTER TABLE `character_inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_inventory` ENABLE KEYS */;

-- Dumping structure for table drp.character_tattoos
CREATE TABLE IF NOT EXISTS `character_tattoos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tattoos` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `char_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_character_tattoos_characters` (`char_id`),
  CONSTRAINT `FK_character_tattoos_characters` FOREIGN KEY (`char_id`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Dumping data for table drp.character_tattoos: ~0 rows (approximately)
/*!40000 ALTER TABLE `character_tattoos` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_tattoos` ENABLE KEYS */;

-- Dumping structure for table drp.farming
CREATE TABLE IF NOT EXISTS `farming` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plant` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `health` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `coords` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `gender` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `food` int(11) DEFAULT NULL,
  `water` int(11) DEFAULT NULL,
  `char_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_farming_characters` (`char_id`),
  CONSTRAINT `FK_farming_characters` FOREIGN KEY (`char_id`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Dumping data for table drp.farming: ~0 rows (approximately)
/*!40000 ALTER TABLE `farming` DISABLE KEYS */;
/*!40000 ALTER TABLE `farming` ENABLE KEYS */;

-- Dumping structure for table drp.inventory_items
CREATE TABLE IF NOT EXISTS `inventory_items` (
  `name` varchar(50) COLLATE utf8_bin NOT NULL,
  `label` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `limit` int(11) DEFAULT '-1',
  `rare` int(11) DEFAULT '0',
  `canRemove` int(11) DEFAULT '1',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Dumping data for table drp.inventory_items: ~19 rows (approximately)
/*!40000 ALTER TABLE `inventory_items` DISABLE KEYS */;
INSERT INTO `inventory_items` (`name`, `label`, `limit`, `rare`, `canRemove`) VALUES
	('bread', 'Bread', 0, 0, 1),
	('chain', 'Chain', 0, 0, 1),
	('cocaine', 'Cocaine', 0, 0, 1),
	('cocainebrick', 'Cocaine Brick', 0, 0, 1),
	('dildo', 'Dildo', 0, 0, 1),
	('earrings', 'Earrings', 0, 0, 1),
	('goldchain', 'Gold Chain', 0, 0, 1),
	('goldearrings', 'Gold Earrings', 0, 0, 1),
	('goldplatedwatch', 'Gold Watch', 0, 0, 1),
	('ifruit', 'IFruit', 0, 0, 1),
	('junk', 'Junk', 0, 0, 1),
	('lockpick', 'Lockpick', 0, 0, 1),
	('marijuana', 'Marijuana', 0, 0, 1),
	('rawcocaine', 'Raw Cocaine', 0, 0, 1),
	('rolex', 'Rolex', 0, 0, 1),
	('silverwatch', 'Silver Watch', 0, 0, 1),
	('watch', 'Watch', 0, 0, 1),
	('water', 'Water', 0, 0, 1),
	('weed', 'Weed', 0, 0, 1),
	('weedseeds', 'Weed Seeds', 0, 0, 1);
/*!40000 ALTER TABLE `inventory_items` ENABLE KEYS */;

-- Dumping structure for table drp.police
CREATE TABLE IF NOT EXISTS `police` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rank` int(11) DEFAULT NULL,
  `division` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `department` varchar(50) COLLATE utf8_bin DEFAULT 'police',
  `char_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `police_fk1` (`char_id`),
  CONSTRAINT `police_fk1` FOREIGN KEY (`char_id`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Dumping data for table drp.police: ~0 rows (approximately)
/*!40000 ALTER TABLE `police` DISABLE KEYS */;
/*!40000 ALTER TABLE `police` ENABLE KEYS */;

-- Dumping structure for table drp.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `identifier` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `rank` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ban_data` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `whitelisted` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Dumping structure for table drp.vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `modelLabel` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `vehicleMods` longtext,
  `plate` varchar(50) DEFAULT NULL,
  `charactername` varchar(50) NOT NULL,
  `char_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `vehicles_ibfk_01` (`char_id`),
  CONSTRAINT `vehicles_ibfk_01` FOREIGN KEY (`char_id`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin2;

-- Dumping data for table drp.vehicles: ~0 rows (approximately)
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;

-- Dumping structure for table drp.vehicle_auction
CREATE TABLE IF NOT EXISTS `vehicle_auction` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sellername` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `vehicleMods` longtext COLLATE utf8_bin,
  `price` int(11) DEFAULT '0',
  `char_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_vehicle_auction_characters` (`char_id`),
  CONSTRAINT `FK_vehicle_auction_characters` FOREIGN KEY (`char_id`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Dumping data for table drp.vehicle_auction: ~0 rows (approximately)
/*!40000 ALTER TABLE `vehicle_auction` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicle_auction` ENABLE KEYS */;

-- Dumping structure for table drp.vehicle_servicemilage
CREATE TABLE IF NOT EXISTS `vehicle_servicemilage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `milage` int(11) DEFAULT '0',
  `vehiclePlate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Dumping data for table drp.vehicle_servicemilage: ~0 rows (approximately)
/*!40000 ALTER TABLE `vehicle_servicemilage` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicle_servicemilage` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
