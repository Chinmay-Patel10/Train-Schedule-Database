CREATE DATABASE  IF NOT EXISTS `traindatabase1` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `traindatabase1`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: traindatabase1
-- ------------------------------------------------------
-- Server version	8.0.37

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `username` varchar(100) NOT NULL,
  `password` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `name_firstname` varchar(100) DEFAULT NULL,
  `name_lastname` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES ('chin','patel','chin@gmail.com','Chinmay','Patel'),('gurvir','dhal',NULL,NULL,NULL),('karam','singh','null','Karam','Singh'),('roman','trevino',NULL,NULL,NULL);
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_customer_rep`
--

DROP TABLE IF EXISTS `employee_customer_rep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_customer_rep` (
  `ssn` char(11) DEFAULT NULL,
  `name_firstname` varchar(100) DEFAULT NULL,
  `name_lastname` varchar(100) DEFAULT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_customer_rep`
--

LOCK TABLES `employee_customer_rep` WRITE;
/*!40000 ALTER TABLE `employee_customer_rep` DISABLE KEYS */;
INSERT INTO `employee_customer_rep` VALUES ('111-11-1111','rep111','rep1','rep1','rep1');
/*!40000 ALTER TABLE `employee_customer_rep` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_site_manager`
--

DROP TABLE IF EXISTS `employee_site_manager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_site_manager` (
  `ssn` char(11) DEFAULT NULL,
  `name_firstname` varchar(100) DEFAULT NULL,
  `name_lastname` varchar(100) DEFAULT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_site_manager`
--

LOCK TABLES `employee_site_manager` WRITE;
/*!40000 ALTER TABLE `employee_site_manager` DISABLE KEYS */;
INSERT INTO `employee_site_manager` VALUES ('000-00-0000','Admin','Admin','admin','admin');
/*!40000 ALTER TABLE `employee_site_manager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `has_ride_origin_destination_partof`
--

DROP TABLE IF EXISTS `has_ride_origin_destination_partof`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `has_ride_origin_destination_partof` (
  `connection_number` int NOT NULL AUTO_INCREMENT,
  `class` enum('economy','business','first') DEFAULT NULL,
  `seat_number` int DEFAULT NULL,
  `isChild` tinyint(1) DEFAULT NULL,
  `isSenior` tinyint(1) DEFAULT NULL,
  `isDisabled` tinyint(1) DEFAULT NULL,
  `reservation_number` int NOT NULL,
  `origin_id` int NOT NULL,
  `destination_id` int NOT NULL,
  `transit_line_name` varchar(100) NOT NULL,
  PRIMARY KEY (`connection_number`,`reservation_number`),
  KEY `reservation_number` (`reservation_number`),
  KEY `origin_id` (`origin_id`),
  KEY `destination_id` (`destination_id`),
  KEY `transit_line_name` (`transit_line_name`),
  CONSTRAINT `has_ride_origin_destination_partof_ibfk_1` FOREIGN KEY (`reservation_number`) REFERENCES `reservation_portfolio` (`reservation_number`) ON DELETE CASCADE,
  CONSTRAINT `has_ride_origin_destination_partof_ibfk_2` FOREIGN KEY (`origin_id`) REFERENCES `station` (`id`) ON DELETE CASCADE,
  CONSTRAINT `has_ride_origin_destination_partof_ibfk_3` FOREIGN KEY (`destination_id`) REFERENCES `station` (`id`) ON DELETE CASCADE,
  CONSTRAINT `has_ride_origin_destination_partof_ibfk_4` FOREIGN KEY (`transit_line_name`) REFERENCES `schedule_origin_of_train_destination_of_train_on` (`transit_line_name`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `has_ride_origin_destination_partof`
--

LOCK TABLES `has_ride_origin_destination_partof` WRITE;
/*!40000 ALTER TABLE `has_ride_origin_destination_partof` DISABLE KEYS */;
INSERT INTO `has_ride_origin_destination_partof` VALUES (17,'economy',11,1,0,0,28,8,3,'NJ Transit'),(18,'first',12,1,0,0,29,9,2,'NJ Acela 32'),(19,'first',2,0,0,1,30,5,7,'NJ Southern 83'),(20,'first',3,0,0,0,31,1,3,'NJ Coastal 24'),(22,'first',3,0,0,1,33,8,3,'NJ Transit'),(23,'first',7,0,0,0,34,9,2,'NJ Acela 32'),(24,'first',3,0,0,0,45,7,8,'NJ Atlantic City Line 11');
/*!40000 ALTER TABLE `has_ride_origin_destination_partof` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `messageid` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `topic` varchar(50) DEFAULT NULL,
  `message` varchar(1000) DEFAULT NULL,
  `usernameOfRep` varchar(100) DEFAULT NULL,
  `reply` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`messageid`),
  KEY `username` (`username`),
  KEY `usernameOfRep` (`usernameOfRep`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`username`) REFERENCES `customer` (`username`) ON DELETE CASCADE,
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`usernameOfRep`) REFERENCES `employee_customer_rep` (`username`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,'chin','Station Location','What Station is Atlantic City located in?','rep1','It is located at Station 7.'),(2,'chin','Hello','I wanted to say hi!','rep1','Hello!!');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation_portfolio`
--

DROP TABLE IF EXISTS `reservation_portfolio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation_portfolio` (
  `reservation_number` int NOT NULL AUTO_INCREMENT,
  `date_made` datetime DEFAULT NULL,
  `booking_fee` double DEFAULT NULL,
  `isWeekly` tinyint(1) DEFAULT NULL,
  `isMonthly` tinyint(1) DEFAULT NULL,
  `isRoundTrip` tinyint(1) DEFAULT NULL,
  `username` varchar(100) NOT NULL,
  PRIMARY KEY (`reservation_number`),
  KEY `username` (`username`),
  CONSTRAINT `reservation_portfolio_ibfk_1` FOREIGN KEY (`username`) REFERENCES `customer` (`username`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation_portfolio`
--

LOCK TABLES `reservation_portfolio` WRITE;
/*!40000 ALTER TABLE `reservation_portfolio` DISABLE KEYS */;
INSERT INTO `reservation_portfolio` VALUES (28,'2024-07-17 01:01:34',30,NULL,NULL,0,'chin'),(29,'2024-07-17 01:02:11',37.5,NULL,NULL,0,'chin'),(30,'2024-07-17 01:02:31',30,NULL,NULL,0,'chin'),(31,'2024-07-17 01:02:51',100,NULL,NULL,0,'chin'),(33,'2024-07-17 01:03:35',20,NULL,NULL,0,'karam'),(34,'2024-07-17 01:14:40',100,NULL,NULL,1,'chin'),(35,'2024-07-17 01:56:50',22.5,NULL,NULL,0,'karam'),(36,'2024-07-17 01:58:31',22.5,NULL,NULL,0,'karam'),(37,'2024-07-17 01:58:37',22.5,NULL,NULL,0,'karam'),(38,'2024-07-17 01:58:41',22.5,NULL,NULL,0,'karam'),(39,'2024-07-17 02:03:34',30,NULL,NULL,0,'karam'),(40,'2024-07-17 02:05:24',30,NULL,NULL,0,'karam'),(41,'2024-07-17 02:05:27',30,NULL,NULL,0,'karam'),(42,'2024-07-17 02:05:29',30,NULL,NULL,0,'karam'),(43,'2024-07-17 02:06:31',30,NULL,NULL,0,'karam'),(44,'2024-07-17 02:07:18',30,NULL,NULL,0,'karam'),(45,'2024-07-17 02:09:14',30,NULL,NULL,0,'karam');
/*!40000 ALTER TABLE `reservation_portfolio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule_origin_of_train_destination_of_train_on`
--

DROP TABLE IF EXISTS `schedule_origin_of_train_destination_of_train_on`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule_origin_of_train_destination_of_train_on` (
  `transit_line_name` varchar(100) NOT NULL,
  `isDelayed` tinyint(1) DEFAULT NULL,
  `normal_fare` double DEFAULT NULL,
  `child_fare` double DEFAULT NULL,
  `senior_fare` double DEFAULT NULL,
  `disabled_fare` double DEFAULT NULL,
  `destination_arrival_time` datetime DEFAULT NULL,
  `destination_departure_time` datetime DEFAULT NULL,
  `origin_arrival_time` datetime DEFAULT NULL,
  `origin_departure_time` datetime DEFAULT NULL,
  `origin_station_id` int NOT NULL,
  `destination_station_id` int NOT NULL,
  `train_id` int NOT NULL,
  PRIMARY KEY (`transit_line_name`),
  KEY `origin_station_id` (`origin_station_id`),
  KEY `destination_station_id` (`destination_station_id`),
  KEY `train_id` (`train_id`),
  CONSTRAINT `schedule_origin_of_train_destination_of_train_on_ibfk_1` FOREIGN KEY (`origin_station_id`) REFERENCES `station` (`id`) ON DELETE CASCADE,
  CONSTRAINT `schedule_origin_of_train_destination_of_train_on_ibfk_2` FOREIGN KEY (`destination_station_id`) REFERENCES `station` (`id`) ON DELETE CASCADE,
  CONSTRAINT `schedule_origin_of_train_destination_of_train_on_ibfk_3` FOREIGN KEY (`train_id`) REFERENCES `train` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule_origin_of_train_destination_of_train_on`
--

LOCK TABLES `schedule_origin_of_train_destination_of_train_on` WRITE;
/*!40000 ALTER TABLE `schedule_origin_of_train_destination_of_train_on` DISABLE KEYS */;
INSERT INTO `schedule_origin_of_train_destination_of_train_on` VALUES ('NJ Acela 32',0,50,37.5,32.5,25,'2024-07-21 05:00:00','2024-07-21 06:00:00','2024-07-21 09:00:00','2024-07-21 10:30:00',9,2,2),('NJ Atlantic City Line 11',0,30,22.5,10.5,15,'2024-07-19 10:00:00','2024-07-19 11:00:00','2024-07-19 07:00:00','2024-07-19 07:30:00',7,8,4),('NJ Coastal 24',0,100,75,65,50,'2024-07-25 08:15:00','2024-07-25 11:00:00','2024-07-30 07:00:00','2020-07-30 07:30:00',1,3,5),('NJ Southern 83',0,60,0,0,30,'2024-07-30 20:00:00','2024-07-30 23:00:00','2024-07-30 10:00:00','2024-07-30 10:30:00',5,7,3),('NJ Transit',1,40,30,26,20,'2024-07-25 05:00:00','2024-07-25 06:00:00','2024-07-25 09:00:00','2024-07-25 10:30:00',8,3,1);
/*!40000 ALTER TABLE `schedule_origin_of_train_destination_of_train_on` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `station`
--

DROP TABLE IF EXISTS `station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `station` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `state` varchar(5) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `station`
--

LOCK TABLES `station` WRITE;
/*!40000 ALTER TABLE `station` DISABLE KEYS */;
INSERT INTO `station` VALUES (1,'Manasquan Stop','NJ','Manasquan'),(2,'Long Branch Stop','NJ','Long Branch'),(3,'Newark Penn','NJ','Newark'),(5,'Piscataway Stop','NJ','Piscataway'),(6,'Princeton Stop','NJ','Princeton'),(7,'AC Stop','NJ','Atlantic City'),(8,'MetroPark Stop','NJ','Edison'),(9,'South Amboy Stop','NJ','South Amboy');
/*!40000 ALTER TABLE `station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stops_in_between`
--

DROP TABLE IF EXISTS `stops_in_between`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stops_in_between` (
  `transit_line_name` varchar(100) NOT NULL,
  `id` int NOT NULL,
  `departure_time` datetime DEFAULT NULL,
  `arrival_time` datetime DEFAULT NULL,
  PRIMARY KEY (`transit_line_name`,`id`),
  KEY `id` (`id`),
  CONSTRAINT `stops_in_between_ibfk_1` FOREIGN KEY (`transit_line_name`) REFERENCES `schedule_origin_of_train_destination_of_train_on` (`transit_line_name`) ON DELETE CASCADE,
  CONSTRAINT `stops_in_between_ibfk_2` FOREIGN KEY (`id`) REFERENCES `station` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stops_in_between`
--

LOCK TABLES `stops_in_between` WRITE;
/*!40000 ALTER TABLE `stops_in_between` DISABLE KEYS */;
INSERT INTO `stops_in_between` VALUES ('NJ Coastal 24',2,'2024-07-30 08:30:00','2024-07-30 08:00:00'),('NJ Coastal 24',5,'2024-07-30 09:30:00','2024-07-30 09:00:00');
/*!40000 ALTER TABLE `stops_in_between` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train`
--

DROP TABLE IF EXISTS `train`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train` (
  `id` int NOT NULL AUTO_INCREMENT,
  `num_seats` int DEFAULT NULL,
  `num_cars` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train`
--

LOCK TABLES `train` WRITE;
/*!40000 ALTER TABLE `train` DISABLE KEYS */;
INSERT INTO `train` VALUES (1,80,10),(2,300,15),(3,30,2),(4,200,10),(5,60,3);
/*!40000 ALTER TABLE `train` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-18 21:52:50
