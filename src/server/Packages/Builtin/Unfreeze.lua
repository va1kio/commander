local module = {
	Name = "Unfreeze",
	Description = "Opposite of Freeze",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local char = module.API.getCharacter(module.API.getPlayerWithName(Attachment))
		if char and char.PrimaryPart then
			char.PrimaryPart.Anchored = false
			return true
		end
		return false
	end
end

return module