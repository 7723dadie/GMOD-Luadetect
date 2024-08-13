-- 主文件，用于加载配置和初始化插件
local config = require("c:/Users/admin/Desktop/config.lua")

-- 初始化插件
function Initialize()
    print("Lua Checker 插件已加载")
    -- 在这里添加你的初始化代码
    require("c:/Users/admin/Desktop/lua_checker.lua")
    CheckDirectory("garrysmod/lua")
    hook.Add("LuaFileLoaded", "LuaChecker_FileLoaded", CheckLoadedLuaFile)
end

-- 初始化插件
Initialize()
