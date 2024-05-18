local utils = {}
local start_config = {
    local_path='.',
    remote='',
    dest_path='',
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

return utils
