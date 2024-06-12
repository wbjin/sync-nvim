local utils = {}
local start_config = {
    local_path='.',
    remote='',
    dest_path='',
    includes={},
}

local cur_dir = io.popen("pwd"):read()

utils.make_config = function()
    if vim.fn.isdirectory(".nvim") == 0 then
        vim.fn.mkdir(".nvim")
    end
    if vim.fn.filereadable(".nvim/config.lua") == 0 then
        local file = io.open(".nvim/config.lua", "w")
        file:write("return " .. tostring(vim.inspect(start_config)))
    end
    print("Made config file in .nvim/config.lua")
end

utils.make_string = function(list, command)
    local str = ""
    for _, file in ipairs(list) do
        str = str .. command .. "='" .. file .. "' "
    end
    return str
end

utils.make_filepaths = function(config, sync_up)
    if sync_up then
        return config["local_path"] .. " " .. config["remote"] .. ":" .. config["dest_path"]
    end
    return config["remote"] .. ":" .. config["dest_path"] .. " " .. config["local_path"]
end

utils.logger = function(message)
    logger = io.open(".nvim/sync-log.txt", "a")
    local current_date_time = os.date("*t")
    local date_time = string.format("%02d-%02d-%04d %02d:%02d:%02d ",
    current_date_time.day, current_date_time.month, current_date_time.year,
    current_date_time.hour, current_date_time.min, current_date_time.sec)
    logger:write(date_time .. message)
    logger:write('\n')
    logger:close()
end

utils.get_config = function(config)
    if vim.fn.isdirectory(".nvim") == 0 then
        print("Please set configs")
        return nil
    end
    if vim.fn.filereadable(".nvim/config.lua") == 0 then
        print("Please set configs")
        return nil
    end
    config = dofile(cur_dir .. "/.nvim/config.lua")
    if config == nil then
        print("Config file empty, you may have to copy over configs")
        return nil
    end
    return config
end
return utils
