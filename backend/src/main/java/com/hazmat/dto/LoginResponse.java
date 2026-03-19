package com.hazmat.dto;

import lombok.Data;

/**
 * 登录响应DTO
 */
@Data
public class LoginResponse {
    
    private Long userId;
    private String username;
    private String realName;
    private String role;
    private String token;
    private String avatar;

    public LoginResponse() {}

    public LoginResponse(Long userId, String username, String realName, String role, String token, String avatar) {
        this.userId = userId;
        this.username = username;
        this.realName = realName;
        this.role = role;
        this.token = token;
        this.avatar = avatar;
    }
}
