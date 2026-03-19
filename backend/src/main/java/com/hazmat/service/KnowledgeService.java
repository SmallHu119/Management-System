package com.hazmat.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hazmat.common.PageResult;
import com.hazmat.common.Result;
import com.hazmat.entity.SafetyKnowledge;
import com.hazmat.mapper.SafetyKnowledgeMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * 安全知识服务
 */
@Service
@RequiredArgsConstructor
public class KnowledgeService {

    private final SafetyKnowledgeMapper knowledgeMapper;

    /**
     * 分页查询安全知识
     */
    public Result<PageResult<SafetyKnowledge>> getKnowledgePage(Integer pageNum, Integer pageSize,
                                                                 String title, String category) {
        Page<SafetyKnowledge> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<SafetyKnowledge> wrapper = new LambdaQueryWrapper<>();
        
        if (StringUtils.hasText(title)) {
            wrapper.like(SafetyKnowledge::getTitle, title);
        }
        if (StringUtils.hasText(category)) {
            wrapper.eq(SafetyKnowledge::getCategory, category);
        }
        wrapper.orderByDesc(SafetyKnowledge::getCreateTime);
        
        IPage<SafetyKnowledge> result = knowledgeMapper.selectPage(page, wrapper);
        return Result.success(PageResult.of(result));
    }

    /**
     * 获取已发布的安全知识（供员工学习）
     */
    public Result<PageResult<SafetyKnowledge>> getPublishedKnowledge(Integer pageNum, Integer pageSize,
                                                                      String title, String category) {
        Page<SafetyKnowledge> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<SafetyKnowledge> wrapper = new LambdaQueryWrapper<>();
        
        wrapper.eq(SafetyKnowledge::getStatus, 1); // 已发布
        if (StringUtils.hasText(title)) {
            wrapper.like(SafetyKnowledge::getTitle, title);
        }
        if (StringUtils.hasText(category)) {
            wrapper.eq(SafetyKnowledge::getCategory, category);
        }
        wrapper.orderByDesc(SafetyKnowledge::getCreateTime);
        
        IPage<SafetyKnowledge> result = knowledgeMapper.selectPage(page, wrapper);
        return Result.success(PageResult.of(result));
    }

    /**
     * 获取安全知识详情
     */
    public Result<SafetyKnowledge> getKnowledgeById(Long id) {
        SafetyKnowledge knowledge = knowledgeMapper.selectById(id);
        if (knowledge != null) {
            // 增加浏览次数
            knowledge.setViewCount(knowledge.getViewCount() + 1);
            knowledgeMapper.updateById(knowledge);
        }
        return Result.success(knowledge);
    }

    /**
     * 添加安全知识
     */
    public Result<String> addKnowledge(SafetyKnowledge knowledge) {
        knowledge.setViewCount(0);
        knowledgeMapper.insert(knowledge);
        return Result.success("添加成功");
    }

    /**
     * 更新安全知识
     */
    public Result<String> updateKnowledge(SafetyKnowledge knowledge) {
        SafetyKnowledge existing = knowledgeMapper.selectById(knowledge.getId());
        if (existing == null) {
            return Result.error("安全知识不存在");
        }
        knowledgeMapper.updateById(knowledge);
        return Result.success("更新成功");
    }

    /**
     * 删除安全知识
     */
    public Result<String> deleteKnowledge(Long id) {
        knowledgeMapper.deleteById(id);
        return Result.success("删除成功");
    }

    /**
     * 发布/取消发布安全知识
     */
    public Result<String> publishKnowledge(Long id, Integer status) {
        SafetyKnowledge knowledge = knowledgeMapper.selectById(id);
        if (knowledge == null) {
            return Result.error("安全知识不存在");
        }
        knowledge.setStatus(status);
        knowledgeMapper.updateById(knowledge);
        return Result.success(status == 1 ? "发布成功" : "已取消发布");
    }

    /**
     * 获取热门安全知识
     */
    public Result<List<SafetyKnowledge>> getHotKnowledge(Integer limit) {
        List<SafetyKnowledge> list = knowledgeMapper.selectList(
                new LambdaQueryWrapper<SafetyKnowledge>()
                        .eq(SafetyKnowledge::getStatus, 1)
                        .orderByDesc(SafetyKnowledge::getViewCount)
                        .last("LIMIT " + limit)
        );
        return Result.success(list);
    }

    /**
     * 获取最新安全知识
     */
    public Result<List<SafetyKnowledge>> getLatestKnowledge(Integer limit) {
        List<SafetyKnowledge> list = knowledgeMapper.selectList(
                new LambdaQueryWrapper<SafetyKnowledge>()
                        .eq(SafetyKnowledge::getStatus, 1)
                        .orderByDesc(SafetyKnowledge::getCreateTime)
                        .last("LIMIT " + limit)
        );
        return Result.success(list);
    }

    /**
     * 统计安全知识数量
     */
    public Result<Long> countKnowledge() {
        return Result.success(knowledgeMapper.selectCount(
                new LambdaQueryWrapper<SafetyKnowledge>().eq(SafetyKnowledge::getStatus, 1)
        ));
    }
}
