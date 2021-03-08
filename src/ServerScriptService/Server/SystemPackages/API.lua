local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local GroupService = game:GetService("GroupService")

local module = {}
local t = {}

function module.sendModalToPlayer(Player: player, Title: string)
	local Bindable = Instance.new("BindableEvent")
	local GUID = HttpService:GenerateGUID()
	Bindable.Name = GUID
	module.Remotes.Event:FireClient(Player, "modal", GUID, Title)
	Bindable.Parent = script.Parent.Parent.Bindables

	return Bindable
end

function module.sendListToPlayer(Player: player, Title: string, Attachment)
	module.Remotes.Event:FireClient(Player, "newList", Title, Attachment)
end

function module.doThisToPlayers(Client: player, Player: string, Callback)
	if string.lower(Player) == "all" then
		for i,v in pairs(Players:GetPlayers()) do
			Callback(v)
		end
	elseif string.lower(Player) == "others" then
		for i,v in pairs(Players:GetPlayers()) do
			if v ~= Client then
				Callback(v)
			end
		end
	elseif string.lower(Player) == "random" then
		Callback(Players:GetPlayers()[math.random(1, #Players:GetPlayers())])
	else
		Player = module.getPlayerWithName(Player)
		if Player then
			Callback(Player)
		end
	end
end

function module.getPlayerWithName(Player: string)
	for i,v in pairs(Players:GetPlayers()) do
		if v.Name:lower() == Player:lower() then
			return v
		end
	end
end

function module.getUserIdWithName(Player: string)
	local success, result = pcall(Players.GetUserIdFromNameAsync, Players, Player)
	return result
end

function module.registerPlayerAddedEvent(Function)
	t[#t + 1] = Function
end

function module.filterText(From: player, Content: string)
	local success, result = pcall(TextService.FilterStringAsync, TextService, Content, From.UserId)
	if success and result then
		return true, result:GetNonChatStringForBroadcastAsync()
	else
		warn(tostring(result))
		return false, result
	end
end

function module.checkAdmin(ClientId: number)
	for i,v in pairs(module.Settings.Admins) do
		if typeof(v) == "string" then
			if v:match("(%d+):([<>]?)(%d+)") then
				-- Group setting.
				-- Formatted as groupId:[<>]?rankId.
				-- "<" / ">" signifies if the user rank should be
				-- less than or greater than the rank (inclusive).
				-- If no "<" or ">" is provided it must be an exact match.
				local groupId, condition, rankId = v:match("(%d+):([<>]?)(%d+)");
				local playerGroups = GroupService:GetGroupsAsync(ClientId) or {};
				local selectedGroup;

				for x,y in ipairs(playerGroups) do
					if y.Id == tonumber(groupId) then
						selectedGroup = y;
						break;
					end
				end

				-- Player not in group or error occurred with Roblox API.
				if selectedGroup == nil then
					return false;
				end

				local difference = selectedGroup.Rank - tonumber(rankId);

				if (condition == "" and difference == 0)
					or (condition == ">" and difference >= 0)
					or (condition == "<" and difference <= 0) then
					return true;
				end
			else
				local success, result = pcall(Players.GetUserIdFromNameAsync, Players, v)
				if success and ClientId == result then
					return true
				end
			end
		elseif typeof(v) == "number" then
			if ClientId == v then
				return true
			end
		end
	end
end

function module.getAdmins()
	return module.Settings.Admins
end

function module.getAvailableAdmins()
	local availableAdmins = 0
	for i,v in pairs(Players:GetPlayers()) do
		if module.checkAdmin(v.UserId) then
			availableAdmins += 1
		end
	end

	return availableAdmins
end

function module.getCharacter(Player: player)
	if Player.Character and Player.Character.PrimaryPart and Player.Character:FindFirstChildOfClass("Humanoid") then
		return Player.Character
	end
end

coroutine.wrap(function()
	Players.PlayerAdded:Connect(function(Client)
		for i,v in pairs(t) do
			pcall(v, Client)
		end
	end)
end)()

return module
