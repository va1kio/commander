local HttpService = game:GetService("HttpService")
local Promise = require(script.Parent.Services.Promise)

local function fetch()
    return Promise.new(function(resolve, reject)
        local status, response = pcall(HttpService.GetAsync, HttpService, "https://api.github.com/repos/va1kio/commander/tags")
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
        for _,v in ipairs(response) do
            if tostring(string.match(v.name, "%d+%.%d+%.%d+")) ~= v.name then
                continue
            else
                return v.name
            end
        end
    else
        return false, HttpService.HttpEnabled
    end
end