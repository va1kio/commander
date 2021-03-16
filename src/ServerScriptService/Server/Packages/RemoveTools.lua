local module = {
	Name = "Removetools",
	Description = "Removes the tools of the player",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local Player = module.API.getPlayerWithName(Attachment)
		local BackPack = Player:FindFirstChildOfClass("Backpack")
		if Backpack then
			Backpack:ClearAllChildren()
			return true
		end
	end
end

return module
