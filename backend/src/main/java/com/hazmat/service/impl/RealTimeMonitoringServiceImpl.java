package com.hazmat.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hazmat.entity.RealTimeMonitoring;
import com.hazmat.entity.HazardWarningRule;
import com.hazmat.entity.WarningRecord;
import com.hazmat.mapper.RealTimeMonitoringMapper;
import com.hazmat.service.RealTimeMonitoringService;
import com.hazmat.service.HazardWarningRuleService;
import com.hazmat.service.WarningRecordService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 实时监测数据服务实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class RealTimeMonitoringServiceImpl extends ServiceImpl<RealTimeMonitoringMapper, RealTimeMonitoring>
        implements RealTimeMonitoringService {

    private final HazardWarningRuleService hazardWarningRuleService;
    private final WarningRecordService warningRecordService;

    @Override
    public IPage<RealTimeMonitoring> getMonitoringDataPage(Integer pageNum, Integer pageSize,
                                                           Long hazmatId, Long paramId,
                                                           Integer status, String startTime, String endTime) {
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
        if (StringUtils.hasText(startTime)) {
            queryWrapper.ge("monitor_time", startTime);
        }
        if (StringUtils.hasText(endTime)) {
            queryWrapper.le("monitor_time", endTime);
        }
        
        queryWrapper.orderByDesc("monitor_time");
        return this.page(page, queryWrapper);
    }

    @Override
    public List<RealTimeMonitoring> getLatestMonitoringData() {
        QueryWrapper<RealTimeMonitoring> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByDesc("monitor_time");
        queryWrapper.last("LIMIT 20");
        return this.list(queryWrapper);
    }

    @Override
    public List<RealTimeMonitoring> getCurrentMonitoringData() {
        // 获取各危化品各参数的最新一条数据
        QueryWrapper<RealTimeMonitoring> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByDesc("monitor_time");
        queryWrapper.last("LIMIT 50");
        return this.list(queryWrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean addMonitoringData(RealTimeMonitoring monitoring) {
        if (monitoring.getMonitorTime() == null) {
            monitoring.setMonitorTime(LocalDateTime.now());
        }
        
        // 检查预警规则并更新状态
        checkWarningRules(monitoring);
        
        boolean saved = this.save(monitoring);
        if (saved) {
            // 如果状态为预警或报警，自动生成预警记录
            if (monitoring.getStatus() != null && monitoring.getStatus() > 0) {
                generateWarningRecord(monitoring);
            }
        }
        return saved;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateMonitoringData(RealTimeMonitoring monitoring) {
        checkWarningRules(monitoring);
        return this.updateById(monitoring);
    }

    /**
     * 检查预警规则，自动判断监测数据状态
     */
    private void checkWarningRules(RealTimeMonitoring monitoring) {
        if (monitoring.getHazmatId() == null || monitoring.getParamId() == null) {
            monitoring.setStatus(0); // 默认正常
            return;
        }
        
        // 查询对应的预警规则
        QueryWrapper<HazardWarningRule> ruleQuery = new QueryWrapper<>();
        ruleQuery.eq("hazmat_id", monitoring.getHazmatId());
        ruleQuery.eq("param_id", monitoring.getParamId());
        ruleQuery.eq("enabled", 1);
        
        List<HazardWarningRule> rules = hazardWarningRuleService.list(ruleQuery);
        
        if (rules.isEmpty()) {
            monitoring.setStatus(0); // 无规则则默认正常
            return;
        }
        
        Double paramValue = monitoring.getParamValue();
        int maxStatus = 0;
        
        for (HazardWarningRule rule : rules) {
            int status = evaluateRule(rule, paramValue);
            maxStatus = Math.max(maxStatus, status);
        }
        
        monitoring.setStatus(maxStatus);
    }

    /**
     * 评估单条预警规则
     * @return 0=正常, 1=预警, 2=报警
     */
    private int evaluateRule(HazardWarningRule rule, Double paramValue) {
        if (paramValue == null) return 0;
        
        // 检查是否超出预警范围
        if (rule.getWarningMaxValue() != null && paramValue > rule.getWarningMaxValue()) {
            return 2; // 报警
        }
        if (rule.getWarningMinValue() != null && paramValue < rule.getWarningMinValue()) {
            return 2; // 报警
        }
        
        // 检查是否在预警边界范围
        if (rule.getMaxValue() != null && paramValue > rule.getMaxValue()) {
            return 1; // 预警
        }
        if (rule.getMinValue() != null && paramValue < rule.getMinValue()) {
            return 1; // 预警
        }
        
        return 0; // 正常
    }

    /**
     * 根据监测数据生成预警记录
     */
    private void generateWarningRecord(RealTimeMonitoring monitoring) {
        WarningRecord record = new WarningRecord();
        record.setHazmatId(monitoring.getHazmatId());
        record.setParamId(monitoring.getParamId());
        record.setWarningValue(monitoring.getParamValue() != null ? BigDecimal.valueOf(monitoring.getParamValue()) : null);
        record.setThresholdValue(getThresholdValue(monitoring));
        record.setWarningLevel(monitoring.getStatus() == 2 ? "重大" : "较大");
        record.setStatus(0); // 未处理
        record.setWarningTime(monitoring.getMonitorTime());
        record.setDescription(String.format("监测参数值 %s 超出阈值范围", monitoring.getParamValue()));
        record.setWarningMessage(record.getDescription());
        
        warningRecordService.save(record);
        log.info("自动生成预警记录:危化品ID={}, 参数ID={}, 预警值={}, 状态={}", 
                monitoring.getHazmatId(), monitoring.getParamId(), 
                monitoring.getParamValue(), monitoring.getStatus());
    }

    /**
     * 获取阈值（用于预警记录）
     */
    private Double getThresholdValue(RealTimeMonitoring monitoring) {
        QueryWrapper<HazardWarningRule> ruleQuery = new QueryWrapper<>();
        ruleQuery.eq("hazmat_id", monitoring.getHazmatId());
        ruleQuery.eq("param_id", monitoring.getParamId());
        ruleQuery.eq("enabled", 1);
        ruleQuery.last("LIMIT 1");
        
        HazardWarningRule rule = hazardWarningRuleService.getOne(ruleQuery, false);
        if (rule != null) {
            return rule.getMaxValue();
        }
        return 0.0;
    }
}
