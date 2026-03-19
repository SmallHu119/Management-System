package com.hazmat.controller;

import com.hazmat.common.Result;
import com.hazmat.service.*;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * 首页统计控制器
 */
@Tag(name = "首页统计", description = "首页数据统计接口")
@RestController
@RequestMapping("/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final HazmatService hazmatService;
    private final CheckService checkService;
    private final HazardService hazardService;
    private final KnowledgeService knowledgeService;
    private final AnnouncementService announcementService;

    @Operation(summary = "获取首页统计数据")
    @GetMapping("/stats")
    public Result<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();
        
        // 危化品数量
        stats.put("hazmatCount", hazmatService.countHazmats().getData());
        
        // 检查计划数量
        stats.put("checkPlanCount", checkService.countPlans().getData());
        
        // 检查记录数量
        stats.put("checkRecordCount", checkService.countRecords().getData());
        
        // 隐患总数
        stats.put("hazardCount", hazardService.countHazards().getData());
        
        // 待处理隐患数
        stats.put("pendingHazardCount", hazardService.countPendingHazards().getData());
        
        // 安全知识数量
        stats.put("knowledgeCount", knowledgeService.countKnowledge().getData());
        
        // 公告数量
        stats.put("announcementCount", announcementService.countAnnouncements().getData());
        
        return Result.success(stats);
    }

    @Operation(summary = "获取最新公告")
    @GetMapping("/announcements")
    public Result<?> getLatestAnnouncements() {
        return announcementService.getLatestAnnouncements(5);
    }

    @Operation(summary = "获取待处理隐患")
    @GetMapping("/pending-hazards")
    public Result<?> getPendingHazards() {
        return hazardService.getPendingHazards();
    }

    @Operation(summary = "获取待执行检查计划")
    @GetMapping("/pending-plans")
    public Result<?> getPendingPlans() {
        return checkService.getPendingPlans();
    }

    @Operation(summary = "获取热门安全知识")
    @GetMapping("/hot-knowledge")
    public Result<?> getHotKnowledge() {
        return knowledgeService.getHotKnowledge(5);
    }

    @Operation(summary = "按类别统计危化品")
    @GetMapping("/hazmat-by-category")
    public Result<?> getHazmatByCategory() {
        return hazmatService.countByCategory();
    }
}
