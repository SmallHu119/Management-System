package com.hazmat.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hazmat.entity.WarningRecord;
import com.hazmat.mapper.WarningRecordMapper;
import com.hazmat.service.WarningRecordService;
import org.springframework.stereotype.Service;

/**
 * 预警记录服务实现类
 */
@Service
public class WarningRecordServiceImpl extends ServiceImpl<WarningRecordMapper, WarningRecord>
        implements WarningRecordService {
}
