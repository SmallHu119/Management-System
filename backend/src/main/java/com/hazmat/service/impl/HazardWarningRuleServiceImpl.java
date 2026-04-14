package com.hazmat.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hazmat.entity.HazardWarningRule;
import com.hazmat.mapper.HazardWarningRuleMapper;
import com.hazmat.service.HazardWarningRuleService;
import org.springframework.stereotype.Service;

/**
 * 预警规则服务实现类
 */
@Service
public class HazardWarningRuleServiceImpl extends ServiceImpl<HazardWarningRuleMapper, HazardWarningRule>
        implements HazardWarningRuleService {
}
