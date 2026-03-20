# 企业危化品安全管理系统

## 1. 项目简介

本项目是一个基于 **SpringBoot + Vue3** 的企业危化品安全管理系统。旨在通过信息化的手段，帮助企业实现对危化品的采购、存储、使用、处置等全生命周期的规范化管理，同时提供安全知识学习、隐患排查与上报、安全检查等功能，全面提升企业的危化品安全管理水平。

系统设计为完全独立的本地部署方案，不依赖任何外部云服务，确保企业数据的安全性和私密性。项目包含了完整的前后端源代码、数据库设计和详细的部署说明，可直接用于二次开发或作为毕业设计参考。

### 主要功能模块

系统包含三种用户角色，各自拥有不同的操作权限：

| 用户角色 | 功能模块 |
| :--- | :--- |
| **普通员工** | 登录注册、个人中心、安全知识在线学习、隐患上报、查看公告 |
| **安全管理员** | 登录、个人信息管理、危化品信息管理、安全检查计划与记录管理、处理隐患、发布安全知识 |
| **系统管理员** | 用户管理（员工、安全管理员）、危化品类别管理、所有危化品信息管理、隐患记录管理、公告管理 |

### 技术栈

- **后端**
  - **核心框架**: Spring Boot 3
  - **安全认证**: Spring Security + JWT
  - **数据库**: MySQL 8.0
  - **ORM**: MyBatis-Plus
  - **API文档**: SpringDoc (Swagger UI)

- **前端**
  - **核心框架**: Vue 3
  - **路由**: Vue Router
  - **状态管理**: Pinia
  - **UI组件库**: Element Plus
  - **构建工具**: Vite
  - **HTTP客户端**: Axios

## 2. 项目结构

```
/hazmat-safety-system
├── backend/                  # SpringBoot 后端项目
│   ├── src/
│   └── pom.xml
├── frontend/                 # Vue3 前端项目
│   ├── src/
│   ├── public/
│   ├── index.html
│   └── package.json
├── docs/
│   └── database_design.sql   # 数据库SQL脚本
└── README.md                 # 项目说明文档
```

## 3. 本地部署指南

请确保您的本地环境已安装以下软件：

- Java Development Kit (JDK) 17 或更高版本
- Maven 3.6 或更高版本
- Node.js 16 或更高版本
- MySQL 8.0 或更高版本

### 3.1. 后端部署

1.  **创建数据库**

    首先，请在您的MySQL服务器中创建一个新的数据库，例如 `hazmat_safety`。

    ```sql
    CREATE DATABASE hazmat_safety DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    ```

2.  **导入数据表**

    使用数据库管理工具（如 Navicat, DBeaver）连接到您创建的数据库，并运行项目根目录 `docs/database_design.sql` 文件中的SQL脚本，以创建所有需要的数据表。

3.  **修改配置文件**

    打开后端项目的配置文件 `backend/src/main/resources/application.yml`，根据您的本地环境修改以下配置：

    ```yaml
    spring:
      datasource:
        url: jdbc:mysql://localhost:3306/hazmat_safety?serverTimezone=Asia/Shanghai
        username: your_mysql_username  # 修改为您的MySQL用户名
        password: your_mysql_password  # 修改为您的MySQL密码
    
    # 文件上传路径（请确保该目录存在且有写入权限）
    file:
      upload-path: /path/to/your/uploads # 例如：/home/ubuntu/uploads
    ```

4.  **启动后端服务**

    进入 `backend` 目录，使用Maven启动项目。

    ```bash
    cd /home/ubuntu/hazmat-safety-system/backend
    mvn spring-boot:run
    ```

    当您在控制台看到类似 `Started HazmatSafetyApplication in ... seconds` 的日志时，表示后端服务已成功启动在 `http://localhost:8080`。

### 3.2. 前端部署

1.  **安装依赖**

    进入 `frontend` 目录，使用 `pnpm` 或 `npm` 安装项目依赖。

    ```bash
    cd /home/ubuntu/hazmat-safety-system/frontend
    pnpm install
    ```

2.  **启动前端开发服务器**

    ```bash
    pnpm dev
    ```

    前端开发服务器将启动在 `http://localhost:3000`。Vite已配置好代理，所有对 `/api` 的请求都会被转发到 `http://localhost:8080` 的后端服务。

3.  **访问系统**

    打开浏览器，访问 `http://localhost:3000` 即可开始使用本系统。

## 4. 默认账号

系统初始化时会自动创建一个默认的系统管理员账号，您可以使用此账号登录并创建其他角色的用户。

- **用户名**: `admin`
- **密码**: `admin123`

## 5. 注意事项

- 本项目为本地部署版本，文件上传功能会将文件存储在您在 `application.yml` 中配置的本地路径下。
- JWT的密钥等敏感信息已硬编码在代码中，仅供学习和演示使用。在生产环境中，应使用更安全的方式（如环境变量、配置中心）进行管理。
- 前端路由守卫实现了基本的角色权限控制，您可以根据实际需求在 `frontend/src/router/index.js` 中进行调整。
