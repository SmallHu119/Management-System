package com.hazmat.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.hazmat.entity.RealTimeMonitoring;

import java.util.List;

/**
 * 实时监测数据服务接口
 */
public interface RealTimeMonitoringService extends IService<RealTimeMonitoring> {

    /**
     * 分页查询监测数据
     */
    IPage<RealTimeMonitoring> getMonitoringDataPage(Integer pageNum, Integer pageSize,
                                                     Long hazmatId, Long paramId,
                                                     Integer status, String startTime, String endTime);

    /**
     * 获取最新监测数据
     */
    List<RealTimeMonitoring> getLatestMonitoringData();

    /**
     * 获取当前实时监测数据
     */
    List<RealTimeMonitoring> getCurrentMonitoringData();

    /**
     * 添加监测数据（自动检查预警规则）
     */
    boolean addMonitoringData(RealTimeMonitoring monitoring);

    /**
     * 更新监测数据（自动检查预警规则）
     */
    boolean updateMonitoringData(RealTimeMonitoring monitoring);
}
