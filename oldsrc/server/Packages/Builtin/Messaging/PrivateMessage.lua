local module = {
	Name = "Private message",
	Description = "Send a message to a specific player, others or all and allow then to reply" ,
	Location = "Player",
}

function process(From, Type, To, Content)
	local response = module.API.Players.notifyWithAction(To, Type, From.Name, Content).Event:Wait()
	if type(response) == "string" then
		local status, response = module.API.filterText(From, response)
		process(To, Type, From, response)
	end
end

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local Input = module.API.sendModalToPlayer(Client, "What's the message?").Event:Wait()
		
		if Input == false then
			return false
		end

		local Status
		Status, Input = module.API.filterText(Client, Input)
		
		if Status then
			module.API.doThisToPlayers(Client, Attachment, function(Player)
				coroutine.wrap(function()
					process(Client, "Reply", Player, Input)
				end)()
			end)
			return true
		else
			module.API.Players.hint(Client, "System", "Your message to \"" .. tostring(Attachment) .. "\" failed to deliver, please retry later")
		end
		return false
	end
end

return module