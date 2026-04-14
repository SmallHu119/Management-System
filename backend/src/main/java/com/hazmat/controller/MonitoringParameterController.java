package com.hazmat.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hazmat.common.PageResult;
import com.hazmat.common.Result;
import com.hazmat.entity.MonitoringParameter;
import com.hazmat.service.MonitoringParameterService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 监测参数管理控制器
 */
@Tag(name = "监测参数管理", description = "监测参数配置管理接口")
@RestController
@RequestMapping("/monitoring/parameter")
@RequiredArgsConstructor
public class MonitoringParameterController {

    private final MonitoringParameterService monitoringParameterService;

    @Operation(summary = "获取所有监测参数")
    @GetMapping("/all")
    public Result<List<MonitoringParameter>> getAllParameters() {
        List<MonitoringParameter> parameters = monitoringParameterService.list();
        return Result.success(parameters);
    }

    @Operation(summary = "分页查询监测参数")
    @GetMapping("/list")
    public Result<PageResult<MonitoringParameter>> getParameterPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String name) {
        Page<MonitoringParameter> page = new Page<>(pageNum, pageSize);
        QueryWrapper<MonitoringParameter> queryWrapper = new QueryWrapper<>();
        if (StringUtils.hasText(name)) {
            queryWrapper.like("name", name);
        }
        IPage<MonitoringParameter> result = monitoringParameterService.page(page, queryWrapper);
        return Result.success(PageResult.of(result));
    }

    @Operation(summary = "获取监测参数详情")
    @GetMapping("/{id}")
    public Result<MonitoringParameter> getParameterById(@PathVariable Long id) {
        MonitoringParameter parameter = monitoringParameterService.getById(id);
        if (parameter == null) {
            return Result.error("监测参数不存在");
        }
        return Result.success(parameter);
    }

    @Operation(summary = "添加监测参数")
    @PostMapping
    public Result<String> addParameter(@RequestBody MonitoringParameter parameter) {
        boolean success = monitoringParameterService.save(parameter);
        if (success) {
            return Result.success("添加成功");
        }
        return Result.error("添加失败");
    }

    @Operation(summary = "更新监测参数")
    @PutMapping
    public Result<String> updateParameter(@RequestBody MonitoringParameter parameter) {
        boolean success = monitoringParameterService.updateById(parameter);
        if (success) {
            return Result.success("更新成功");
        }
        return Result.error("更新失败");
    }

    @Operation(summary = "删除监测参数")
    @DeleteMapping("/{id}")
    public Result<String> deleteParameter(@PathVariable Long id) {
        boolean success = monitoringParameterService.removeById(id);
        if (success) {
            return Result.success("删除成功");
        }
        return Result.error("删除失败");
    }
}
