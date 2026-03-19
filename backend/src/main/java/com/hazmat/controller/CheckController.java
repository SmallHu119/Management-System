package com.hazmat.controller;

import com.hazmat.common.PageResult;
import com.hazmat.common.Result;
import com.hazmat.entity.CheckPlan;
import com.hazmat.entity.CheckRecord;
import com.hazmat.service.CheckService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 安全检查控制器
 */
@Tag(name = "安全检查", description = "检查计划和检查记录管理接口")
@RestController
@RequestMapping("/check")
@RequiredArgsConstructor
public class CheckController {

    private final CheckService checkService;

    // ==================== 检查计划管理 ====================

    @Operation(summary = "分页查询检查计划")
    @GetMapping("/plan/list")
    public Result<PageResult<CheckPlan>> getPlanPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) Integer status) {
        return checkService.getPlanPage(pageNum, pageSize, title, status);
    }

    @Operation(summary = "获取待执行的检查计划")
    @GetMapping("/plan/pending")
    public Result<List<CheckPlan>> getPendingPlans() {
        return checkService.getPendingPlans();
    }

    @Operation(summary = "获取检查计划详情")
    @GetMapping("/plan/{id}")
    public Result<CheckPlan> getPlanById(@PathVariable Long id) {
        return checkService.getPlanById(id);
    }

    @Operation(summary = "添加检查计划")
    @PostMapping("/plan")
    public Result<String> addPlan(@RequestBody CheckPlan plan) {
        return checkService.addPlan(plan);
    }

    @Operation(summary = "更新检查计划")
    @PutMapping("/plan")
    public Result<String> updatePlan(@RequestBody CheckPlan plan) {
        return checkService.updatePlan(plan);
    }

    @Operation(summary = "删除检查计划")
    @DeleteMapping("/plan/{id}")
    public Result<String> deletePlan(@PathVariable Long id) {
        return checkService.deletePlan(id);
    }

    @Operation(summary = "更新计划状态")
    @PutMapping("/plan/{id}/status/{status}")
    public Result<String> updatePlanStatus(@PathVariable Long id, @PathVariable Integer status) {
        return checkService.updatePlanStatus(id, status);
    }

    // ==================== 检查记录管理 ====================

    @Operation(summary = "分页查询检查记录")
    @GetMapping("/record/list")
    public Result<PageResult<CheckRecord>> getRecordPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) Long planId,
            @RequestParam(required = false) Integer status) {
        return checkService.getRecordPage(pageNum, pageSize, title, planId, status);
    }

    @Operation(summary = "获取检查记录详情")
    @GetMapping("/record/{id}")
    public Result<CheckRecord> getRecordById(@PathVariable Long id) {
        return checkService.getRecordById(id);
    }

    @Operation(summary = "添加检查记录")
    @PostMapping("/record")
    public Result<String> addRecord(@RequestBody CheckRecord record) {
        return checkService.addRecord(record);
    }

    @Operation(summary = "更新检查记录")
    @PutMapping("/record")
    public Result<String> updateRecord(@RequestBody CheckRecord record) {
        return checkService.updateRecord(record);
    }

    @Operation(summary = "删除检查记录")
    @DeleteMapping("/record/{id}")
    public Result<String> deleteRecord(@PathVariable Long id) {
        return checkService.deleteRecord(id);
    }

    @Operation(summary = "审核检查记录")
    @PutMapping("/record/{id}/audit/{status}")
    public Result<String> auditRecord(@PathVariable Long id, @PathVariable Integer status) {
        return checkService.auditRecord(id, status);
    }

    // ==================== 统计接口 ====================

    @Operation(summary = "统计检查计划数量")
    @GetMapping("/plan/count")
    public Result<Long> countPlans() {
        return checkService.countPlans();
    }

    @Operation(summary = "统计检查记录数量")
    @GetMapping("/record/count")
    public Result<Long> countRecords() {
        return checkService.countRecords();
    }
}
