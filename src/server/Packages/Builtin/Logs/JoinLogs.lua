local module = {
	Name = "Join logs",
	Description = "Shows a list of who joined",
	Location = "Server",
}
local t = {}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		module.API.sendListToPlayer(Client, "Join logs", t)
		return true
	elseif Type == "firstrun" then
		module.API.registerPlayerAddedEvent(function(Client)
			t[#t + 1] = os.date("%X", os.time()) .. ": " .. Client.Name
		end)
	end
end

return module