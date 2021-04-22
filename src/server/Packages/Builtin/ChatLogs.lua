local module = {
	Name = "Chat logs",
	Description = "Shows a list of chat messages",
	Location = "Server",
}
local t = {}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		module.API.sendListToPlayer(Client, "Chat logs", t)
		return true
	elseif Type == "firstrun" then
		module.API.registerPlayerAddedEvent(function(Client)
			Client.Chatted:Connect(function(Message)
				t[#t + 1] = Client.Name .. ": " .. Message
			end)
		end)
	end
end

return module