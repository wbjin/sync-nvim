local M = {}
local config = {
    local_path = nil,
    remote = nil,
    dest_path = nil,
}

local utils = require "sync.utils"
local cur_dir = io.popen("pwd"):read()
local config = nil
if vim.fn.isdirectory(".nvim") ~= 0 then
    if vim.fn.filereadable(".nvim/config.lua") ~= 0 then
        config = dofile(cur_dir .. "/.nvim/config.lua")
    end
end

M.setup = function()
    vim.api.nvim_create_user_command("SyncInit",
        function()
            utils.make_config()
        end,
        {}
    )
    vim.api.nvim_create_user_command("Sync", sync, {})
    vim.api.nvim_create_user_command("SyncInclude", sync_inc, {})
    vim.keymap.set('n', "<leader>rs", ":Sync<CR>")
end

function sync()
    if vim.fn.isdirectory(".nvim") == 0 then
        print("Please set configs")
        return
    end
    if vim.fn.filereadable(".nvim/config.lua") == 0 then
        print("Please set configs")
        return
    end
    config = dofile(cur_dir .. "/.nvim/config.lua")
    if config == nil then
        print("Config file empty, you may have to copy over configs")
        return
    end
    local command = "rsync -a --exclude .nvim " .. config["local_path"] .. " " .. config["remote"] .. ":" .. config["dest_path"]
    utils.logger(command)
    local ret = io.popen(command)
    local sucess = {ret:close()}
    if sucess[1] then
        print("Sync success")
    else
        print("Sync fail")
    end
end

function sync_inc()
    if vim.fn.isdirectory(".nvim") == 0 then
        print("Please set configs")
        return
    end
    if vim.fn.filereadable(".nvim/config.lua") == 0 then
        print("Please set configs")
        return
    end
    config = dofile(cur_dir .. "/.nvim/config.lua")
    if config == nil then
        print("Config file empty, you may have to copy over configs")
        return
    end
    local includes = ""
    for _, include in ipairs(config["includes"]) do
        includes = includes .. " --include " .. include
    end
    includes  = includes .. " "
    local command = "rsync -av --exclude * --exclude __pycache__" .. includes .. config["local_path"] .. " " .. config["remote"] .. ":" .. config["dest_path"]
    utils.logger(command)
    local ret = io.popen(command)
    local sucess = {ret:close()}
    if sucess[1] then
        print("Sync success")
    else
        print("Sync fail")
    end
end
return M
