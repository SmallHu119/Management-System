package com.hazmat.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hazmat.common.PageResult;
import com.hazmat.common.Result;
import com.hazmat.entity.Announcement;
import com.hazmat.mapper.AnnouncementMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 公告服务
 */
@Service
@RequiredArgsConstructor
public class AnnouncementService {

    private final AnnouncementMapper announcementMapper;

    /**
     * 分页查询公告
     */
    public Result<PageResult<Announcement>> getAnnouncementPage(Integer pageNum, Integer pageSize,
                                                                 String title, String type) {
        Page<Announcement> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Announcement> wrapper = new LambdaQueryWrapper<>();
        
        if (StringUtils.hasText(title)) {
            wrapper.like(Announcement::getTitle, title);
        }
        if (StringUtils.hasText(type)) {
            wrapper.eq(Announcement::getType, type);
        }
        wrapper.orderByDesc(Announcement::getPriority)
               .orderByDesc(Announcement::getPublishTime);
        
        IPage<Announcement> result = announcementMapper.selectPage(page, wrapper);
        return Result.success(PageResult.of(result));
    }

    /**
     * 获取已发布的公告（供前台展示）
     */
    public Result<PageResult<Announcement>> getPublishedAnnouncements(Integer pageNum, Integer pageSize,
                                                                       String type) {
        Page<Announcement> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Announcement> wrapper = new LambdaQueryWrapper<>();
        
        wrapper.eq(Announcement::getStatus, 1); // 已发布
        if (StringUtils.hasText(type)) {
            wrapper.eq(Announcement::getType, type);
        }
        wrapper.orderByDesc(Announcement::getPriority)
               .orderByDesc(Announcement::getPublishTime);
        
        IPage<Announcement> result = announcementMapper.selectPage(page, wrapper);
        return Result.success(PageResult.of(result));
    }

    /**
     * 获取公告详情
     */
    public Result<Announcement> getAnnouncementById(Long id) {
        return Result.success(announcementMapper.selectById(id));
    }

    /**
     * 添加公告
     */
    public Result<String> addAnnouncement(Announcement announcement) {
        if (announcement.getStatus() == 1) {
            announcement.setPublishTime(LocalDateTime.now());
        }
        announcementMapper.insert(announcement);
        return Result.success("添加成功");
    }

    /**
     * 更新公告
     */
    public Result<String> updateAnnouncement(Announcement announcement) {
        Announcement existing = announcementMapper.selectById(announcement.getId());
        if (existing == null) {
            return Result.error("公告不存在");
        }
        
        // 如果从草稿变为发布，设置发布时间
        if (existing.getStatus() == 0 && announcement.getStatus() == 1) {
            announcement.setPublishTime(LocalDateTime.now());
        }
        
        announcementMapper.updateById(announcement);
        return Result.success("更新成功");
    }

    /**
     * 删除公告
     */
    public Result<String> deleteAnnouncement(Long id) {
        announcementMapper.deleteById(id);
        return Result.success("删除成功");
    }

    /**
     * 发布/取消发布公告
     */
    public Result<String> publishAnnouncement(Long id, Integer status) {
        Announcement announcement = announcementMapper.selectById(id);
        if (announcement == null) {
            return Result.error("公告不存在");
        }
        
        announcement.setStatus(status);
        if (status == 1) {
            announcement.setPublishTime(LocalDateTime.now());
        }
        
        announcementMapper.updateById(announcement);
        return Result.success(status == 1 ? "发布成功" : "已取消发布");
    }

    /**
     * 获取最新公告
     */
    public Result<List<Announcement>> getLatestAnnouncements(Integer limit) {
        List<Announcement> list = announcementMapper.selectList(
                new LambdaQueryWrapper<Announcement>()
                        .eq(Announcement::getStatus, 1)
                        .orderByDesc(Announcement::getPriority)
                        .orderByDesc(Announcement::getPublishTime)
                        .last("LIMIT " + limit)
        );
        return Result.success(list);
    }

    /**
     * 获取系统简介
     */
    public Result<Announcement> getSystemIntro() {
        Announcement intro = announcementMapper.selectOne(
                new LambdaQueryWrapper<Announcement>()
                        .eq(Announcement::getType, "系统简介")
                        .eq(Announcement::getStatus, 1)
                        .orderByDesc(Announcement::getCreateTime)
                        .last("LIMIT 1")
        );
        return Result.success(intro);
    }

    /**
     * 统计公告数量
     */
    public Result<Long> countAnnouncements() {
        return Result.success(announcementMapper.selectCount(
                new LambdaQueryWrapper<Announcement>().eq(Announcement::getStatus, 1)
        ));
    }
}
