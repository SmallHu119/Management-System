package com.hazmat.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hazmat.common.PageResult;
import com.hazmat.common.Result;
import com.hazmat.entity.HazmatInfo;
import com.hazmat.entity.HazardWarningRule;
import com.hazmat.entity.MonitoringParameter;
import com.hazmat.mapper.HazmatInfoMapper;
import com.hazmat.mapper.MonitoringParameterMapper;
import com.hazmat.service.HazardWarningRuleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 危化品预警规则管理控制器
 */
@Tag(name = "预警规则管理", description = "危化品预警规则配置管理接口")
@RestController
@RequestMapping("/warning/rule")
@RequiredArgsConstructor
public class HazardWarningRuleController {

    private final HazardWarningRuleService hazardWarningRuleService;
    private final HazmatInfoMapper hazmatInfoMapper;
    private final MonitoringParameterMapper monitoringParameterMapper;

    @Operation(summary = "获取所有预警规则")
    @GetMapping("/all")
    public Result<List<HazardWarningRule>> getAllRules() {
        List<HazardWarningRule> rules = hazardWarningRuleService.list();
        enrichWarningRules(rules);
        return Result.success(rules);
    }

    @Operation(summary = "分页查询预警规则")
    @GetMapping("/list")
    public Result<PageResult<HazardWarningRule>> getRulePage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Long hazmatId,
            @RequestParam(required = false) Long paramId) {
        Page<HazardWarningRule> page = new Page<>(pageNum, pageSize);
        QueryWrapper<HazardWarningRule> queryWrapper = new QueryWrapper<>();
        
        if (hazmatId != null) {
            queryWrapper.eq("hazmat_id", hazmatId);
        }
        if (paramId != null) {
            queryWrapper.eq("param_id", paramId);
        }
        
        IPage<HazardWarningRule> result = hazardWarningRuleService.page(page, queryWrapper);
        enrichWarningRules(result.getRecords());
        return Result.success(PageResult.of(result));
    }

    @Operation(summary = "根据危化品ID获取预警规则")
    @GetMapping("/by-hazmat/{hazmatId}")
    public Result<List<HazardWarningRule>> getRulesByHazmatId(@PathVariable Long hazmatId) {
        QueryWrapper<HazardWarningRule> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("hazmat_id", hazmatId)
                   .eq("status", 1); // 只返回启用的规则
        
        List<HazardWarningRule> rules = hazardWarningRuleService.list(queryWrapper);
        enrichWarningRules(rules);
        return Result.success(rules);
    }

    @Operation(summary = "获取预警规则详情")
    @GetMapping("/{id}")
    public Result<HazardWarningRule> getRuleById(@PathVariable Long id) {
        HazardWarningRule rule = hazardWarningRuleService.getById(id);
        if (rule == null) {
            return Result.error("预警规则不存在");
        }
        enrichWarningRules(java.util.Collections.singletonList(rule));
        return Result.success(rule);
    }

    @Operation(summary = "添加预警规则")
    @PostMapping
    public Result<String> addRule(@RequestBody HazardWarningRule rule) {
        boolean success = hazardWarningRuleService.save(rule);
        if (success) {
            return Result.success("添加成功");
        }
        return Result.error("添加失败");
    }

    @Operation(summary = "更新预警规则")
    @PutMapping
    public Result<String> updateRule(@RequestBody HazardWarningRule rule) {
        boolean success = hazardWarningRuleService.updateById(rule);
        if (success) {
            return Result.success("更新成功");
        }
        return Result.error("更新失败");
    }

    @Operation(summary = "删除预警规则")
    @DeleteMapping("/{id}")
    public Result<String> deleteRule(@PathVariable Long id) {
        boolean success = hazardWarningRuleService.removeById(id);
        if (success) {
            return Result.success("删除成功");
        }
        return Result.error("删除失败");
    }

    @Operation(summary = "启用/禁用预警规则")
    @PutMapping("/status/{id}")
    public Result<String> toggleRuleStatus(@PathVariable Long id, @RequestParam Integer status) {
        HazardWarningRule rule = new HazardWarningRule();
        rule.setId(id);
        rule.setStatus(status);
        boolean success = hazardWarningRuleService.updateById(rule);
        if (success) {
            return Result.success(status == 1 ? "启用成功" : "禁用成功");
        }
        return Result.error("操作失败");
    }

    /**
     * 补全预警规则的危化品名称、参数名称和单位
     */
    private void enrichWarningRules(List<HazardWarningRule> rules) {
        if (rules == null || rules.isEmpty()) return;
        for (HazardWarningRule rule : rules) {
            if (rule.getHazmatId() != null) {
                try {
                    HazmatInfo hazmat = hazmatInfoMapper.selectById(rule.getHazmatId());
                    if (hazmat != null) {
                        rule.setHazmatName(hazmat.getName());
                    }
                } catch (Exception ignored) {}
            }
            if (rule.getParamId() != null) {
                try {
                    MonitoringParameter param = monitoringParameterMapper.selectById(rule.getParamId());
                    if (param != null) {
                        rule.setParamName(param.getName());
                        rule.setParamUnit(param.getUnit());
                    }
                } catch (Exception ignored) {}
            }
        }
    }
}
