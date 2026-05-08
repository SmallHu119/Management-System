package com.hazmat.controller;

import com.hazmat.common.Result;
import com.hazmat.dto.AiChatRequest;
import com.hazmat.service.AiAssistantService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Tag(name = "AI助手", description = "基于DeepSeek的危化品安全AI助手接口")
@RestController
@RequestMapping("/ai")
@RequiredArgsConstructor
public class AiAssistantController {

    private final AiAssistantService aiAssistantService;

    @Operation(summary = "AI对话")
    @PostMapping("/chat")
    public Result<Map<String, String>> chat(@RequestBody AiChatRequest request) {
        String reply = aiAssistantService.chat(request.getMessage());
        return Result.success(Map.of("reply", reply));
    }

    @Operation(summary = "清除对话历史")
    @DeleteMapping("/history")
    public Result<String> clearHistory() {
        aiAssistantService.clearHistory();
        return Result.success("对话历史已清除");
    }
}
