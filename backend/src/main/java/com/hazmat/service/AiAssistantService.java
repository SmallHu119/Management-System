package com.hazmat.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class AiAssistantService {

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    @Value("${deepseek.api-key}")
    private String apiKey;

    @Value("${deepseek.api-url:https://api.deepseek.com/v1/chat/completions}")
    private String apiUrl;

    @Value("${deepseek.model:deepseek-chat}")
    private String model;

    private final List<Map<String, String>> conversationHistory = new ArrayList<>();

    private static final String SYSTEM_PROMPT =
            "你是一个企业危化品安全管理AI助手，专注于以下领域：\n" +
            "1. 危险化学品的储存、运输和使用安全管理\n" +
            "2. 安全隐患识别与风险评估\n" +
            "3. 安全检查流程与规范\n" +
            "4. 安全知识普及与培训指导\n" +
            "5. 监测预警参数解读与建议\n" +
            "6. 应急处置措施咨询\n\n" +
            "请用简洁专业的中文回答，每次回答不超过300字。如果用户的问题与危化品安全无关，请礼貌地引导用户回到安全话题。";

    public String chat(String userMessage) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(apiKey);

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("model", model);

            List<Map<String, String>> messages = new ArrayList<>();
            Map<String, String> systemMsg = new HashMap<>();
            systemMsg.put("role", "system");
            systemMsg.put("content", SYSTEM_PROMPT);
            messages.add(systemMsg);

            // 加入最近6轮对话历史(12条消息)
            int historyStart = Math.max(0, conversationHistory.size() - 12);
            messages.addAll(conversationHistory.subList(historyStart, conversationHistory.size()));

            Map<String, String> userMsg = new HashMap<>();
            userMsg.put("role", "user");
            userMsg.put("content", userMessage);
            messages.add(userMsg);

            requestBody.put("messages", messages);
            requestBody.put("max_tokens", 800);
            requestBody.put("temperature", 0.7);

            HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);

            ResponseEntity<String> response = restTemplate.postForEntity(apiUrl, request, String.class);

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                JsonNode root = objectMapper.readTree(response.getBody());
                String reply = root.path("choices").get(0).path("message").path("content").asText();

                // 保存对话历史
                conversationHistory.add(userMsg);
                Map<String, String> assistantMsg = new HashMap<>();
                assistantMsg.put("role", "assistant");
                assistantMsg.put("content", reply);
                conversationHistory.add(assistantMsg);

                return reply;
            }

            return "AI服务暂时不可用，请稍后重试。";
        } catch (Exception e) {
            log.error("调用DeepSeek API失败", e);
            return "抱歉，AI助手遇到了一些问题：" + e.getMessage();
        }
    }

    public void clearHistory() {
        conversationHistory.clear();
    }
}
