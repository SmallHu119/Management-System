package com.hazmat.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hazmat.common.PageResult;
import com.hazmat.common.Result;
import com.hazmat.entity.HazmatInfo;
import com.hazmat.entity.WarningRecord;
import com.hazmat.mapper.HazmatInfoMapper;
import com.hazmat.service.WarningRecordService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 预警记录管理控制器
 * 状态定义: 0-未处理, 1-处理中, 2-已解决, 3-已忽略
 */
@Tag(name = "预警记录管理", description = "危化品预警记录管理接口")
@Slf4j
@RestController
@RequestMapping("/warning/record")
@RequiredArgsConstructor
public class WarningRecordController {

    private final WarningRecordService warningRecordService;
    private final HazmatInfoMapper hazmatInfoMapper;

    @Operation(summary = "获取所有预警记录")
    @GetMapping("/all")
    public Result<List<WarningRecord>> getAllRecords() {
        try {
            List<WarningRecord> records = warningRecordService.list();
            enrichWarningRecords(records);
            return Result.success(records);
        } catch (Exception e) {
            log.warn("查询预警记录失败", e);
            return Result.success(java.util.Collections.emptyList());
        }
    }

    @Operation(summary = "分页查询预警记录")
    @GetMapping("/list")
    public Result<PageResult<WarningRecord>> getRecordPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Long hazmatId,
            @RequestParam(required = false) String warningLevel,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String handlerName,
            @RequestParam(required = false) LocalDateTime startTime,
            @RequestParam(required = false) LocalDateTime endTime) {
        try {
            Page<WarningRecord> page = new Page<>(pageNum, pageSize);
            QueryWrapper<WarningRecord> queryWrapper = new QueryWrapper<>();
            
            if (hazmatId != null) {
                queryWrapper.eq("hazmat_id", hazmatId);
            }
            if (warningLevel != null && !warningLevel.isEmpty()) {
                queryWrapper.eq("warning_level", warningLevel);
            }
            if (status != null) {
                queryWrapper.eq("status", status);
            }
            if (handlerName != null && !handlerName.isEmpty()) {
                queryWrapper.eq("handler_name", handlerName);
            }
            if (startTime != null) {
                queryWrapper.ge("create_time", startTime);
            }
            if (endTime != null) {
                queryWrapper.le("create_time", endTime);
            }
            
            queryWrapper.orderByDesc("create_time");
            
            IPage<WarningRecord> result = warningRecordService.page(page, queryWrapper);
            enrichWarningRecords(result.getRecords());
            return Result.success(PageResult.of(result));
        } catch (Exception e) {
            log.warn("分页查询预警记录失败", e);
            return Result.success(PageResult.empty());
        }
    }

    @Operation(summary = "获取未处理的预警记录")
    @GetMapping("/unhandled")
    public Result<List<WarningRecord>> getUnhandledRecords() {
        QueryWrapper<WarningRecord> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("status", 0) // 0-未处理
                   .orderByDesc("create_time");
        
        List<WarningRecord> records = warningRecordService.list(queryWrapper);
        enrichWarningRecords(records);
        return Result.success(records);
    }

    @Operation(summary = "获取预警记录详情")
    @GetMapping("/{id}")
    public Result<WarningRecord> getRecordById(@PathVariable Long id) {
        WarningRecord record = warningRecordService.getById(id);
        if (record == null) {
            return Result.error("预警记录不存在");
        }
        enrichWarningRecords(java.util.Collections.singletonList(record));
        return Result.success(record);
    }

    @Operation(summary = "处理预警记录")
    @PutMapping("/handle/{id}")
    public Result<String> handleWarningRecord(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body) {
        WarningRecord record = new WarningRecord();
        record.setId(id);
        
        Object statusObj = body.get("status");
        if (statusObj != null) {
            record.setStatus(Integer.valueOf(statusObj.toString()));
        } else {
            record.setStatus(1); // 默认处理中
        }
        
        Object handlerIdObj = body.get("handlerId");
        if (handlerIdObj != null) {
            record.setHandlerId(Long.valueOf(handlerIdObj.toString()));
        }
        
        Object handlerNameObj = body.get("handlerName");
        if (handlerNameObj != null) {
            record.setHandlerName(handlerNameObj.toString());
        }
        
        Object handleResultObj = body.get("handleResult");
        if (handleResultObj != null) {
            record.setHandleResult(handleResultObj.toString());
        }
        
        Object remarkObj = body.get("remark");
        if (remarkObj != null) {
            String handleResult = record.getHandleResult();
            if (handleResult == null || handleResult.isEmpty()) {
                record.setHandleResult(remarkObj.toString());
            } else {
                record.setHandleResult(handleResult + "\n备注: " + remarkObj.toString());
            }
        }
        
        record.setHandleTime(LocalDateTime.now());
        
        boolean success = warningRecordService.updateById(record);
        if (success) {
            return Result.success("处理成功");
        }
        return Result.error("处理失败");
    }

    @Operation(summary = "关闭预警记录")
    @PutMapping("/close/{id}")
    public Result<String> closeWarningRecord(@PathVariable Long id) {
        WarningRecord record = new WarningRecord();
        record.setId(id);
        record.setStatus(2); // 2-已解决
        
        boolean success = warningRecordService.updateById(record);
        if (success) {
            return Result.success("关闭成功");
        }
        return Result.error("关闭失败");
    }

    @Operation(summary = "删除预警记录")
    @DeleteMapping("/{id}")
    public Result<String> deleteWarningRecord(@PathVariable Long id) {
        boolean success = warningRecordService.removeById(id);
        if (success) {
            return Result.success("删除成功");
        }
        return Result.error("删除失败");
    }

    @Operation(summary = "统计预警记录数量")
    @GetMapping("/count")
    public Result<Long> countWarningRecords(@RequestParam(required = false) Integer status) {
        QueryWrapper<WarningRecord> queryWrapper = new QueryWrapper<>();
        if (status != null) {
            queryWrapper.eq("status", status);
        }
        long count = warningRecordService.count(queryWrapper);
        return Result.success(count);
    }

    @Operation(summary = "按预警级别统计")
    @GetMapping("/count-by-level")
    public Result<List<Map<String, Object>>> countByWarningLevel() {
        List<Map<String, Object>> result = new ArrayList<>();
        
        String[] levels = {"一般", "较大", "重大"};
        for (String level : levels) {
            QueryWrapper<WarningRecord> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("warning_level", level);
            long count = warningRecordService.count(queryWrapper);
            
            Map<String, Object> item = new HashMap<>();
            item.put("warningLevel", level);
            item.put("count", count);
            result.add(item);
        }
        
        return Result.success(result);
    }

    @Operation(summary = "获取预警统计数据")
    @GetMapping("/statistics")
    public Result<Map<String, Object>> getWarningStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        // 未处理预警数
        QueryWrapper<WarningRecord> unhandledWrapper = new QueryWrapper<>();
        unhandledWrapper.eq("status", 0);
        long unhandledCount = warningRecordService.count(unhandledWrapper);
        stats.put("unhandledCount", unhandledCount);
        stats.put("newUnhandled", unhandledCount); // 简化处理
        
        // 今日预警数
        LocalDateTime todayStart = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);
        QueryWrapper<WarningRecord> todayWrapper = new QueryWrapper<>();
        todayWrapper.ge("create_time", todayStart);
        long todayCount = warningRecordService.count(todayWrapper);
        stats.put("todayCount", todayCount);
        stats.put("todayChange", 0); // 简化处理
        
        // 重大预警数
        QueryWrapper<WarningRecord> criticalWrapper = new QueryWrapper<>();
        criticalWrapper.eq("warning_level", "重大");
        long criticalCount = warningRecordService.count(criticalWrapper);
        stats.put("criticalCount", criticalCount);
        
        // 重大未处理
        QueryWrapper<WarningRecord> criticalUnhandledWrapper = new QueryWrapper<>();
        criticalUnhandledWrapper.eq("warning_level", "重大").eq("status", 0);
        long criticalUnhandled = warningRecordService.count(criticalUnhandledWrapper);
        stats.put("criticalUnhandled", criticalUnhandled);
        
        // 处理完成率
        long totalCount = warningRecordService.count();
        QueryWrapper<WarningRecord> handledWrapper = new QueryWrapper<>();
        handledWrapper.in("status", 2, 3); // 已解决或已忽略
        long handledCount = warningRecordService.count(handledWrapper);
        double handlingRate = totalCount > 0 ? (double) handledCount / totalCount * 100 : 0;
        stats.put("handlingRate", Math.round(handlingRate * 10) / 10.0);
        stats.put("targetRate", 95);
        
        return Result.success(stats);
    }

    @Operation(summary = "获取预警详情(含趋势数据)")
    @GetMapping("/detail/{id}")
    public Result<Map<String, Object>> getWarningDetail(@PathVariable Long id) {
        WarningRecord record = warningRecordService.getById(id);
        if (record == null) {
            return Result.error("预警记录不存在");
        }
        
        // 补全危化品名称
        enrichWarningRecords(java.util.Collections.singletonList(record));
        
        Map<String, Object> detail = new HashMap<>();
        detail.put("id", record.getId());
        detail.put("hazmatId", record.getHazmatId());
        detail.put("ruleId", record.getRuleId());
        detail.put("paramId", record.getParamId());
        detail.put("paramValue", record.getParamValue());
        detail.put("warningLevel", record.getWarningLevel());
        detail.put("warningMessage", record.getWarningMessage());
        detail.put("status", record.getStatus());
        detail.put("handlerId", record.getHandlerId());
        detail.put("handlerName", record.getHandlerName());
        detail.put("handleTime", record.getHandleTime());
        detail.put("handleResult", record.getHandleResult());
        detail.put("createTime", record.getCreateTime());
        detail.put("warningTime", record.getCreateTime());
        detail.put("warningTitle", record.getWarningLevel() + "预警 - " + record.getWarningMessage());
        detail.put("warningContent", record.getWarningMessage());
        detail.put("hazmatName", record.getHazmatName());
        detail.put("trendData", new ArrayList<>()); // 趋势数据需要关联查询，暂返回空
        
        return Result.success(detail);
    }

    /**
     * 补全预警记录的危化品名称
     */
    private void enrichWarningRecords(List<WarningRecord> records) {
        if (records == null || records.isEmpty()) return;
        for (WarningRecord record : records) {
            if (record.getHazmatId() != null) {
                try {
                    HazmatInfo hazmat = hazmatInfoMapper.selectById(record.getHazmatId());
                    if (hazmat != null) {
                        record.setHazmatName(hazmat.getName());
                    }
                } catch (Exception ignored) {}
            }
        }
    }
}
