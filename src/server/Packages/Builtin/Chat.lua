local Chat = game:GetService("Chat")
local module = {
	Name = "Chat",
	Description = "Creates a bubble chat with ChatService:Chat()",
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
				if Player.Character then
					Chat:Chat(Player.Character, Input)
				end
			end)
			return true
		else
			module.Remotes.Event:FireClient(Client, "newMessage", "", {From = "System", Content = "Your bubble chat request to \"" .. tostring(Attachment) .. "\" failed to filter, please retry later."})
		end
		return false
	end
end

return module