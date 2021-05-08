local module = {
	Name = "Check ban",
	Description = "Check a player's ban status",
	Location = "Player",
}

local DataStoreService
local dataStore

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local player = module.API.getUserIdWithName(Attachment)
		local success, result = pcall(dataStore.GetAsync, dataStore, "data")
		if success then
			result = result or {}
			result = result[tostring(player)] or module.Shared.LocalBans[player]
		else
			warn(result)
		end

		if success then
			if result then
				local message = "This player is currently banned, \n\nName: " .. Attachment .. " (" .. player .. ")\n"
				warn(result.Reason)
				result = message .. "Moderator: " .. tostring(result.By[2]) .. "\nDuration: " .. tostring(result.End) .. "\nReason: " .. tostring(result.Reason or "N/A")
			else
				result = "This player is not banned"
			end
		else
			result = "An error occured, please try later"
		end

		module.API.Players.notify(Client, "CheckBan", result)
		return true
	elseif Type == "firstrun" then
		DataStoreService = module.Services.DataStoreService
		dataStore = DataStoreService:GetDataStore(module.Settings.Misc.DataStoresKey.Ban or "commander.bans")
		module.Shared.LocalBans = module.Shared.LocalBans or {}
	end
end

return module