local module = {
	Name = "Time ban",
	Description = "Bans a player for a certain of time",
	Location = "Player",
}

local DataStoreService
local dataStore

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local player = module.API.getUserIdWithName(Attachment)
		local actualPlayer = module.API.getPlayerWithName(Attachment)
		if typeof(player) == "number" and not module.API.checkAdmin(player) then
			local Input = module.API.sendModalToPlayer(Client, "Reason?").Event:Wait()

			if Input == false then
				return false
			end

			local Input2 = module.API.sendModalToPlayer(Client, "How many hours?").Event:Wait()

			if Input2 == false then
				return false
			end

			local success, result = module.API.filterText(Client, Input)
			success = pcall(dataStore.SetAsync, dataStore, player, {End = os.time() + tonumber(Input2) * 60 * 60, Reason = result})

			if actualPlayer and success then
				actualPlayer:Kick("\nBanned\nReason: " .. result .. "\n\nCome back at " .. os.date("%d %b, %Y (%a) %X", tick() + tonumber(Input2) * 60 * 60))
				return true
			end
			return false
		end
	elseif Type == "firstrun" then
		DataStoreService = module.Services.DataStoreService
		dataStore = DataStoreService:GetDataStore(module.Settings.Misc.DataStoresKey.Ban or "commander.bans")
	end
end

return module