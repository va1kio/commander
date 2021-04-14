local module = {}
local Services = require(script.Parent.Parent.Parent.Services)

function module.getPlayerWithName(Name: string)
	for _,v in pairs(Services.Players:GetPlayers()) do
		if string.lower(v.Name) == string.lower(Name) then
			return v
		end
	end
end

function module.getPlayerWithId(Id: number)
	for _,v in pairs(Services.Players:GetPlayers()) do
		if v.UserId == id then
			return v
		end
	end
end

function module.getCharacter(Player: player)
	if Player.Character and Player.Character.PrimaryPart and Player.Character:FindFirstChildOfClass("Humanoid") then
		return Player.Character
	end
end

function module.doThisToPlayer(Client: player?, Player: player, Callback)
	-- TODO: Rewrite the current method so it will support execution even without a client parameter, allowing packages to be more flexible
end

function module.sendMessage(Player: player, From: string, Content: string)
	
end

function module.sendNotification(Player: player, From: string, Content: string, Image: string?)
	
end

function module.sendHint(Player: player, From: string, Content: string, Color: color3?)
	
end