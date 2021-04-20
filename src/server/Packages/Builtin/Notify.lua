local module = {
	Name = "Notify",
	Description = "Send a notification to a specific player, others or all" ,
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local Input = module.API.sendModalToPlayer(Client, "What's the message?").Event:Wait()
		
		if Input == false then
			return false
		end

		local Status
		Status, Input = module.API.filterText(Client, Input)
		
		if Status then
			module.API.doThisToPlayers(Client, Attachment, function(Player)
				module.API.Players.notify(Player, Client.Name, Input)
			end)
			return true
		else
			module.API.Players.hint(Client, "System", "Your notification to \"" .. tostring(Attachment) .. "\" failed to deliver, please retry later")
		end
		return false
	end
end

return module
