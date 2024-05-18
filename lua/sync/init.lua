local M = {}
local config = {
    local_path = nil,
    remote = nil,
    dest_path = nil,
}

local utils = require "sync.utils"
local cur_dir = io.popen("pwd"):read()
local config = dofile(cur_dir .. "/.nvim/config.lua")

M.setup = function()
    vim.api.nvim_create_user_command("SyncInit",
        function()
            utils.make_config()
        end,
        {}
    )
    vim.api.nvim_create_user_command("SyncSetLocal",
        function(args)
            local path = vim.fn.input "path: "
            set_local(path)
        end,
        {}
    )
    vim.api.nvim_create_user_command("SyncSetDest",
        function(args)
            local ssh = vim.fn.input "ssh: "
            set_ssh(ssh)
            print("Set ssh destination")
        end,
        {}
    )
    vim.api.nvim_create_user_command("SyncSetDestPath",
        function(args)
            local path = vim.fn.input "path: "
            set_dest(path)
            print("Set destination path")
        end,
        {}
    )
    vim.api.nvim_create_user_command("SyncSetAll",
        function(args)
            local local_path = vim.fn.input "Local path: "
            local dest_ssh = vim.fn.input "ssh: "
            local dest_path = vim.fn.input "Destination path: "
            set_local(local_path)
            set_ssh(dest_ssh)
            set_dest(dest_path)
            print("Set all")
        end,
        {}
    )
    vim.api.nvim_create_user_command("Sync", sync, {})
    vim.keymap.set('n', "<leader>rs", ":Sync<CR>")
end

function sync()
    config = dofile(cur_dir .. "/.nvim/config.lua")
    if config["local_path"] == nil or config["dest_path"] == nil or config["remote"] == nil then
        print("Please set configs")
        return
    end
    local command = "rsync -a " .. config["local_path"] .. " " .. config["remote"] .. ":" .. config["dest_path"]
    local ret = io.popen(command)
    local sucess = {ret:close()}
    if sucess[1] then
        print("Sync success")
    else
        print("Sync fail")
    end
end

return M
