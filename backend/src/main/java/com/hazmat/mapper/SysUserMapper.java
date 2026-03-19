package com.hazmat.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hazmat.entity.SysUser;
import org.apache.ibatis.annotations.Mapper;

/**
 * 普通员工Mapper接口
 */
@Mapper
public interface SysUserMapper extends BaseMapper<SysUser> {
}
