package com.hazmat.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hazmat.common.PageResult;
import com.hazmat.common.Result;
import com.hazmat.entity.HazmatCategory;
import com.hazmat.entity.HazmatInfo;
import com.hazmat.mapper.HazmatCategoryMapper;
import com.hazmat.mapper.HazmatInfoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * 危化品管理服务
 */
@Service
@RequiredArgsConstructor
public class HazmatService {

    private final HazmatCategoryMapper categoryMapper;
    private final HazmatInfoMapper infoMapper;

    // ==================== 危化品类别管理 ====================

    /**
     * 获取所有类别列表
     */
    public Result<List<HazmatCategory>> getAllCategories() {
        List<HazmatCategory> list = categoryMapper.selectList(
                new LambdaQueryWrapper<HazmatCategory>()
                        .eq(HazmatCategory::getStatus, 1)
                        .orderByAsc(HazmatCategory::getSortOrder)
        );
        return Result.success(list);
    }

    /**
     * 分页查询类别
     */
    public Result<PageResult<HazmatCategory>> getCategoryPage(Integer pageNum, Integer pageSize, String name) {
        Page<HazmatCategory> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<HazmatCategory> wrapper = new LambdaQueryWrapper<>();
        
        if (StringUtils.hasText(name)) {
            wrapper.like(HazmatCategory::getName, name);
        }
        wrapper.orderByAsc(HazmatCategory::getSortOrder);
        
        IPage<HazmatCategory> result = categoryMapper.selectPage(page, wrapper);
        return Result.success(PageResult.of(result));
    }

    /**
     * 获取类别详情
     */
    public Result<HazmatCategory> getCategoryById(Long id) {
        return Result.success(categoryMapper.selectById(id));
    }

    /**
     * 添加类别
     */
    public Result<String> addCategory(HazmatCategory category) {
        category.setStatus(1);
        categoryMapper.insert(category);
        return Result.success("添加成功");
    }

    /**
     * 更新类别
     */
    public Result<String> updateCategory(HazmatCategory category) {
        HazmatCategory existing = categoryMapper.selectById(category.getId());
        if (existing == null) {
            return Result.error("类别不存在");
        }
        categoryMapper.updateById(category);
        return Result.success("更新成功");
    }

    /**
     * 删除类别
     */
    public Result<String> deleteCategory(Long id) {
        // 检查是否有危化品使用该类别
        Long count = infoMapper.selectCount(
                new LambdaQueryWrapper<HazmatInfo>().eq(HazmatInfo::getCategoryId, id)
        );
        if (count > 0) {
            return Result.error("该类别下存在危化品，无法删除");
        }
        categoryMapper.deleteById(id);
        return Result.success("删除成功");
    }

    // ==================== 危化品信息管理 ====================

    /**
     * 分页查询危化品
     */
    public Result<PageResult<HazmatInfo>> getHazmatPage(Integer pageNum, Integer pageSize, 
                                                         String name, Long categoryId, String dangerType) {
        Page<HazmatInfo> page = new Page<>(pageNum, pageSize);
        IPage<HazmatInfo> result = infoMapper.selectPageWithCategory(page, name, categoryId, dangerType);
        return Result.success(PageResult.of(result));
    }

    /**
     * 获取危化品详情
     */
    public Result<HazmatInfo> getHazmatById(Long id) {
        HazmatInfo info = infoMapper.selectById(id);
        if (info != null && info.getCategoryId() != null) {
            HazmatCategory category = categoryMapper.selectById(info.getCategoryId());
            if (category != null) {
                info.setCategoryName(category.getName());
            }
        }
        return Result.success(info);
    }

    /**
     * 添加危化品
     */
    public Result<String> addHazmat(HazmatInfo info) {
        info.setStatus(1);
        infoMapper.insert(info);
        return Result.success("添加成功");
    }

    /**
     * 更新危化品
     */
    public Result<String> updateHazmat(HazmatInfo info) {
        HazmatInfo existing = infoMapper.selectById(info.getId());
        if (existing == null) {
            return Result.error("危化品不存在");
        }
        infoMapper.updateById(info);
        return Result.success("更新成功");
    }

    /**
     * 删除危化品
     */
    public Result<String> deleteHazmat(Long id) {
        infoMapper.deleteById(id);
        return Result.success("删除成功");
    }

    /**
     * 获取所有危化品列表（不分页）
     */
    public Result<List<HazmatInfo>> getAllHazmats() {
        List<HazmatInfo> list = infoMapper.selectList(
                new LambdaQueryWrapper<HazmatInfo>()
                        .eq(HazmatInfo::getStatus, 1)
                        .orderByDesc(HazmatInfo::getCreateTime)
        );
        return Result.success(list);
    }

    /**
     * 统计危化品数量
     */
    public Result<Long> countHazmats() {
        Long count = infoMapper.selectCount(
                new LambdaQueryWrapper<HazmatInfo>().eq(HazmatInfo::getStatus, 1)
        );
        return Result.success(count);
    }

    /**
     * 按类别统计危化品数量
     */
    public Result<List<HazmatCategory>> countByCategory() {
        List<HazmatCategory> categories = categoryMapper.selectList(
                new LambdaQueryWrapper<HazmatCategory>().eq(HazmatCategory::getStatus, 1)
        );
        
        for (HazmatCategory category : categories) {
            Long count = infoMapper.selectCount(
                    new LambdaQueryWrapper<HazmatInfo>()
                            .eq(HazmatInfo::getCategoryId, category.getId())
                            .eq(HazmatInfo::getStatus, 1)
            );
            category.setDescription(count.toString()); // 临时使用description字段存储数量
        }
        
        return Result.success(categories);
    }
}
