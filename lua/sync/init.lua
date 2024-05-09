local M = {}
local local_absolute_path = nil
local dest_absolute_path = nil
local dest_ssh = nil

M.setup = function()
    vim.api.nvim_create_user_command("SyncSetLocal",
        function(args)
            local path = vim.fn.input "path: "
            set_local(path)
            print("Set local path")
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
end

function set_local(path)
    local_absolute_path = path
end

function set_dest(path)
    if path[1] == '/' then
        path = std:sub(1)
    end
    dest_absolute_path = path
end

function set_ssh(ssh)
    dest_ssh = ssh
end

function sync()
    if local_absolute_path == nil or dest_ssh == nil or dest_absolute_path == nil then
        print("Please set configs")
        return
    end
    local command = "rsync -a " .. local_absolute_path .. " " .. dest_ssh .. ":" .. dest_absolute_path
    local ret = io.popen(command)
    local sucess = {ret:close()}
    if sucess[1] then
        print("Sync success")
    else
        print("Sync fail")
    end
end

return M
