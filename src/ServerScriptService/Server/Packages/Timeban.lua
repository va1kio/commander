local DataStoreService = game:GetService("DataStoreService")
local dataStore = DataStoreService:GetDataStore("commander.bans")
local module = {
	Name = "Time ban",
	Description = "Bans a player for a certain of time",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local player = module.API.getUserIdWithName(Attachment)
		local actualPlayer = module.API.getPlayerWithName(Attachment)
		if typeof(player) == "number" and not module.API.checkAdmin(player) then
			local Input = module.API.sendModalToPlayer(Client, "Reason?").Event:Wait()
			
			if not Input then return end
			
			local Input2 = module.API.sendModalToPlayer(Client, "How many hours?").Event:Wait()
			
			if not Input2 then return end
			
			local success, result = module.API.filterText(Client, Input)
			success = pcall(dataStore.SetAsync, dataStore, player, {End = os.time() + tonumber(Input2) * 60 * 60, Reason = result})
			
			if actualPlayer and success then
				Client:Kick("\nBanned\nReason: " .. result .. "\n\nCome back at " .. os.date("%d %b, %Y (%a) %X", tick() + tonumber(Input2) * 60 * 60))
				return true
			end
		end
	end
end

return module
