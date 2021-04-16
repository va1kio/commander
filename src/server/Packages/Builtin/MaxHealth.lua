local module = {
	Name = "MaxHealth",
	Description = "Changes a player's maximum health",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local char = module.API.getCharacter(module.API.getPlayerWithName(Attachment))
		local Input = module.API.sendModalToPlayer(Client).Event:Wait()

		if Input == false then
			return false
		end

		if char then
			char.Humanoid.MaxHealth = tonumber(Input)
			return true
		end
		return false
	end
end


return module