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

local function ContainsDisallowed(Input)
	local allowedTypes = {"table", "function", "thread"}
	for _, value in ipairs(Input) do
		return typeof(value) == "userdata" or allowedTypes[type(value)] ~= nil
	end
end

local function IsolateFunction(Function)
	local function ReturnResults(Success: boolean, ...)
		return Success and (not ContainsDisallowed({...}) and ... or "API returned disallowed arguments. Vulnerability?") or "An error occured."
	end

	return function(...)
		if ContainsDisallowed({...}) then
			return "Disallowed input!"
		end

		return ReturnResults(pcall(Function, ...))
	end
end

local function WrapInPCall(Function, ...)
	local success, response = pcall(Function, ...)
	local tries = 0
	while not success and tries < 3 do
		success, response = pcall(Function, ...)
	end
	
	return success, response
end

local function MakeBindable(Function)
	local Bindable = Instance.new("BindableFunction")
	Bindable.OnInvoke = not table.find(module, Function) and Function or IsolateFunction(Function)
	return Bindable
end

function API.Players.SendModal(Player: player, Title: string?): bindableevent
	local Bindable = Instance.new("BindableEvent")
	local GUID = HttpService:GenerateGUID()
	Bindable.Name = GUID
	module.Remotes.Event:FireClient(Player, "modal", GUID, Title or "Input required")
	Bindable.Parent = script.Parent.Parent.Bindables
	
	return Bindable
end

function API.Players.SendList(Player: player, Title: string, Attachment)
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

	local function GetWithName(Player)
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
			GetWithName(PlayerName)
		end
	else
		GetWithName(Player)
	end

	return #playerList > 0 and playerList or nil
end

function API.Players.ExecuteWithPrefix(Client: player, Player: string, Callback)
	Player = string.lower(Player)
	local clientAdminLevel = API.Players.GetAdminLevel(Client.UserId)

	if clientAdminLevel
	and module.DisableTable[clientAdminLevel]
	and module.DisableTable[clientAdminLevel][Player] == true then
		return false
	end
	
	local List = API.Players.GetPlayersFromNameSelector(Client, Player)

	if List then
		for _, client in ipairs(List) do
			Callback(client)
		end
		return true
	else
		return false
	end
end

function API.Players.GetPlayerByName(Player: string)
	for _, client in ipairs(Players:GetPlayers()) do
		if string.lower(client.Name) == string.lower(Player) then
			return client
		end
	end
end

function API.Players.GetPlayerByUserId(Player: number)
	for _, client in ipairs(Players:GetPlayers()) do
		if client.UserId == Player then
			return client
		end
	end
end

function API.Players.GetPlayerByNamePartial(Player: string)
	for _, client in ipairs(Players:GetPlayers()) do
		if string.lower(string.sub(client.Name, 1, #Player)) == string.lower(Player) then
			return client
		end
	end
end

function API.Players.GetPlayerWithFilter(Filter: (Instance) -> boolean)
	for _, client in ipairs(Players:GetPlayers()) do
		if Filter(client) == true then
			return client
		end
	end
end

function API.Players.GetUserIdFromName(Player: string)
	local success, result = WrapInPCall(Players.GetUserIdFromNameAsync, Players, Player)
	if not success then
		error("Commander; GetUserIdFromName errored: " .. result)
	end
	
	return result
end

function API.Players.ListenToPlayerAdded(Function)
	table.insert(t, Function)
	for _, client in ipairs(Players:GetPlayers()) do
		pcall(Function, client)
	end 
end

function API.Players.FilterString(From: player, Content: string)
	if not utf8.len(Content) then -- Prevents invalid UTF8 from being sent to oddly behaving UTF8 from being sent
		return false, ""
	end

	if RunService:IsStudio() then return true, Content end

	local success, result = WrapInPCall(TextService.FilterStringAsync, TextService, Content, From.UserId)
	if success and result then
		result = result:GetNonChatStringForBroadcastAsync()
	end

	return success, result
end

function API.Players.Message(To: player|string, From: string, Content: string, Duration: number?, Sound: number?)
	local attachment = {["From"] = From, ["Content"] = Content, ["Duration"] = Duration, ["Sound"] = Sound or module.Settings.UI.AlertSound}
	if tostring(To):lower() == "all" then
		module.Remotes.Event:FireAllClients("newMessage", "", attachment)
	else
		module.Remotes.Event:FireClient(To, "newMessage", "", attachment)
	end
end

function API.Players.Hint(To: player|string, From: string, Content: string, Duration: number?, Sound: number?)
	local attachment = {["From"] = From, ["Content"] = Content, ["Duration"] = Duration, ["Sound"] = Sound or module.Settings.UI.AlertSound}
	if tostring(To):lower() == "all" then
		module.Remotes.Event:FireAllClients("newHint", "", attachment)
	else
		module.Remotes.Event:FireClient(To, "newHint", "", attachment)
	end
end

function API.Players.Notify(To: player|string, From: string, Content: string, Sound: number?)
	local attachment = {["From"] = From, ["Content"] = Content, ["Sound"] = Sound or module.Settings.UI.AlertSound}
	if tostring(To):lower() == "all" then
		module.Remotes.Event:FireAllClients("newNotify", "", attachment)
	else
		module.Remotes.Event:FireClient(To, "newNotify", "", attachment)
	end
end

function API.Players.NotifyWithAction(To: player|string, Type, From: string, Content: string, Sound: number?)
	local bindable = Instance.new("BindableEvent")
	local guid = HttpService:GenerateGUID()
	local attachment = {["From"] = From, ["Content"] = Content, ["Sound"] = Sound or module.Settings.UI.AlertSound}
	Bindable.Name = guid
	
	if tostring(To):lower() == "all" then
		module.Remotes.Event:FireAllClients("newNotifyWithAction", {["Type"] = Type, ["GUID"] = guid}, attachment)
	else
		module.Remotes.Event:FireClient(To, "newNotifyWithAction", {["Type"] = Type, ["GUID"] = guid}, attachment)
	end
	
	bindable.Parent = script.Parent.Parent.Bindables
	return bindable
end

function API.Players.CheckPermission(ClientId: number, Command: string)
	local clientAdminLevel = API.Players.GetAdminLevel(ClientId)

	if not clientAdminLevel or not module.PermissionTable[clientAdminLevel] then
		return false
	end

	return (module.PermissionTable[clientAdminLevel][Command] == true
		or module.PermissionTable[clientAdminLevel]["*"] == true)
end

function API.Players.GetAdminStatus(ClientId: number)
	for _, player in ipairs(Players:GetPlayers()) do
		if player.UserId == ClientId and CollectionService:HasTag(player, "commander.admins") then
			return true
		elseif player.UserId == ClientId and CollectionService:HasTag(player, "commander.fetched") then
			return false
		elseif API.Players.GetAdminLevel(ClientId) ~= nil then
			CollectionService:AddTag(player, "commander.admins")
			return true
		end
	end
	
	return API.Players.getAdminLevel(ClientId) ~= nil
end

function API.Players.GetAdminLevel(ClientId: number)
	local highestPriority, permissionGroupId = -math.huge, nil;

	for name, permission in pairs(module.Settings.Admins) do
		local permissionGroup = module.Settings.Permissions[permission]

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

		if typeof(name) == "string" then
			if string.match(i, "(%d+):([<>]?)(%d+)") then
				-- Group setting.
				-- Formatted as groupId:[<>]?rankId.
				-- "<" / ">" signifies if the user rank should be
				-- less than or greater than the rank (inclusive).
				-- If no "<" or ">" is provided it must be an exact match.
				local groupId, condition, rankId = string.match(name, "(%d+):([<>]?)(%d+)")
				local success, playerGroups
				local selectedGroup
				
				if groupCache[ClientId] then
					success = true
					playerGroups = groupCache[ClientId]
				else
					success, playerGroups = WrapInPCall(GroupService.GetGroupsAsync, GroupService, ClientId)
				end
				
				if not success then
					-- I know this is such a bad naming for errors...
					error("Commander; GetAdminLevel errored: " .. playerGroups)
				elseif not playerGroups then
					playerGroups = {}
				end

				if playerGroups and not groupCache[ClientId] then
					groupCache[ClientId] = playerGroups
				end

				for _, group in ipairs(playerGroups) do
					if group.Id == tonumber(groupId) then
						selectedGroup = group
						break
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
				local success, result = WrapInPCall(Players.GetUserIdFromNameAsync, Players, name)

				if success and ClientId == result then
					isInGroup = true
				end
			end
		elseif type(name) == "number" then
			if ClientId == name then
				isInGroup = true
			end
		end

		-- Player is in this role.
		if isInGroup == true then
			highestPriority = permissionGroup.Priority
			permissionGroupId = permission
		end
	end

	return permissionGroupId
end

function API.Players.GetAdmins()
	return module.Settings.Admins
end

function API.Players.GetAvailableAdmins()
	local availableAdmins = 0
	for _, player in ipairs(Players:GetPlayers()) do
		if API.Players.GetAdminStatus(player.UserId) then
			availableAdmins += 1
		end
	end

	return availableAdmins
end

function API.Players.GetCharacter(Player: player)
	if Player and Player.Character and Player.Character.PrimaryPart and Player.Character:FindFirstChildOfClass("Humanoid") then
		return Player.Character
	end
end

function API.Players.SetTransparency(Character: model, Value: number)
	for _, object in ipairs(Character:GetDescendants()) do
		if object:IsA("BasePart") or object:IsA("Decal")or object:IsA("Texture") then
			object.Transparency = Value
		end
	end
end

function API.Core.GetDataStore(Name: string, Scope: string?)
	local object = {}
	object.__index = object
	function object:Get(Key: string)
		return module.Services.Promise.new(function(Resolve, Reject)
			local status, response = pcall(self._object.GetAsync, self._object, Key)

			if status then
				Resolve(response)
			else
				Reject(response)
			end
		end)
	end

	function object:Set(Key: string, Data: any)
		return module.Services.Promise.new(function(Resolve, Reject)
			local status, response = pcall(self._object.SetAsync, self._object, Key, Data)

			if status then
				Resolve(response)
			else
				Reject(response)
			end
		end)
	end

	function object:Increment(Key: string, Delta: number, UserIds: array, Options: instance)
		return module.Services.Promise.new(function(Resolve, Reject)
			local status, response = pcall(self._object.IncrementAsync, self._object, Key, Delta, UserIds, Options)

			if status then
				Resolve(response)
			else
				Reject(response)
			end
		end)
	end

	function object:Update(Key: string, Transformer: (string) -> void)
		return module.Services.Promise.new(function(Resolve, Reject)
			local status, response = pcall(self._object.RemoveAsync, self._object, Key, Transformer)

			if status then
				Resolve(response)
			else
				Reject(response)
			end
		end)
	end

	function object:Remove(Key: string)
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

-- To make naming convention much consistent, we have changed our function to PascalCase
-- As a result, we need backward compatibility as older packages and code uses camelCase
-- for functions
API.Players = setmetatable(API.Players, {
	__index = function(self, key: string)
		key = string.upper(string.sub(key,1,1)) .. string.sub(key,2)
		
		return rawget(self,key) --calling self[newKey] would just invoke this index again
	end	
})

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
	CheckHasPermission = MakeBindable(IsolateFunction(module.Players.checkHasPermission)),
	CheckAdmin = MakeBindable(IsolateFunction(module.Players.checkAdmin)),
	GetAdminLevel = MakeBindable(IsolateFunction(module.Players.getAdminLevel)),
	GetAvailableAdmins = MakeBindable(IsolateFunction(module.Players.getAvailableAdmins)),
	GetPlayersFromNameSelector = MakeBindable(IsolateFunction(module.Players.GetPlayersFromNameSelector)),
	GetAdminStatus = MakeBindable(IsolateFunction(module.Players.getAdminStatus)),
	GetAdmins = makeBindable(function()
		local permissions = {}
		for name, permission in pairs(module.Players.getAdmins()) do
			permissions[name] = permission
		end
		return setmetatable(permissions, {__metatable = "The metatable is locked"})
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
