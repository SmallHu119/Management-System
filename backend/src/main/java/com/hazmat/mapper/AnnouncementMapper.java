package com.hazmat.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hazmat.entity.Announcement;
import org.apache.ibatis.annotations.Mapper;

/**
 * 公告信息Mapper接口
 */
@Mapper
public interface AnnouncementMapper extends BaseMapper<Announcement> {
}
