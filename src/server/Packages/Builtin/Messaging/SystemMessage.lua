local module = {
	Name = "System Message",
	Description = "Send a System message to everyone",
	Location = "Server",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local Input = module.API.sendModalToPlayer(Client, "What's the message?").Event:Wait()

		if not Input then return false end

		local Status
		Status, Input = module.API.filterText(Client, Input)

		if Status then
			module.API.Players.message("all", "System", Input)
			return true
		else
			module.API.Players.hint(Client, "System", "Your message to \"" .. tostring(Attachment) .. "\" failed to deliver, please retry later")
		end
		return false
	end
end

return module
