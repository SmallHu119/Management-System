package com.hazmat.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hazmat.entity.HazmatCategory;
import org.apache.ibatis.annotations.Mapper;

/**
 * 危化品类别Mapper接口
 */
@Mapper
public interface HazmatCategoryMapper extends BaseMapper<HazmatCategory> {
}
