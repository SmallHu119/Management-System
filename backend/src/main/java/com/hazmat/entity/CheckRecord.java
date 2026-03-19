package com.hazmat.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 检查记录实体类
 */
@Data
@TableName("check_record")
public class CheckRecord {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long planId;
    
    private String title;
    
    private LocalDate checkDate;
    
    private String checkLocation;
    
    private String checkContent;
    
    private String checkResult;
    
    private String problemsFound;
    
    private String suggestions;
    
    private Long checkerId;
    
    private String checkerName;
    
    private Integer status;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
