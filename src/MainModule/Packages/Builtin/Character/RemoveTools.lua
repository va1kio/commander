local module = {
	Name = "Removetools",
	Description = "Removes the tools of the player",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local Player = module.API.getPlayerWithName(Attachment)
		local Backpack = Player:FindFirstChildOfClass("Backpack")
		if Backpack then
			for _, v in ipairs({Player.Character and table.unpack(Player.Character:GetChildren()), table.unpack(Backpack:GetChildren())}) do
				if v:IsA("BackpackItem") then
					v:Destroy()
				end
			end
			return true
		end
	end
end

return module
