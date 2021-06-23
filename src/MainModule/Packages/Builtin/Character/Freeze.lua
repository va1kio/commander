local module = {
	Name = "Freeze",
	Description = "Stops a player from moving around",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local char = module.API.getCharacter(module.API.getPlayerWithName(Attachment))
		if char and char.PrimaryPart then
			char.PrimaryPart.Anchored = true
			return true
		end
		return false
	end
end

return module