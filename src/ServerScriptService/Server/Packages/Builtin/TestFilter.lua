local module = {
	Name = "Test filter",
	Description = "Test whether your message will be filitered or not" ,
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
			module.Remotes.Event:FireClient(Client, "newMessage", "", {From = "System; TestFilter", Content = "Your message has been filtered, here's the result:\n" .. Input})
			return true
		else
			module.Remotes.Event:FireClient(Client, "newMessage", "", {From = "System; TestFilter", Content = "Your message \"" .. tostring(Attachment) .. "\" failed to filter, please retry later."})
		end
		return false
	end
end

return module
