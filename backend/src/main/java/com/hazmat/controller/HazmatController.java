package com.hazmat.controller;

import com.hazmat.common.PageResult;
import com.hazmat.common.Result;
import com.hazmat.entity.HazmatCategory;
import com.hazmat.entity.HazmatInfo;
import com.hazmat.service.HazmatService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 危化品管理控制器
 */
@Tag(name = "危化品管理", description = "危化品信息和类别管理接口")
@RestController
@RequestMapping("/hazmat")
@RequiredArgsConstructor
public class HazmatController {

    private final HazmatService hazmatService;

    // ==================== 危化品类别管理 ====================

    @Operation(summary = "获取所有类别列表")
    @GetMapping("/category/all")
    public Result<List<HazmatCategory>> getAllCategories() {
        return hazmatService.getAllCategories();
    }

    @Operation(summary = "分页查询类别")
    @GetMapping("/category/list")
    public Result<PageResult<HazmatCategory>> getCategoryPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String name) {
        return hazmatService.getCategoryPage(pageNum, pageSize, name);
    }

    @Operation(summary = "获取类别详情")
    @GetMapping("/category/{id}")
    public Result<HazmatCategory> getCategoryById(@PathVariable Long id) {
        return hazmatService.getCategoryById(id);
    }

    @Operation(summary = "添加类别")
    @PostMapping("/category")
    public Result<String> addCategory(@RequestBody HazmatCategory category) {
        return hazmatService.addCategory(category);
    }

    @Operation(summary = "更新类别")
    @PutMapping("/category")
    public Result<String> updateCategory(@RequestBody HazmatCategory category) {
        return hazmatService.updateCategory(category);
    }

    @Operation(summary = "删除类别")
    @DeleteMapping("/category/{id}")
    public Result<String> deleteCategory(@PathVariable Long id) {
        return hazmatService.deleteCategory(id);
    }

    // ==================== 危化品信息管理 ====================

    @Operation(summary = "分页查询危化品")
    @GetMapping("/info/list")
    public Result<PageResult<HazmatInfo>> getHazmatPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String dangerType) {
        return hazmatService.getHazmatPage(pageNum, pageSize, name, categoryId, dangerType);
    }

    @Operation(summary = "获取所有危化品列表")
    @GetMapping("/info/all")
    public Result<List<HazmatInfo>> getAllHazmats() {
        return hazmatService.getAllHazmats();
    }

    @Operation(summary = "获取危化品详情")
    @GetMapping("/info/{id}")
    public Result<HazmatInfo> getHazmatById(@PathVariable Long id) {
        return hazmatService.getHazmatById(id);
    }

    @Operation(summary = "添加危化品")
    @PostMapping("/info")
    public Result<String> addHazmat(@RequestBody HazmatInfo info) {
        return hazmatService.addHazmat(info);
    }

    @Operation(summary = "更新危化品")
    @PutMapping("/info")
    public Result<String> updateHazmat(@RequestBody HazmatInfo info) {
        return hazmatService.updateHazmat(info);
    }

    @Operation(summary = "删除危化品")
    @DeleteMapping("/info/{id}")
    public Result<String> deleteHazmat(@PathVariable Long id) {
        return hazmatService.deleteHazmat(id);
    }

    // ==================== 统计接口 ====================

    @Operation(summary = "统计危化品数量")
    @GetMapping("/count")
    public Result<Long> countHazmats() {
        return hazmatService.countHazmats();
    }

    @Operation(summary = "按类别统计危化品数量")
    @GetMapping("/count-by-category")
    public Result<List<HazmatCategory>> countByCategory() {
        return hazmatService.countByCategory();
    }
}
