package com.hazmat.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hazmat.entity.HazardWarningRule;
import org.apache.ibatis.annotations.Mapper;

/**
 * 预警规则 Mapper 接口
 */
@Mapper
public interface HazardWarningRuleMapper extends BaseMapper<HazardWarningRule> {
}
