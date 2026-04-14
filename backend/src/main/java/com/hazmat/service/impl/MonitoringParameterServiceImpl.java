package com.hazmat.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hazmat.entity.MonitoringParameter;
import com.hazmat.mapper.MonitoringParameterMapper;
import com.hazmat.service.MonitoringParameterService;
import org.springframework.stereotype.Service;

/**
 * 监测参数服务实现类
 */
@Service
public class MonitoringParameterServiceImpl extends ServiceImpl<MonitoringParameterMapper, MonitoringParameter>
        implements MonitoringParameterService {
}
