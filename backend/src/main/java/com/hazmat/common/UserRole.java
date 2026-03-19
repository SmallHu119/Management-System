package com.hazmat.common;

/**
 * 用户角色枚举
 */
public enum UserRole {
    
    USER("user", "普通员工"),
    SAFETY_ADMIN("safety_admin", "安全管理员"),
    ADMIN("admin", "系统管理员");

    private final String code;
    private final String name;

    UserRole(String code, String name) {
        this.code = code;
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public String getName() {
        return name;
    }

    public static UserRole fromCode(String code) {
        for (UserRole role : values()) {
            if (role.getCode().equals(code)) {
                return role;
            }
        }
        return null;
    }
}
