package com.hazmat.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 检查计划实体类
 */
@Data
@TableName("check_plan")
public class CheckPlan {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String title;
    
    private String description;
    
    private String checkType;
    
    private LocalDate planDate;
    
    private String department;
    
    private Integer status;
    
    private Long createBy;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
