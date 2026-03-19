-- MySQL dump 10.13  Distrib 8.0.43, for Linux (x86_64)
--
-- Host: localhost    Database: hazmat_safety
-- ------------------------------------------------------
-- Server version	8.0.44-0ubuntu0.22.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `announcement`
--

DROP TABLE IF EXISTS `announcement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcement` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` varchar(200) NOT NULL COMMENT '公告标题',
  `content` text COMMENT '公告内容',
  `type` varchar(50) DEFAULT NULL COMMENT '公告类型（通知、公告、系统简介）',
  `priority` int DEFAULT '0' COMMENT '优先级',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-草稿，1-已发布',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  `create_by` bigint DEFAULT NULL COMMENT '创建人ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='公告信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcement`
--

LOCK TABLES `announcement` WRITE;
/*!40000 ALTER TABLE `announcement` DISABLE KEYS */;
INSERT INTO `announcement` VALUES (1,'企业危化品安全管理系统上线通知','各位员工：\n\n为进一步加强公司危险化学品安全管理，提高安全管理水平，公司决定启用企业危化品安全管理系统。\n\n系统主要功能包括：\n1. 危化品信息管理\n2. 安全检查管理\n3. 隐患上报与处理\n4. 安全知识学习\n\n请各部门积极配合，按要求完成系统培训和使用。\n\n特此通知。','通知',1,1,'2026-01-05 08:59:13',NULL,'2026-01-05 08:59:13','2026-01-05 08:59:13'),(2,'系统简介','企业危化品安全管理系统是一套基于SpringBoot+Vue3技术栈开发的现代化安全管理平台，旨在帮助企业实现危险化学品的全生命周期管理。\n\n系统特点：\n1. 前后端分离架构，界面美观、操作便捷\n2. 完善的权限管理，保障数据安全\n3. 全面的危化品信息管理功能\n4. 规范的安全检查流程\n5. 便捷的隐患上报机制\n6. 丰富的安全知识库','系统简介',0,1,'2026-01-05 08:59:13',NULL,'2026-01-05 08:59:13','2026-01-05 08:59:13');
/*!40000 ALTER TABLE `announcement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `check_plan`
--

DROP TABLE IF EXISTS `check_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `check_plan` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '计划ID',
  `title` varchar(200) NOT NULL COMMENT '计划标题',
  `description` text COMMENT '计划描述',
  `check_type` varchar(50) DEFAULT NULL COMMENT '检查类型（日常检查、专项检查、综合检查）',
  `plan_date` date DEFAULT NULL COMMENT '计划检查日期',
  `department` varchar(100) DEFAULT NULL COMMENT '检查部门',
  `status` tinyint DEFAULT '0' COMMENT '状态：0-待执行，1-进行中，2-已完成',
  `create_by` bigint DEFAULT NULL COMMENT '创建人ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='检查计划表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `check_plan`
--

LOCK TABLES `check_plan` WRITE;
/*!40000 ALTER TABLE `check_plan` DISABLE KEYS */;
/*!40000 ALTER TABLE `check_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `check_record`
--

DROP TABLE IF EXISTS `check_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `check_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `plan_id` bigint DEFAULT NULL COMMENT '关联计划ID',
  `title` varchar(200) NOT NULL COMMENT '检查标题',
  `check_date` date DEFAULT NULL COMMENT '检查日期',
  `check_location` varchar(200) DEFAULT NULL COMMENT '检查地点',
  `check_content` text COMMENT '检查内容',
  `check_result` text COMMENT '检查结果',
  `problems_found` text COMMENT '发现问题',
  `suggestions` text COMMENT '整改建议',
  `checker_id` bigint DEFAULT NULL COMMENT '检查人ID',
  `checker_name` varchar(50) DEFAULT NULL COMMENT '检查人姓名',
  `status` tinyint DEFAULT '0' COMMENT '状态：0-待审核，1-已通过，2-需整改',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='检查记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `check_record`
--

LOCK TABLES `check_record` WRITE;
/*!40000 ALTER TABLE `check_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `check_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hazard_report`
--

DROP TABLE IF EXISTS `hazard_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hazard_report` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '隐患ID',
  `title` varchar(200) NOT NULL COMMENT '隐患标题',
  `description` text COMMENT '隐患描述',
  `location` varchar(200) DEFAULT NULL COMMENT '隐患位置',
  `hazard_level` varchar(20) DEFAULT NULL COMMENT '隐患等级（一般、较大、重大）',
  `hazard_type` varchar(50) DEFAULT NULL COMMENT '隐患类型',
  `images` text COMMENT '图片路径（JSON数组）',
  `reporter_id` bigint DEFAULT NULL COMMENT '上报人ID',
  `reporter_name` varchar(50) DEFAULT NULL COMMENT '上报人姓名',
  `report_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '上报时间',
  `status` tinyint DEFAULT '0' COMMENT '状态：0-待处理，1-处理中，2-已整改，3-已关闭',
  `handler_id` bigint DEFAULT NULL COMMENT '处理人ID',
  `handler_name` varchar(50) DEFAULT NULL COMMENT '处理人姓名',
  `handle_time` datetime DEFAULT NULL COMMENT '处理时间',
  `handle_result` text COMMENT '处理结果',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_reporter_id` (`reporter_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='隐患上报表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hazard_report`
--

LOCK TABLES `hazard_report` WRITE;
/*!40000 ALTER TABLE `hazard_report` DISABLE KEYS */;
INSERT INTO `hazard_report` VALUES (1,'111','1111111111111','1','一般',NULL,'',2,'111','2026-01-05 04:22:33',0,NULL,NULL,NULL,NULL,'2026-01-05 04:22:33','2026-01-05 04:22:33');
/*!40000 ALTER TABLE `hazard_report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hazmat_category`
--

DROP TABLE IF EXISTS `hazmat_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hazmat_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '类别ID',
  `name` varchar(100) NOT NULL COMMENT '类别名称',
  `code` varchar(50) DEFAULT NULL COMMENT '类别编码',
  `description` text COMMENT '类别描述',
  `danger_level` varchar(20) DEFAULT NULL COMMENT '危险等级',
  `parent_id` bigint DEFAULT '0' COMMENT '父类别ID',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='危化品类别表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hazmat_category`
--

LOCK TABLES `hazmat_category` WRITE;
/*!40000 ALTER TABLE `hazmat_category` DISABLE KEYS */;
INSERT INTO `hazmat_category` VALUES (1,'爆炸品','CAT001','具有爆炸性质的危险化学品','极高',0,1,1,'2026-01-05 08:59:13','2026-01-05 08:59:13'),(2,'压缩气体和液化气体','CAT002','在压力下储存的气体','高',0,2,1,'2026-01-05 08:59:13','2026-01-05 08:59:13'),(3,'易燃液体','CAT003','闪点低于61℃的液体','高',0,3,1,'2026-01-05 08:59:13','2026-01-05 08:59:13'),(4,'易燃固体','CAT004','容易燃烧的固体物质','中',0,4,1,'2026-01-05 08:59:13','2026-01-05 08:59:13'),(5,'氧化剂和有机过氧化物','CAT005','具有氧化性的物质','高',0,5,1,'2026-01-05 08:59:13','2026-01-05 08:59:13'),(6,'毒害品','CAT006','对人体有毒害作用的物质','高',0,6,1,'2026-01-05 08:59:13','2026-01-05 08:59:13'),(7,'腐蚀品','CAT007','具有腐蚀性的物质','中',0,7,1,'2026-01-05 08:59:13','2026-01-05 08:59:13'),(8,'放射性物品','CAT008','具有放射性的物质','极高',0,8,1,'2026-01-05 08:59:13','2026-01-05 08:59:13');
/*!40000 ALTER TABLE `hazmat_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hazmat_info`
--

DROP TABLE IF EXISTS `hazmat_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hazmat_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '危化品ID',
  `name` varchar(100) NOT NULL COMMENT '危化品名称',
  `code` varchar(50) DEFAULT NULL COMMENT '危化品编码',
  `category_id` bigint DEFAULT NULL COMMENT '类别ID',
  `cas_number` varchar(50) DEFAULT NULL COMMENT 'CAS号',
  `un_number` varchar(50) DEFAULT NULL COMMENT 'UN编号',
  `danger_type` varchar(100) DEFAULT NULL COMMENT '危险类型（易燃、易爆、剧毒、腐蚀等）',
  `physical_state` varchar(20) DEFAULT NULL COMMENT '物理状态（固体、液体、气体）',
  `storage_condition` text COMMENT '储存条件',
  `emergency_measure` text COMMENT '应急处置措施',
  `protective_measure` text COMMENT '防护措施',
  `msds_file` varchar(255) DEFAULT NULL COMMENT 'MSDS文件路径',
  `stock_quantity` decimal(10,2) DEFAULT '0.00' COMMENT '库存数量',
  `unit` varchar(20) DEFAULT NULL COMMENT '计量单位',
  `location` varchar(200) DEFAULT NULL COMMENT '存放位置',
  `supplier` varchar(200) DEFAULT NULL COMMENT '供应商',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` bigint DEFAULT NULL COMMENT '创建人ID',
  PRIMARY KEY (`id`),
  KEY `idx_category_id` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='危化品信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hazmat_info`
--

LOCK TABLES `hazmat_info` WRITE;
/*!40000 ALTER TABLE `hazmat_info` DISABLE KEYS */;
INSERT INTO `hazmat_info` VALUES (1,'硫酸','HM001',7,'7664-93-9','UN1830','腐蚀品','液体','储存于阴凉、通风的库房。库温不超过35℃，相对湿度不超过85%。','皮肤接触：立即脱去污染的衣着，用大量流动清水冲洗至少15分钟。','穿橡胶耐酸碱服，戴橡胶耐酸碱手套，戴化学安全防护眼镜。',NULL,500.00,'升','A区-1号仓库',NULL,1,'2026-01-05 08:59:13','2026-01-05 08:59:13',NULL),(2,'盐酸','HM002',7,'7647-01-0','UN1789','腐蚀品','液体','储存于阴凉、通风的库房。库温不宜超过30℃。','皮肤接触：立即脱去污染的衣着，用大量流动清水冲洗至少15分钟。','穿橡胶耐酸碱服，戴橡胶耐酸碱手套。',NULL,300.00,'升','A区-2号仓库',NULL,1,'2026-01-05 08:59:13','2026-01-05 08:59:13',NULL),(3,'甲醇','HM003',3,'67-56-1','UN1230','易燃液体、有毒','液体','储存于阴凉、通风的库房。远离火种、热源。','迅速撤离泄漏污染区人员至安全区，并进行隔离，严格限制出入。','穿防静电工作服，戴橡胶手套，佩戴过滤式防毒面具。',NULL,200.00,'升','B区-1号仓库',NULL,1,'2026-01-05 08:59:13','2026-01-05 08:59:13',NULL),(4,'乙醇','HM004',3,'64-17-5','UN1170','易燃液体','液体','储存于阴凉、通风的库房。远离火种、热源。库温不宜超过30℃。','迅速撤离泄漏污染区人员至安全区，并进行隔离。','穿防静电工作服，戴一般作业防护手套。',NULL,400.00,'升','B区-2号仓库',NULL,1,'2026-01-05 08:59:13','2026-01-05 08:59:13',NULL),(5,'氢氧化钠','HM005',7,'1310-73-2','UN1823','腐蚀品','固体','储存于阴凉、干燥、通风良好的库房。远离火种、热源。','皮肤接触：立即脱去污染的衣着，用大量流动清水冲洗至少15分钟。','穿橡胶耐酸碱服，戴橡胶耐酸碱手套。',NULL,100.00,'千克','C区-1号仓库',NULL,1,'2026-01-05 08:59:13','2026-01-05 08:59:13',NULL);
/*!40000 ALTER TABLE `hazmat_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `safety_admin`
--

DROP TABLE IF EXISTS `safety_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `safety_admin` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '安全管理员ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `real_name` varchar(50) DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `department` varchar(100) DEFAULT NULL COMMENT '负责部门',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像URL',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='安全管理员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `safety_admin`
--

LOCK TABLES `safety_admin` WRITE;
/*!40000 ALTER TABLE `safety_admin` DISABLE KEYS */;
INSERT INTO `safety_admin` VALUES (1,'safety','$2b$12$tpP2JAqVoWFv0gpHINXCIOzLkBXozPwQJ.bQkP8ISRodVV36ahICW','安全管理员','13800000001','safety@example.com','安全管理部',NULL,1,'2026-01-05 08:59:13','2026-01-05 09:15:26');
/*!40000 ALTER TABLE `safety_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `safety_knowledge`
--

DROP TABLE IF EXISTS `safety_knowledge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `safety_knowledge` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '知识ID',
  `title` varchar(200) NOT NULL COMMENT '标题',
  `content` text COMMENT '内容',
  `category` varchar(50) DEFAULT NULL COMMENT '分类（操作规程、安全知识、应急预案）',
  `cover_image` varchar(255) DEFAULT NULL COMMENT '封面图片',
  `view_count` int DEFAULT '0' COMMENT '浏览次数',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-草稿，1-已发布',
  `create_by` bigint DEFAULT NULL COMMENT '创建人ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='安全知识表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `safety_knowledge`
--

LOCK TABLES `safety_knowledge` WRITE;
/*!40000 ALTER TABLE `safety_knowledge` DISABLE KEYS */;
INSERT INTO `safety_knowledge` VALUES (1,'危险化学品安全操作规程','一、总则\n1. 本规程适用于公司所有涉及危险化学品操作的岗位。\n2. 所有操作人员必须经过专业培训并取得相应资质后方可上岗。\n\n二、操作前准备\n1. 检查个人防护装备是否齐全、完好。\n2. 检查操作区域通风设施是否正常运行。\n3. 确认应急设施（洗眼器、淋浴器等）处于正常状态。\n\n三、操作要求\n1. 严格按照操作规程进行操作，不得擅自更改操作步骤。\n2. 操作过程中应保持注意力集中，不得从事与工作无关的活动。\n3. 发现异常情况应立即停止操作并报告。','操作规程',NULL,2,1,NULL,'2026-01-05 08:59:13','2026-01-05 08:59:13'),(2,'化学品泄漏应急处置预案','一、目的\n为有效预防、及时控制和消除化学品泄漏事故的危害，保障员工生命安全和公司财产安全。\n\n二、适用范围\n适用于公司范围内所有化学品泄漏事故的应急处置。\n\n三、应急处置程序\n1. 发现泄漏后，立即向安全管理部门报告。\n2. 疏散泄漏区域内无关人员，设置警戒区域。\n3. 根据泄漏物质特性，选择适当的防护装备和处置方法。\n4. 对泄漏物进行收集、处理，防止扩散。\n5. 事故处置完毕后，进行现场清理和环境监测。','应急预案',NULL,0,1,NULL,'2026-01-05 08:59:13','2026-01-05 08:59:13'),(3,'个人防护装备使用指南','一、防护装备分类\n1. 呼吸防护：防毒面具、空气呼吸器、防尘口罩等。\n2. 眼面防护：安全眼镜、防护面罩、防化学飞溅眼罩等。\n3. 身体防护：防化服、耐酸碱服、防静电服等。\n4. 手部防护：耐酸碱手套、防化手套、绝缘手套等。\n5. 足部防护：防化靴、绝缘鞋、防砸鞋等。\n\n二、使用注意事项\n1. 使用前检查防护装备是否完好无损。\n2. 正确佩戴，确保密封性和防护效果。\n3. 使用后及时清洗、消毒、存放。\n4. 定期检查、更换过期或损坏的防护装备。','安全知识',NULL,2,1,NULL,'2026-01-05 08:59:13','2026-01-05 08:59:13');
/*!40000 ALTER TABLE `safety_knowledge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_admin`
--

DROP TABLE IF EXISTS `sys_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_admin` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '系统管理员ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `real_name` varchar(50) DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像URL',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统管理员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_admin`
--

LOCK TABLES `sys_admin` WRITE;
/*!40000 ALTER TABLE `sys_admin` DISABLE KEYS */;
INSERT INTO `sys_admin` VALUES (1,'admin','$2b$12$tpP2JAqVoWFv0gpHINXCIOzLkBXozPwQJ.bQkP8ISRodVV36ahICW','系统管理员','13800000000','admin@example.com',NULL,1,'2026-01-05 08:59:13','2026-01-05 09:15:26');
/*!40000 ALTER TABLE `sys_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `real_name` varchar(50) DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `department` varchar(100) DEFAULT NULL COMMENT '所属部门',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像URL',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='普通员工表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,'huyiwen','$2a$10$nhrkfSvgfJCHZJyz2hyDfuhNROwBK397CTqUZVsaADcPHGR.jOsOy','Huyiwen','17683728423','17683728423@163.com','测试部',NULL,1,'2026-01-05 04:10:52','2026-01-05 04:10:52'),(2,'111','$2a$10$GPdgYd/3CpGNqJiRw0/4aucro5R/ip4a722Lt60oUygDk2RdirE3.','111','13686666666','1111111@qq.com','1',NULL,1,'2026-01-05 04:21:03','2026-01-05 04:21:03');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-05  4:32:51
