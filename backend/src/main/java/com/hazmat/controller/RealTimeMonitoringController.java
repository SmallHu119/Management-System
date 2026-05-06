package com.hazmat.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hazmat.common.PageResult;
import com.hazmat.common.Result;
import com.hazmat.entity.HazmatInfo;
import com.hazmat.entity.MonitoringParameter;
import com.hazmat.entity.RealTimeMonitoring;
import com.hazmat.mapper.HazmatInfoMapper;
import com.hazmat.mapper.MonitoringParameterMapper;
import com.hazmat.service.RealTimeMonitoringService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 实时监测数据管理控制器
 */
@Tag(name = "实时监测管理", description = "危化品实时监测数据管理接口")
@Slf4j
@RestController
@RequestMapping("/monitoring/realtime")
@RequiredArgsConstructor
public class RealTimeMonitoringController {

    private final RealTimeMonitoringService realTimeMonitoringService;
    private final HazmatInfoMapper hazmatInfoMapper;
    private final MonitoringParameterMapper monitoringParameterMapper;

    @Operation(summary = "上报实时监测数据")
    @PostMapping("/report")
    public Result<String> reportMonitoringData(@RequestBody RealTimeMonitoring monitoringData) {
        try {
            // 设置监测时间为当前时间
            if (monitoringData.getMonitorTime() == null) {
                monitoringData.setMonitorTime(LocalDateTime.now());
            }
            // 默认状态为正常
            if (monitoringData.getStatus() == null) {
                monitoringData.setStatus(0);
            }
            realTimeMonitoringService.addMonitoringData(monitoringData);
            return Result.success("数据上报成功");
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("数据上报失败：" + e.getMessage());
        }
    }

    @Operation(summary = "分页查询实时监测数据")
    @GetMapping("/list")
    public Result<PageResult<RealTimeMonitoring>> getMonitoringPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Long hazmatId,
            @RequestParam(required = false) Long paramId,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) LocalDateTime startTime,
            @RequestParam(required = false) LocalDateTime endTime) {
        try {
            Page<RealTimeMonitoring> page = new Page<>(pageNum, pageSize);
            QueryWrapper<RealTimeMonitoring> queryWrapper = new QueryWrapper<>();
            
            if (hazmatId != null) {
                queryWrapper.eq("hazmat_id", hazmatId);
            }
            if (paramId != null) {
                queryWrapper.eq("param_id", paramId);
            }
            if (status != null) {
                queryWrapper.eq("status", status);
            }
            if (startTime != null) {
                queryWrapper.ge("monitor_time", startTime);
            }
            if (endTime != null) {
                queryWrapper.le("monitor_time", endTime);
            }
            
            queryWrapper.orderByDesc("monitor_time");
            
            IPage<RealTimeMonitoring> result = realTimeMonitoringService.page(page, queryWrapper);
            enrichMonitoringData(result.getRecords());
            return Result.success(PageResult.of(result));
        } catch (Exception e) {
            log.warn("查询实时监测数据失败", e);
            return Result.success(PageResult.empty());
        }
    }

    @Operation(summary = "获取危化品最新监测数据")
    @GetMapping("/latest/{hazmatId}")
    public Result<List<RealTimeMonitoring>> getLatestMonitoringData(@PathVariable Long hazmatId) {
        QueryWrapper<RealTimeMonitoring> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("hazmat_id", hazmatId)
                   .orderByDesc("monitor_time")
                   .last("LIMIT 10"); // 获取最新10条记录
        
        List<RealTimeMonitoring> dataList = realTimeMonitoringService.list(queryWrapper);
        enrichMonitoringData(dataList);
        return Result.success(dataList);
    }

    @Operation(summary = "获取危化品当前最新监测数据")
    @GetMapping("/current/{hazmatId}")
    public Result<RealTimeMonitoring> getCurrentMonitoringData(@PathVariable Long hazmatId) {
        QueryWrapper<RealTimeMonitoring> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("hazmat_id", hazmatId)
                   .orderByDesc("monitor_time")
                   .last("LIMIT 1"); // 获取最新一条记录
        
        RealTimeMonitoring data = realTimeMonitoringService.getOne(queryWrapper);
        if (data == null) {
            return Result.error("暂无监测数据");
        }
        enrichMonitoringData(java.util.Collections.singletonList(data));
        return Result.success(data);
    }

    @Operation(summary = "删除监测数据")
    @DeleteMapping("/{id}")
    public Result<String> deleteMonitoringData(@PathVariable Long id) {
        boolean success = realTimeMonitoringService.removeById(id);
        if (success) {
            return Result.success("删除成功");
        }
        return Result.error("删除失败");
    }

    @Operation(summary = "获取危化品监测趋势数据")
    @GetMapping("/trend/{hazmatId}")
    public Result<Map<String, Object>> getMonitoringTrend(
            @PathVariable Long hazmatId,
            @RequestParam(required = false) Long paramId,
            @RequestParam(required = false) String timeRange,
            @RequestParam(required = false) LocalDateTime startTime,
            @RequestParam(required = false) LocalDateTime endTime) {
        
        // 根据 timeRange 计算时间范围
        if (timeRange != null && startTime == null) {
            LocalDateTime now = LocalDateTime.now();
            switch (timeRange) {
                case "6h":
                    startTime = now.minusHours(6);
                    break;
                case "12h":
                    startTime = now.minusHours(12);
                    break;
                case "24h":
                    startTime = now.minusHours(24);
                    break;
                case "7d":
                    startTime = now.minusDays(7);
                    break;
                case "30d":
                    startTime = now.minusDays(30);
                    break;
                default:
                    startTime = now.minusHours(24);
            }
            endTime = now;
        }
        
        QueryWrapper<RealTimeMonitoring> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("hazmat_id", hazmatId);
        
        if (paramId != null) {
            queryWrapper.eq("param_id", paramId);
        }
        if (startTime != null) {
            queryWrapper.ge("monitor_time", startTime);
        }
        if (endTime != null) {
            queryWrapper.le("monitor_time", endTime);
        }
        
        queryWrapper.orderByAsc("monitor_time");
        
        List<RealTimeMonitoring> dataList = realTimeMonitoringService.list(queryWrapper);
        
        // 构造前端需要的格式
        Map<String, Object> trendData = new HashMap<>();
        List<String> xData = new java.util.ArrayList<>();
        List<Object> yData = new java.util.ArrayList<>();
        
        for (RealTimeMonitoring data : dataList) {
            xData.add(data.getMonitorTime() != null ? data.getMonitorTime().toString() : "");
            yData.add(data.getParamValue());
        }
        
        trendData.put("xData", xData);
        trendData.put("yData", yData);
        trendData.put("warningMin", null);
        trendData.put("warningMax", null);
        trendData.put("normalMin", null);
        trendData.put("normalMax", null);
        
        return Result.success(trendData);
    }

    @Operation(summary = "获取监测统计数据")
    @GetMapping("/statistics")
    public Result<Map<String, Object>> getMonitoringStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        // 今日监测数据总数
        LocalDateTime todayStart = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);
        QueryWrapper<RealTimeMonitoring> todayWrapper = new QueryWrapper<>();
        todayWrapper.ge("monitor_time", todayStart);
        long todayTotal = realTimeMonitoringService.count(todayWrapper);
        
        // 总数据量
        long totalData = realTimeMonitoringService.count();
        
        // 预警数据
        QueryWrapper<RealTimeMonitoring> warningWrapper = new QueryWrapper<>();
        warningWrapper.eq("status", 1);
        warningWrapper.ge("monitor_time", todayStart);
        long warningCount = realTimeMonitoringService.count(warningWrapper);
        
        // 报警数据(status=2)
        QueryWrapper<RealTimeMonitoring> alertWrapper = new QueryWrapper<>();
        alertWrapper.eq("status", 2);
        alertWrapper.ge("monitor_time", todayStart);
        long alertCount = realTimeMonitoringService.count(alertWrapper);
        
        // 正常率
        double normalRate = totalData > 0 ? (double)(totalData - warningCount - alertCount) / totalData * 100 : 100;
        
        stats.put("totalData", totalData);
        stats.put("newData", todayTotal);
        stats.put("warningCount", warningCount);
        stats.put("newWarning", warningCount);
        stats.put("alertCount", alertCount);
        stats.put("newAlert", alertCount);
        stats.put("normalRate", Math.round(normalRate * 10) / 10.0);
        stats.put("rateChange", 0);
        
        return Result.success(stats);
    }

    @Operation(summary = "根据ID获取监测数据")
    @GetMapping("/data/{id}")
    public Result<RealTimeMonitoring> getMonitoringDataById(@PathVariable Long id) {
        RealTimeMonitoring data = realTimeMonitoringService.getById(id);
        if (data == null) {
            return Result.error("监测数据不存在");
        }
        enrichMonitoringData(java.util.Collections.singletonList(data));
        return Result.success(data);
    }

    @Operation(summary = "更新监测数据")
    @PutMapping("/data")
    public Result<String> updateMonitoringData(@RequestBody RealTimeMonitoring monitoringData) {
        boolean success = realTimeMonitoringService.updateById(monitoringData);
        if (success) {
            return Result.success("更新成功");
        }
        return Result.error("更新失败");
    }

    /**
     * 补全监测数据的危化品名称、参数名称和单位
     */
    private void enrichMonitoringData(java.util.List<RealTimeMonitoring> records) {
        if (records == null || records.isEmpty()) return;
        for (RealTimeMonitoring data : records) {
            if (data.getHazmatId() != null) {
                try {
                    HazmatInfo hazmat = hazmatInfoMapper.selectById(data.getHazmatId());
                    if (hazmat != null) {
                        data.setHazmatName(hazmat.getName());
                    }
                } catch (Exception ignored) {}
            }
            if (data.getParamId() != null) {
                try {
                    MonitoringParameter param = monitoringParameterMapper.selectById(data.getParamId());
                    if (param != null) {
                        data.setParamName(param.getName());
                        data.setParamUnit(param.getUnit());
                    }
                } catch (Exception ignored) {}
            }
        }
    }
}
