package com.hazmat.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hazmat.entity.SafetyKnowledge;
import org.apache.ibatis.annotations.Mapper;

/**
 * 安全知识Mapper接口
 */
@Mapper
public interface SafetyKnowledgeMapper extends BaseMapper<SafetyKnowledge> {
}
