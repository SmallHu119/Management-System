/*
 Navicat Premium Data Transfer

 Source Server         : huyiwen
 Source Server Type    : MySQL
 Source Server Version : 80045 (8.0.45)
 Source Host           : localhost:3306
 Source Schema         : hazmat_safety

 Target Server Type    : MySQL
 Target Server Version : 80045 (8.0.45)
 File Encoding         : 65001

 Date: 06/05/2026 10:56:46
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for announcement
-- ----------------------------
DROP TABLE IF EXISTS `announcement`;
CREATE TABLE `announcement`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '公告内容',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '公告类型（通知、公告、系统简介）',
  `priority` int NULL DEFAULT 0 COMMENT '优先级',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-草稿，1-已发布',
  `publish_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of announcement
-- ----------------------------
INSERT INTO `announcement` VALUES (1, '企业危化品安全管理系统上线通知', '各位员工：\n\n为进一步加强公司危险化学品安全管理，提高安全管理水平，公司决定启用企业危化品安全管理系统。\n\n系统主要功能包括：\n1. 危化品信息管理\n2. 安全检查管理\n3. 隐患上报与处理\n4. 安全知识学习\n\n请各部门积极配合，按要求完成系统培训和使用。\n\n特此通知。', '通知', 1, 1, '2026-03-20 20:07:03', NULL, '2026-01-05 08:59:13', '2026-01-05 08:59:13');
INSERT INTO `announcement` VALUES (2, '系统简介', '企业危化品安全管理系统是一套基于SpringBoot+Vue3技术栈开发的现代化安全管理平台，旨在帮助企业实现危险化学品的全生命周期管理。\n\n系统特点：\n1. 前后端分离架构，界面美观、操作便捷\n2. 完善的权限管理，保障数据安全\n3. 全面的危化品信息管理功能\n4. 规范的安全检查流程\n5. 便捷的隐患上报机制\n6. 丰富的安全知识库', '系统简介', 0, 1, '2026-01-05 08:59:13', NULL, '2026-01-05 08:59:13', '2026-01-05 08:59:13');

-- ----------------------------
-- Table structure for check_plan
-- ----------------------------
DROP TABLE IF EXISTS `check_plan`;
CREATE TABLE `check_plan`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '计划ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '计划标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '计划描述',
  `check_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '检查类型（日常检查、专项检查、综合检查）',
  `plan_date` date NULL DEFAULT NULL COMMENT '计划检查日期',
  `department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '检查部门',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0-待执行，1-进行中，2-已完成',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '检查计划表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of check_plan
-- ----------------------------
INSERT INTO `check_plan` VALUES (1, '测试', NULL, NULL, '2026-03-20', NULL, 2, NULL, '2026-03-19 10:49:19', '2026-03-19 10:49:19');
INSERT INTO `check_plan` VALUES (2, '硫酸储存区专项检查', '检查硫酸储存区的温控系统、通风系统和防泄漏设施', '专项检查', '2026-01-04', '安全管理部', 1, 1, '2026-01-03 08:30:00', '2026-01-04 10:00:00');
INSERT INTO `check_plan` VALUES (3, '1月综合安全检查', '对全厂危化品储存、使用、运输进行全面检查', '综合检查', '2026-01-08', '安全管理部', 0, 1, '2026-01-03 08:00:00', '2026-01-03 08:00:00');
INSERT INTO `check_plan` VALUES (4, '甲醇储存区专项检查', '检查甲醇储存区的防火防爆设施', '专项检查', '2026-01-06', '安全管理部', 0, 2, '2026-01-04 09:00:00', '2026-01-04 09:00:00');
INSERT INTO `check_plan` VALUES (5, '1月第二次日常安全检查', '对B区所有仓库进行日常检查', '日常检查', '2026-01-10', '安全管理部', 0, 1, '2026-01-05 08:00:00', '2026-01-05 08:00:00');

-- ----------------------------
-- Table structure for check_record
-- ----------------------------
DROP TABLE IF EXISTS `check_record`;
CREATE TABLE `check_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `plan_id` bigint NULL DEFAULT NULL COMMENT '关联计划ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '检查标题',
  `check_date` date NULL DEFAULT NULL COMMENT '检查日期',
  `check_location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '检查地点',
  `check_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '检查内容',
  `check_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '检查结果',
  `problems_found` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '发现问题',
  `suggestions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '整改建议',
  `checker_id` bigint NULL DEFAULT NULL COMMENT '检查人ID',
  `checker_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '检查人姓名',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0-待审核，1-已通过，2-需整改',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_plan_id`(`plan_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '检查记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of check_record
-- ----------------------------
INSERT INTO `check_record` VALUES (1, 1, '测试 - 检查记录', '2026-03-20', NULL, NULL, '正常', NULL, NULL, 1, '系统管理员', 1, '2026-03-19 10:49:51', '2026-03-19 10:49:51');
INSERT INTO `check_record` VALUES (2, 1, 'A区-2号仓库(盐酸)日常检查', '2026-01-02', 'A区-2号仓库', '检查储存容器完整性、通风设备运行状态', '通风设备运行正常，但发现一个盐酸桶密封圈老化', '盐酸桶密封圈老化', '建议3天内更换老化的密封圈', 1, '安全管理员', 2, '2026-01-02 11:00:00', '2026-01-02 11:00:00');
INSERT INTO `check_record` VALUES (3, 2, '硫酸储存区专项检查', '2026-01-04', 'A区-1号仓库', '检查温控系统精度、防泄漏托盘、应急喷淋设备', '温控系统正常，防泄漏托盘完好，应急喷淋出水正常', NULL, NULL, 1, '安全管理员', 1, '2026-01-04 09:30:00', '2026-01-04 09:30:00');
INSERT INTO `check_record` VALUES (4, 2, '硫酸储存区专项检查(复查)', '2026-01-05', 'A区-1号仓库', '复查上次发现的盐酸桶密封圈更换情况', '密封圈已更换，确认完好', NULL, NULL, 2, '李安全', 1, '2026-01-05 10:00:00', '2026-01-05 10:00:00');

-- ----------------------------
-- Table structure for hazard_report
-- ----------------------------
DROP TABLE IF EXISTS `hazard_report`;
CREATE TABLE `hazard_report`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '隐患ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '隐患标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '隐患描述',
  `location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '隐患位置',
  `hazard_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '隐患等级（一般、较大、重大）',
  `hazard_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '隐患类型',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '图片路径（JSON数组）',
  `reporter_id` bigint NULL DEFAULT NULL COMMENT '上报人ID',
  `reporter_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '上报人姓名',
  `report_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上报时间',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0-待处理，1-处理中，2-已整改，3-已关闭',
  `handler_id` bigint NULL DEFAULT NULL COMMENT '处理人ID',
  `handler_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '处理人姓名',
  `handle_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `handle_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '处理结果',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_reporter_id`(`reporter_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '隐患上报表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hazard_report
-- ----------------------------
INSERT INTO `hazard_report` VALUES (2, '测试', '测试系统测试系统测试系统测试系统', 'A51001Q', '一般', NULL, '', 1, 'safety', '2026-03-19 10:52:09', 2, 1, 'admin', '2026-03-19 10:52:58', '测试通过', '2026-03-19 10:52:09', '2026-03-19 10:52:09');
INSERT INTO `hazard_report` VALUES (3, '盐酸储存桶轻微泄漏', 'A区-2号仓库第3号盐酸储存桶底部发现少量液体渗出，约为每小时5ml', 'A区-2号仓库', '一般', '容器泄漏', '', 3, '张三', '2026-01-04 16:20:00', 1, 1, '安全管理员', '2026-01-04 17:00:00', '已将泄漏桶转移至防泄漏托盘，正在联系供应商更换', '2026-01-04 16:20:00', '2026-01-04 17:00:00');
INSERT INTO `hazard_report` VALUES (4, '乙醇储存区消防通道被占用', 'B区-2号仓库门口消防通道被临时堆放的包装箱占用约三分之一通道宽度', 'B区-2号仓库', '较大', '消防通道堵塞', '', 4, '李四', '2026-01-05 08:45:00', 0, NULL, NULL, NULL, NULL, '2026-01-05 08:45:00', '2026-01-05 08:45:00');
INSERT INTO `hazard_report` VALUES (5, '氢氧化钠储存区地面有积水', 'C区-1号仓库地面发现约2平方米积水，存在氢氧化钠遇水发热风险', 'C区-1号仓库', '一般', '环境异常', '', 5, '王五', '2026-01-05 11:00:00', 0, NULL, NULL, NULL, NULL, '2026-01-05 11:00:00', '2026-01-05 11:00:00');

-- ----------------------------
-- Table structure for hazard_warning_rule
-- ----------------------------
DROP TABLE IF EXISTS `hazard_warning_rule`;
CREATE TABLE `hazard_warning_rule`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '规则ID',
  `hazmat_id` bigint NOT NULL COMMENT '关联危化品ID',
  `param_id` bigint NOT NULL COMMENT '监测参数ID',
  `warning_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预警级别（一般、较大、重大）',
  `threshold_min` decimal(10, 2) NULL DEFAULT NULL COMMENT '阈值下限',
  `threshold_max` decimal(10, 2) NULL DEFAULT NULL COMMENT '阈值上限',
  `min_value` decimal(10, 2) NULL DEFAULT NULL COMMENT '正常范围最小值',
  `max_value` decimal(10, 2) NULL DEFAULT NULL COMMENT '正常范围最大值',
  `warning_min_value` decimal(10, 2) NULL DEFAULT NULL COMMENT '预警范围最小值',
  `warning_max_value` decimal(10, 2) NULL DEFAULT NULL COMMENT '预警范围最大值',
  `warning_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '预警提示信息',
  `notification_methods` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '通知方式（邮件、短信、系统消息）',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `enabled` tinyint NULL DEFAULT 1 COMMENT '是否启用:0-禁用,1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hazmat_id`(`hazmat_id` ASC) USING BTREE,
  INDEX `idx_param_id`(`param_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '危化品预警规则表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hazard_warning_rule
-- ----------------------------
INSERT INTO `hazard_warning_rule` VALUES (3, 1, 2, '一般', 30.00, 85.00, NULL, NULL, NULL, NULL, '硫酸储存环境湿度应保持在30%-85%之间', '系统消息', 1, 1, '2026-03-26 11:36:44', '2026-03-26 11:36:44');
INSERT INTO `hazard_warning_rule` VALUES (4, 2, 1, '一般', 5.00, 30.00, NULL, NULL, NULL, NULL, '盐酸储存温度应保持在5-30℃之间', '系统消息', 1, 1, '2026-03-26 11:36:44', '2026-03-26 11:36:44');
INSERT INTO `hazard_warning_rule` VALUES (5, 2, 1, '较大', NULL, 35.00, NULL, NULL, NULL, NULL, '盐酸储存温度过高，存在挥发风险', '系统消息,邮件', 1, 1, '2026-03-26 11:36:44', '2026-03-26 11:36:44');
INSERT INTO `hazard_warning_rule` VALUES (6, 2, 7, '重大', 19.50, NULL, NULL, NULL, NULL, NULL, '储存区域氧气含量过低，存在窒息风险', '系统消息,短信,邮件', 1, 1, '2026-03-26 11:36:44', '2026-03-26 11:36:44');
INSERT INTO `hazard_warning_rule` VALUES (7, 3, 1, '一般', 0.00, 25.00, NULL, NULL, NULL, NULL, '甲醇储存温度应保持在0-25℃之间', '系统消息', 1, 1, '2026-03-26 11:36:44', '2026-03-26 11:36:44');
INSERT INTO `hazard_warning_rule` VALUES (8, 3, 1, '较大', NULL, 30.00, NULL, NULL, NULL, NULL, '甲醇储存温度过高，存在火灾风险', '系统消息,邮件', 1, 1, '2026-03-26 11:36:44', '2026-03-26 11:36:44');
INSERT INTO `hazard_warning_rule` VALUES (9, 3, 6, '重大', NULL, 50.00, NULL, NULL, NULL, NULL, '甲醇储存区域烟雾浓度过高，可能发生火灾', '系统消息,短信,邮件', 1, 1, '2026-03-26 11:36:44', '2026-03-26 11:36:44');
INSERT INTO `hazard_warning_rule` VALUES (10, 3, 4, '较大', NULL, 200.00, NULL, NULL, NULL, NULL, '甲醇蒸汽浓度超标，存在爆炸风险', '系统消息,短信', 1, 1, '2026-03-26 11:36:44', '2026-03-26 11:36:44');
INSERT INTO `hazard_warning_rule` VALUES (11, 3, 4, '一般', 0.00, 200.00, 0.00, 150.00, NULL, 200.00, '甲醇蒸气浓度偏高，注意通风', '系统消息', 1, 1, '2026-05-06 10:42:10', '2026-05-06 10:42:10');
INSERT INTO `hazard_warning_rule` VALUES (12, 3, 6, '重大', NULL, 50.00, 0.00, 30.00, NULL, 50.00, '甲醇储存区域烟雾浓度过高，可能发生火灾', '系统消息,短信,邮件', 1, 1, '2026-05-06 10:42:10', '2026-05-06 10:42:10');
INSERT INTO `hazard_warning_rule` VALUES (13, 4, 1, '3', -5.00, 30.00, -5.00, 25.00, -10.00, 30.00, '乙醇储存温度偏高', '系统消息', 1, 1, '2026-05-06 10:42:10', '2026-05-06 10:47:36');
INSERT INTO `hazard_warning_rule` VALUES (14, 4, 1, '较大', NULL, 35.00, -5.00, 25.00, NULL, 35.00, '乙醇储存温度过高，存在火灾爆炸风险', '系统消息,邮件', 1, 1, '2026-05-06 10:42:10', '2026-05-06 10:42:10');
INSERT INTO `hazard_warning_rule` VALUES (15, 5, 2, '一般', 20.00, 80.00, 20.00, 70.00, 10.00, 80.00, '氢氧化钠储存环境湿度偏高，注意防潮', '系统消息', 1, 1, '2026-05-06 10:42:10', '2026-05-06 10:42:10');
INSERT INTO `hazard_warning_rule` VALUES (16, 5, 2, '较大', NULL, 90.00, 20.00, 70.00, NULL, 90.00, '氢氧化钠储存环境湿度过高，存在潮解风险', '系统消息,邮件', 1, 1, '2026-05-06 10:42:10', '2026-05-06 10:42:10');
INSERT INTO `hazard_warning_rule` VALUES (17, 5, 1, '一般', 0.00, 35.00, 0.00, 30.00, -5.00, 35.00, '氢氧化钠储存温度偏高', '系统消息', 1, 1, '2026-05-06 10:42:10', '2026-05-06 10:42:10');

-- ----------------------------
-- Table structure for hazmat_category
-- ----------------------------
DROP TABLE IF EXISTS `hazmat_category`;
CREATE TABLE `hazmat_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '类别ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类别名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '类别编码',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '类别描述',
  `danger_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '危险等级',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父类别ID',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '危化品类别表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hazmat_category
-- ----------------------------
INSERT INTO `hazmat_category` VALUES (1, '爆炸品', 'CAT001', '具有爆炸性质的危险化学品', '极高', 0, 1, 1, '2026-01-05 08:59:13', '2026-01-05 08:59:13');
INSERT INTO `hazmat_category` VALUES (2, '压缩气体和液化气体', 'CAT002', '在压力下储存的气体', '高', 0, 2, 1, '2026-01-05 08:59:13', '2026-01-05 08:59:13');
INSERT INTO `hazmat_category` VALUES (3, '易燃液体', 'CAT003', '闪点低于61℃的液体', '高', 0, 3, 1, '2026-01-05 08:59:13', '2026-01-05 08:59:13');
INSERT INTO `hazmat_category` VALUES (4, '易燃固体', 'CAT004', '容易燃烧的固体物质', '中', 0, 4, 1, '2026-01-05 08:59:13', '2026-01-05 08:59:13');
INSERT INTO `hazmat_category` VALUES (5, '氧化剂和有机过氧化物', 'CAT005', '具有氧化性的物质', '高', 0, 5, 1, '2026-01-05 08:59:13', '2026-01-05 08:59:13');
INSERT INTO `hazmat_category` VALUES (6, '毒害品', 'CAT006', '对人体有毒害作用的物质', '高', 0, 6, 1, '2026-01-05 08:59:13', '2026-01-05 08:59:13');
INSERT INTO `hazmat_category` VALUES (7, '腐蚀品', 'CAT007', '具有腐蚀性的物质', '中', 0, 7, 1, '2026-01-05 08:59:13', '2026-01-05 08:59:13');
INSERT INTO `hazmat_category` VALUES (8, '放射性物品', 'CAT008', '具有放射性的物质', '极高', 0, 8, 1, '2026-01-05 08:59:13', '2026-01-05 08:59:13');

-- ----------------------------
-- Table structure for hazmat_info
-- ----------------------------
DROP TABLE IF EXISTS `hazmat_info`;
CREATE TABLE `hazmat_info`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '危化品ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '危化品名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '危化品编码',
  `category_id` bigint NULL DEFAULT NULL COMMENT '类别ID',
  `cas_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'CAS号',
  `un_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'UN编号',
  `danger_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '危险类型（易燃、易爆、剧毒、腐蚀等）',
  `physical_state` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物理状态（固体、液体、气体）',
  `storage_condition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '储存条件',
  `emergency_measure` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '应急处置措施',
  `protective_measure` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '防护措施',
  `msds_file` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'MSDS文件路径',
  `stock_quantity` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '库存数量',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '计量单位',
  `location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '存放位置',
  `supplier` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '供应商',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category_id`(`category_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '危化品信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hazmat_info
-- ----------------------------
INSERT INTO `hazmat_info` VALUES (1, '硫酸', 'HM001', 7, '7664-93-9', 'UN1830', '腐蚀品', '液体', '储存于阴凉、通风的库房。库温不超过35℃，相对湿度不超过85%。', '皮肤接触：立即脱去污染的衣着，用大量流动清水冲洗至少15分钟。', '穿橡胶耐酸碱服，戴橡胶耐酸碱手套，戴化学安全防护眼镜。', NULL, 500.00, '升', 'A区-1号仓库', NULL, 1, '2026-01-05 08:59:13', '2026-01-05 08:59:13', NULL);
INSERT INTO `hazmat_info` VALUES (2, '盐酸', 'HM002', 7, '7647-01-0', 'UN1789', '腐蚀品', '液体', '储存于阴凉、通风的库房。库温不宜超过30℃。', '皮肤接触：立即脱去污染的衣着，用大量流动清水冲洗至少15分钟。', '穿橡胶耐酸碱服，戴橡胶耐酸碱手套。', NULL, 300.00, '升', 'A区-2号仓库', NULL, 1, '2026-01-05 08:59:13', '2026-01-05 08:59:13', NULL);
INSERT INTO `hazmat_info` VALUES (3, '甲醇', 'HM003', 3, '67-56-1', 'UN1230', '易燃液体、有毒', '液体', '储存于阴凉、通风的库房。远离火种、热源。', '迅速撤离泄漏污染区人员至安全区，并进行隔离，严格限制出入。', '穿防静电工作服，戴橡胶手套，佩戴过滤式防毒面具。', NULL, 200.00, '升', 'B区-1号仓库', NULL, 1, '2026-01-05 08:59:13', '2026-01-05 08:59:13', NULL);
INSERT INTO `hazmat_info` VALUES (4, '乙醇', 'HM004', 3, '64-17-5', 'UN1170', '易燃液体', '液体', '储存于阴凉、通风的库房。远离火种、热源。库温不宜超过30℃。', '迅速撤离泄漏污染区人员至安全区，并进行隔离。', '穿防静电工作服，戴一般作业防护手套。', NULL, 400.00, '升', 'B区-2号仓库', NULL, 1, '2026-01-05 08:59:13', '2026-01-05 08:59:13', NULL);
INSERT INTO `hazmat_info` VALUES (5, '氢氧化钠', 'HM005', 7, '1310-73-2', 'UN1823', '腐蚀品', '固体', '储存于阴凉、干燥、通风良好的库房。远离火种、热源。', '皮肤接触：立即脱去污染的衣着，用大量流动清水冲洗至少15分钟。', '穿橡胶耐酸碱服，戴橡胶耐酸碱手套。', NULL, 100.00, '千克', 'C区-1号仓库', NULL, 1, '2026-01-05 08:59:13', '2026-01-05 08:59:13', NULL);

-- ----------------------------
-- Table structure for monitoring_parameter
-- ----------------------------
DROP TABLE IF EXISTS `monitoring_parameter`;
CREATE TABLE `monitoring_parameter`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '参数ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参数名称（温度、湿度、压力、浓度等）',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '参数编码',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '计量单位',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '参数描述',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '监测参数表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of monitoring_parameter
-- ----------------------------
INSERT INTO `monitoring_parameter` VALUES (1, '温度', 'PARAM001', '℃', '环境或储存容器内的温度', 1, 1, '2026-03-26 11:36:44', '2026-03-26 11:36:44');
INSERT INTO `monitoring_parameter` VALUES (2, '湿度', 'PARAM002', '%RH', '环境相对湿度', 2, 1, '2026-03-26 11:36:44', '2026-03-26 11:36:44');
INSERT INTO `monitoring_parameter` VALUES (3, '压力', 'PARAM003', 'kPa', '储存容器内的压力', 3, 1, '2026-03-26 11:36:44', '2026-03-26 11:36:44');
INSERT INTO `monitoring_parameter` VALUES (4, '浓度', 'PARAM004', 'ppm', '空气中有害物质浓度', 4, 1, '2026-03-26 11:36:44', '2026-03-26 11:36:44');
INSERT INTO `monitoring_parameter` VALUES (5, '液位', 'PARAM005', '%', '储存容器内的液体高度百分比', 5, 1, '2026-03-26 11:36:44', '2026-03-26 11:36:44');
INSERT INTO `monitoring_parameter` VALUES (6, '烟雾浓度', 'PARAM006', 'ppm', '环境中烟雾浓度', 6, 1, '2026-03-26 11:36:44', '2026-03-26 11:36:44');
INSERT INTO `monitoring_parameter` VALUES (7, '氧气含量', 'PARAM007', '%', '环境中氧气含量百分比', 7, 1, '2026-03-26 11:36:44', '2026-03-26 11:36:44');

-- ----------------------------
-- Table structure for real_time_monitoring
-- ----------------------------
DROP TABLE IF EXISTS `real_time_monitoring`;
CREATE TABLE `real_time_monitoring`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '数据ID',
  `hazmat_id` bigint NOT NULL COMMENT '关联危化品ID',
  `param_id` bigint NOT NULL COMMENT '监测参数ID',
  `param_value` decimal(10, 2) NOT NULL COMMENT '监测值',
  `monitor_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '监测时间',
  `device_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '监测设备ID',
  `location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '监测位置',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0-正常，1-预警',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hazmat_id`(`hazmat_id` ASC) USING BTREE,
  INDEX `idx_param_id`(`param_id` ASC) USING BTREE,
  INDEX `idx_monitor_time`(`monitor_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '实时监测数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of real_time_monitoring
-- ----------------------------

-- ----------------------------
-- Table structure for safety_admin
-- ----------------------------
DROP TABLE IF EXISTS `safety_admin`;
CREATE TABLE `safety_admin`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '安全管理员ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责部门',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像URL',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '安全管理员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of safety_admin
-- ----------------------------
INSERT INTO `safety_admin` VALUES (1, 'safety', '$2b$12$tpP2JAqVoWFv0gpHINXCIOzLkBXozPwQJ.bQkP8ISRodVV36ahICW', '安全管理员', '13800000001', 'safety@example.com', '安全管理部', NULL, 1, '2026-01-05 08:59:13', '2026-01-05 09:15:26');
INSERT INTO `safety_admin` VALUES (2, 'safety2', '$2b$12$tpP2JAqVoWFv0gpHINXCIOzLkBXozPwQJ.bQkP8ISRodVV36ahICW', '李安全', '13800000005', 'lisafe@example.com', '安全管理部', NULL, 1, '2026-05-06 10:42:10', '2026-05-06 10:42:10');

-- ----------------------------
-- Table structure for safety_knowledge
-- ----------------------------
DROP TABLE IF EXISTS `safety_knowledge`;
CREATE TABLE `safety_knowledge`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '知识ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '内容',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类（操作规程、安全知识、应急预案）',
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '封面图片',
  `view_count` int NULL DEFAULT 0 COMMENT '浏览次数',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-草稿，1-已发布',
  `create_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '安全知识表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of safety_knowledge
-- ----------------------------
INSERT INTO `safety_knowledge` VALUES (1, '危险化学品安全操作规程', '一、总则\n1. 本规程适用于公司所有涉及危险化学品操作的岗位。\n2. 所有操作人员必须经过专业培训并取得相应资质后方可上岗。\n\n二、操作前准备\n1. 检查个人防护装备是否齐全、完好。\n2. 检查操作区域通风设施是否正常运行。\n3. 确认应急设施（洗眼器、淋浴器等）处于正常状态。\n\n三、操作要求\n1. 严格按照操作规程进行操作，不得擅自更改操作步骤。\n2. 操作过程中应保持注意力集中，不得从事与工作无关的活动。\n3. 发现异常情况应立即停止操作并报告。', '操作规程', NULL, 7, 1, NULL, '2026-01-05 08:59:13', '2026-01-05 08:59:13');
INSERT INTO `safety_knowledge` VALUES (2, '化学品泄漏应急处置预案', '一、目的\n为有效预防、及时控制和消除化学品泄漏事故的危害，保障员工生命安全和公司财产安全。\n\n二、适用范围\n适用于公司范围内所有化学品泄漏事故的应急处置。\n\n三、应急处置程序\n1. 发现泄漏后，立即向安全管理部门报告。\n2. 疏散泄漏区域内无关人员，设置警戒区域。\n3. 根据泄漏物质特性，选择适当的防护装备和处置方法。\n4. 对泄漏物进行收集、处理，防止扩散。\n5. 事故处置完毕后，进行现场清理和环境监测。', '应急预案', NULL, 4, 1, NULL, '2026-01-05 08:59:13', '2026-01-05 08:59:13');
INSERT INTO `safety_knowledge` VALUES (3, '个人防护装备使用指南', '一、防护装备分类\n1. 呼吸防护：防毒面具、空气呼吸器、防尘口罩等。\n2. 眼面防护：安全眼镜、防护面罩、防化学飞溅眼罩等。\n3. 身体防护：防化服、耐酸碱服、防静电服等。\n4. 手部防护：耐酸碱手套、防化手套、绝缘手套等。\n5. 足部防护：防化靴、绝缘鞋、防砸鞋等。\n\n二、使用注意事项\n1. 使用前检查防护装备是否完好无损。\n2. 正确佩戴，确保密封性和防护效果。\n3. 使用后及时清洗、消毒、存放。\n4. 定期检查、更换过期或损坏的防护装备。', '安全知识', NULL, 3, 1, NULL, '2026-01-05 08:59:13', '2026-01-05 08:59:13');
INSERT INTO `safety_knowledge` VALUES (4, '测试', '测试', '案例分析', NULL, 3, 1, NULL, '2026-03-20 20:05:57', '2026-03-20 20:05:57');
INSERT INTO `safety_knowledge` VALUES (5, '硫酸灼伤事故案例分析', '事故经过：\n2025年3月，某化工厂操作人员在转移硫酸时未佩戴防酸手套，不慎将硫酸溅到右手。\n\n原因分析：\n1. 未正确穿戴个人防护装备\n2. 操作规程执行不到位\n3. 现场缺少应急冲洗设施检查\n\n经验教训：\n1. 接触腐蚀品必须穿戴全套防护装备\n2. 操作前必须检查应急设施是否正常\n3. 严格执行操作规程，杜绝侥幸心理', '案例分析', NULL, 0, 1, 2, '2026-01-04 14:00:00', '2026-01-04 14:00:00');
INSERT INTO `safety_knowledge` VALUES (6, '易燃液体防火防爆知识', '一、易燃液体特性\n1. 闪点低，易挥发形成可燃蒸气\n2. 蒸气与空气可形成爆炸性混合物\n3. 遇明火、高热极易燃烧爆炸\n\n二、防火措施\n1. 储存区域严禁烟火\n2. 使用防爆电气设备\n3. 保持良好通风\n4. 控制储存温度在安全范围内\n\n三、灭火方法\n1. 小型火灾：使用干粉灭火器\n2. 大量泄漏起火：使用泡沫灭火\n3. 严禁使用水直接喷射', '安全知识', NULL, 0, 1, 1, '2026-01-05 08:00:00', '2026-01-05 08:00:00');

-- ----------------------------
-- Table structure for sys_admin
-- ----------------------------
DROP TABLE IF EXISTS `sys_admin`;
CREATE TABLE `sys_admin`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '系统管理员ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像URL',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统管理员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_admin
-- ----------------------------
INSERT INTO `sys_admin` VALUES (1, 'admin', '$2b$12$tpP2JAqVoWFv0gpHINXCIOzLkBXozPwQJ.bQkP8ISRodVV36ahICW', '系统管理员', '13800000000', 'admin@example.com', NULL, 1, '2026-01-05 08:59:13', '2026-01-05 09:15:26');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所属部门',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像URL',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '普通员工表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'huyiwen', '$2a$10$nhrkfSvgfJCHZJyz2hyDfuhNROwBK397CTqUZVsaADcPHGR.jOsOy', 'Huyiwen', '17683728423', '17683728423@163.com', '测试部', NULL, 1, '2026-01-05 04:10:52', '2026-01-05 04:10:52');
INSERT INTO `sys_user` VALUES (3, 'ceshi', '$2a$10$x0B7mNR2tRGy6Z/7i661QuHbY3LUgBWjAI1c/ZbZBHCeALB4QKFCa', '测试远', '17683728888', '17683728888@163.com', '测试部', NULL, 1, '2026-03-19 14:17:49', '2026-03-19 14:17:49');
INSERT INTO `sys_user` VALUES (4, 'ceshi1', '$2a$10$an5hTSioyJtUps5O/WU5k.UqKlQTgxMHAYGyMqqYA6sxT/xlBhuV6', 'huyiwen', '17683728423', '17683728423@163.com', 'cesi', NULL, 1, '2026-03-20 20:09:20', '2026-03-20 20:09:20');
INSERT INTO `sys_user` VALUES (5, 'huyiwen1', '$2a$10$NDZlOROFIqbh6eY0it9E9uggq1zGf3HXuWCYk7WyGoh3hefdtmgsa', 'huyiwen', '', '', '', NULL, 1, '2026-05-06 09:51:15', '2026-05-06 09:51:15');

-- ----------------------------
-- Table structure for warning_record
-- ----------------------------
DROP TABLE IF EXISTS `warning_record`;
CREATE TABLE `warning_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '预警ID',
  `hazmat_id` bigint NOT NULL COMMENT '关联危化品ID',
  `rule_id` bigint NOT NULL COMMENT '关联预警规则ID',
  `param_value` decimal(10, 2) NOT NULL COMMENT '触发值',
  `warning_value` decimal(10, 2) NULL DEFAULT NULL COMMENT '预警值',
  `threshold_value` decimal(10, 2) NULL DEFAULT NULL COMMENT '阈值',
  `warning_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预警级别',
  `warning_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预警信息',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0-未处理，1-已处理',
  `handler_id` bigint NULL DEFAULT NULL COMMENT '处理人ID',
  `handler_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '处理人姓名',
  `handle_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `handle_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '处理结果',
  `warning_time` datetime NULL DEFAULT NULL COMMENT '预警时间',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '描述',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '预警时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hazmat_id`(`hazmat_id` ASC) USING BTREE,
  INDEX `idx_rule_id`(`rule_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预警记录表' ROW_FORMAT = Dynamic;

-- =====================================================
-- 风险监测与预警模块 - 完整修复脚本
-- =====================================================
-- 执行前提: 已导入 hazmat_safety.sql
-- 作用: 修复表结构缺失、修正数据错误、插入测试数据
-- 兼容: MySQL 8.0+
-- =====================================================

USE hazmat_safety;

SELECT '=== 开始修复监测预警模块 ===' AS step;

-- ============================================================
-- 第一步: 修复 real_time_monitoring 表
-- ============================================================

-- 1.1 添加缺失的 data_source 列(MySQL 8.0 兼容写法)
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'hazmat_safety' AND TABLE_NAME = 'real_time_monitoring' AND COLUMN_NAME = 'data_source');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE `real_time_monitoring` ADD COLUMN `data_source` VARCHAR(50) DEFAULT NULL COMMENT ''数据来源(传感器/手动录入/外部接口)'' AFTER `device_id`',
    'SELECT ''data_source 列已存在，跳过'' AS msg');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 1.2 修正 status 字段注释(原来是0/1，现改为0/1/2)
ALTER TABLE `real_time_monitoring`
    MODIFY COLUMN `status` TINYINT DEFAULT 0 COMMENT '状态:0-正常,1-预警,2-报警';

SELECT '=== real_time_monitoring 表修复完成 ===' AS step;

-- ============================================================
-- 第二步: 修复 warning_record 表
-- ============================================================

-- 2.1 添加缺失的 param_id 列(MySQL 8.0 兼容写法)
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'hazmat_safety' AND TABLE_NAME = 'warning_record' AND COLUMN_NAME = 'param_id');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE `warning_record` ADD COLUMN `param_id` BIGINT DEFAULT NULL COMMENT ''关联监测参数ID'' AFTER `rule_id`',
    'SELECT ''param_id 列已存在，跳过'' AS msg');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2.2 修正 status 字段注释(原来是0/1，现改为0/1/2/3)
ALTER TABLE `warning_record`
    MODIFY COLUMN `status` TINYINT DEFAULT 0 COMMENT '状态:0-未处理,1-处理中,2-已解决,3-已忽略';

SELECT '=== warning_record 表修复完成 ===' AS step;

-- ============================================================
-- 第三步: 修复 hazard_warning_rule 脏数据
-- ============================================================

-- 3.1 修正 warning_level='3' 为正确的 '一般'
UPDATE `hazard_warning_rule`
SET `warning_level` = '一般'
WHERE `id` = 13 AND `warning_level` = '3';

-- 3.2 为旧规则(3-10)补全 min_value/max_value/warning_min_value/warning_max_value
-- 硫酸湿度规则 (id=3)
UPDATE `hazard_warning_rule` SET
    `min_value` = 30.00, `max_value` = 80.00,
    `warning_min_value` = 20.00, `warning_max_value` = 85.00
WHERE `id` = 3;

-- 盐酸温度一般规则 (id=4)
UPDATE `hazard_warning_rule` SET
    `min_value` = 5.00, `max_value` = 25.00,
    `warning_min_value` = 0.00, `warning_max_value` = 30.00
WHERE `id` = 4;

-- 盐酸温度较大规则 (id=5)
UPDATE `hazard_warning_rule` SET
    `min_value` = 5.00, `max_value` = 25.00,
    `warning_min_value` = NULL, `warning_max_value` = 35.00
WHERE `id` = 5;

-- 盐酸氧气重大规则 (id=6)
UPDATE `hazard_warning_rule` SET
    `min_value` = 20.00, `max_value` = 100.00,
    `warning_min_value` = 19.50, `warning_max_value` = NULL
WHERE `id` = 6;

-- 甲醇温度一般规则 (id=7)
UPDATE `hazard_warning_rule` SET
    `min_value` = -5.00, `max_value` = 20.00,
    `warning_min_value` = -10.00, `warning_max_value` = 25.00
WHERE `id` = 7;

-- 甲醇温度较大规则 (id=8)
UPDATE `hazard_warning_rule` SET
    `min_value` = -5.00, `max_value` = 20.00,
    `warning_min_value` = NULL, `warning_max_value` = 30.00
WHERE `id` = 8;

-- 甲醇烟雾重大规则 (id=9)
UPDATE `hazard_warning_rule` SET
    `min_value` = 0.00, `max_value` = 30.00,
    `warning_min_value` = NULL, `warning_max_value` = 50.00
WHERE `id` = 9;

-- 甲醇浓度较大规则 (id=10)
UPDATE `hazard_warning_rule` SET
    `min_value` = 0.00, `max_value` = 150.00,
    `warning_min_value` = NULL, `warning_max_value` = 200.00
WHERE `id` = 10;

SELECT '=== hazard_warning_rule 数据修复完成 ===' AS step;

-- ============================================================
-- 第四步: 插入 real_time_monitoring 测试数据
-- 覆盖 2026-01-01 ~ 2026-01-05, 含正常(0)/预警(1)/报警(2)
-- ============================================================

-- === 2026-01-01 ===
INSERT IGNORE INTO `real_time_monitoring` (`id`, `hazmat_id`, `param_id`, `param_value`, `monitor_time`, `device_id`, `data_source`, `location`, `status`, `create_time`) VALUES
(101, 1, 1, 25.10, '2026-01-01 08:00:00', 'DEV-S001', '传感器', 'A区-1号仓库', 0, '2026-01-01 08:00:00'),
(102, 1, 2, 50.30, '2026-01-01 08:00:00', 'DEV-S001', '传感器', 'A区-1号仓库', 0, '2026-01-01 08:00:00'),
(103, 1, 4, 2.30, '2026-01-01 08:00:00', 'DEV-S001', '传感器', 'A区-1号仓库', 0, '2026-01-01 08:00:00'),
(104, 2, 1, 22.60, '2026-01-01 09:00:00', 'DEV-S002', '传感器', 'A区-2号仓库', 0, '2026-01-01 09:00:00'),
(105, 2, 5, 55.70, '2026-01-01 09:00:00', 'DEV-S002', '传感器', 'A区-2号仓库', 0, '2026-01-01 09:00:00'),
(106, 3, 1, 18.90, '2026-01-01 10:00:00', 'DEV-S003', '传感器', 'B区-1号仓库', 0, '2026-01-01 10:00:00'),
(107, 3, 3, 101.50, '2026-01-01 10:00:00', 'DEV-S003', '传感器', 'B区-1号仓库', 0, '2026-01-01 10:00:00'),
(108, 4, 1, 20.80, '2026-01-01 11:00:00', 'DEV-S004', '传感器', 'B区-2号仓库', 0, '2026-01-01 11:00:00'),
(109, 5, 1, 23.90, '2026-01-01 08:30:00', 'DEV-S005', '传感器', 'C区-1号仓库', 0, '2026-01-01 08:30:00'),
(110, 5, 2, 36.20, '2026-01-01 08:30:00', 'DEV-S005', '传感器', 'C区-1号仓库', 0, '2026-01-01 08:30:00');

-- === 2026-01-02 ===
INSERT IGNORE INTO `real_time_monitoring` (`id`, `hazmat_id`, `param_id`, `param_value`, `monitor_time`, `device_id`, `data_source`, `location`, `status`, `create_time`) VALUES
(201, 1, 1, 24.30, '2026-01-02 08:00:00', 'DEV-S001', '传感器', 'A区-1号仓库', 0, '2026-01-02 08:00:00'),
(202, 1, 2, 51.40, '2026-01-02 08:00:00', 'DEV-S001', '传感器', 'A区-1号仓库', 0, '2026-01-02 08:00:00'),
(203, 1, 4, 3.20, '2026-01-02 08:00:00', 'DEV-S001', '传感器', 'A区-1号仓库', 0, '2026-01-02 08:00:00'),
-- 硫酸浓度偏高超正常上限(>3ppm) → 预警
(204, 1, 4, 4.80, '2026-01-02 16:30:00', 'DEV-S001', '传感器', 'A区-1号仓库', 1, '2026-01-02 16:30:00'),
(205, 2, 1, 23.10, '2026-01-02 09:00:00', 'DEV-S002', '传感器', 'A区-2号仓库', 0, '2026-01-02 09:00:00'),
(206, 2, 2, 44.50, '2026-01-02 09:00:00', 'DEV-S002', '传感器', 'A区-2号仓库', 0, '2026-01-02 09:00:00'),
(207, 3, 1, 19.30, '2026-01-02 10:00:00', 'DEV-S003', '传感器', 'B区-1号仓库', 0, '2026-01-02 10:00:00'),
(208, 4, 1, 21.40, '2026-01-02 11:00:00', 'DEV-S004', '传感器', 'B区-2号仓库', 0, '2026-01-02 11:00:00'),
-- 氢氧化钠湿度超正常上限(>70%) → 预警
(209, 5, 2, 75.60, '2026-01-02 14:00:00', 'DEV-S005', '传感器', 'C区-1号仓库', 1, '2026-01-02 14:00:00');

-- === 2026-01-03 ===
INSERT IGNORE INTO `real_time_monitoring` (`id`, `hazmat_id`, `param_id`, `param_value`, `monitor_time`, `device_id`, `data_source`, `location`, `status`, `create_time`) VALUES
(301, 1, 1, 25.60, '2026-01-03 08:00:00', 'DEV-S001', '传感器', 'A区-1号仓库', 0, '2026-01-03 08:00:00'),
(302, 1, 5, 72.30, '2026-01-03 08:00:00', 'DEV-S001', '传感器', 'A区-1号仓库', 0, '2026-01-03 08:00:00'),
-- 盐酸温度超正常上限(>25℃) → 预警
(303, 2, 1, 28.50, '2026-01-03 15:00:00', 'DEV-S002', '传感器', 'A区-2号仓库', 1, '2026-01-03 15:00:00'),
(304, 2, 4, 3.20, '2026-01-03 15:00:00', 'DEV-S002', '传感器', 'A区-2号仓库', 0, '2026-01-03 15:00:00'),
(305, 3, 1, 20.10, '2026-01-03 09:00:00', 'DEV-S003', '传感器', 'B区-1号仓库', 0, '2026-01-03 09:00:00'),
(306, 3, 4, 5.80, '2026-01-03 09:00:00', 'DEV-S003', '传感器', 'B区-1号仓库', 0, '2026-01-03 09:00:00'),
(307, 4, 1, 20.90, '2026-01-03 10:00:00', 'DEV-S004', '传感器', 'B区-2号仓库', 0, '2026-01-03 10:00:00'),
(308, 5, 1, 24.50, '2026-01-03 08:30:00', 'DEV-S005', '传感器', 'C区-1号仓库', 0, '2026-01-03 08:30:00');

-- === 2026-01-04 ===
INSERT IGNORE INTO `real_time_monitoring` (`id`, `hazmat_id`, `param_id`, `param_value`, `monitor_time`, `device_id`, `data_source`, `location`, `status`, `create_time`) VALUES
(401, 1, 1, 24.80, '2026-01-04 08:00:00', 'DEV-S001', '传感器', 'A区-1号仓库', 0, '2026-01-04 08:00:00'),
(402, 1, 3, 104.10, '2026-01-04 08:00:00', 'DEV-S001', '传感器', 'A区-1号仓库', 0, '2026-01-04 08:00:00'),
(403, 2, 1, 22.40, '2026-01-04 09:00:00', 'DEV-S002', '传感器', 'A区-2号仓库', 0, '2026-01-04 09:00:00'),
-- 乙醇温度超正常上限(>25℃) → 预警
(404, 4, 1, 28.30, '2026-01-04 14:00:00', 'DEV-S004', '传感器', 'B区-2号仓库', 1, '2026-01-04 14:00:00'),
(405, 5, 1, 23.40, '2026-01-04 08:30:00', 'DEV-S005', '传感器', 'C区-1号仓库', 0, '2026-01-04 08:30:00');

-- === 2026-01-05 (今天) ===
INSERT IGNORE INTO `real_time_monitoring` (`id`, `hazmat_id`, `param_id`, `param_value`, `monitor_time`, `device_id`, `data_source`, `location`, `status`, `create_time`) VALUES
-- 硫酸早晨全面正常
(501, 1, 1, 23.90, '2026-01-05 08:00:00', 'DEV-S001', '传感器', 'A区-1号仓库', 0, '2026-01-05 08:00:00'),
(502, 1, 2, 47.80, '2026-01-05 08:00:00', 'DEV-S001', '传感器', 'A区-1号仓库', 0, '2026-01-05 08:00:00'),
(503, 1, 3, 101.70, '2026-01-05 08:00:00', 'DEV-S001', '传感器', 'A区-1号仓库', 0, '2026-01-05 08:00:00'),
(504, 1, 4, 1.90, '2026-01-05 08:00:00', 'DEV-S001', '传感器', 'A区-1号仓库', 0, '2026-01-05 08:00:00'),
(505, 1, 5, 70.20, '2026-01-05 08:00:00', 'DEV-S001', '传感器', 'A区-1号仓库', 0, '2026-01-05 08:00:00'),
-- 硫酸中午温度超正常上限(>30℃) → 预警
(506, 1, 1, 31.60, '2026-01-05 13:30:00', 'DEV-S001', '传感器', 'A区-1号仓库', 1, '2026-01-05 13:30:00'),
(507, 1, 2, 53.20, '2026-01-05 13:30:00', 'DEV-S001', '传感器', 'A区-1号仓库', 0, '2026-01-05 13:30:00'),
-- 盐酸早晨正常
(508, 2, 1, 22.80, '2026-01-05 08:30:00', 'DEV-S002', '传感器', 'A区-2号仓库', 0, '2026-01-05 08:30:00'),
(509, 2, 2, 44.30, '2026-01-05 08:30:00', 'DEV-S002', '传感器', 'A区-2号仓库', 0, '2026-01-05 08:30:00'),
(510, 2, 4, 2.40, '2026-01-05 08:30:00', 'DEV-S002', '传感器', 'A区-2号仓库', 0, '2026-01-05 08:30:00'),
-- 盐酸下午浓度严重超标(>5ppm) → 报警
(511, 2, 4, 7.50, '2026-01-05 15:45:00', 'DEV-S002', '传感器', 'A区-2号仓库', 2, '2026-01-05 15:45:00'),
-- 甲醇早晨正常
(512, 3, 1, 18.50, '2026-01-05 09:00:00', 'DEV-S003', '传感器', 'B区-1号仓库', 0, '2026-01-05 09:00:00'),
(513, 3, 3, 100.80, '2026-01-05 09:00:00', 'DEV-S003', '传感器', 'B区-1号仓库', 0, '2026-01-05 09:00:00'),
(514, 3, 4, 6.20, '2026-01-05 09:00:00', 'DEV-S003', '传感器', 'B区-1号仓库', 0, '2026-01-05 09:00:00'),
-- 甲醇下午浓度偏高(>150ppm) → 预警
(515, 3, 4, 168.30, '2026-01-05 16:00:00', 'DEV-S003', '传感器', 'B区-1号仓库', 1, '2026-01-05 16:00:00'),
-- 乙醇正常
(516, 4, 1, 21.20, '2026-01-05 10:00:00', 'DEV-S004', '传感器', 'B区-2号仓库', 0, '2026-01-05 10:00:00'),
(517, 4, 2, 42.60, '2026-01-05 10:00:00', 'DEV-S004', '传感器', 'B区-2号仓库', 0, '2026-01-05 10:00:00'),
(518, 4, 5, 61.40, '2026-01-05 10:00:00', 'DEV-S004', '传感器', 'B区-2号仓库', 0, '2026-01-05 10:00:00'),
-- 氢氧化钠正常
(519, 5, 1, 24.30, '2026-01-05 08:30:00', 'DEV-S005', '传感器', 'C区-1号仓库', 0, '2026-01-05 08:30:00'),
(520, 5, 2, 34.80, '2026-01-05 08:30:00', 'DEV-S005', '传感器', 'C区-1号仓库', 0, '2026-01-05 08:30:00'),
(521, 5, 5, 82.10, '2026-01-05 08:30:00', 'DEV-S005', '传感器', 'C区-1号仓库', 0, '2026-01-05 08:30:00'),
-- 氢氧化钠下午湿度严重超标(>80%) → 报警
(522, 5, 2, 85.30, '2026-01-05 14:00:00', 'DEV-S005', '传感器', 'C区-1号仓库', 2, '2026-01-05 14:00:00'),
-- 手动录入数据
(523, 1, 4, 3.50, '2026-01-05 11:00:00', NULL, '手动录入', 'A区-1号仓库', 0, '2026-01-05 11:00:00'),
(524, 3, 5, 45.80, '2026-01-05 11:30:00', NULL, '手动录入', 'B区-1号仓库', 0, '2026-01-05 11:30:00'),
(525, 5, 2, 36.50, '2026-01-05 10:30:00', NULL, '手动录入', 'C区-1号仓库', 0, '2026-01-05 10:30:00');

SELECT '=== 实时监测数据插入完成 ===' AS step;

-- ============================================================
-- 第五步: 插入 warning_record 测试数据
-- 状态: 0-未处理, 1-处理中, 2-已解决, 3-已忽略
-- ============================================================

INSERT IGNORE INTO `warning_record` (`id`, `hazmat_id`, `rule_id`, `param_id`, `param_value`, `warning_value`, `threshold_value`, `warning_level`, `warning_message`, `status`, `handler_id`, `handler_name`, `handle_time`, `handle_result`, `warning_time`, `description`, `create_time`, `update_time`) VALUES
-- 01-02: 硫酸浓度预警 (已解决)
(1, 1, 4, 4, 4.80, 3.00, 5.00, '一般', '硫酸储存区域酸雾浓度偏高。当前浓度4.80ppm', 2, 1, '安全管理员', '2026-01-02 17:30:00', '已排查，确认为传感器附近临时挥发，加强通风后恢复正常', '2026-01-02 16:30:00', NULL, '2026-01-02 16:30:00', '2026-01-02 17:30:00'),
-- 01-02: 氢氧化钠湿度预警 (已忽略)
(2, 5, 15, 2, 75.60, 70.00, 80.00, '一般', '氢氧化钠储存环境湿度偏高，注意防潮。当前湿度75.60%', 3, 1, '安全管理员', '2026-01-02 15:00:00', '临时湿度波动，已自行恢复', '2026-01-02 14:00:00', NULL, '2026-01-02 14:00:00', '2026-01-02 15:00:00'),
-- 01-03: 盐酸温度预警 (已解决)
(3, 2, 4, 1, 28.50, 25.00, 30.00, '一般', '盐酸储存温度偏高，请关注。当前温度28.50℃', 2, 1, '安全管理员', '2026-01-03 16:00:00', '已调整仓库空调温度设置', '2026-01-03 15:00:00', NULL, '2026-01-03 15:00:00', '2026-01-03 16:00:00'),
-- 01-04: 乙醇温度预警 (处理中)
(4, 4, 13, 1, 28.30, 25.00, 30.00, '一般', '乙醇储存温度偏高。当前温度28.30℃', 1, 1, '安全管理员', '2026-01-04 15:00:00', '正在排查原因，已启动降温措施', '2026-01-04 14:00:00', NULL, '2026-01-04 14:00:00', '2026-01-04 15:00:00'),
-- 01-05: 硫酸温度预警 (未处理)
(5, 1, 1, 1, 31.60, 30.00, 35.00, '一般', '硫酸储存温度偏高，请注意检查。当前温度31.60℃', 0, NULL, NULL, NULL, NULL, '2026-01-05 13:30:00', '中午气温升高导致', '2026-01-05 13:30:00', '2026-01-05 13:30:00'),
-- 01-05: 盐酸浓度报警 (未处理)
(6, 2, 4, 4, 7.50, 5.00, 5.00, '重大', '盐酸储存区域酸雾浓度严重超标。当前浓度7.50ppm', 0, NULL, NULL, NULL, NULL, '2026-01-05 15:45:00', '疑似盐酸桶密封圈老化导致微量泄漏', '2026-01-05 15:45:00', '2026-01-05 15:45:00'),
-- 01-05: 甲醇浓度预警 (未处理)
(7, 3, 11, 4, 168.30, 150.00, 200.00, '一般', '甲醇蒸气浓度偏高，注意通风。当前浓度168.30ppm', 0, NULL, NULL, NULL, NULL, '2026-01-05 16:00:00', NULL, '2026-01-05 16:00:00', '2026-01-05 16:00:00'),
-- 01-05: 氢氧化钠湿度报警 (未处理)
(8, 5, 16, 2, 85.30, 80.00, 90.00, '较大', '氢氧化钠储存环境湿度过高，存在潮解风险。当前湿度85.30%', 0, NULL, NULL, NULL, NULL, '2026-01-05 14:00:00', '可能与今天降雨有关', '2026-01-05 14:00:00', '2026-01-05 14:00:00');

SELECT '=== 预警记录数据插入完成 ===' AS step;

-- ============================================================
-- 验证
-- ============================================================

SELECT '========================================' AS separator;
SELECT '修复验证报告' AS title;
SELECT '========================================' AS separator;

SELECT 'real_time_monitoring 今日概览' AS section,
    COUNT(*) AS total,
    SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) AS normal,
    SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS warning,
    SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) AS alarm
FROM `real_time_monitoring`
WHERE DATE(monitor_time) = CURDATE();

SELECT 'warning_record 概览' AS section,
    COUNT(*) AS total,
    SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) AS unhandled,
    SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS processing,
    SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) AS resolved,
    SUM(CASE WHEN status = 3 THEN 1 ELSE 0 END) AS ignored
FROM `warning_record`;

SELECT 'hazard_warning_rule 概览' AS section,
    COUNT(*) AS total,
    SUM(CASE WHEN enabled = 1 THEN 1 ELSE 0 END) AS enabled_count
FROM `hazard_warning_rule`;

SELECT '========================================' AS separator;
SELECT '全部修复完成！请重启后端服务。' AS message;
SELECT '========================================' AS separator;

-- ----------------------------
-- Records of warning_record
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
