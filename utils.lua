-- 主文件，用于加载配置和初始化插件
local config = require("c:/Users/admin/Desktop/config.lua")

-- 初始化插件
function Initialize()
    print("Lua Checker 插件已加载")
    -- 在这里添加你的初始化代码
    CheckDirectory("garrysmod/lua")
    hook.Add("LuaFileLoaded", "LuaChecker_FileLoaded", CheckLoadedLuaFile)
end

-- 检查目录中的所有Lua文件
function CheckDirectory(directory)
    local files, folders = file.Find(directory .. "/*", "GAME")
    for _, file in ipairs(files) do
        if file:match("%.lua$") then
            CheckLuaFile(path.Combine(directory, file))
        end
    end
    for _, folder in ipairs(folders) do
        CheckDirectory(path.Combine(directory, folder))
    end
end

-- 检查单个Lua文件
function CheckLuaFile(filePath)
    if IsWhitelisted(filePath) then
        print("文件 " .. filePath .. " 已通过检查，放过")
        return
    end

    local fileContent, err = file.Read(filePath, "GAME")
    if not fileContent then
        print("无法读取文件 " .. filePath .. ": " .. (err or "未知错误"))
        AddToBlacklist(filePath) -- 将读取失败的文件添加到黑名单
        return
    end

    -- 检查代码中的潜在安全风险
    if CheckForSecurityRisks(fileContent) then
        print("文件 " .. filePath .. " 包含潜在的安全风险")
        AddToBlacklist(filePath)
    else
        print("文件 " .. filePath .. " 检查通过")
        AddToWhitelist(filePath)
    end
end

-- 检查加载的Lua文件
function CheckLoadedLuaFile(filePath)
    if IsBlacklisted(filePath) then
        print("尝试加载黑名单中的文件: " .. filePath)
        return false -- 阻止加载
    elseif IsWhitelisted(filePath) then
        print("文件 " .. filePath .. " 已通过检查，放过")
        return true -- 允许加载
    else
        CheckLuaFile(filePath)
        return not IsBlacklisted(filePath)
    end
end

-- 添加文件名到黑名单
local blacklist = {}
function AddToBlacklist(filePath)
    blacklist[filePath] = true
end

-- 检查文件名是否在黑名单中
function IsBlacklisted(filePath)
    return blacklist[filePath] or false
end

-- 添加文件名到白名单
local whitelist = {}
function AddToWhitelist(filePath)
    whitelist[filePath] = true
end

-- 检查文件名是否在白名单中
function IsWhitelisted(filePath)
    return whitelist[filePath] or false
end

-- 检查代码中的潜在安全风险
local riskyFunctions = config.risky_functions

function CheckForSecurityRisks(code)
    for _, func in ipairs(riskyFunctions) do
        if string.find(code, func) then
            return true
        end
    end
    return false
end

-- 检查多个Lua文件
function CheckMultipleLuaFiles(filePaths)
    for _, filePath in ipairs(filePaths) do
        CheckLuaFile(filePath)
    end
end

-- 初始化插件
Initialize()
