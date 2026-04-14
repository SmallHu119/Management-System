package com.hazmat.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hazmat.entity.RealTimeMonitoring;
import org.apache.ibatis.annotations.Mapper;

/**
 * 实时监测数据 Mapper 接口
 */
@Mapper
public interface RealTimeMonitoringMapper extends BaseMapper<RealTimeMonitoring> {
}
