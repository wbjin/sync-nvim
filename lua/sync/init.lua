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
    vim.api.nvim_create_user_command("SyncDown", sync_down, {})
    vim.keymap.set('n', "<leader>rs", ":Sync<CR>")
end

function run_sync(command)
    utils.logger(command)
    local function execute()
        local ret = io.popen(command)
        if not ret then
            error("Failed to rsync")
        end
        local sucess = {ret:close()}
        if sucess[1] then
            print("Sync success")
        else
            print("Sync fail")
        end
    end
    local status, err = pcall(execute)
    if not status then
        print("Error caught: " .. err)
    end
end

function sync()
    config = utils.get_config()
    if config == nil then
        return
    end
    file_paths = utils.make_filepaths(config, true)
    -- local command = "rsync -varz --exclude .nvim --exclude __pycache__ --exclude env --exclude .git --exclude .ruff_cache " .. file_paths
    local command = "rsync -varz  "
                        .. "--exclude='.*' --exclude='*.*/' --exclude='__pycache__' "
                        .. file_paths

    run_sync(command)
end

function sync_inc()
    config = utils.get_config()
    if config == nil then
        return
    end
    includes = utils.make_string(config["includes"], "--include")
    file_paths = utils.make_filepaths(config, true)
    local command = "rsync -varz  "
                        .. "--exclude='*' --exclude='__pycache__' --exclude='.git'"
                        .. includes
                        .. file_paths

    run_sync(command)
end

function sync_down()
    config = utils.get_config()
    if config == nil then
        return
    end
    file_paths = utils.make_filepaths(config, false)
    local command = "rsync -varz " .. file_paths

    run_sync(command)
end

return M
