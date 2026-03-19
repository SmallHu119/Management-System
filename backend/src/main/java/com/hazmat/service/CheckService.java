package com.hazmat.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hazmat.common.PageResult;
import com.hazmat.common.Result;
import com.hazmat.entity.CheckPlan;
import com.hazmat.entity.CheckRecord;
import com.hazmat.mapper.CheckPlanMapper;
import com.hazmat.mapper.CheckRecordMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * 安全检查服务
 */
@Service
@RequiredArgsConstructor
public class CheckService {

    private final CheckPlanMapper planMapper;
    private final CheckRecordMapper recordMapper;

    // ==================== 检查计划管理 ====================

    /**
     * 分页查询检查计划
     */
    public Result<PageResult<CheckPlan>> getPlanPage(Integer pageNum, Integer pageSize, 
                                                      String title, Integer status) {
        Page<CheckPlan> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<CheckPlan> wrapper = new LambdaQueryWrapper<>();
        
        if (StringUtils.hasText(title)) {
            wrapper.like(CheckPlan::getTitle, title);
        }
        if (status != null) {
            wrapper.eq(CheckPlan::getStatus, status);
        }
        wrapper.orderByDesc(CheckPlan::getCreateTime);
        
        IPage<CheckPlan> result = planMapper.selectPage(page, wrapper);
        return Result.success(PageResult.of(result));
    }

    /**
     * 获取检查计划详情
     */
    public Result<CheckPlan> getPlanById(Long id) {
        return Result.success(planMapper.selectById(id));
    }

    /**
     * 添加检查计划
     */
    public Result<String> addPlan(CheckPlan plan) {
        plan.setStatus(0); // 待执行
        planMapper.insert(plan);
        return Result.success("添加成功");
    }

    /**
     * 更新检查计划
     */
    public Result<String> updatePlan(CheckPlan plan) {
        CheckPlan existing = planMapper.selectById(plan.getId());
        if (existing == null) {
            return Result.error("检查计划不存在");
        }
        planMapper.updateById(plan);
        return Result.success("更新成功");
    }

    /**
     * 删除检查计划
     */
    public Result<String> deletePlan(Long id) {
        // 检查是否有关联的检查记录
        Long count = recordMapper.selectCount(
                new LambdaQueryWrapper<CheckRecord>().eq(CheckRecord::getPlanId, id)
        );
        if (count > 0) {
            return Result.error("该计划下存在检查记录，无法删除");
        }
        planMapper.deleteById(id);
        return Result.success("删除成功");
    }

    /**
     * 更新计划状态
     */
    public Result<String> updatePlanStatus(Long id, Integer status) {
        CheckPlan plan = planMapper.selectById(id);
        if (plan == null) {
            return Result.error("检查计划不存在");
        }
        plan.setStatus(status);
        planMapper.updateById(plan);
        return Result.success("状态更新成功");
    }

    // ==================== 检查记录管理 ====================

    /**
     * 分页查询检查记录
     */
    public Result<PageResult<CheckRecord>> getRecordPage(Integer pageNum, Integer pageSize, 
                                                          String title, Long planId, Integer status) {
        Page<CheckRecord> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<CheckRecord> wrapper = new LambdaQueryWrapper<>();
        
        if (StringUtils.hasText(title)) {
            wrapper.like(CheckRecord::getTitle, title);
        }
        if (planId != null) {
            wrapper.eq(CheckRecord::getPlanId, planId);
        }
        if (status != null) {
            wrapper.eq(CheckRecord::getStatus, status);
        }
        wrapper.orderByDesc(CheckRecord::getCreateTime);
        
        IPage<CheckRecord> result = recordMapper.selectPage(page, wrapper);
        return Result.success(PageResult.of(result));
    }

    /**
     * 获取检查记录详情
     */
    public Result<CheckRecord> getRecordById(Long id) {
        return Result.success(recordMapper.selectById(id));
    }

    /**
     * 添加检查记录
     */
    public Result<String> addRecord(CheckRecord record) {
        record.setStatus(0); // 待审核
        recordMapper.insert(record);
        
        // 更新计划状态为进行中
        if (record.getPlanId() != null) {
            CheckPlan plan = planMapper.selectById(record.getPlanId());
            if (plan != null && plan.getStatus() == 0) {
                plan.setStatus(1); // 进行中
                planMapper.updateById(plan);
            }
        }
        
        return Result.success("添加成功");
    }

    /**
     * 更新检查记录
     */
    public Result<String> updateRecord(CheckRecord record) {
        CheckRecord existing = recordMapper.selectById(record.getId());
        if (existing == null) {
            return Result.error("检查记录不存在");
        }
        recordMapper.updateById(record);
        return Result.success("更新成功");
    }

    /**
     * 删除检查记录
     */
    public Result<String> deleteRecord(Long id) {
        recordMapper.deleteById(id);
        return Result.success("删除成功");
    }

    /**
     * 审核检查记录
     */
    public Result<String> auditRecord(Long id, Integer status) {
        CheckRecord record = recordMapper.selectById(id);
        if (record == null) {
            return Result.error("检查记录不存在");
        }
        record.setStatus(status);
        recordMapper.updateById(record);
        return Result.success("审核完成");
    }

    /**
     * 获取待执行的检查计划列表
     */
    public Result<List<CheckPlan>> getPendingPlans() {
        List<CheckPlan> list = planMapper.selectList(
                new LambdaQueryWrapper<CheckPlan>()
                        .in(CheckPlan::getStatus, 0, 1)
                        .orderByAsc(CheckPlan::getPlanDate)
        );
        return Result.success(list);
    }

    /**
     * 统计检查计划数量
     */
    public Result<Long> countPlans() {
        return Result.success(planMapper.selectCount(null));
    }

    /**
     * 统计检查记录数量
     */
    public Result<Long> countRecords() {
        return Result.success(recordMapper.selectCount(null));
    }
}
