-- 配置示例
return {
    enable_strict_mode = true,
    max_code_length = 1000,
    -- 其他配置项
    check_interval = 60, -- 新增：检查间隔时间（秒）
    log_level = "info", -- 新增：日志级别（debug, info, warning, error）
    whitelist_paths = { -- 新增：白名单路径列表
        "garrysmod/lua/autorun",
        "garrysmod/lua/includes",
    },
    blacklist_paths = { -- 新增：黑名单路径列表
        "garrysmod/lua/unsafe",
    },
    risky_functions = { -- 新增：自定义潜在风险函数列表
        "os.execute",
        "io.popen",
        "file.Delete",
        "file.Write",
        "file.Append",
        "http.Fetch",
        "http.Post",
        -- 添加其他潜在风险函数
    },
}
