local module = {
	Name = "Toggle slock",
	Description = "Toggles slock, player who is not admin will be kicked if slock is on",
	Location = "Server",
}

local status = false

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		status = not status
		module.API.Players.hint(Client, "ServerLock", "Server is now " .. (status and "locked" or "unlocked"))
		return true
	elseif Type == "firstrun" then
		module.API.registerPlayerAddedEvent(function(Client)
			if not module.API.checkAdmin(Client.UserId) and status then
				Client:Kick("\nThis server is server locked, consider join another server.")
			end
		end)
	end
end

return module