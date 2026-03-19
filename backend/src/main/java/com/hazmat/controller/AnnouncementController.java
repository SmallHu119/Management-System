package com.hazmat.controller;

import com.hazmat.common.PageResult;
import com.hazmat.common.Result;
import com.hazmat.entity.Announcement;
import com.hazmat.service.AnnouncementService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 公告控制器
 */
@Tag(name = "公告管理", description = "公告信息管理接口")
@RestController
@RequestMapping("/announcement")
@RequiredArgsConstructor
public class AnnouncementController {

    private final AnnouncementService announcementService;

    @Operation(summary = "分页查询公告（管理端）")
    @GetMapping("/list")
    public Result<PageResult<Announcement>> getAnnouncementPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String type) {
        return announcementService.getAnnouncementPage(pageNum, pageSize, title, type);
    }

    @Operation(summary = "分页查询已发布的公告（前台）")
    @GetMapping("/published")
    public Result<PageResult<Announcement>> getPublishedAnnouncements(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String type) {
        return announcementService.getPublishedAnnouncements(pageNum, pageSize, type);
    }

    @Operation(summary = "获取公告详情")
    @GetMapping("/{id}")
    public Result<Announcement> getAnnouncementById(@PathVariable Long id) {
        return announcementService.getAnnouncementById(id);
    }

    @Operation(summary = "添加公告")
    @PostMapping
    public Result<String> addAnnouncement(@RequestBody Announcement announcement) {
        return announcementService.addAnnouncement(announcement);
    }

    @Operation(summary = "更新公告")
    @PutMapping
    public Result<String> updateAnnouncement(@RequestBody Announcement announcement) {
        return announcementService.updateAnnouncement(announcement);
    }

    @Operation(summary = "删除公告")
    @DeleteMapping("/{id}")
    public Result<String> deleteAnnouncement(@PathVariable Long id) {
        return announcementService.deleteAnnouncement(id);
    }

    @Operation(summary = "发布/取消发布公告")
    @PutMapping("/{id}/publish/{status}")
    public Result<String> publishAnnouncement(@PathVariable Long id, @PathVariable Integer status) {
        return announcementService.publishAnnouncement(id, status);
    }

    @Operation(summary = "获取最新公告")
    @GetMapping("/latest")
    public Result<List<Announcement>> getLatestAnnouncements(
            @RequestParam(defaultValue = "5") Integer limit) {
        return announcementService.getLatestAnnouncements(limit);
    }

    @Operation(summary = "获取系统简介")
    @GetMapping("/intro")
    public Result<Announcement> getSystemIntro() {
        return announcementService.getSystemIntro();
    }

    @Operation(summary = "统计公告数量")
    @GetMapping("/count")
    public Result<Long> countAnnouncements() {
        return announcementService.countAnnouncements();
    }
}
