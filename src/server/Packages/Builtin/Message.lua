local module = {
	Name = "Message",
	Description = "Send a message to everyone" ,
	Location = "Server",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local Input = module.API.sendModalToPlayer(Client, "What's the message?").Event:Wait()

<<<<<<< HEAD
		if not Input then return false end
=======
		if Input == false then
			return false
		end
>>>>>>> 1ad486a6a581821bc1221b272946191f770ff14b

		local Status
		Status, Input = module.API.filterText(Client, Input)

		if Status then
			module.API.Players.message("all", Client.Name, Input)
			return true
		else
			module.API.Players.hint(Client, "System", "Your message to \"" .. tostring(Attachment) .. "\" failed to deliver, please retry later")
		end
		return false
	end
end

return module
