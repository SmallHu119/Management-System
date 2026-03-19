package com.hazmat.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hazmat.common.Result;
import com.hazmat.common.UserRole;
import com.hazmat.dto.LoginRequest;
import com.hazmat.dto.LoginResponse;
import com.hazmat.dto.PasswordChangeRequest;
import com.hazmat.dto.RegisterRequest;
import com.hazmat.entity.SafetyAdmin;
import com.hazmat.entity.SysAdmin;
import com.hazmat.entity.SysUser;
import com.hazmat.mapper.SafetyAdminMapper;
import com.hazmat.mapper.SysAdminMapper;
import com.hazmat.mapper.SysUserMapper;
import com.hazmat.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

/**
 * 认证服务
 */
@Service
@RequiredArgsConstructor
public class AuthService {

    private final SysUserMapper sysUserMapper;
    private final SafetyAdminMapper safetyAdminMapper;
    private final SysAdminMapper sysAdminMapper;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    /**
     * 用户登录
     */
    public Result<LoginResponse> login(LoginRequest request) {
        String userType = request.getUserType();
        String username = request.getUsername();
        String password = request.getPassword();

        switch (userType) {
            case "user":
                return loginAsUser(username, password);
            case "safety_admin":
                return loginAsSafetyAdmin(username, password);
            case "admin":
                return loginAsAdmin(username, password);
            default:
                return Result.error("无效的用户类型");
        }
    }

    /**
     * 普通员工登录
     */
    private Result<LoginResponse> loginAsUser(String username, String password) {
        SysUser user = sysUserMapper.selectOne(
                new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, username)
        );
        
        if (user == null) {
            return Result.error("用户名或密码错误");
        }
        
        if (user.getStatus() != 1) {
            return Result.error("账号已被禁用");
        }
        
        if (!passwordEncoder.matches(password, user.getPassword())) {
            return Result.error("用户名或密码错误");
        }
        
        String token = jwtUtil.generateToken(user.getId(), user.getUsername(), UserRole.USER.getCode());
        LoginResponse response = new LoginResponse(
                user.getId(),
                user.getUsername(),
                user.getRealName(),
                UserRole.USER.getCode(),
                token,
                user.getAvatar()
        );
        
        return Result.success("登录成功", response);
    }

    /**
     * 安全管理员登录
     */
    private Result<LoginResponse> loginAsSafetyAdmin(String username, String password) {
        SafetyAdmin admin = safetyAdminMapper.selectOne(
                new LambdaQueryWrapper<SafetyAdmin>().eq(SafetyAdmin::getUsername, username)
        );
        
        if (admin == null) {
            return Result.error("用户名或密码错误");
        }
        
        if (admin.getStatus() != 1) {
            return Result.error("账号已被禁用");
        }
        
        if (!passwordEncoder.matches(password, admin.getPassword())) {
            return Result.error("用户名或密码错误");
        }
        
        String token = jwtUtil.generateToken(admin.getId(), admin.getUsername(), UserRole.SAFETY_ADMIN.getCode());
        LoginResponse response = new LoginResponse(
                admin.getId(),
                admin.getUsername(),
                admin.getRealName(),
                UserRole.SAFETY_ADMIN.getCode(),
                token,
                admin.getAvatar()
        );
        
        return Result.success("登录成功", response);
    }

    /**
     * 系统管理员登录
     */
    private Result<LoginResponse> loginAsAdmin(String username, String password) {
        SysAdmin admin = sysAdminMapper.selectOne(
                new LambdaQueryWrapper<SysAdmin>().eq(SysAdmin::getUsername, username)
        );
        
        if (admin == null) {
            return Result.error("用户名或密码错误");
        }
        
        if (admin.getStatus() != 1) {
            return Result.error("账号已被禁用");
        }
        
        if (!passwordEncoder.matches(password, admin.getPassword())) {
            return Result.error("用户名或密码错误");
        }
        
        String token = jwtUtil.generateToken(admin.getId(), admin.getUsername(), UserRole.ADMIN.getCode());
        LoginResponse response = new LoginResponse(
                admin.getId(),
                admin.getUsername(),
                admin.getRealName(),
                UserRole.ADMIN.getCode(),
                token,
                admin.getAvatar()
        );
        
        return Result.success("登录成功", response);
    }

    /**
     * 普通员工注册
     */
    public Result<String> register(RegisterRequest request) {
        // 检查用户名是否已存在
        Long count = sysUserMapper.selectCount(
                new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, request.getUsername())
        );
        
        if (count > 0) {
            return Result.error("用户名已存在");
        }
        
        // 创建新用户
        SysUser user = new SysUser();
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRealName(request.getRealName());
        user.setPhone(request.getPhone());
        user.setEmail(request.getEmail());
        user.setDepartment(request.getDepartment());
        user.setStatus(1);
        
        sysUserMapper.insert(user);
        
        return Result.success("注册成功");
    }

    /**
     * 修改密码（普通员工）
     */
    public Result<String> changeUserPassword(Long userId, PasswordChangeRequest request) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            return Result.error("用户不存在");
        }
        
        if (!passwordEncoder.matches(request.getOldPassword(), user.getPassword())) {
            return Result.error("原密码错误");
        }
        
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        sysUserMapper.updateById(user);
        
        return Result.success("密码修改成功");
    }

    /**
     * 修改密码（安全管理员）
     */
    public Result<String> changeSafetyAdminPassword(Long userId, PasswordChangeRequest request) {
        SafetyAdmin admin = safetyAdminMapper.selectById(userId);
        if (admin == null) {
            return Result.error("用户不存在");
        }
        
        if (!passwordEncoder.matches(request.getOldPassword(), admin.getPassword())) {
            return Result.error("原密码错误");
        }
        
        admin.setPassword(passwordEncoder.encode(request.getNewPassword()));
        safetyAdminMapper.updateById(admin);
        
        return Result.success("密码修改成功");
    }

    /**
     * 修改密码（系统管理员）
     */
    public Result<String> changeAdminPassword(Long userId, PasswordChangeRequest request) {
        SysAdmin admin = sysAdminMapper.selectById(userId);
        if (admin == null) {
            return Result.error("用户不存在");
        }
        
        if (!passwordEncoder.matches(request.getOldPassword(), admin.getPassword())) {
            return Result.error("原密码错误");
        }
        
        admin.setPassword(passwordEncoder.encode(request.getNewPassword()));
        sysAdminMapper.updateById(admin);
        
        return Result.success("密码修改成功");
    }
}
