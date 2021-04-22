local module = {
	Name = "Hand to",
	Description = "Hands a tool to a player",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local Input = module.API.sendModalToPlayer(Client, "What's the tool name?").Event:Wait()
		local player 
		local tool
		if Input == false then return false end
		player, tool = module.API.getPlayerWithName(Attachment), Client.Backpack:FindFirstChild(Input)

		if player and tool then
			tool.Parent = player.Backpack
			module.API.Players.hint(player, "HandTo", Client.Name .. "has gave you " .. tool.Name)
			return true
		else
			module.API.Players.hint(Client, "HandTo", "An error occured, are you sure that the player and tool is valid?")
		end
		return false
	end
end

return module