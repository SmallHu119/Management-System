package com.hazmat.controller;

import com.hazmat.common.Result;
import com.hazmat.service.FileService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

/**
 * 文件上传控制器
 */
@Tag(name = "文件管理", description = "文件上传下载接口")
@RestController
@RequestMapping("/file")
@RequiredArgsConstructor
public class FileController {

    private final FileService fileService;

    @Operation(summary = "上传文件")
    @PostMapping("/upload")
    public Result<String> uploadFile(@RequestParam("file") MultipartFile file) {
        return fileService.uploadFile(file);
    }

    @Operation(summary = "上传图片")
    @PostMapping("/upload/image")
    public Result<String> uploadImage(@RequestParam("file") MultipartFile file) {
        return fileService.uploadImage(file);
    }

    @Operation(summary = "删除文件")
    @DeleteMapping
    public Result<String> deleteFile(@RequestParam String filePath) {
        return fileService.deleteFile(filePath);
    }
}
