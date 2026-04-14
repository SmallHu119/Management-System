package com.hazmat.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 实时监测数据实体类
 */
@Data
@TableName("real_time_monitoring")
public class RealTimeMonitoring {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long hazmatId;
    
    private Long paramId;
    
    private Double paramValue;
    
    private LocalDateTime monitorTime;
    
    private String deviceId;
    
    private String dataSource;
    
    private String location;
    
    private Integer status;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    // 非数据库字段
    @TableField(exist = false)
    private String hazmatName;
    
    @TableField(exist = false)
    private String paramName;
    
    @TableField(exist = false)
    private String paramUnit;
}
