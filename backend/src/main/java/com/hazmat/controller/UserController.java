package com.hazmat.controller;

import com.hazmat.common.PageResult;
import com.hazmat.common.Result;
import com.hazmat.entity.SafetyAdmin;
import com.hazmat.entity.SysAdmin;
import com.hazmat.entity.SysUser;
import com.hazmat.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 用户管理控制器
 */
@Tag(name = "用户管理", description = "用户增删改查接口")
@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    // ==================== 普通员工管理 ====================

    @Operation(summary = "分页查询普通员工")
    @GetMapping("/list")
    public Result<PageResult<SysUser>> getUserPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String realName) {
        return userService.getUserPage(pageNum, pageSize, username, realName);
    }

    @Operation(summary = "获取普通员工详情")
    @GetMapping("/{id}")
    public Result<SysUser> getUserById(@PathVariable Long id) {
        return userService.getUserById(id);
    }

    @Operation(summary = "更新普通员工信息")
    @PutMapping
    public Result<String> updateUser(@RequestBody SysUser user) {
        return userService.updateUser(user);
    }

    @Operation(summary = "删除普通员工")
    @DeleteMapping("/{id}")
    public Result<String> deleteUser(@PathVariable Long id) {
        return userService.deleteUser(id);
    }

    @Operation(summary = "修改员工状态")
    @PutMapping("/{id}/status/{status}")
    public Result<String> updateUserStatus(@PathVariable Long id, @PathVariable Integer status) {
        return userService.updateUserStatus(id, status);
    }

    @Operation(summary = "重置员工密码")
    @PutMapping("/{id}/reset-password")
    public Result<String> resetUserPassword(@PathVariable Long id, 
                                            @RequestParam(defaultValue = "123456") String newPassword) {
        return userService.resetUserPassword(id, newPassword);
    }

    // ==================== 安全管理员管理 ====================

    @Operation(summary = "分页查询安全管理员")
    @GetMapping("/safety-admin/list")
    public Result<PageResult<SafetyAdmin>> getSafetyAdminPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String realName) {
        return userService.getSafetyAdminPage(pageNum, pageSize, username, realName);
    }

    @Operation(summary = "获取安全管理员详情")
    @GetMapping("/safety-admin/{id}")
    public Result<SafetyAdmin> getSafetyAdminById(@PathVariable Long id) {
        return userService.getSafetyAdminById(id);
    }

    @Operation(summary = "添加安全管理员")
    @PostMapping("/safety-admin")
    public Result<String> addSafetyAdmin(@RequestBody SafetyAdmin admin) {
        return userService.addSafetyAdmin(admin);
    }

    @Operation(summary = "更新安全管理员信息")
    @PutMapping("/safety-admin")
    public Result<String> updateSafetyAdmin(@RequestBody SafetyAdmin admin) {
        return userService.updateSafetyAdmin(admin);
    }

    @Operation(summary = "删除安全管理员")
    @DeleteMapping("/safety-admin/{id}")
    public Result<String> deleteSafetyAdmin(@PathVariable Long id) {
        return userService.deleteSafetyAdmin(id);
    }

    @Operation(summary = "修改安全管理员状态")
    @PutMapping("/safety-admin/{id}/status/{status}")
    public Result<String> updateSafetyAdminStatus(@PathVariable Long id, @PathVariable Integer status) {
        return userService.updateSafetyAdminStatus(id, status);
    }

    @Operation(summary = "重置安全管理员密码")
    @PutMapping("/safety-admin/{id}/reset-password")
    public Result<String> resetSafetyAdminPassword(@PathVariable Long id,
                                                    @RequestParam(defaultValue = "123456") String newPassword) {
        return userService.resetSafetyAdminPassword(id, newPassword);
    }

    // ==================== 系统管理员管理 ====================

    @Operation(summary = "获取系统管理员详情")
    @GetMapping("/admin/{id}")
    public Result<SysAdmin> getAdminById(@PathVariable Long id) {
        return userService.getAdminById(id);
    }

    @Operation(summary = "更新系统管理员信息")
    @PutMapping("/admin")
    public Result<String> updateAdmin(@RequestBody SysAdmin admin) {
        return userService.updateAdmin(admin);
    }
}
