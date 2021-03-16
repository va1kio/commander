local module = {
	Name = "Health",
	Description = "Changes a player's health",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local Input = module.API.sendModalToPlayer(Client).Event:Wait()

		if Input == false then
			return
		end

		local _, Humanoid = module.API.getCharacter(module.API.getPlayerWithName(Attachment))
		
		if Humanoid then
			Humanoid.Health = tonumber(Input)
			return true
		end
	end
end

return module
