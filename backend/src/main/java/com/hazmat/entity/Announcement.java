package com.hazmat.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 公告信息实体类
 */
@Data
@TableName("announcement")
public class Announcement {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String title;
    
    private String content;
    
    private String type;
    
    private Integer priority;
    
    private Integer status;
    
    private LocalDateTime publishTime;
    
    private Long createBy;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
