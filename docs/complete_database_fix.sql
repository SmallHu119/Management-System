-- =====================================================
-- 完整数据库初始化脚本
-- 修复所有500错误 - 创建所有缺失的表和字段
-- =====================================================

USE hazmat_safety;

-- 1. 监测参数表
CREATE TABLE IF NOT EXISTS `monitoring_parameter` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '参数ID',
    `name` VARCHAR(100) NOT NULL COMMENT '参数名称',
    `code` VARCHAR(50) DEFAULT NULL COMMENT '参数编码',
    `unit` VARCHAR(20) DEFAULT NULL COMMENT '计量单位',
    `description` TEXT COMMENT '参数描述',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `status` TINYINT DEFAULT 1 COMMENT '状态:0-禁用,1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='监测参数表';

-- 2. 危化品预警规则表
CREATE TABLE IF NOT EXISTS `hazard_warning_rule` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '规则ID',
    `hazmat_id` BIGINT NOT NULL COMMENT '关联危化品ID',
    `param_id` BIGINT NOT NULL COMMENT '监测参数ID',
    `warning_level` VARCHAR(20) NOT NULL COMMENT '预警级别(一般、较大、重大)',
    `threshold_min` DECIMAL(10,2) DEFAULT NULL COMMENT '阈值下限',
    `threshold_max` DECIMAL(10,2) DEFAULT NULL COMMENT '阈值上限',
    `min_value` DECIMAL(10,2) DEFAULT NULL COMMENT '正常范围最小值',
    `max_value` DECIMAL(10,2) DEFAULT NULL COMMENT '正常范围最大值',
    `warning_min_value` DECIMAL(10,2) DEFAULT NULL COMMENT '预警范围最小值',
    `warning_max_value` DECIMAL(10,2) DEFAULT NULL COMMENT '预警范围最大值',
    `warning_message` TEXT COMMENT '预警提示信息',
    `notification_methods` VARCHAR(200) DEFAULT NULL COMMENT '通知方式',
    `status` TINYINT DEFAULT 1 COMMENT '状态:0-禁用,1-启用',
    `enabled` TINYINT DEFAULT 1 COMMENT '是否启用:0-禁用,1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_hazmat_id` (`hazmat_id`),
    KEY `idx_param_id` (`param_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='危化品预警规则表';

-- 3. 实时监测数据表
CREATE TABLE IF NOT EXISTS `real_time_monitoring` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '数据ID',
    `hazmat_id` BIGINT NOT NULL COMMENT '关联危化品ID',
    `param_id` BIGINT NOT NULL COMMENT '监测参数ID',
    `param_value` DECIMAL(10,2) NOT NULL COMMENT '监测值',
    `monitor_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '监测时间',
    `device_id` VARCHAR(100) DEFAULT NULL COMMENT '监测设备ID',
    `data_source` VARCHAR(50) DEFAULT NULL COMMENT '数据来源',
    `location` VARCHAR(200) DEFAULT NULL COMMENT '监测位置',
    `status` TINYINT DEFAULT 0 COMMENT '状态:0-正常,1-预警,2-报警',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_hazmat_id` (`hazmat_id`),
    KEY `idx_param_id` (`param_id`),
    KEY `idx_monitor_time` (`monitor_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实时监测数据表';

-- 4. 预警记录表
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
    `status` TINYINT DEFAULT 0 COMMENT '状态:0-未处理,1-处理中,2-已解决,3-已忽略',
    `handler_id` BIGINT DEFAULT NULL COMMENT '处理人ID',
    `handler_name` VARCHAR(50) DEFAULT NULL COMMENT '处理人姓名',
    `handle_time` DATETIME DEFAULT NULL COMMENT '处理时间',
    `handle_result` TEXT COMMENT '处理结果',
    `warning_time` DATETIME DEFAULT NULL COMMENT '预警时间',
    `description` TEXT COMMENT '描述',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_hazmat_id` (`hazmat_id`),
    KEY `idx_rule_id` (`rule_id`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预警记录表';

-- =====================================================
-- 初始化测试数据
-- =====================================================

-- 插入监测参数
INSERT IGNORE INTO `monitoring_parameter` (`id`, `name`, `code`, `unit`, `description`, `sort_order`) VALUES
(1, '温度', 'PARAM001', '℃', '环境或储存容器内的温度', 1),
(2, '湿度', 'PARAM002', '%RH', '环境相对湿度', 2),
(3, '压力', 'PARAM003', 'kPa', '储存容器内的压力', 3),
(4, '浓度', 'PARAM004', 'ppm', '空气中有害物质浓度', 4),
(5, '液位', 'PARAM005', '%', '储存容器内的液体高度百分比', 5),
(6, '烟雾浓度', 'PARAM006', 'ppm', '环境中烟雾浓度', 6),
(7, '氧气含量', 'PARAM007', '%', '环境中氧气含量百分比', 7);

-- =====================================================
-- 验证所有表是否创建成功
-- =====================================================

SELECT '=== 监测相关表 ===' AS info;
SHOW TABLES LIKE '%monitoring%';

SELECT '=== 预警相关表 ===' AS info;
SHOW TABLES LIKE '%warning%';

SELECT '=== 表结构验证 ===' AS info;

-- 检查monitoring_parameter表
SELECT 'monitoring_parameter表:' AS table_name;
DESC `monitoring_parameter`;

-- 检查hazard_warning_rule表
SELECT 'hazard_warning_rule表:' AS table_name;
DESC `hazard_warning_rule`;

-- 检查real_time_monitoring表
SELECT 'real_time_monitoring表:' AS table_name;
DESC `real_time_monitoring`;

-- 检查warning_record表
SELECT 'warning_record表:' AS table_name;
DESC `warning_record`;

-- 显示测试数据
SELECT '=== 监测参数数据 ===' AS info;
SELECT * FROM `monitoring_parameter`;

SELECT '=== 修复完成 ===' AS message;
SELECT '请重启后端服务并刷新浏览器' AS next_step;
