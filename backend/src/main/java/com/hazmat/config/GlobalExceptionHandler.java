package com.hazmat.config;

import com.hazmat.common.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 全局异常处理器
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 处理参数校验异常
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Result<String> handleValidationException(MethodArgumentNotValidException e) {
        List<FieldError> fieldErrors = e.getBindingResult().getFieldErrors();
        String message = fieldErrors.stream()
                .map(FieldError::getDefaultMessage)
                .collect(Collectors.joining(", "));
        return Result.error(400, message);
    }

    /**
     * 处理绑定异常
     */
    @ExceptionHandler(BindException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Result<String> handleBindException(BindException e) {
        List<FieldError> fieldErrors = e.getBindingResult().getFieldErrors();
        String message = fieldErrors.stream()
                .map(FieldError::getDefaultMessage)
                .collect(Collectors.joining(", "));
        return Result.error(400, message);
    }

    /**
     * 处理认证异常
     */
    @ExceptionHandler(BadCredentialsException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public Result<String> handleBadCredentialsException(BadCredentialsException e) {
        return Result.unauthorized("用户名或密码错误");
    }

    /**
     * 处理访问拒绝异常
     */
    @ExceptionHandler(AccessDeniedException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    public Result<String> handleAccessDeniedException(AccessDeniedException e) {
        return Result.forbidden("没有访问权限");
    }

    /**
     * 处理SQL语法异常（表不存在等）—— 返回空数据而非500
     */
    @ExceptionHandler(BadSqlGrammarException.class)
    @ResponseStatus(HttpStatus.OK)
    public Result<Object> handleBadSqlGrammarException(BadSqlGrammarException e) {
        log.warn("数据库表不存在或SQL语法错误：{}", e.getMessage());
        Map<String, Object> emptyPage = new HashMap<>();
        emptyPage.put("records", List.of());
        emptyPage.put("total", 0);
        return Result.success(emptyPage);
    }

    /**
     * 处理数据访问异常—— 返回空数据而非500
     */
    @ExceptionHandler(DataAccessException.class)
    @ResponseStatus(HttpStatus.OK)
    public Result<Object> handleDataAccessException(DataAccessException e) {
        log.warn("数据访问异常：{}", e.getMessage());
        return Result.success(new HashMap<>());
    }

    /**
     * 处理运行时异常
     */
    @ExceptionHandler(RuntimeException.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public Result<String> handleRuntimeException(RuntimeException e) {
        log.error("运行时异常：", e);
        return Result.error("系统错误：" + e.getMessage());
    }

    /**
     * 处理其他异常
     */
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public Result<String> handleException(Exception e) {
        log.error("系统异常：", e);
        return Result.error("系统异常，请稍后重试");
    }
}
