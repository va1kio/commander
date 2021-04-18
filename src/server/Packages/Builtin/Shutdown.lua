local Players = game:GetService("Players")
local module = {
	Name = "Shutdown",
	Description = "Kicks all player in the current server",
	Location = "Server",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local Input = module.API.sendModalToPlayer(Client).Event:Wait()
		
		if Input == false then
			return false
		end

		local success, result = module.API.filterText(Client, Input)
		
		if success and result then
			module.API.Players.message("all", "System", "Shutting down in 5")
			wait(5)
			for i,v in pairs(Players:GetPlayers()) do
				v:Kick(result)
			end
			return true
		end
		return false
	end
end

return module