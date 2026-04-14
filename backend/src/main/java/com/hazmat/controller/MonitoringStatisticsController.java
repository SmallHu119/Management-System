package com.hazmat.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.hazmat.common.Result;
import com.hazmat.entity.HazmatInfo;
import com.hazmat.entity.WarningRecord;
import com.hazmat.mapper.HazmatInfoMapper;
import com.hazmat.service.WarningRecordService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 监测统计分析控制器
 */
@Tag(name = "监测统计分析", description = "监测预警数据统计分析接口")
@RestController
@RequestMapping("/monitoring/statistics")
@RequiredArgsConstructor
public class MonitoringStatisticsController {

    private final WarningRecordService warningRecordService;
    private final HazmatInfoMapper hazmatInfoMapper;

    @Operation(summary = "获取主要统计数据")
    @GetMapping("/main")
    public Result<Map<String, Object>> getMainStatistics(
            @RequestParam(required = false) String timeRange,
            @RequestParam(required = false) String startTime,
            @RequestParam(required = false) String endTime,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String warningLevel) {
        
        Map<String, Object> stats = new HashMap<>();
        LocalDateTime start = getStartTime(timeRange, startTime);
        
        QueryWrapper<WarningRecord> wrapper = new QueryWrapper<>();
        if (start != null) {
            wrapper.ge("create_time", start);
        }
        if (warningLevel != null && !warningLevel.isEmpty()) {
            wrapper.in("warning_level", Arrays.asList(warningLevel.split(",")));
        }
        
        long totalCount = warningRecordService.count(wrapper);
        stats.put("totalWarningCount", totalCount);
        stats.put("monthlyCount", totalCount);
        stats.put("monthlyChange", 0);
        
        // 重大预警
        QueryWrapper<WarningRecord> criticalWrapper = new QueryWrapper<>();
        if (start != null) {
            criticalWrapper.ge("create_time", start);
        }
        criticalWrapper.eq("warning_level", "重大");
        long criticalCount = warningRecordService.count(criticalWrapper);
        stats.put("criticalWarningCount", criticalCount);
        stats.put("criticalPercentage", totalCount > 0 ? Math.round((double) criticalCount / totalCount * 1000) / 10.0 : 0);
        
        // 平均处理时长(简化)
        stats.put("avgHandleTime", "0分钟");
        stats.put("avgHandleTimeChange", 0);
        
        // 未处理
        QueryWrapper<WarningRecord> unhandledWrapper = new QueryWrapper<>();
        unhandledWrapper.eq("status", 0);
        long unhandledCount = warningRecordService.count(unhandledWrapper);
        stats.put("unhandledCount", unhandledCount);
        stats.put("overdueCount", 0);
        
        return Result.success(stats);
    }

    @Operation(summary = "获取预警级别统计")
    @GetMapping("/level")
    public Result<Map<String, Object>> getLevelStatistics(
            @RequestParam(required = false) String timeRange,
            @RequestParam(required = false) String startTime,
            @RequestParam(required = false) String warningLevel) {
        
        Map<String, Object> stats = new HashMap<>();
        LocalDateTime start = getStartTime(timeRange, startTime);
        
        long generalCount = countByLevel("一般", start);
        long majorCount = countByLevel("较大", start);
        long criticalCount = countByLevel("重大", start);
        long total = generalCount + majorCount + criticalCount;
        
        stats.put("generalCount", generalCount);
        stats.put("generalPercentage", total > 0 ? Math.round((double) generalCount / total * 1000) / 10.0 : 0);
        stats.put("majorCount", majorCount);
        stats.put("majorPercentage", total > 0 ? Math.round((double) majorCount / total * 1000) / 10.0 : 0);
        stats.put("criticalCount", criticalCount);
        stats.put("criticalPercentage", total > 0 ? Math.round((double) criticalCount / total * 1000) / 10.0 : 0);
        
        return Result.success(stats);
    }

    @Operation(summary = "获取预警趋势统计")
    @GetMapping("/trend")
    public Result<Map<String, Object>> getTrendStatistics(
            @RequestParam(required = false) String timeRange,
            @RequestParam(required = false) String startTime,
            @RequestParam(required = false) String groupBy,
            @RequestParam(required = false) String warningLevel) {
        
        Map<String, Object> result = new HashMap<>();
        LocalDateTime start = getStartTime(timeRange, startTime);
        
        // 获取时间范围内的所有预警记录
        QueryWrapper<WarningRecord> wrapper = new QueryWrapper<>();
        if (start != null) {
            wrapper.ge("create_time", start);
        }
        wrapper.orderByAsc("create_time");
        List<WarningRecord> records = warningRecordService.list(wrapper);
        
        // 按日期分组统计
        String groupFormat = "hour".equals(groupBy) ? "yyyy-MM-dd HH:00" : "yyyy-MM-dd";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(groupFormat);
        
        Map<String, List<WarningRecord>> grouped = records.stream()
                .filter(r -> r.getCreateTime() != null)
                .collect(Collectors.groupingBy(r -> r.getCreateTime().format(formatter)));
        
        List<String> xData = new ArrayList<>(grouped.keySet());
        Collections.sort(xData);
        
        List<Long> generalData = new ArrayList<>();
        List<Long> majorData = new ArrayList<>();
        List<Long> criticalData = new ArrayList<>();
        List<Long> totalData = new ArrayList<>();
        
        for (String key : xData) {
            List<WarningRecord> group = grouped.get(key);
            long gc = group.stream().filter(r -> "一般".equals(r.getWarningLevel())).count();
            long mc = group.stream().filter(r -> "较大".equals(r.getWarningLevel())).count();
            long cc = group.stream().filter(r -> "重大".equals(r.getWarningLevel())).count();
            generalData.add(gc);
            majorData.add(mc);
            criticalData.add(cc);
            totalData.add(gc + mc + cc);
        }
        
        result.put("xData", xData);
        result.put("generalData", generalData);
        result.put("majorData", majorData);
        result.put("criticalData", criticalData);
        result.put("totalData", totalData);
        
        return Result.success(result);
    }

    @Operation(summary = "获取危化品风险排名")
    @GetMapping("/hazmat-rank")
    public Result<Map<String, Object>> getHazmatRankStatistics(
            @RequestParam(required = false) String timeRange,
            @RequestParam(required = false) String startTime,
            @RequestParam(required = false) String rankType,
            @RequestParam(required = false) String warningLevel) {
        
        Map<String, Object> result = new HashMap<>();
        LocalDateTime start = getStartTime(timeRange, startTime);
        
        QueryWrapper<WarningRecord> wrapper = new QueryWrapper<>();
        if (start != null) {
            wrapper.ge("create_time", start);
        }
        if ("criticalCount".equals(rankType)) {
            wrapper.eq("warning_level", "重大");
        }
        
        List<WarningRecord> records = warningRecordService.list(wrapper);
        
        // 按危化品分组统计
        Map<Long, Long> hazmatCountMap = records.stream()
                .filter(r -> r.getHazmatId() != null)
                .collect(Collectors.groupingBy(WarningRecord::getHazmatId, Collectors.counting()));
        
        // 排序取前10
        List<Map.Entry<Long, Long>> sorted = hazmatCountMap.entrySet().stream()
                .sorted(Map.Entry.<Long, Long>comparingByValue().reversed())
                .limit(10)
                .collect(Collectors.toList());
        
        List<String> names = new ArrayList<>();
        List<Long> values = new ArrayList<>();
        for (Map.Entry<Long, Long> entry : sorted) {
            try {
                HazmatInfo hazmat = hazmatInfoMapper.selectById(entry.getKey());
                names.add(hazmat != null ? hazmat.getName() : "危化品#" + entry.getKey());
            } catch (Exception e) {
                names.add("危化品#" + entry.getKey());
            }
            values.add(entry.getValue());
        }
        
        result.put("names", names);
        result.put("values", values);
        
        return Result.success(result);
    }

    @Operation(summary = "获取预警类型统计")
    @GetMapping("/type")
    public Result<Map<String, Object>> getTypeStatistics(
            @RequestParam(required = false) String timeRange,
            @RequestParam(required = false) String startTime) {
        
        Map<String, Object> stats = new HashMap<>();
        // 当前系统只有阈值型预警，简化统计
        long totalCount = warningRecordService.count();
        stats.put("thresholdCount", totalCount);
        stats.put("trendCount", 0);
        stats.put("correlationCount", 0);
        stats.put("otherCount", 0);
        
        return Result.success(stats);
    }

    @Operation(summary = "获取处理效率统计")
    @GetMapping("/efficiency")
    public Result<Map<String, Object>> getEfficiencyStatistics(
            @RequestParam(required = false) String timeRange,
            @RequestParam(required = false) String startTime) {
        
        Map<String, Object> result = new HashMap<>();
        
        // 获取有处理人的记录
        QueryWrapper<WarningRecord> wrapper = new QueryWrapper<>();
        wrapper.isNotNull("handler_name");
        wrapper.ne("handler_name", "");
        List<WarningRecord> records = warningRecordService.list(wrapper);
        
        // 按处理人分组
        Map<String, List<WarningRecord>> byHandler = records.stream()
                .filter(r -> r.getHandlerName() != null)
                .collect(Collectors.groupingBy(WarningRecord::getHandlerName));
        
        List<Map<String, Object>> list = new ArrayList<>();
        List<String> xData = new ArrayList<>();
        List<Object> avgTimeData = new ArrayList<>();
        List<Object> targetTimeData = new ArrayList<>();
        List<Object> handleRateData = new ArrayList<>();
        List<Object> targetRateData = new ArrayList<>();
        
        for (Map.Entry<String, List<WarningRecord>> entry : byHandler.entrySet()) {
            Map<String, Object> item = new HashMap<>();
            item.put("handlerName", entry.getKey());
            item.put("totalCount", entry.getValue().size());
            item.put("avgHandleTime", 0);
            item.put("maxHandleTime", 0);
            item.put("onTimeRate", 100);
            item.put("overdueCount", 0);
            list.add(item);
            
            xData.add(entry.getKey());
            avgTimeData.add(0);
            targetTimeData.add(30);
            handleRateData.add(100);
            targetRateData.add(95);
        }
        
        // 如果没有数据，提供默认
        if (list.isEmpty()) {
            Map<String, Object> defaultItem = new HashMap<>();
            defaultItem.put("handlerName", "暂无数据");
            defaultItem.put("totalCount", 0);
            defaultItem.put("avgHandleTime", 0);
            defaultItem.put("maxHandleTime", 0);
            defaultItem.put("onTimeRate", 0);
            defaultItem.put("overdueCount", 0);
            list.add(defaultItem);
        }
        
        Map<String, Object> chartData = new HashMap<>();
        chartData.put("xData", xData);
        chartData.put("avgTimeData", avgTimeData);
        chartData.put("targetTimeData", targetTimeData);
        chartData.put("handleRateData", handleRateData);
        chartData.put("targetRateData", targetRateData);
        
        result.put("list", list);
        result.put("chartData", chartData);
        
        return Result.success(result);
    }

    private long countByLevel(String level, LocalDateTime start) {
        QueryWrapper<WarningRecord> wrapper = new QueryWrapper<>();
        wrapper.eq("warning_level", level);
        if (start != null) {
            wrapper.ge("create_time", start);
        }
        return warningRecordService.count(wrapper);
    }

    private LocalDateTime getStartTime(String timeRange, String startTimeStr) {
        if (startTimeStr != null && !startTimeStr.isEmpty()) {
            return LocalDateTime.parse(startTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        }
        if (timeRange == null || timeRange.isEmpty()) {
            return null;
        }
        LocalDateTime now = LocalDateTime.now();
        switch (timeRange) {
            case "7d": return now.minusDays(7);
            case "15d": return now.minusDays(15);
            case "30d": return now.minusDays(30);
            case "90d": return now.minusDays(90);
            case "year": return now.withDayOfYear(1).withHour(0).withMinute(0).withSecond(0).withNano(0);
            default: return now.minusDays(30);
        }
    }
}
