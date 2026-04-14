package com.hazmat.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hazmat.entity.MonitoringParameter;
import org.apache.ibatis.annotations.Mapper;

/**
 * 监测参数 Mapper 接口
 */
@Mapper
public interface MonitoringParameterMapper extends BaseMapper<MonitoringParameter> {
}
