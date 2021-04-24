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
        return response[1].name
    else
        return false
    end
end