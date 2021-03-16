local module = {
	Name = "Heal",
	Description = "Heals a player",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local _, Humanoid = module.API.getCharacter(module.API.getPlayerWithName(Attachment))
		if Humanoid then
			Humanoid.Health = char.Humanoid.MaxHealth
			return true
		end
	end
end

return module
