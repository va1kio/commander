local module = {
	Name = "Respawn",
	Description = "Respawns a player",
	Location = "Player",
}

local Players = game:GetService("Players")

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local Player = module.API.getPlayerWithName(Attachment)
		if not (Players.CharacterAutoLoads and not Player.Character) then
			Player:LoadCharacter()
			return true
		end
	end
end

return module
