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

function module.doThisToPlayers(Client: player, Player: player, Callback)
	Player = string.lower(Player)

	local clientAdminLevel = module.getAdminLevel(Client.UserId)

	if clientAdminLevel
	and module.DisableTable[clientAdminLevel]
	and module.DisableTable[clientAdminLevel][Player] == true then
		return false
	end

	local function runOnName(Player)
		if Player == "all" then
			for _, v in pairs(Players:GetPlayers()) do
				Callback(v)
			end
		elseif Player == "others" then
			for _, v in pairs(Players:GetPlayers()) do
				if v ~= Client then
					Callback(v)
				end
			end
		elseif Player == "me" or Player == "" then
			Callback(Client)
		elseif Player == "admins" or Player == "nonadmins" then
			for _, v in pairs(Players:GetPlayers()) do
				if Player == "admins" and module.checkAdmin(v.UserId) or Player == "nonadmins" then
					Callback(v)
				end
			end
		elseif Player == "random" then
			Callback(Players:GetPlayers()[math.random(1, #Players:GetPlayers())])
		else
			Player = module.getPlayerWithName(Player)
			if Player then
				Callback(Player)
			end
		end
	end
	
	if string.match(",", Player) then
		local i = 0
		for Player in string.gmatch(Player, "[^,]+,") do
			i += string.len(Player)
			runOnName(string.sub(Player1, string.len(Player) - 1))
		end
		runOnName(string.sub(Player, i + 1, string.len(Player)))
	else
		runOnName(Player)
	end

	return true
end

function module.getPlayerWithName(Player: string)
	for i,v in pairs(Players:GetPlayers()) do
		if v.Name:lower() == Player:lower() then
			return v
		end
	end
end

function module.getPlayerWithNamePartial(Player: string)
	for i,v in ipairs(Players:GetPlayers()) do
		if v.Name:sub(1, #Player):lower() == Player:lower() then
			return v;
		end
	end
end

function module.getPlayerWithFilter(filter: (Instance) -> boolean)
	for i,v in ipairs(Players:GetPlayers()) do
		if filter(v) == true then
			return v;
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
		result = result:GetNonChatStringForBroadcastAsync()
	end
			
	return success, result
end

function module.checkHasPermission(ClientId: number, Command: string)
	local clientAdminLevel = module.getAdminLevel(ClientId)

	if not clientAdminLevel or not module.PermissionTable[clientAdminLevel] then
		return false
	end

	return (module.PermissionTable[clientAdminLevel][Command] == true
		or module.PermissionTable[clientAdminLevel]["*"] == true)
end

function module.checkAdmin(ClientId: number)
	return module.getAdminLevel(ClientId) ~= nil
end

function module.getAdminLevel(ClientId: number)
	local highestPriority, permissionGroupId = -math.huge, nil;

	for i,v in pairs(module.Settings.Admins) do
		local permissionGroup = module.Settings.Permissions[v]

		-- If permission group is invalid or group has
		-- lower priority than a group that the user has
		-- continue.
		if permissionGroup == nil
			or permissionGroup.Priority == nil
			or permissionGroup.Priority < highestPriority then
			continue
		end

		-- Whether or not user matches the role.
		local isInGroup = false

		if typeof(i) == "string" then
			if i:match("(%d+):([<>]?)(%d+)") then
				-- Group setting.
				-- Formatted as groupId:[<>]?rankId.
				-- "<" / ">" signifies if the user rank should be
				-- less than or greater than the rank (inclusive).
				-- If no "<" or ">" is provided it must be an exact match.
				local groupId, condition, rankId = i:match("(%d+):([<>]?)(%d+)");
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
					continue
				end

				local difference = selectedGroup.Rank - tonumber(rankId);
				
				if (condition == "" and difference == 0)
					or (condition == ">" and difference >= 0)
					or (condition == "<" and difference <= 0) then
					isInGroup = true
				end
			else
				local success, result = pcall(Players.GetUserIdFromNameAsync, Players, i)

				if success and ClientId == result then
					isInGroup = true
				end
			end
		elseif typeof(i) == "number" then
			if ClientId == i then
				isInGroup = true
			end
		end

		-- Player is in this role.
		if isInGroup == true then
			highestPriority = permissionGroup.Priority
			permissionGroupId = v
		end
	end

	return permissionGroupId
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
