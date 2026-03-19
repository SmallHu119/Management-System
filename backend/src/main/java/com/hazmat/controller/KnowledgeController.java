package com.hazmat.controller;

import com.hazmat.common.PageResult;
import com.hazmat.common.Result;
import com.hazmat.entity.SafetyKnowledge;
import com.hazmat.service.KnowledgeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 安全知识控制器
 */
@Tag(name = "安全知识", description = "安全知识管理接口")
@RestController
@RequestMapping("/knowledge")
@RequiredArgsConstructor
public class KnowledgeController {

    private final KnowledgeService knowledgeService;

    @Operation(summary = "分页查询安全知识（管理端）")
    @GetMapping("/list")
    public Result<PageResult<SafetyKnowledge>> getKnowledgePage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String category) {
        return knowledgeService.getKnowledgePage(pageNum, pageSize, title, category);
    }

    @Operation(summary = "分页查询已发布的安全知识（员工端）")
    @GetMapping("/published")
    public Result<PageResult<SafetyKnowledge>> getPublishedKnowledge(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String category) {
        return knowledgeService.getPublishedKnowledge(pageNum, pageSize, title, category);
    }

    @Operation(summary = "获取安全知识详情")
    @GetMapping("/{id}")
    public Result<SafetyKnowledge> getKnowledgeById(@PathVariable Long id) {
        return knowledgeService.getKnowledgeById(id);
    }

    @Operation(summary = "添加安全知识")
    @PostMapping
    public Result<String> addKnowledge(@RequestBody SafetyKnowledge knowledge) {
        return knowledgeService.addKnowledge(knowledge);
    }

    @Operation(summary = "更新安全知识")
    @PutMapping
    public Result<String> updateKnowledge(@RequestBody SafetyKnowledge knowledge) {
        return knowledgeService.updateKnowledge(knowledge);
    }

    @Operation(summary = "删除安全知识")
    @DeleteMapping("/{id}")
    public Result<String> deleteKnowledge(@PathVariable Long id) {
        return knowledgeService.deleteKnowledge(id);
    }

    @Operation(summary = "发布/取消发布安全知识")
    @PutMapping("/{id}/publish/{status}")
    public Result<String> publishKnowledge(@PathVariable Long id, @PathVariable Integer status) {
        return knowledgeService.publishKnowledge(id, status);
    }

    @Operation(summary = "获取热门安全知识")
    @GetMapping("/hot")
    public Result<List<SafetyKnowledge>> getHotKnowledge(
            @RequestParam(defaultValue = "5") Integer limit) {
        return knowledgeService.getHotKnowledge(limit);
    }

    @Operation(summary = "获取最新安全知识")
    @GetMapping("/latest")
    public Result<List<SafetyKnowledge>> getLatestKnowledge(
            @RequestParam(defaultValue = "5") Integer limit) {
        return knowledgeService.getLatestKnowledge(limit);
    }

    @Operation(summary = "统计安全知识数量")
    @GetMapping("/count")
    public Result<Long> countKnowledge() {
        return knowledgeService.countKnowledge();
    }
}
