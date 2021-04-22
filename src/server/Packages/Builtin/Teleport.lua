local module = {
	Name = "Teleport",
	Description = "Teleports a player to another player",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local char = module.API.getCharacter(module.API.getPlayerWithName(Attachment))
		if char then
			local Input = module.API.sendModalToPlayer(Client).Event:Wait()

			if not Input then return false end

			local char1 = module.API.getCharacter(module.API.getPlayerWithName(Input))

			local primaryPart, primaryPart1 = char.PrimaryPart, char1 and char1.PrimaryPart
			if primaryPart and primaryPart1 then
				char:SetPrimaryPartCFrame(primaryPart1.CFrame:ToWorldSpace(CFrame.new(Vector3.new(0, 0, 5), primaryPart1.Position)))
				return true
			end
			return false
		end
	end
end

return module
