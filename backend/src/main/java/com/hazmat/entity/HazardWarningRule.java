package com.hazmat.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 危化品预警规则实体类
 */
@Data
@TableName("hazard_warning_rule")
public class HazardWarningRule {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long hazmatId;
    
    private Long paramId;
    
    private String warningLevel;
    
    private BigDecimal thresholdMin;
    
    private BigDecimal thresholdMax;
    
    private Double minValue;
    
    private Double maxValue;
    
    private Double warningMinValue;
    
    private Double warningMaxValue;
    
    private String warningMessage;
    
    private String notificationMethods;
    
    private Integer status;
    
    private Integer enabled;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    // 非数据库字段
    @TableField(exist = false)
    private String hazmatName;
    
    @TableField(exist = false)
    private String paramName;
    
    @TableField(exist = false)
    private String paramUnit;
}
