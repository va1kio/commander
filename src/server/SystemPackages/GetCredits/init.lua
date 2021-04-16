local HttpService = game:GetService("HttpService")

local BACKUP_CREDITS = require(script.Credits)
local CREDITS_URL = "https://raw.githubusercontent.com/va1kio/commander/main/src/server/SystemPackages/GetCredits/Credits.lua"

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