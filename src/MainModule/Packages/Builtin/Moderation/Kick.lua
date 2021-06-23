local module = {
	Name = "Kick",
	Description = "Kicks a player",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local player = module.API.getPlayerWithName(Attachment)
		if player and not module.API.checkAdmin(player.UserId) then
			local Input = module.API.sendModalToPlayer(Client).Event:Wait()

			if Input == false then
				return false
			end

			local success, result = module.API.filterText(Client, Input)

			if success and result then
				player:Kick(result)
				return true
			end
			return false
		end
	end
end

return module