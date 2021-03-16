local module = {
	Name = "Bring",
	Description = "Brings a player to you",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local char = module.API.getCharacter(module.API.getPlayerWithName(Attachment))
		if char then
			if Client.Character then
				local primaryPart, primaryPart2 = char.PrimaryPart, Client.Character.PrimaryPart
				if primaryPart and primaryPart2 then
					char:SetPrimaryPartCFrame(primaryPart2.CFrame:ToWorldSpace(CFrame.new(Vector3.new(0, 0, 5))))
					return true
				end
			end
		end
	end
end

return module
