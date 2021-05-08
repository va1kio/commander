local module = {
	Name = "Unmute",
	Description = "Unmutes a player from chatting",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local player = module.API.getPlayerWithName(Attachment)
		if player then
            module.API.Players.hint(player, "System", "You have been unmuted by " .. Client.name)
            module.Remotes.Event:FireClient(player, "setCoreGuiEnabled", 'n/a', {["Type"] = Enum.CoreGuiType.Chat, ["Status"] = true})
			return true
		end
		return false
	end
end

return module