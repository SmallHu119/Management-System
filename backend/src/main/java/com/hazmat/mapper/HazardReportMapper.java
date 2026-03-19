package com.hazmat.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hazmat.entity.HazardReport;
import org.apache.ibatis.annotations.Mapper;

/**
 * 隐患上报Mapper接口
 */
@Mapper
public interface HazardReportMapper extends BaseMapper<HazardReport> {
}
