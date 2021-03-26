local module = {
	Name = "Toggle slock",
	Description = "Toggles slock, player who is not admin will be kicked if slock is on",
	Location = "Server",
}

local status = false

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		status = not status
		module.Remotes.Event:FireClient(Client, "newMessage", "", {From = "System; ServerLock", Content = "ServerLock status has been changed to " .. tostring(status)})
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