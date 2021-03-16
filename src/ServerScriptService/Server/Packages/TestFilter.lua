local module = {
	Name = "Test filter",
	Description = "Test whether your message will be filitered or not" ,
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local Input = module.API.sendModalToPlayer(Client, "What's the message?").Event:Wait()
		
		if not Input then return end

		local Status
		Status, Input = module.API.filterText(Client, Input)
		
		if Status then
			module.Remotes.Event:FireClient(Client, "newMessage", "", {From = "System; TestFilter", Content = "Your message has been filitered, here's the result:\n" .. Input})
			return true
		else
			module.Remotes.Event:FireClient(Client, "newMessage", "", {From = "System; TestFilter", Content = "Your message \"" .. tostring(Attachment) .. "\" failed to filitered, please retry later."})
		end
	end
end

return module
