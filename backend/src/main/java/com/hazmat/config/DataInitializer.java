package com.hazmat.config;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hazmat.entity.SysAdmin;
import com.hazmat.mapper.SysAdminMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

/**
 * 数据初始化
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final SysAdminMapper sysAdminMapper;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        // 检查是否存在系统管理员
        Long count = sysAdminMapper.selectCount(new LambdaQueryWrapper<>());
        if (count == 0) {
            // 创建默认管理员
            SysAdmin admin = new SysAdmin();
            admin.setUsername("admin");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setRealName("系统管理员");
            admin.setPhone("13800000000");
            admin.setEmail("admin@example.com");
            admin.setStatus(1);
            sysAdminMapper.insert(admin);
            log.info("已创建默认系统管理员账号：admin / admin123");
        }
    }
}
