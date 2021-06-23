local module = {
	Name = "Damage",
	Description = "Damages a player, negative number means healing",
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
			char.Humanoid:TakeDamage(tonumber(Input))
			return true
		end
		return false
	end
end

return module