local module = {
	Name = "Server Ban",
	Description = "Server Bans a player",
	Location = "Player",
}

module.BanTable = {}

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
            if success then
                module.BanTable[Client] = Input
            else
                return false
            end
			
			if actualPlayer and success then
				actualPlayer:Kick("\nServer Banned\nReason: " ..  module.BanTable[Client])
				return true
			end
			return false
		end
	elseif Type == "firstrun" then
		module.API.registerPlayerAddedEvent(function(Client)
            if table.find(module.BanTable, Client) then
                Client:Kick("SeverBanned banned\nReason: " .. module.BanTable[Client])
            end
        end)
	end
end

return module