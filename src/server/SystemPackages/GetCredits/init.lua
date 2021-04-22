local HttpService = game:GetService("HttpService")

local commanderBuild = require(script.Parent.Settings).Version

local branchName = commanderBuild[2]:match("Preview") ~= nil and "preview" or "main"

local BACKUP_CREDITS = require(script.Credits)
local CREDITS_URL = "https://raw.githubusercontent.com/va1kio/commander/" .. branchName .. "/src/server/SystemPackages/GetCredits/Credits.json"

return function()
	local success, result = pcall(function()
		return HttpService:GetAsync(CREDITS_URL)
	end)

	if success then
		return HttpService:JSONDecode(result)
	else
		warn("Failed to fetch Credits with error " .. result)
		return BACKUP_CREDITS
	end
end