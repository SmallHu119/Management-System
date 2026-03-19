package com.hazmat.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hazmat.common.PageResult;
import com.hazmat.common.Result;
import com.hazmat.entity.SafetyAdmin;
import com.hazmat.entity.SysAdmin;
import com.hazmat.entity.SysUser;
import com.hazmat.mapper.SafetyAdminMapper;
import com.hazmat.mapper.SysAdminMapper;
import com.hazmat.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

/**
 * 用户管理服务
 */
@Service
@RequiredArgsConstructor
public class UserService {

    private final SysUserMapper sysUserMapper;
    private final SafetyAdminMapper safetyAdminMapper;
    private final SysAdminMapper sysAdminMapper;
    private final PasswordEncoder passwordEncoder;

    // ==================== 普通员工管理 ====================

    /**
     * 分页查询普通员工
     */
    public Result<PageResult<SysUser>> getUserPage(Integer pageNum, Integer pageSize, String username, String realName) {
        Page<SysUser> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<SysUser> wrapper = new LambdaQueryWrapper<>();
        
        if (StringUtils.hasText(username)) {
            wrapper.like(SysUser::getUsername, username);
        }
        if (StringUtils.hasText(realName)) {
            wrapper.like(SysUser::getRealName, realName);
        }
        wrapper.orderByDesc(SysUser::getCreateTime);
        
        IPage<SysUser> result = sysUserMapper.selectPage(page, wrapper);
        // 清除密码信息
        result.getRecords().forEach(u -> u.setPassword(null));
        
        return Result.success(PageResult.of(result));
    }

    /**
     * 获取普通员工详情
     */
    public Result<SysUser> getUserById(Long id) {
        SysUser user = sysUserMapper.selectById(id);
        if (user != null) {
            user.setPassword(null);
        }
        return Result.success(user);
    }

    /**
     * 更新普通员工信息
     */
    public Result<String> updateUser(SysUser user) {
        SysUser existing = sysUserMapper.selectById(user.getId());
        if (existing == null) {
            return Result.error("用户不存在");
        }
        
        // 不允许通过此接口修改密码
        user.setPassword(null);
        sysUserMapper.updateById(user);
        
        return Result.success("更新成功");
    }

    /**
     * 删除普通员工
     */
    public Result<String> deleteUser(Long id) {
        sysUserMapper.deleteById(id);
        return Result.success("删除成功");
    }

    /**
     * 修改员工状态
     */
    public Result<String> updateUserStatus(Long id, Integer status) {
        SysUser user = sysUserMapper.selectById(id);
        if (user == null) {
            return Result.error("用户不存在");
        }
        user.setStatus(status);
        sysUserMapper.updateById(user);
        return Result.success("状态更新成功");
    }

    // ==================== 安全管理员管理 ====================

    /**
     * 分页查询安全管理员
     */
    public Result<PageResult<SafetyAdmin>> getSafetyAdminPage(Integer pageNum, Integer pageSize, String username, String realName) {
        Page<SafetyAdmin> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<SafetyAdmin> wrapper = new LambdaQueryWrapper<>();
        
        if (StringUtils.hasText(username)) {
            wrapper.like(SafetyAdmin::getUsername, username);
        }
        if (StringUtils.hasText(realName)) {
            wrapper.like(SafetyAdmin::getRealName, realName);
        }
        wrapper.orderByDesc(SafetyAdmin::getCreateTime);
        
        IPage<SafetyAdmin> result = safetyAdminMapper.selectPage(page, wrapper);
        result.getRecords().forEach(u -> u.setPassword(null));
        
        return Result.success(PageResult.of(result));
    }

    /**
     * 获取安全管理员详情
     */
    public Result<SafetyAdmin> getSafetyAdminById(Long id) {
        SafetyAdmin admin = safetyAdminMapper.selectById(id);
        if (admin != null) {
            admin.setPassword(null);
        }
        return Result.success(admin);
    }

    /**
     * 添加安全管理员
     */
    public Result<String> addSafetyAdmin(SafetyAdmin admin) {
        // 检查用户名是否已存在
        Long count = safetyAdminMapper.selectCount(
                new LambdaQueryWrapper<SafetyAdmin>().eq(SafetyAdmin::getUsername, admin.getUsername())
        );
        if (count > 0) {
            return Result.error("用户名已存在");
        }
        
        admin.setPassword(passwordEncoder.encode(admin.getPassword()));
        admin.setStatus(1);
        safetyAdminMapper.insert(admin);
        
        return Result.success("添加成功");
    }

    /**
     * 更新安全管理员信息
     */
    public Result<String> updateSafetyAdmin(SafetyAdmin admin) {
        SafetyAdmin existing = safetyAdminMapper.selectById(admin.getId());
        if (existing == null) {
            return Result.error("安全管理员不存在");
        }
        
        // 不允许通过此接口修改密码
        admin.setPassword(null);
        safetyAdminMapper.updateById(admin);
        
        return Result.success("更新成功");
    }

    /**
     * 删除安全管理员
     */
    public Result<String> deleteSafetyAdmin(Long id) {
        safetyAdminMapper.deleteById(id);
        return Result.success("删除成功");
    }

    /**
     * 修改安全管理员状态
     */
    public Result<String> updateSafetyAdminStatus(Long id, Integer status) {
        SafetyAdmin admin = safetyAdminMapper.selectById(id);
        if (admin == null) {
            return Result.error("安全管理员不存在");
        }
        admin.setStatus(status);
        safetyAdminMapper.updateById(admin);
        return Result.success("状态更新成功");
    }

    // ==================== 系统管理员管理 ====================

    /**
     * 获取系统管理员详情
     */
    public Result<SysAdmin> getAdminById(Long id) {
        SysAdmin admin = sysAdminMapper.selectById(id);
        if (admin != null) {
            admin.setPassword(null);
        }
        return Result.success(admin);
    }

    /**
     * 更新系统管理员信息
     */
    public Result<String> updateAdmin(SysAdmin admin) {
        SysAdmin existing = sysAdminMapper.selectById(admin.getId());
        if (existing == null) {
            return Result.error("管理员不存在");
        }
        
        // 不允许通过此接口修改密码
        admin.setPassword(null);
        sysAdminMapper.updateById(admin);
        
        return Result.success("更新成功");
    }

    /**
     * 重置用户密码
     */
    public Result<String> resetUserPassword(Long id, String newPassword) {
        SysUser user = sysUserMapper.selectById(id);
        if (user == null) {
            return Result.error("用户不存在");
        }
        user.setPassword(passwordEncoder.encode(newPassword));
        sysUserMapper.updateById(user);
        return Result.success("密码重置成功");
    }

    /**
     * 重置安全管理员密码
     */
    public Result<String> resetSafetyAdminPassword(Long id, String newPassword) {
        SafetyAdmin admin = safetyAdminMapper.selectById(id);
        if (admin == null) {
            return Result.error("安全管理员不存在");
        }
        admin.setPassword(passwordEncoder.encode(newPassword));
        safetyAdminMapper.updateById(admin);
        return Result.success("密码重置成功");
    }
}
