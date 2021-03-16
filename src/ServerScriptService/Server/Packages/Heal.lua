local module = {
	Name = "Heal",
	Description = "Heals a player",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local char = module.API.getCharacter(module.API.getPlayerWithName(Attachment))
		if char then
			local Humanoid = char:FindFirstChildOfClass("Humanoid")
			Humanoid.Health = Humanoid.MaxHealth
			return true
		end
	end
end

return module
