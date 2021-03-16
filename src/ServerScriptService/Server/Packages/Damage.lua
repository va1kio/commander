local module = {
	Name = "Damage",
	Description = "Damages a player, negative number means healing",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local Input = module.API.sendModalToPlayer(Client).Event:Wait()
		
		if not Input then return end

		local _, Humanoid = module.API.getCharacter(module.API.getPlayerWithName(Attachment))

		if Humanoid then
			Humanoid:TakeDamage(tonumber(Input))
			return true
		end
	end
end

return module
