package com.hazmat.common;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;

/**
 * 分页结果
 */
@Data
public class PageResult<T> {
    
    private List<T> records;
    
    @JsonProperty("list")
    public List<T> getList() {
        return records;
    }

    private Long total;
    private Long size;
    private Long current;
    private Long pages;

    public PageResult() {}

    public PageResult(IPage<T> page) {
        this.records = page.getRecords();
        this.total = page.getTotal();
        this.size = page.getSize();
        this.current = page.getCurrent();
        this.pages = page.getPages();
    }

    public static <T> PageResult<T> of(IPage<T> page) {
        return new PageResult<>(page);
    }
}
