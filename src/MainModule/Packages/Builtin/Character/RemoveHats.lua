local module = {
	Name = "Removehats",
	Description = "Removes the hats and other accessories of a player",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local Player = module.API.getPlayerWithName(Attachment)
		if Player.Character then
			for _, v in ipairs(Player.Character:GetChildren()) do
				if v:IsA("Accoutrement") then
					v:Destroy()
				end
			end
			return true
		end
	end
end

return module
