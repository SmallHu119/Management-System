package com.hazmat.service;

import com.hazmat.common.Result;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * 文件上传服务
 */
@Service
public class FileService {

    @Value("${file.upload-path}")
    private String uploadPath;

    /**
     * 上传文件
     */
    public Result<String> uploadFile(MultipartFile file) {
        if (file.isEmpty()) {
            return Result.error("文件不能为空");
        }

        try {
            // 生成文件存储路径（按日期分目录）
            String dateDir = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
            String dirPath = uploadPath + "/" + dateDir;
            
            // 创建目录
            Path directory = Paths.get(dirPath);
            if (!Files.exists(directory)) {
                Files.createDirectories(directory);
            }

            // 生成新文件名
            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String newFilename = UUID.randomUUID().toString().replace("-", "") + extension;

            // 保存文件
            Path filePath = Paths.get(dirPath, newFilename);
            file.transferTo(filePath.toFile());

            // 返回相对路径
            String relativePath = "/uploads/" + dateDir + "/" + newFilename;
            return Result.success("上传成功", relativePath);

        } catch (IOException e) {
            return Result.error("文件上传失败：" + e.getMessage());
        }
    }

    /**
     * 上传图片
     */
    public Result<String> uploadImage(MultipartFile file) {
        if (file.isEmpty()) {
            return Result.error("文件不能为空");
        }

        // 检查文件类型
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            return Result.error("只能上传图片文件");
        }

        // 检查文件大小（最大5MB）
        if (file.getSize() > 5 * 1024 * 1024) {
            return Result.error("图片大小不能超过5MB");
        }

        return uploadFile(file);
    }

    /**
     * 删除文件
     */
    public Result<String> deleteFile(String filePath) {
        if (filePath == null || filePath.isEmpty()) {
            return Result.error("文件路径不能为空");
        }

        try {
            // 转换为实际路径
            String actualPath = filePath.replace("/uploads/", uploadPath + "/");
            File file = new File(actualPath);
            
            if (file.exists()) {
                if (file.delete()) {
                    return Result.success("删除成功");
                } else {
                    return Result.error("删除失败");
                }
            } else {
                return Result.error("文件不存在");
            }
        } catch (Exception e) {
            return Result.error("删除失败：" + e.getMessage());
        }
    }
}
