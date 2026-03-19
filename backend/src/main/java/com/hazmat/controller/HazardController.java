package com.hazmat.controller;

import com.hazmat.common.PageResult;
import com.hazmat.common.Result;
import com.hazmat.entity.HazardReport;
import com.hazmat.service.HazardService;
import com.hazmat.util.JwtUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 隐患上报控制器
 */
@Tag(name = "隐患管理", description = "隐患上报和处理接口")
@RestController
@RequestMapping("/hazard")
@RequiredArgsConstructor
public class HazardController {

    private final HazardService hazardService;
    private final JwtUtil jwtUtil;

    @Operation(summary = "分页查询隐患记录")
    @GetMapping("/list")
    public Result<PageResult<HazardReport>> getHazardPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String hazardLevel) {
        return hazardService.getHazardPage(pageNum, pageSize, title, status, hazardLevel);
    }

    @Operation(summary = "获取我的隐患上报记录")
    @GetMapping("/my")
    public Result<PageResult<HazardReport>> getMyHazards(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            HttpServletRequest request) {
        String token = getTokenFromRequest(request);
        if (token == null) {
            return Result.unauthorized("请先登录");
        }
        Long userId = jwtUtil.getUserIdFromToken(token);
        return hazardService.getMyHazards(userId, pageNum, pageSize);
    }

    @Operation(summary = "获取待处理的隐患列表")
    @GetMapping("/pending")
    public Result<List<HazardReport>> getPendingHazards() {
        return hazardService.getPendingHazards();
    }

    @Operation(summary = "获取隐患详情")
    @GetMapping("/{id}")
    public Result<HazardReport> getHazardById(@PathVariable Long id) {
        return hazardService.getHazardById(id);
    }

    @Operation(summary = "上报隐患")
    @PostMapping
    public Result<String> reportHazard(@RequestBody HazardReport report, HttpServletRequest request) {
        String token = getTokenFromRequest(request);
        if (token != null) {
            Long userId = jwtUtil.getUserIdFromToken(token);
            String username = jwtUtil.getUsernameFromToken(token);
            report.setReporterId(userId);
            report.setReporterName(username);
        }
        return hazardService.reportHazard(report);
    }

    @Operation(summary = "更新隐患信息")
    @PutMapping
    public Result<String> updateHazard(@RequestBody HazardReport report) {
        return hazardService.updateHazard(report);
    }

    @Operation(summary = "删除隐患记录")
    @DeleteMapping("/{id}")
    public Result<String> deleteHazard(@PathVariable Long id) {
        return hazardService.deleteHazard(id);
    }

    @Operation(summary = "处理隐患")
    @PostMapping("/{id}/handle")
    public Result<String> handleHazard(
            @PathVariable Long id,
            @RequestParam String handleResult,
            @RequestParam Integer status,
            HttpServletRequest request) {
        String token = getTokenFromRequest(request);
        Long handlerId = null;
        String handlerName = null;
        if (token != null) {
            handlerId = jwtUtil.getUserIdFromToken(token);
            handlerName = jwtUtil.getUsernameFromToken(token);
        }
        return hazardService.handleHazard(id, handlerId, handlerName, handleResult, status);
    }

    // ==================== 统计接口 ====================

    @Operation(summary = "统计隐患数量")
    @GetMapping("/count")
    public Result<Long> countHazards() {
        return hazardService.countHazards();
    }

    @Operation(summary = "统计待处理隐患数量")
    @GetMapping("/count/pending")
    public Result<Long> countPendingHazards() {
        return hazardService.countPendingHazards();
    }

    /**
     * 从请求头中获取Token
     */
    private String getTokenFromRequest(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}
