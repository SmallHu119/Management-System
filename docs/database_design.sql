-- =====================================================
-- 企业危化品安全管理系统 数据库设计
-- 基于 SpringBoot + Vue3 + MySQL
-- =====================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS hazmat_safety DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE hazmat_safety;

-- =====================================================
-- 1. 用户相关表
-- =====================================================

-- 用户表（普通员工）
CREATE TABLE IF NOT EXISTS `sys_user` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `password` VARCHAR(100) NOT NULL COMMENT '密码',
    `real_name` VARCHAR(50) DEFAULT NULL COMMENT '真实姓名',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    `department` VARCHAR(100) DEFAULT NULL COMMENT '所属部门',
    `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像URL',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='普通员工表';

-- 安全管理员表
CREATE TABLE IF NOT EXISTS `safety_admin` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '安全管理员ID',
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `password` VARCHAR(100) NOT NULL COMMENT '密码',
    `real_name` VARCHAR(50) DEFAULT NULL COMMENT '真实姓名',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    `department` VARCHAR(100) DEFAULT NULL COMMENT '负责部门',
    `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像URL',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='安全管理员表';

-- 系统管理员表
CREATE TABLE IF NOT EXISTS `sys_admin` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '系统管理员ID',
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `password` VARCHAR(100) NOT NULL COMMENT '密码',
    `real_name` VARCHAR(50) DEFAULT NULL COMMENT '真实姓名',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像URL',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统管理员表';

-- =====================================================
-- 2. 危化品相关表
-- =====================================================

-- 危化品类别表
CREATE TABLE IF NOT EXISTS `hazmat_category` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '类别ID',
    `name` VARCHAR(100) NOT NULL COMMENT '类别名称',
    `code` VARCHAR(50) DEFAULT NULL COMMENT '类别编码',
    `description` TEXT COMMENT '类别描述',
    `danger_level` VARCHAR(20) DEFAULT NULL COMMENT '危险等级',
    `parent_id` BIGINT DEFAULT 0 COMMENT '父类别ID',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='危化品类别表';

-- 危化品信息表
CREATE TABLE IF NOT EXISTS `hazmat_info` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '危化品ID',
    `name` VARCHAR(100) NOT NULL COMMENT '危化品名称',
    `code` VARCHAR(50) DEFAULT NULL COMMENT '危化品编码',
    `category_id` BIGINT DEFAULT NULL COMMENT '类别ID',
    `cas_number` VARCHAR(50) DEFAULT NULL COMMENT 'CAS号',
    `un_number` VARCHAR(50) DEFAULT NULL COMMENT 'UN编号',
    `danger_type` VARCHAR(100) DEFAULT NULL COMMENT '危险类型（易燃、易爆、剧毒、腐蚀等）',
    `physical_state` VARCHAR(20) DEFAULT NULL COMMENT '物理状态（固体、液体、气体）',
    `storage_condition` TEXT COMMENT '储存条件',
    `emergency_measure` TEXT COMMENT '应急处置措施',
    `protective_measure` TEXT COMMENT '防护措施',
    `msds_file` VARCHAR(255) DEFAULT NULL COMMENT 'MSDS文件路径',
    `stock_quantity` DECIMAL(10,2) DEFAULT 0 COMMENT '库存数量',
    `unit` VARCHAR(20) DEFAULT NULL COMMENT '计量单位',
    `location` VARCHAR(200) DEFAULT NULL COMMENT '存放位置',
    `supplier` VARCHAR(200) DEFAULT NULL COMMENT '供应商',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    PRIMARY KEY (`id`),
    KEY `idx_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='危化品信息表';

-- =====================================================
-- 3. 安全检查相关表
-- =====================================================

-- 检查计划表
CREATE TABLE IF NOT EXISTS `check_plan` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '计划ID',
    `title` VARCHAR(200) NOT NULL COMMENT '计划标题',
    `description` TEXT COMMENT '计划描述',
    `check_type` VARCHAR(50) DEFAULT NULL COMMENT '检查类型（日常检查、专项检查、综合检查）',
    `plan_date` DATE DEFAULT NULL COMMENT '计划检查日期',
    `department` VARCHAR(100) DEFAULT NULL COMMENT '检查部门',
    `status` TINYINT DEFAULT 0 COMMENT '状态：0-待执行，1-进行中，2-已完成',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='检查计划表';

-- 检查记录表
CREATE TABLE IF NOT EXISTS `check_record` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '记录ID',
    `plan_id` BIGINT DEFAULT NULL COMMENT '关联计划ID',
    `title` VARCHAR(200) NOT NULL COMMENT '检查标题',
    `check_date` DATE DEFAULT NULL COMMENT '检查日期',
    `check_location` VARCHAR(200) DEFAULT NULL COMMENT '检查地点',
    `check_content` TEXT COMMENT '检查内容',
    `check_result` TEXT COMMENT '检查结果',
    `problems_found` TEXT COMMENT '发现问题',
    `suggestions` TEXT COMMENT '整改建议',
    `checker_id` BIGINT DEFAULT NULL COMMENT '检查人ID',
    `checker_name` VARCHAR(50) DEFAULT NULL COMMENT '检查人姓名',
    `status` TINYINT DEFAULT 0 COMMENT '状态：0-待审核，1-已通过，2-需整改',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_plan_id` (`plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='检查记录表';

-- =====================================================
-- 4. 隐患管理相关表
-- =====================================================

-- 隐患上报表
CREATE TABLE IF NOT EXISTS `hazard_report` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '隐患ID',
    `title` VARCHAR(200) NOT NULL COMMENT '隐患标题',
    `description` TEXT COMMENT '隐患描述',
    `location` VARCHAR(200) DEFAULT NULL COMMENT '隐患位置',
    `hazard_level` VARCHAR(20) DEFAULT NULL COMMENT '隐患等级（一般、较大、重大）',
    `hazard_type` VARCHAR(50) DEFAULT NULL COMMENT '隐患类型',
    `images` TEXT COMMENT '图片路径（JSON数组）',
    `reporter_id` BIGINT DEFAULT NULL COMMENT '上报人ID',
    `reporter_name` VARCHAR(50) DEFAULT NULL COMMENT '上报人姓名',
    `report_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '上报时间',
    `status` TINYINT DEFAULT 0 COMMENT '状态：0-待处理，1-处理中，2-已整改，3-已关闭',
    `handler_id` BIGINT DEFAULT NULL COMMENT '处理人ID',
    `handler_name` VARCHAR(50) DEFAULT NULL COMMENT '处理人姓名',
    `handle_time` DATETIME DEFAULT NULL COMMENT '处理时间',
    `handle_result` TEXT COMMENT '处理结果',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_reporter_id` (`reporter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='隐患上报表';

-- =====================================================
-- 5. 安全知识与公告相关表
-- =====================================================

-- 安全知识表
CREATE TABLE IF NOT EXISTS `safety_knowledge` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '知识ID',
    `title` VARCHAR(200) NOT NULL COMMENT '标题',
    `content` TEXT COMMENT '内容',
    `category` VARCHAR(50) DEFAULT NULL COMMENT '分类（操作规程、安全知识、应急预案）',
    `cover_image` VARCHAR(255) DEFAULT NULL COMMENT '封面图片',
    `view_count` INT DEFAULT 0 COMMENT '浏览次数',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-草稿，1-已发布',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='安全知识表';

-- 公告信息表
CREATE TABLE IF NOT EXISTS `announcement` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '公告ID',
    `title` VARCHAR(200) NOT NULL COMMENT '公告标题',
    `content` TEXT COMMENT '公告内容',
    `type` VARCHAR(50) DEFAULT NULL COMMENT '公告类型（通知、公告、系统简介）',
    `priority` INT DEFAULT 0 COMMENT '优先级',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-草稿，1-已发布',
    `publish_time` DATETIME DEFAULT NULL COMMENT '发布时间',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建人ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公告信息表';

-- =====================================================
-- 6. 初始化数据
-- =====================================================

-- 插入默认系统管理员（密码：admin123，使用BCrypt加密）
INSERT INTO `sys_admin` (`username`, `password`, `real_name`, `phone`, `email`, `status`) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '系统管理员', '13800000000', 'admin@example.com', 1);

-- 插入默认安全管理员（密码：safety123）
INSERT INTO `safety_admin` (`username`, `password`, `real_name`, `phone`, `email`, `department`, `status`) VALUES
('safety', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '安全管理员', '13800000001', 'safety@example.com', '安全管理部', 1);

-- 插入危化品类别
INSERT INTO `hazmat_category` (`name`, `code`, `description`, `danger_level`, `sort_order`) VALUES
('爆炸品', 'CAT001', '具有爆炸性质的危险化学品', '极高', 1),
('压缩气体和液化气体', 'CAT002', '在压力下储存的气体', '高', 2),
('易燃液体', 'CAT003', '闪点低于61℃的液体', '高', 3),
('易燃固体', 'CAT004', '容易燃烧的固体物质', '中', 4),
('氧化剂和有机过氧化物', 'CAT005', '具有氧化性的物质', '高', 5),
('毒害品', 'CAT006', '对人体有毒害作用的物质', '高', 6),
('腐蚀品', 'CAT007', '具有腐蚀性的物质', '中', 7),
('放射性物品', 'CAT008', '具有放射性的物质', '极高', 8);

-- 插入示例危化品信息
INSERT INTO `hazmat_info` (`name`, `code`, `category_id`, `cas_number`, `un_number`, `danger_type`, `physical_state`, `storage_condition`, `emergency_measure`, `protective_measure`, `stock_quantity`, `unit`, `location`) VALUES
('硫酸', 'HM001', 7, '7664-93-9', 'UN1830', '腐蚀品', '液体', '储存于阴凉、通风的库房。库温不超过35℃，相对湿度不超过85%。', '皮肤接触：立即脱去污染的衣着，用大量流动清水冲洗至少15分钟。', '穿橡胶耐酸碱服，戴橡胶耐酸碱手套，戴化学安全防护眼镜。', 500.00, '升', 'A区-1号仓库'),
('盐酸', 'HM002', 7, '7647-01-0', 'UN1789', '腐蚀品', '液体', '储存于阴凉、通风的库房。库温不宜超过30℃。', '皮肤接触：立即脱去污染的衣着，用大量流动清水冲洗至少15分钟。', '穿橡胶耐酸碱服，戴橡胶耐酸碱手套。', 300.00, '升', 'A区-2号仓库'),
('甲醇', 'HM003', 3, '67-56-1', 'UN1230', '易燃液体、有毒', '液体', '储存于阴凉、通风的库房。远离火种、热源。', '迅速撤离泄漏污染区人员至安全区，并进行隔离，严格限制出入。', '穿防静电工作服，戴橡胶手套，佩戴过滤式防毒面具。', 200.00, '升', 'B区-1号仓库'),
('乙醇', 'HM004', 3, '64-17-5', 'UN1170', '易燃液体', '液体', '储存于阴凉、通风的库房。远离火种、热源。库温不宜超过30℃。', '迅速撤离泄漏污染区人员至安全区，并进行隔离。', '穿防静电工作服，戴一般作业防护手套。', 400.00, '升', 'B区-2号仓库'),
('氢氧化钠', 'HM005', 7, '1310-73-2', 'UN1823', '腐蚀品', '固体', '储存于阴凉、干燥、通风良好的库房。远离火种、热源。', '皮肤接触：立即脱去污染的衣着，用大量流动清水冲洗至少15分钟。', '穿橡胶耐酸碱服，戴橡胶耐酸碱手套。', 100.00, '千克', 'C区-1号仓库');

-- 插入安全知识
INSERT INTO `safety_knowledge` (`title`, `content`, `category`, `status`) VALUES
('危险化学品安全操作规程', '一、总则\n1. 本规程适用于公司所有涉及危险化学品操作的岗位。\n2. 所有操作人员必须经过专业培训并取得相应资质后方可上岗。\n\n二、操作前准备\n1. 检查个人防护装备是否齐全、完好。\n2. 检查操作区域通风设施是否正常运行。\n3. 确认应急设施（洗眼器、淋浴器等）处于正常状态。\n\n三、操作要求\n1. 严格按照操作规程进行操作，不得擅自更改操作步骤。\n2. 操作过程中应保持注意力集中，不得从事与工作无关的活动。\n3. 发现异常情况应立即停止操作并报告。', '操作规程', 1),
('化学品泄漏应急处置预案', '一、目的\n为有效预防、及时控制和消除化学品泄漏事故的危害，保障员工生命安全和公司财产安全。\n\n二、适用范围\n适用于公司范围内所有化学品泄漏事故的应急处置。\n\n三、应急处置程序\n1. 发现泄漏后，立即向安全管理部门报告。\n2. 疏散泄漏区域内无关人员，设置警戒区域。\n3. 根据泄漏物质特性，选择适当的防护装备和处置方法。\n4. 对泄漏物进行收集、处理，防止扩散。\n5. 事故处置完毕后，进行现场清理和环境监测。', '应急预案', 1),
('个人防护装备使用指南', '一、防护装备分类\n1. 呼吸防护：防毒面具、空气呼吸器、防尘口罩等。\n2. 眼面防护：安全眼镜、防护面罩、防化学飞溅眼罩等。\n3. 身体防护：防化服、耐酸碱服、防静电服等。\n4. 手部防护：耐酸碱手套、防化手套、绝缘手套等。\n5. 足部防护：防化靴、绝缘鞋、防砸鞋等。\n\n二、使用注意事项\n1. 使用前检查防护装备是否完好无损。\n2. 正确佩戴，确保密封性和防护效果。\n3. 使用后及时清洗、消毒、存放。\n4. 定期检查、更换过期或损坏的防护装备。', '安全知识', 1);

-- 插入公告信息
INSERT INTO `announcement` (`title`, `content`, `type`, `priority`, `status`, `publish_time`) VALUES
('企业危化品安全管理系统上线通知', '各位员工：\n\n为进一步加强公司危险化学品安全管理，提高安全管理水平，公司决定启用企业危化品安全管理系统。\n\n系统主要功能包括：\n1. 危化品信息管理\n2. 安全检查管理\n3. 隐患上报与处理\n4. 安全知识学习\n\n请各部门积极配合，按要求完成系统培训和使用。\n\n特此通知。', '通知', 1, 1, NOW()),
('系统简介', '企业危化品安全管理系统是一套基于SpringBoot+Vue3技术栈开发的现代化安全管理平台，旨在帮助企业实现危险化学品的全生命周期管理。\n\n系统特点：\n1. 前后端分离架构，界面美观、操作便捷\n2. 完善的权限管理，保障数据安全\n3. 全面的危化品信息管理功能\n4. 规范的安全检查流程\n5. 便捷的隐患上报机制\n6. 丰富的安全知识库', '系统简介', 0, 1, NOW());
