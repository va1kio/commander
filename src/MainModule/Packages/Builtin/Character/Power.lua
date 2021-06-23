local module = {
	Name = "Power",
	Description = "Changes a player's JumpPower",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local Input = module.API.sendModalToPlayer(Client).Event:Wait()

		if Input == false then
			return false
		end

		local char = module.API.getCharacter(module.API.getPlayerWithName(Attachment))

		if char then
			if char.Humanoid.UseJumpPower then
				char.Humanoid.JumpPower = tonumber(Input)
			else
				char.Humanoid.JumpHeight = tonumber(Input)
			end
			
			return true
		end
		return false
	end
end

return module
