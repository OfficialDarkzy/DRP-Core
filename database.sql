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

-- Dumping data for table drp.characters: ~0 rows (approximately)
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;

-- Dumping data for table drp.character_clothing: ~0 rows (approximately)
/*!40000 ALTER TABLE `character_clothing` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_clothing` ENABLE KEYS */;

-- Dumping data for table drp.character_inventory: ~0 rows (approximately)
/*!40000 ALTER TABLE `character_inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_inventory` ENABLE KEYS */;

-- Dumping data for table drp.character_tattoos: ~0 rows (approximately)
/*!40000 ALTER TABLE `character_tattoos` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_tattoos` ENABLE KEYS */;

-- Dumping data for table drp.farming: ~0 rows (approximately)
/*!40000 ALTER TABLE `farming` DISABLE KEYS */;
/*!40000 ALTER TABLE `farming` ENABLE KEYS */;

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

-- Dumping data for table drp.police: ~0 rows (approximately)
/*!40000 ALTER TABLE `police` DISABLE KEYS */;
/*!40000 ALTER TABLE `police` ENABLE KEYS */;

-- Dumping data for table drp.users: ~0 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- Dumping data for table drp.vehicles: ~0 rows (approximately)
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;

-- Dumping data for table drp.vehicle_auction: ~0 rows (approximately)
/*!40000 ALTER TABLE `vehicle_auction` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicle_auction` ENABLE KEYS */;

-- Dumping data for table drp.vehicle_servicemilage: ~0 rows (approximately)
/*!40000 ALTER TABLE `vehicle_servicemilage` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicle_servicemilage` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
