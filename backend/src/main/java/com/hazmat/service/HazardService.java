package com.hazmat.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hazmat.common.PageResult;
import com.hazmat.common.Result;
import com.hazmat.entity.HazardReport;
import com.hazmat.mapper.HazardReportMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 隐患上报服务
 */
@Service
@RequiredArgsConstructor
public class HazardService {

    private final HazardReportMapper hazardReportMapper;

    /**
     * 分页查询隐患记录
     */
    public Result<PageResult<HazardReport>> getHazardPage(Integer pageNum, Integer pageSize,
                                                          String title, Integer status, String hazardLevel) {
        Page<HazardReport> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<HazardReport> wrapper = new LambdaQueryWrapper<>();
        
        if (StringUtils.hasText(title)) {
            wrapper.like(HazardReport::getTitle, title);
        }
        if (status != null) {
            wrapper.eq(HazardReport::getStatus, status);
        }
        if (StringUtils.hasText(hazardLevel)) {
            wrapper.eq(HazardReport::getHazardLevel, hazardLevel);
        }
        wrapper.orderByDesc(HazardReport::getReportTime);
        
        IPage<HazardReport> result = hazardReportMapper.selectPage(page, wrapper);
        return Result.success(PageResult.of(result));
    }

    /**
     * 获取用户上报的隐患记录
     */
    public Result<PageResult<HazardReport>> getMyHazards(Long userId, Integer pageNum, Integer pageSize) {
        Page<HazardReport> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<HazardReport> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(HazardReport::getReporterId, userId);
        wrapper.orderByDesc(HazardReport::getReportTime);
        
        IPage<HazardReport> result = hazardReportMapper.selectPage(page, wrapper);
        return Result.success(PageResult.of(result));
    }

    /**
     * 获取隐患详情
     */
    public Result<HazardReport> getHazardById(Long id) {
        return Result.success(hazardReportMapper.selectById(id));
    }

    /**
     * 上报隐患
     */
    public Result<String> reportHazard(HazardReport report) {
        report.setStatus(0); // 待处理
        report.setReportTime(LocalDateTime.now());
        hazardReportMapper.insert(report);
        return Result.success("上报成功");
    }

    /**
     * 更新隐患信息
     */
    public Result<String> updateHazard(HazardReport report) {
        HazardReport existing = hazardReportMapper.selectById(report.getId());
        if (existing == null) {
            return Result.error("隐患记录不存在");
        }
        hazardReportMapper.updateById(report);
        return Result.success("更新成功");
    }

    /**
     * 删除隐患记录
     */
    public Result<String> deleteHazard(Long id) {
        hazardReportMapper.deleteById(id);
        return Result.success("删除成功");
    }

    /**
     * 处理隐患
     */
    public Result<String> handleHazard(Long id, Long handlerId, String handlerName, String handleResult, Integer status) {
        HazardReport report = hazardReportMapper.selectById(id);
        if (report == null) {
            return Result.error("隐患记录不存在");
        }
        
        report.setHandlerId(handlerId);
        report.setHandlerName(handlerName);
        report.setHandleResult(handleResult);
        report.setHandleTime(LocalDateTime.now());
        report.setStatus(status);
        
        hazardReportMapper.updateById(report);
        return Result.success("处理成功");
    }

    /**
     * 获取待处理的隐患列表
     */
    public Result<List<HazardReport>> getPendingHazards() {
        List<HazardReport> list = hazardReportMapper.selectList(
                new LambdaQueryWrapper<HazardReport>()
                        .in(HazardReport::getStatus, 0, 1)
                        .orderByDesc(HazardReport::getReportTime)
        );
        return Result.success(list);
    }

    /**
     * 统计隐患数量
     */
    public Result<Long> countHazards() {
        return Result.success(hazardReportMapper.selectCount(null));
    }

    /**
     * 统计待处理隐患数量
     */
    public Result<Long> countPendingHazards() {
        Long count = hazardReportMapper.selectCount(
                new LambdaQueryWrapper<HazardReport>().eq(HazardReport::getStatus, 0)
        );
        return Result.success(count);
    }

    /**
     * 按状态统计隐患数量
     */
    public Result<List<HazardReport>> countByStatus() {
        // 这里简化处理，实际可以使用分组查询
        return Result.success(hazardReportMapper.selectList(null));
    }
}
