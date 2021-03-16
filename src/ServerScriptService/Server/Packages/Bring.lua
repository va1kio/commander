local module = {
	Name = "Bring",
	Description = "Brings a player to you",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local char = module.API.getCharacter(module.API.getPlayerWithName(Attachment))
		if char and Client.Character  then
			local primaryPart = char.PrimaryPart
			local primaryPart2 = Client.Character.PrimaryPart
			if primaryPart and primaryPart2 then
				primaryPart.CFrame = primaryPart2.CFrame
				return true
			end
		end
	end
end

return module
