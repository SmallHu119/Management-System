-- =====================================================
-- 监测预警模块 - 数据库修复脚本
-- 用于修复已有数据库中缺失的表和字段
-- =====================================================

USE hazmat_safety;

-- 1. 监测参数表
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

-- 2. 危化品预警规则表
CREATE TABLE IF NOT EXISTS `hazard_warning_rule` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '规则ID',
    `hazmat_id` BIGINT NOT NULL COMMENT '关联危化品ID',
    `param_id` BIGINT NOT NULL COMMENT '监测参数ID',
    `warning_level` VARCHAR(20) NOT NULL COMMENT '预警级别（一般、较大、重大）',
    `threshold_min` DECIMAL(10,2) DEFAULT NULL COMMENT '阈值下限',
    `threshold_max` DECIMAL(10,2) DEFAULT NULL COMMENT '阈值上限',
    `min_value` DECIMAL(10,2) DEFAULT NULL COMMENT '正常范围最小值',
    `max_value` DECIMAL(10,2) DEFAULT NULL COMMENT '正常范围最大值',
    `warning_min_value` DECIMAL(10,2) DEFAULT NULL COMMENT '预警范围最小值',
    `warning_max_value` DECIMAL(10,2) DEFAULT NULL COMMENT '预警范围最大值',
    `warning_message` TEXT COMMENT '预警提示信息',
    `notification_methods` VARCHAR(200) DEFAULT NULL COMMENT '通知方式（邮件、短信、系统消息）',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `enabled` TINYINT DEFAULT 1 COMMENT '是否启用：0-禁用，1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_hazmat_id` (`hazmat_id`),
    KEY `idx_param_id` (`param_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='危化品预警规则表';

-- 3. 实时监测数据表 (新增 data_source 字段)
CREATE TABLE IF NOT EXISTS `real_time_monitoring` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '数据ID',
    `hazmat_id` BIGINT NOT NULL COMMENT '关联危化品ID',
    `param_id` BIGINT NOT NULL COMMENT '监测参数ID',
    `param_value` DECIMAL(10,2) NOT NULL COMMENT '监测值',
    `monitor_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '监测时间',
    `device_id` VARCHAR(100) DEFAULT NULL COMMENT '监测设备ID',
    `data_source` VARCHAR(50) DEFAULT NULL COMMENT '数据来源（传感器、手动录入、外部接口）',
    `location` VARCHAR(200) DEFAULT NULL COMMENT '监测位置',
    `status` TINYINT DEFAULT 0 COMMENT '状态：0-正常，1-预警，2-报警',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_hazmat_id` (`hazmat_id`),
    KEY `idx_param_id` (`param_id`),
    KEY `idx_monitor_time` (`monitor_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实时监测数据表';

-- 4. 预警记录表 (新增 param_id 字段，扩展状态为0/1/2/3)
CREATE TABLE IF NOT EXISTS `warning_record` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '预警ID',
    `hazmat_id` BIGINT NOT NULL COMMENT '关联危化品ID',
    `rule_id` BIGINT NOT NULL COMMENT '关联预警规则ID',
    `param_id` BIGINT DEFAULT NULL COMMENT '关联监测参数ID',
    `param_value` DECIMAL(10,2) NOT NULL COMMENT '触发值',
    `warning_value` DECIMAL(10,2) DEFAULT NULL COMMENT '预警值',
    `threshold_value` DECIMAL(10,2) DEFAULT NULL COMMENT '阈值',
    `warning_level` VARCHAR(20) NOT NULL COMMENT '预警级别',
    `warning_message` TEXT NOT NULL COMMENT '预警信息',
    `status` TINYINT DEFAULT 0 COMMENT '状态：0-未处理，1-处理中，2-已解决，3-已忽略',
    `handler_id` BIGINT DEFAULT NULL COMMENT '处理人ID',
    `handler_name` VARCHAR(50) DEFAULT NULL COMMENT '处理人姓名',
    `handle_time` DATETIME DEFAULT NULL COMMENT '处理时间',
    `handle_result` TEXT COMMENT '处理结果',
    `warning_time` DATETIME DEFAULT NULL COMMENT '预警时间',
    `description` TEXT COMMENT '描述',
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

INSERT IGNORE INTO `monitoring_parameter` (`id`, `name`, `code`, `unit`, `description`, `sort_order`) VALUES
(1, '温度', 'PARAM001', '℃', '环境或储存容器内的温度', 1),
(2, '湿度', 'PARAM002', '%RH', '环境相对湿度', 2),
(3, '压力', 'PARAM003', 'kPa', '储存容器内的压力', 3),
(4, '浓度', 'PARAM004', 'ppm', '空气中有害物质浓度', 4),
(5, '液位', 'PARAM005', '%', '储存容器内的液体高度百分比', 5),
(6, '烟雾浓度', 'PARAM006', 'ppm', '环境中烟雾浓度', 6),
(7, '氧气含量', 'PARAM007', '%', '环境中氧气含量百分比', 7);

-- =====================================================
-- 如果已有 real_time_monitoring 表但缺少 data_source 字段
-- =====================================================
-- ALTER TABLE `real_time_monitoring` ADD COLUMN `data_source` VARCHAR(50) DEFAULT NULL COMMENT '数据来源' AFTER `device_id`;

-- =====================================================
-- 如果已有 warning_record 表但缺少 param_id 字段
-- =====================================================
-- ALTER TABLE `warning_record` ADD COLUMN `param_id` BIGINT DEFAULT NULL COMMENT '关联监测参数ID' AFTER `rule_id`;
