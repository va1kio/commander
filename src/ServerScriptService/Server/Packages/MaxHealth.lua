local module = {
	Name = "MaxHealth",
	Description = "Changes a player's maximum health",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local char = module.API.getCharacter(module.API.getPlayerWithName(Attachment))
		module.API.sendModalToPlayer(Client).Event:Connect(function(Input)
			if Input ~= false then
				if char then
					char.Humanoid.MaxHealth = tonumber(Input)
				end
			end
		end)
	end
end


return module