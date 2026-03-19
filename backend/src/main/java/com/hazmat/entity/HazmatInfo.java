package com.hazmat.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 危化品信息实体类
 */
@Data
@TableName("hazmat_info")
public class HazmatInfo {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String name;
    
    private String code;
    
    private Long categoryId;
    
    private String casNumber;
    
    private String unNumber;
    
    private String dangerType;
    
    private String physicalState;
    
    private String storageCondition;
    
    private String emergencyMeasure;
    
    private String protectiveMeasure;
    
    private String msdsFile;
    
    private BigDecimal stockQuantity;
    
    private String unit;
    
    private String location;
    
    private String supplier;
    
    private Integer status;
    
    private Long createBy;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    // 非数据库字段
    @TableField(exist = false)
    private String categoryName;
}
