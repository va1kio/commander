local module = {
	Name = "MaxHealth",
	Description = "Changes a player's maximum health",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local _, Humanoid = module.API.getCharacter(module.API.getPlayerWithName(Attachment))
		local Input = module.API.sendModalToPlayer(Client).Event:Wait()

		if Input == false then
			return
		end

		if Humanoid then
			Humanoid.MaxHealth = tonumber(Input)
			return true
		end
	end
end


return module
