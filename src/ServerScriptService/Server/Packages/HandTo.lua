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
		if Input == false then return end
		player, tool = module.API.getPlayerWithName(Attachment), Client.Backpack:FindFirstChild(Input)
		
		if player and tool then
			tool.Parent = player.Backpack
			module.Remotes.Event:FireClient(player, "newMessage", "", {From = "System; HandTo", Content = Client.Name .. "has given you tool " .. tool.Name})
		else
			module.Remotes.Event:FireClient(Client, "newMessage", "", {From = "System; HandTo", Content = "Are you sure that player and tool exist?")
		end
	end
end

return module