local utils = {}
local start_config = {
    local_path='.',
    remote='',
    dest_path='',
    includes={},
}

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

return utils
