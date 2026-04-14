-- =====================================================
-- 快速修复预警规则500错误
-- 执行此脚本修复hazard_warning_rule表结构
-- =====================================================

USE hazmat_safety;

-- 检查表是否存在
SELECT COUNT(*) AS table_exists 
FROM information_schema.tables 
WHERE table_schema = 'hazmat_safety' 
AND table_name = 'hazard_warning_rule';

-- 如果表不存在,创建表
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
    `notification_methods` VARCHAR(200) DEFAULT NULL COMMENT '通知方式(邮件、短信、系统消息)',
    `status` TINYINT DEFAULT 1 COMMENT '状态:0-禁用,1-启用',
    `enabled` TINYINT DEFAULT 1 COMMENT '是否启用:0-禁用,1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_hazmat_id` (`hazmat_id`),
    KEY `idx_param_id` (`param_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='危化品预警规则表';

-- 如果表已存在但缺少字段,添加缺失字段
-- 注意:如果字段已存在会报错,可以忽略

-- 添加 min_value 字段
ALTER TABLE `hazard_warning_rule` 
ADD COLUMN `min_value` DECIMAL(10,2) DEFAULT NULL COMMENT '正常范围最小值' AFTER `threshold_max`;

-- 添加 max_value 字段
ALTER TABLE `hazard_warning_rule` 
ADD COLUMN `max_value` DECIMAL(10,2) DEFAULT NULL COMMENT '正常范围最大值' AFTER `min_value`;

-- 添加 warning_min_value 字段
ALTER TABLE `hazard_warning_rule` 
ADD COLUMN `warning_min_value` DECIMAL(10,2) DEFAULT NULL COMMENT '预警范围最小值' AFTER `max_value`;

-- 添加 warning_max_value 字段
ALTER TABLE `hazard_warning_rule` 
ADD COLUMN `warning_max_value` DECIMAL(10,2) DEFAULT NULL COMMENT '预警范围最大值' AFTER `warning_min_value`;

-- 添加 enabled 字段
ALTER TABLE `hazard_warning_rule` 
ADD COLUMN `enabled` TINYINT DEFAULT 1 COMMENT '是否启用:0-禁用,1-启用' AFTER `status`;

-- 验证表结构
DESC `hazard_warning_rule`;

-- 检查warning_record表
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
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '预警时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_hazmat_id` (`hazmat_id`),
    KEY `idx_rule_id` (`rule_id`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预警记录表';

-- 添加warning_record缺失字段
ALTER TABLE `warning_record`
ADD COLUMN `warning_value` DECIMAL(10,2) DEFAULT NULL COMMENT '预警值' AFTER `param_value`;

ALTER TABLE `warning_record`
ADD COLUMN `threshold_value` DECIMAL(10,2) DEFAULT NULL COMMENT '阈值' AFTER `warning_value`;

ALTER TABLE `warning_record`
ADD COLUMN `warning_time` DATETIME DEFAULT NULL COMMENT '预警时间' AFTER `handle_result`;

ALTER TABLE `warning_record`
ADD COLUMN `description` TEXT COMMENT '描述' AFTER `warning_time`;

-- 验证表结构
DESC `warning_record`;

-- 显示所有相关表
SHOW TABLES LIKE '%warning%';
SHOW TABLES LIKE '%monitoring%';

SELECT '修复完成!请重启后端服务并刷新浏览器。' AS message;
