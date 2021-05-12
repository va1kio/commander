local HttpService = game:GetService("HttpService")
local Promise = require(script.Parent.Services.Promise)

local URL = "https://api.github.com/repos/va1kio/commander/tags"

local function fetch()
    return Promise.new(function(resolve, reject)
        local status, response = pcall(HttpService.GetAsync, HttpService, URL)
        if status then
            resolve(HttpService:JSONDecode(response))
        else
            reject(response)
        end
    end)
end

return function()
    local status, response = fetch():await()
    if status then
        for _, item in ipairs(response) do
            if tostring(string.match(item.name, "%d+%.%d+%.%d+")) ~= item.name then
                continue
            else
                return item.name, HttpService.HttpEnabled
            end
        end
    else
        return false, HttpService.HttpEnabled
    end
end