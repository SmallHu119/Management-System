package com.hazmat.controller;

import com.hazmat.common.Result;
import com.hazmat.dto.LoginRequest;
import com.hazmat.dto.LoginResponse;
import com.hazmat.dto.PasswordChangeRequest;
import com.hazmat.dto.RegisterRequest;
import com.hazmat.service.AuthService;
import com.hazmat.util.JwtUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 认证控制器
 */
@Tag(name = "认证管理", description = "登录、注册、修改密码等接口")
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final JwtUtil jwtUtil;

    @Operation(summary = "用户登录")
    @PostMapping("/login")
    public Result<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        return authService.login(request);
    }

    @Operation(summary = "员工注册")
    @PostMapping("/register")
    public Result<String> register(@Valid @RequestBody RegisterRequest request) {
        return authService.register(request);
    }

    @Operation(summary = "修改密码")
    @PostMapping("/change-password")
    public Result<String> changePassword(@Valid @RequestBody PasswordChangeRequest request,
                                         HttpServletRequest httpRequest) {
        String token = getTokenFromRequest(httpRequest);
        if (token == null) {
            return Result.unauthorized("请先登录");
        }
        
        Long userId = jwtUtil.getUserIdFromToken(token);
        String role = jwtUtil.getRoleFromToken(token);
        
        if (userId == null || role == null) {
            return Result.unauthorized("无效的Token");
        }
        
        switch (role) {
            case "user":
                return authService.changeUserPassword(userId, request);
            case "safety_admin":
                return authService.changeSafetyAdminPassword(userId, request);
            case "admin":
                return authService.changeAdminPassword(userId, request);
            default:
                return Result.error("无效的用户类型");
        }
    }

    @Operation(summary = "获取当前用户信息")
    @GetMapping("/info")
    public Result<?> getCurrentUser(HttpServletRequest request) {
        String token = getTokenFromRequest(request);
        if (token == null || !jwtUtil.validateToken(token)) {
            return Result.unauthorized("请先登录");
        }
        
        Long userId = jwtUtil.getUserIdFromToken(token);
        String username = jwtUtil.getUsernameFromToken(token);
        String role = jwtUtil.getRoleFromToken(token);
        
        LoginResponse response = new LoginResponse();
        response.setUserId(userId);
        response.setUsername(username);
        response.setRole(role);
        
        return Result.success(response);
    }

    @Operation(summary = "退出登录")
    @PostMapping("/logout")
    public Result<String> logout() {
        // JWT是无状态的，客户端删除token即可
        return Result.success("退出成功");
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
