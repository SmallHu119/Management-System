-- =====================================================
-- 企业危化品安全管理系统 - 风险监测与预警模块数据库设计
-- =====================================================

USE hazmat_safety;

-- =====================================================
-- 7. 风险监测与预警相关表
-- =====================================================

-- 监测参数表
CREATE TABLE IF NOT EXISTS `monitoring_parameter` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '参数ID',
    `name` VARCHAR(100) NOT NULL COMMENT '参数名称（温度、湿度、压力、浓度等）',
    `code` VARCHAR(50) DEFAULT NULL COMMENT '参数编码',
    `unit` VARCHAR(20) DEFAULT NULL COMMENT '计量单位',
    `description` TEXT COMMENT '参数描述',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='监测参数表';

-- 危化品预警规则表
CREATE TABLE IF NOT EXISTS `hazard_warning_rule` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '规则ID',
    `hazmat_id` BIGINT NOT NULL COMMENT '关联危化品ID',
    `param_id` BIGINT NOT NULL COMMENT '监测参数ID',
    `warning_level` VARCHAR(20) NOT NULL COMMENT '预警级别（一般、较大、重大）',
    `threshold_min` DECIMAL(10,2) DEFAULT NULL COMMENT '阈值下限',
    `threshold_max` DECIMAL(10,2) DEFAULT NULL COMMENT '阈值上限',
    `warning_message` TEXT COMMENT '预警提示信息',
    `notification_methods` VARCHAR(200) DEFAULT NULL COMMENT '通知方式（邮件、短信、系统消息）',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_hazmat_id` (`hazmat_id`),
    KEY `idx_param_id` (`param_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='危化品预警规则表';

-- 实时监测数据表
CREATE TABLE IF NOT EXISTS `real_time_monitoring` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '数据ID',
    `hazmat_id` BIGINT NOT NULL COMMENT '关联危化品ID',
    `param_id` BIGINT NOT NULL COMMENT '监测参数ID',
    `param_value` DECIMAL(10,2) NOT NULL COMMENT '监测值',
    `monitor_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '监测时间',
    `device_id` VARCHAR(100) DEFAULT NULL COMMENT '监测设备ID',
    `location` VARCHAR(200) DEFAULT NULL COMMENT '监测位置',
    `status` TINYINT DEFAULT 0 COMMENT '状态：0-正常，1-预警',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_hazmat_id` (`hazmat_id`),
    KEY `idx_param_id` (`param_id`),
    KEY `idx_monitor_time` (`monitor_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实时监测数据表';

-- 预警记录表
CREATE TABLE IF NOT EXISTS `warning_record` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '预警ID',
    `hazmat_id` BIGINT NOT NULL COMMENT '关联危化品ID',
    `rule_id` BIGINT NOT NULL COMMENT '关联预警规则ID',
    `param_value` DECIMAL(10,2) NOT NULL COMMENT '触发值',
    `warning_level` VARCHAR(20) NOT NULL COMMENT '预警级别',
    `warning_message` TEXT NOT NULL COMMENT '预警信息',
    `status` TINYINT DEFAULT 0 COMMENT '状态：0-未处理，1-已处理',
    `handler_id` BIGINT DEFAULT NULL COMMENT '处理人ID',
    `handler_name` VARCHAR(50) DEFAULT NULL COMMENT '处理人姓名',
    `handle_time` DATETIME DEFAULT NULL COMMENT '处理时间',
    `handle_result` TEXT COMMENT '处理结果',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '预警时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_hazmat_id` (`hazmat_id`),
    KEY `idx_rule_id` (`rule_id`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预警记录表';

-- =====================================================
-- 初始化监测参数数据
-- =====================================================

INSERT INTO `monitoring_parameter` (`name`, `code`, `unit`, `description`, `sort_order`) VALUES
('温度', 'PARAM001', '℃', '环境或储存容器内的温度', 1),
('湿度', 'PARAM002', '%RH', '环境相对湿度', 2),
('压力', 'PARAM003', 'kPa', '储存容器内的压力', 3),
('浓度', 'PARAM004', 'ppm', '空气中有害物质浓度', 4),
('液位', 'PARAM005', '%', '储存容器内的液体高度百分比', 5),
('烟雾浓度', 'PARAM006', 'ppm', '环境中烟雾浓度', 6),
('氧气含量', 'PARAM007', '%', '环境中氧气含量百分比', 7);

-- =====================================================
-- 初始化部分危化品的预警规则
-- =====================================================

-- 硫酸预警规则
INSERT INTO `hazard_warning_rule` (`hazmat_id`, `param_id`, `warning_level`, `threshold_min`, `threshold_max`, `warning_message`, `notification_methods`) VALUES
(1, 1, '一般', 5, 35, '硫酸储存温度应保持在5-35℃之间', '系统消息'),
(1, 1, '较大', NULL, 40, '硫酸储存温度过高，存在安全隐患', '系统消息,邮件'),
(1, 2, '一般', 30, 85, '硫酸储存环境湿度应保持在30%-85%之间', '系统消息');

-- 盐酸预警规则
INSERT INTO `hazard_warning_rule` (`hazmat_id`, `param_id`, `warning_level`, `threshold_min`, `threshold_max`, `warning_message`, `notification_methods`) VALUES
(2, 1, '一般', 5, 30, '盐酸储存温度应保持在5-30℃之间', '系统消息'),
(2, 1, '较大', NULL, 35, '盐酸储存温度过高，存在挥发风险', '系统消息,邮件'),
(2, 7, '重大', 19.5, NULL, '储存区域氧气含量过低，存在窒息风险', '系统消息,短信,邮件');

-- 甲醇预警规则
INSERT INTO `hazard_warning_rule` (`hazmat_id`, `param_id`, `warning_level`, `threshold_min`, `threshold_max`, `warning_message`, `notification_methods`) VALUES
(3, 1, '一般', 0, 25, '甲醇储存温度应保持在0-25℃之间', '系统消息'),
(3, 1, '较大', NULL, 30, '甲醇储存温度过高，存在火灾风险', '系统消息,邮件'),
(3, 6, '重大', NULL, 50, '甲醇储存区域烟雾浓度过高，可能发生火灾', '系统消息,短信,邮件'),
(3, 4, '较大', NULL, 200, '甲醇蒸汽浓度超标，存在爆炸风险', '系统消息,短信');