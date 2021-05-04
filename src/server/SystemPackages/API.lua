local module = {}
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local GroupService = game:GetService("GroupService")

-- TODO: Update group cache over interval?
local isFirstTime = true
local API = {}
local globalAPI
local t = {}
local groupCache = {}
API.Players = {
	["OldMethods"] = {
		["sendModalToPlayer"] = "sendModal",
		["sendListToPlayer"] = "sendList",
		["doThisToPlayers"] = "executeWithPrefix",
		["getPlayerWithName"] = "getPlayerByName",
		["getPlayerWithNamePartial"] = "getPlayerByNamePartial",
		["getPlayerWithFilter"] = "getPlayerWithFilter",
		["getUserIdWithName"] = "getUserIdFromName",
		["getCharacter"] = "getCharacter",
		["filterText"] = "filterString",
		["newMessage"] = "message",
		["newHint"] = "hint",
		["newNotify"] = "notify",
		["newNotifyWithAction"] = "notifyWithAction",
		["checkHasPermission"] = "checkPermission",
		["checkAdmin"] = "getAdminStatus",
		["getAdminLevel"] = "getAdminLevel",
		["getAdmins"] = "getAdmins",
		["getAvailableAdmins"] = "getAvailableAdmins",
		["registerPlayerAddedEvent"] = "listenToPlayerAdded",
	}
}
API.Core = {}

local function containsDisallowed(tbl)
	local allowedTypes = {"table", "function", "thread"}
	for _, value in ipairs(tbl) do
		return typeof(value) == "userdata" or allowedTypes[type(value)] ~= nil
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
	Bindable.OnInvoke = not table.find(module, func) and func or sandboxFunc(func)
	return Bindable
end

function API.Players.sendModal(Player: player, Title: string?): bindableevent
	local Bindable = Instance.new("BindableEvent")
	local GUID = HttpService:GenerateGUID()
	Bindable.Name = GUID
	module.Remotes.Event:FireClient(Player, "modal", GUID, Title or "Input required")
	Bindable.Parent = script.Parent.Parent.Bindables
	
	return Bindable
end

function API.Players.sendList(Player: player, Title: string, Attachment)
	module.Remotes.Event:FireClient(Player, "newList", Title, Attachment)
end

function API.Players.GetPlayersFromNameSelector(Client: player, Player: string)
	local playerList = {}
	Player = string.lower(Player)
	local clientAdminLevel = API.Players.getAdminLevel(Client.UserId)

	if clientAdminLevel
	and module.DisableTable[clientAdminLevel]
	and module.DisableTable[clientAdminLevel][Player] == true then
		return false
	end

	local function getWithName(Player)
		local prefixes = {
			["all"] = function()
				for _, player in ipairs(Players:GetPlayers()) do
					table.insert(playerList, player)
				end
			end,

			["others"] = function()
				for _, player in ipairs(Player:GetPlayers()) do
					if player ~= Client then
						table.insert(playerList, player)
					end
				end
			end,

			["me"] = function()
				table.insert(playerList, Client)
			end,

			["admins"] = function()
				for _, player in ipairs(Players:GetPlayers()) do
					if API.Players.getAdminStatus(player.UserId) then
						table.insert(playerList, player)
					end
				end
			end,

			["nonadmins"] = function()
				for _, player in ipairs(Players:GetPlayers()) do
					if not API.Players.getAdminStatus(player.UserId) then
						table.insert(playerList, player)
					end
				end
			end,

			["random"] = function()
				table.insert(playerList, Players:GetPlayers()[math.random(1, #Players:GetPlayers())])
			end
		}

		if prefixes[tostring(Player)] then
			prefixes[tostring(Player)]()
		else
			table.insert(playerList, API.Players.getPlayerByName(Player))
		end
	end

	if string.match(Player, ",") then
		for PlayerName in string.gmatch(Player, "([^,]+)(,? ?)") do
			getWithName(PlayerName)
		end
	else
		getWithName(Player)
	end

	return #playerList > 0 and playerList or nil
end

function API.Players.executeWithPrefix(Client: player, Player: string, Callback)
	Player = string.lower(Player)
	local clientAdminLevel = API.Players.getAdminLevel(Client.UserId)

	if clientAdminLevel
	and module.DisableTable[clientAdminLevel]
	and module.DisableTable[clientAdminLevel][Player] == true then
		return false
	end
	
	local List = API.Players.GetPlayersFromNameSelector(Client, Player)

	if List then
		for _, v in ipairs(List) do
			Callback(v)
		end
		return true
	else
		return false
	end
end

function API.Players.getPlayerByName(Player: string)
	for _, v in ipairs(Players:GetPlayers()) do
		if string.lower(v.Name) == string.lower(Player) then
			return v
		end
	end
end

function API.Players.getPlayerByNamePartial(Player: string)
	for _, v in ipairs(Players:GetPlayers()) do
		if string.lower(string.sub(v.Name, 1, #Player)) == string.lower(Player) then
			return v;
		end
	end
end

function API.Players.getPlayerWithFilter(filter: (Instance) -> boolean)
	for _, v in ipairs(Players:GetPlayers()) do
		if filter(v) == true then
			return v;
		end
	end
end

function API.Players.getUserIdFromName(Player: string)
	local success, result = pcall(Players.GetUserIdFromNameAsync, Players, Player)
	return result
end

function API.Players.listenToPlayerAdded(Function)
	table.insert(t, Function)
	for _, client in ipairs(Players:GetPlayers()) do
		pcall(Function, client)
	end 
end

function API.Players.filterString(From: player, Content: string)
	if not utf8.len(Content) then -- Prevents invalid UTF8 from being sent to oddly behaving UTF8 from being sent
		return false, ""
	end

	if RunService:IsStudio() then return true, Content end

	local success, result = pcall(TextService.FilterStringAsync, TextService, Content, From.UserId)
	if success and result then
		result = result:GetNonChatStringForBroadcastAsync()
	end

	return success, result
end

function API.Players.message(To: player|string, From: string, Content: string, Duration: number?, Sound: number?)
	local attachment = {["From"] = From, ["Content"] = Content, ["Duration"] = Duration, ["Sound"] = Sound or module.Settings.UI.AlertSound}
	if tostring(To):lower() == "all" then
		module.Remotes.Event:FireAllClients("newMessage", "", attachment)
	else
		module.Remotes.Event:FireClient(To, "newMessage", "", attachment)
	end
end

function API.Players.hint(To: player|string, From: string, Content: string, Duration: number?, Sound: number?)
	local attachment = {["From"] = From, ["Content"] = Content, ["Duration"] = Duration, ["Sound"] = Sound or module.Settings.UI.AlertSound}
	if tostring(To):lower() == "all" then
		module.Remotes.Event:FireAllClients("newHint", "", attachment)
	else
		module.Remotes.Event:FireClient(To, "newHint", "", attachment)
	end
end

function API.Players.notify(To: player|string, From: string, Content: string, Sound: number?)
	local attachment = {["From"] = From, ["Content"] = Content, ["Sound"] = Sound or module.Settings.UI.AlertSound}
	if tostring(To):lower() == "all" then
		module.Remotes.Event:FireAllClients("newNotify", "", attachment)
	else
		module.Remotes.Event:FireClient(To, "newNotify", "", attachment)
	end
end

function API.Players.notifyWithAction(To: player|string, Type, From: string, Content: string, Sound: number?)
	local Bindable = Instance.new("BindableEvent")
	local GUID = HttpService:GenerateGUID()
	local attachment = {["From"] = From, ["Content"] = Content, ["Sound"] = Sound or module.Settings.UI.AlertSound}
	Bindable.Name = GUID
	
	if tostring(To):lower() == "all" then
		module.Remotes.Event:FireAllClients("newNotifyWithAction", {["Type"] = Type, ["GUID"] = GUID}, attachment)
	else
		module.Remotes.Event:FireClient(To, "newNotifyWithAction", {["Type"] = Type, ["GUID"] = GUID}, attachment)
	end
	
	Bindable.Parent = script.Parent.Parent.Bindables
	return Bindable
end

function API.Players.checkPermission(ClientId: number, Command: string)
	local clientAdminLevel = API.Players.getAdminLevel(ClientId)

	if not clientAdminLevel or not module.PermissionTable[clientAdminLevel] then
		return false
	end

	return (module.PermissionTable[clientAdminLevel][Command] == true
		or module.PermissionTable[clientAdminLevel]["*"] == true)
end

function API.Players.getAdminStatus(ClientId: number)
	for _, player in ipairs(Players:GetPlayers()) do
		return player.UserId == ClientId and CollectionService:HasTag(player, "commander.admins")
	end
	
	return API.Players.getAdminLevel(ClientId) ~= nil
end

function API.Players.getAdminLevel(ClientId: number)
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

function API.Players.getAdmins()
	return module.Settings.Admins
end

function API.Players.getAvailableAdmins()
	local availableAdmins = 0
	for _, v in ipairs(Players:GetPlayers()) do
		if API.Players.getAdminStatus(v.UserId) then
			availableAdmins += 1
		end
	end

	return availableAdmins
end

function API.Players.getCharacter(Player: player)
	if Player and Player.Character and Player.Character.PrimaryPart and Player.Character:FindFirstChildOfClass("Humanoid") then
		return Player.Character
	end
end

function API.Players.setTransparency(Character: model, Value: number)
	for _, object in ipairs(Character:GetDescendants()) do
		if object:IsA("BasePart") or object:IsA("Decal")or object:IsA("Texture") then
			object.Transparency = Value
		end
	end
end

function API.Core.getDataStore(Name: string, Scope: string?)
	local object = {}
	object.__index = object
	function object:get(Key: string)
		return module.Services.Promise.new(function(Resolve, Reject)
			local status, response = pcall(self._object.GetAsync, self._object, Key)

			if status then
				Resolve(response)
			else
				Reject(response)
			end
		end)
	end

	function object:set(Key: string, Data: any)
		return module.Services.Promise.new(function(Resolve, Reject)
			local status, response = pcall(self._object.SetAsync, self._object, Key, Data)

			if status then
				Resolve(response)
			else
				Reject(response)
			end
		end)
	end

	function object:increment(Key: string, Delta: number, UserIds: array, Options: instance)
		return module.Services.Promise.new(function(Resolve, Reject)
			local status, response = pcall(self._object.IncrementAsync, self._object, Key, Delta, UserIds, Options)

			if status then
				Resolve(response)
			else
				Reject(response)
			end
		end)
	end

	function object:update(Key: string, Transformer: (string) -> void)
		return module.Services.Promise.new(function(Resolve, Reject)
			local status, response = pcall(self._object.RemoveAsync, self._object, Key, Transformer)

			if status then
				Resolve(response)
			else
				Reject(response)
			end
		end)
	end

	function object:remove(Key: string)
		return module.Services.Promise.new(function(Resolve, Reject)
			local status, response = pcall(self._object.RemoveAsync, self._object, Key)

			if status then
				Resolve(response)
			else
				Reject(response)
			end
		end)
	end

	return module.Services.Promise.new(function(Resolve, Reject)
		local status, response = pcall(module.Services.DataStoreService.GetDataStore, module.Services.DataStoreService, Name, Scope)
		if status then
			local newMeta = setmetatable({
				_object = response
			}, object)

			Resolve(newMeta)
		else
			Reject(response)
		end
	end)
end

module = setmetatable({}, {
	__index = function(self, key: string)
		if API.Players.OldMethods[key] then
			return API.Players[API.Players.OldMethods[key]]
		else
			return API[key]
		end
	end,
	__metatable = "The metatable is locked"
})

globalAPI = setmetatable({
	checkHasPermission = makeBindable(sandboxFunc(module.Players.checkHasPermission)),
	checkAdmin = makeBindable(sandboxFunc(module.Players.checkAdmin)),
	getAdminLevel = makeBindable(sandboxFunc(module.Players.getAdminLevel)),
	getAvailableAdmins = makeBindable(sandboxFunc(module.Players.getAvailableAdmins)),
	GetPlayersFromNameSelector = makeBindable(sandboxFunc(module.Players.GetPlayersFromNameSelector)),
	getAdminStatus = makeBindable(sandboxFunc(module.Players.getAdminStatus)),
	getAdmins = makeBindable(function()
		local Tbl = {}
		for k, v in pairs(module.Players.getAdmins()) do
			Tbl[k] = v
		end
		return setmetatable(Tbl, {__metatable = "The metatable is locked"})
	end)
}, {
	__metatable = "The metatable is locked",
	__newindex = function() error("Attempt to modify a readonly table", 2) end
})

Players.PlayerAdded:Connect(function(Client)
	for _, callback in ipairs(t) do
		pcall(callback, Client)
	end
end)

rawset(_G, "CommanderAPI", globalAPI)
return module
