local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local GroupService = game:GetService("GroupService")

-- TODO: Update group cache over interval?
local module = {}
local t = {}
local groupCache = {}

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
			for _, v in ipairs(Players:GetPlayers()) do
				Callback(v)
			end
		elseif Player == "others" then
			for _, v in ipairs(Players:GetPlayers()) do
				if v ~= Client then
					Callback(v)
				end
			end
		elseif Player == "me" then
			Callback(Client)
		elseif Player == "admins" or Player == "nonadmins" then
			for _, v in ipairs(Players:GetPlayers()) do
				local isAdmin = module.checkAdmin(v.UserId)
				if Player == "admins" and isAdmin or Player == "nonadmins" and not isAdmin then
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
	
	if string.match(Player, ",") then
		for PlayerName in string.gmatch(Player, "([^,]+)(,? ?)") do
			runOnName(PlayerName)
		end
	else
		runOnName(Player)
	end

	return true
end

function module.getPlayerWithName(Player: string)
	for _, v in ipairs(Players:GetPlayers()) do
		if string.lower(v.Name) == string.lower(Player) then
			return v
		end
	end
end

function module.getPlayerWithNamePartial(Player: string)
	for _, v in ipairs(Players:GetPlayers()) do
		if string.lower(string.sub(v.Name, 1, #Player)) == string.lower(Player) then
			return v;
		end
	end
end

function module.getPlayerWithFilter(filter: (Instance) -> boolean)
	for _, v in ipairs(Players:GetPlayers()) do
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
	table.insert(t, Function)
end

function module.filterText(From: player, Content: string)
	local success, result = pcall(TextService.FilterStringAsync, TextService, Content, From.UserId)
	if success and result then
		result = result:GetNonChatStringForBroadcastAsync()
	end
			
	return success, result
end

function module.newMessage(To: player|string, From: string, Content: string, Duration: number?)
	if tostring(To):lower() == "all" then
		module.Remotes.Event:FireAllClients("newMessage", "", {["From"] = From, ["Content"] = Content, ["Duration"] = Duration or 5})
	else
		module.Remotes.Event:FireClient(player, "newMessage", "", {["From"] = From, ["Content"] = Content, ["Duration"] = Duration or 5})
	end
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

	for i, v in pairs(module.Settings.Admins) do
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
			if string.match(i, "(%d+):([<>]?)(%d+)") then
				-- Group setting.
				-- Formatted as groupId:[<>]?rankId.
				-- "<" / ">" signifies if the user rank should be
				-- less than or greater than the rank (inclusive).
				-- If no "<" or ">" is provided it must be an exact match.
				local groupId, condition, rankId = string.match(i, "(%d+):([<>]?)(%d+)");
				local playerGroups = groupCache[ClientId] or GroupService:GetGroupsAsync(ClientId) or {};
				local selectedGroup;

				if playerGroups and not groupCache[ClientId] then
					groupCache[ClientId] = playerGroups
				end

				for _, y in ipairs(playerGroups) do
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
		elseif type(i) == "number" then
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
	for _, v in ipairs(Players:GetPlayers()) do
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

local function containsDisallowed(tbl)
	for _, v in ipairs(tbl) do
		if type(v) == "table" or typeof(v) == "userdata" or type(v) == "function" or type(v) == "thread" then
			return true
		end
	end
end

local function sandboxFunc(func)
	local function returnResults(success, ...)
		return success and (not containsDisallowed({...}) and ... or "API returned disallowed arguments. Vulnerability?") or "An error occured."
	end

	return function(...)
		if containsDisallowed({...}) then
			return "Disallowed input!"
		end

		return returnResults(pcall(func, ...))
	end
end

local function makeBindable(func)
	local Bindable = Instance.new("BindableFunction")
	Bindable.OnInvoke = sandboxFunc(func)
	return Bindable
end

local globalAPI = setmetatable({
	checkHasPermission = makeBindable(module.checkHasPermission),
	checkAdmin = makeBindable(module.checkAdmin),
	getAdminLevel = makeBindable(module.getAdminLevel),
	getAvailableAdmins = makeBindable(module.getAvailableAdmins)
}, {
	__metatable = "This table is read only.",
	__newindex = function() return end
})

rawset(_G, "CommanderAPI", globalAPI)

Players.PlayerAdded:Connect(function(Client)
	for _, v in ipairs(t) do
		pcall(v, Client)
	end
end)

return module
