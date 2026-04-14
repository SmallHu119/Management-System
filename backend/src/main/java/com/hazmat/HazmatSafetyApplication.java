package com.hazmat;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 企业危化品安全管理系统启动类
 */
@SpringBootApplication
@MapperScan("com.hazmat.mapper")
public class HazmatSafetyApplication {

    public static void main(String[] args) {
        SpringApplication.run(HazmatSafetyApplication.class, args);
        System.out.println("=============================================================");
        System.out.println("  企业危化品安全管理系统启动成功！");
        System.out.println("  访问地址: http://localhost:8080/api");
        System.out.println("  API文档: http://localhost:8080/api/swagger-ui.html");
        System.out.println("  前端启动后，访问: http://localhost:3000 即可直接访问前端页面");
        System.out.println("=============================================================");
    }
}