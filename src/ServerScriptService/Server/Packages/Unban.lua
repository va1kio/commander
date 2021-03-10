local DataStoreService = game:GetService("DataStoreService")
local dataStore = DataStoreService:GetDataStore("commander.bans")
local module = {
	Name = "Unban",
	Description = "Unbans a player",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local player = module.API.getUserIdWithName(Attachment)
		if typeof(player) == "number" then
			pcall(dataStore.RemoveAsync, dataStore, player)
		end
	end
end

return module