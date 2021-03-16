local module = {
	Name = "Hand to",
	Description = "Hands a tool to a player",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local Input = module.API.sendModalToPlayer(Client, "What's the tool name?").Event:Wait()
		if not Input then return end
		local player, tool = module.API.getPlayerWithName(Attachment), (Client:FindFirstChildOfWhichIsA("Backpack") or Client:WaitForChild("Backpack", 5) or Instance.new("Backpack", Client)):FindFirstChild(Input)
		
		if player and tool then
			tool.Parent = player:FindFirstChildOfWhichIsA("Backpack") or player:WaitForChild("Backpack", 5) or Instance.new("Backpack", player)
			module.Remotes.Event:FireClient(player, "newMessage", "", {From = "System; HandTo", Content = Client.Name .. "has given you tool " .. tool.Name})
			return true
		else
			module.Remotes.Event:FireClient(Client, "newMessage", "", {From = "System; HandTo", Content = "Are you sure that player and tool exist?"})
		end
	end
end

return module
