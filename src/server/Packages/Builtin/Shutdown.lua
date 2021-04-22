local Players = game:GetService("Players")
local module = {
	Name = "Shutdown",
	Description = "Closes the current server",
	Location = "Server",
}

<<<<<<< HEAD
local isClosed, reason = false, ""

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local Input = module.API.sendModalToPlayer(Client).Event:Wait()

		local success, result
		if Input then
			success, result = module.API.filterText(Client, Input)
		end

		if not Input or success and result then
			module.API.Players.message("all", "System", "Shutting down in 5")
=======
module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local Input = module.API.sendModalToPlayer(Client).Event:Wait()

		if Input == false then
			return false
		end

		local success, result = module.API.filterText(Client, Input)

		if success and result then
			module.Remotes.Event:FireAllClients("newMessage", "", {From = "System", Content = "This server will be shutting down in 5 seconds"})
>>>>>>> 1ad486a6a581821bc1221b272946191f770ff14b
			wait(5)

			isClosed, reason = true, Input or "No reason given"
			for _, v in ipairs(Players:GetPlayers()) do
				v:Kick(string.format("\nThe server has shutdown. Reason: %s", reason))
			end
			return true
		end
		return false
	elseif Type == "firstrun" then
		module.API.registerPlayerAddedEvent(function(Client)
			if isClosed then
				Client:Kick(string.format("\nThe server has shutdown. Reason: %s", reason))
			end
		end)
	end
end

return module
