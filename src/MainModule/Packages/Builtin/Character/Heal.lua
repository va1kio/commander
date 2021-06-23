local module = {
	Name = "Heal",
	Description = "Heals a player",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local char = module.API.getCharacter(module.API.getPlayerWithName(Attachment))
		if char then
			char.Humanoid.Health = char.Humanoid.MaxHealth
			return true
		end
		return false
	end
end

return module