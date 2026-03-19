package com.hazmat.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 隐患上报实体类
 */
@Data
@TableName("hazard_report")
public class HazardReport {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String title;
    
    private String description;
    
    private String location;
    
    private String hazardLevel;
    
    private String hazardType;
    
    private String images;
    
    private Long reporterId;
    
    private String reporterName;
    
    private LocalDateTime reportTime;
    
    private Integer status;
    
    private Long handlerId;
    
    private String handlerName;
    
    private LocalDateTime handleTime;
    
    private String handleResult;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
