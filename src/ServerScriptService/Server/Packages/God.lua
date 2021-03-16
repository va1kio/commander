local module = {
	Name = "God",
	Description = "Sets the player's health to math.huge, resulting in unlimited health.",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local char = module.API.getCharacter(module.API.getPlayerWithName(Attachment))
		if char then
			local Humanoid = char:FindFirstChild("Humanoid")
			Humanoid.MaxHealth = math.huge
			Humanoid.Health = math.huge
			return true
		end
	end
end

return module
