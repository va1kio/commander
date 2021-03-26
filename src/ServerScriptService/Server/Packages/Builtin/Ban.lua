local module = {
	Name = "Ban",
	Description = "Bans a player",
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

			local success, result = module.API.filterText(Client, Input)
			success = pcall(dataStore.SetAsync, dataStore, player, {End = math.huge, Reason = result})
			
			if actualPlayer and success then
				actualPlayer:Kick("\nPermanently banned\nReason: " ..  result)
				return true
			end
			return false
		end
	elseif Type == "firstrun" then
		DataStoreService = module.Services.DataStoreService
		dataStore = DataStoreService:GetDataStore("commander.bans")

		module.API.registerPlayerAddedEvent(function(Client)
			local success, data = pcall(dataStore.GetAsync, dataStore, Client.UserId)
			if success then
				if data.End == math.huge then
					Client:Kick("\nPermanently banned\nReason: " .. data.Reason)
				elseif os.time() < tonumber(data.End) then
					Client:Kick("\nBanned\nReason: " .. data.Reason .. "\n\nCome back at " .. os.date("%d %b, %Y (%a) %X", data.End))
				end
			end
		end)
	end
end

return module