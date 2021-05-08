local module = {
	Name = "Mute",
	Description = "Mutes a player from chatting",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local player = module.API.getPlayerWithName(Attachment)
		if player then
            module.API.Players.hint(player, "System", "You have been muted by " .. Client.name)
            module.Remotes.Event:FireClient(player, "setCoreGuiEnabled", 'n/a', {["Type"] = Enum.CoreGuiType.Chat, ["Status"] = false})
			return true
		end
		return false
	end
end

return module
