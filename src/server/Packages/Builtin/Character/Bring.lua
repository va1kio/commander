local module = {
	Name = "Bring",
	Description = "Brings a player to you",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local char = module.API.getCharacter(module.API.getPlayerWithName(Attachment))
		local primaryPart, primaryPart2 = char and char.PrimaryPart, Client.Character and Client.Character.PrimaryPart
		if primaryPart and primaryPart2 then
			char:SetPrimaryPartCFrame(primaryPart2.CFrame:ToWorldSpace(CFrame.new(Vector3.new(0, 0, 5), primaryPart2.Position)))
			return true
		end

		return false
	end
end

return module
