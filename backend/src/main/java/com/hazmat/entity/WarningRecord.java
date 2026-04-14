package com.hazmat.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 预警记录实体类
 */
@Data
@TableName("warning_record")
public class WarningRecord {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long hazmatId;
    
    private Long ruleId;
    
    private Long paramId;
    
    private BigDecimal paramValue;
    
    private BigDecimal warningValue;
    
    private Double thresholdValue;
    
    private String warningLevel;
    
    private String warningMessage;
    
    private Integer status;
    
    private Long handlerId;
    
    private String handlerName;
    
    private LocalDateTime handleTime;
    
    private String handleResult;
    
    private LocalDateTime warningTime;
    
    private String description;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    // 非数据库字段
    @TableField(exist = false)
    private String hazmatName;
    
    @TableField(exist = false)
    private String ruleName;
}
