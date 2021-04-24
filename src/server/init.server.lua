local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local remotefolder = Instance.new("Folder")
local availableAdmins = 0 -- In order to reduce server stress, we are caching this value so less API calls will be needed to send the available admins number back to player

local isPlayerAddedFired = false
local remotes = {
	Function = Instance.new("RemoteFunction"),
	Event = Instance.new("RemoteEvent")
}

local packages, packagesButtons, systemPackages, permissionTable, disableTable = {}, {}, {}, {}, {}
local currentTheme = nil

remotefolder.Name = "Commander Remotes"
remotes.Function.Parent, remotes.Event.Parent = remotefolder, remotefolder
remotefolder.Parent = ReplicatedStorage
remotefolder = nil

for i,v in pairs(script.Packages:GetDescendants()) do
	if v:IsA("ModuleScript") then
		pcall(function()
			local mod = require(v)
			if mod.Execute and mod.Name and mod.Description and mod.Location then
				packagesButtons[#packagesButtons + 1] = {
					Name = mod.Name,
					Protocol = mod.Name,
					Description = mod.Description,
					Location = mod.Location,
					PackageId = v.Name
				}
			end
		end)
	end
end

-- Builds permission tables to allow indexing for permissions.
local function buildPermissionTables()
	local permissions = systemPackages.Settings["Permissions"]

	for i,v in pairs(permissions) do
		permissionTable[i] = {}

		if v["Permissions"] then
			for _,perm in ipairs(v["Permissions"]) do
				permissionTable[i][perm] = true
			end
		end

		if v["Inherits"] and permissions[v["Inherits"]] and permissions[v["Inherits"]]["Permissions"] then
			for _,perm in ipairs(permissions[v["Inherits"]]["Permissions"]) do
				permissionTable[i][perm] = true
			end
		end
	end
end

-- Builds disable prefix table.
local function buildDisableTables()
	local permissions = systemPackages.Settings["Permissions"]

	for i,v in pairs(permissions) do
		disableTable[i] = {}

		if v["DisallowPrefixes"] then
			for _,disallow in ipairs(v["DisallowPrefixes"]) do
				disableTable[i][disallow:lower()] = true
			end
		end
	end
end

local function loadPackages()
	for i,v in pairs(script.SystemPackages:GetChildren()) do
		if v:IsA("ModuleScript") then
			local name = v.Name
			v = require(v)
			systemPackages[name] = v
		end
	end

	buildPermissionTables()
	buildDisableTables()
	systemPackages.API.PermissionTable = permissionTable
	systemPackages.API.DisableTable = disableTable

	for i,v in pairs(systemPackages) do
		for index, value in pairs(systemPackages) do
			if systemPackages[index] ~= v and typeof(v) ~= "function" and i ~= "Settings" then
				v.Remotes = remotes
				v[index] = value
			end
		end
	end

	for i,v in pairs(script.Packages:GetDescendants()) do
		if v:IsA("ModuleScript") and not v.Parent:IsA("ModuleScript") then
			pcall(function()
				local mod = require(v)
				mod.Services = systemPackages.Services
				mod.API = systemPackages.API
				mod.Settings = systemPackages.Settings
				mod.Remotes = remotes
				mod.fetchLogs = script.waypointBindable
				mod.PackageId = v.Name
				if mod and mod.Name and mod.Description and mod.Location then
					packages[mod.Name] = mod
				end
				mod.Execute(nil, "firstrun")
			end)
		end
	end
end

loadPackages()
systemPackages.Settings.Credits = systemPackages.GetCredits()
systemPackages.Settings.LatestVersion = systemPackages.GetRelease()
systemPackages.Settings.UI.AlertSound = systemPackages.Settings.UI.AlertSound or 6518811702

if not script.Library.UI.Stylesheets:FindFirstChild(systemPackages.Settings.UI.Theme) then
	error("ERR! | Theme " .. systemPackages.Settings.UI.Theme .. " is not installed")
else
	local themeColorValue = Instance.new("Color3Value")
	themeColorValue.Name = "ThemeColor"
	themeColorValue.Value = systemPackages.Settings.UI.Accent
	currentTheme = script.Library.UI.Stylesheets:FindFirstChild(systemPackages.Settings.UI.Theme):Clone()
	currentTheme.Name = "Stylesheet"
	themeColorValue.Parent = currentTheme
	currentTheme.Parent = script.Library.UI.Panel.Scripts.Library.Modules
end

script.waypointBindable.OnInvoke = function()
	return systemPackages.Services.Waypoints.fetch()
end

remotes.Function.OnServerInvoke = function(Client, Type, Protocol, Attachment)
	if CollectionService:HasTag(Client, "commander.admins") and Type ~= "notifyCallback" then
		if Type == "command" and packages[Protocol] then
			if systemPackages.API.checkHasPermission(Client.UserId, packages[Protocol].PackageId) then
				local status = packages[Protocol].Execute(Client, Type, Attachment)
				if status then
					systemPackages.Services.Waypoints.new(Client.Name, packages[Protocol].Name, {Attachment})
				elseif status == nil then
					systemPackages.Services.Waypoints.new(Client.Name, packages[Protocol].Name .. " (TRY)", {Attachment})
				end
			else
				warn(Client.UserId, "does not have permission to run", Protocol)
			end

			return
		elseif Type == "input" then
			-- bindable aren't really good for this, yikes
			local Event = script.Bindables:FindFirstChild(Protocol)
			if Event and Attachment then
				Event:Fire(Attachment or false)
				Event:Destroy()
			else
				return false
			end
		elseif Type == "getAdmins" then
			return systemPackages.API.getAdmins()
		elseif Type == "getAvailableAdmins" then
			return #CollectionService:GetTagged("commander.admins")
		elseif Type == "getCurrentVersion" then
			return systemPackages.Settings.Version[1], systemPackages.Settings.Version[2]
		elseif Type == "getHasPermission" then
			return systemPackages.API.checkHasPermission(Client.UserId, Protocol)
		elseif Type == "getElapsedTime" then
			return workspace.DistributedGameTime
		elseif Type == "setupUIForPlayer" then
			remotes.Event:FireClient(Client, "firstRun", "n/a", systemPackages.Settings)
			CollectionService:AddTag(Client, "commander.admins")

			-- Filter out commands that the user doesn't have access to.
			local packagesButtonsFiltered = {};

			for i,v in ipairs(packagesButtons) do
				if systemPackages.API.checkHasPermission(Client.UserId, v.PackageId) then
					table.insert(packagesButtonsFiltered, v)
				end
			end

			remotes.Event:FireClient(Client, "fetchCommands", "n/a", packagesButtonsFiltered)
			remotes.Event:FireClient(Client, "fetchAdminLevel", "n/a", systemPackages.API.getAdminLevel(Client.UserId))
		elseif Type == "getSettings" then
			return systemPackages.Settings
		end
	end
	
	if Type == "notifyCallback" then
		-- bindable aren't really good for this, yikes
		local Event = script.Bindables:FindFirstChild(Protocol)
		if Event and Attachment then
			Event:Fire(Attachment or false)
			Event:Destroy()
		else
			return false
		end
	end
end

local function setupUIForPlayer(Client)
	local UI = script.Library.UI.Client:Clone()
	UI.ResetOnSpawn = false
	UI.Scripts.Core.Disabled = false
	UI.Parent = Client.PlayerGui

	if systemPackages.API.checkAdmin(Client.UserId) then
		CollectionService:AddTag(Client, "commander.admins")
		isPlayerAddedFired = true
		UI = script.Library.UI.Panel:Clone()
		UI.Name = "Panel"
		UI.ResetOnSpawn = false
		UI.Scripts.Core.Disabled = false
		UI.Parent = Client.PlayerGui
		systemPackages.API.Players.notify(Client, "System", "Press the \"" .. systemPackages.Settings.UI.Keybind.Name .. "\" or click the Command icon on the top to toggle Commander")
		if systemPackages.Settings.LatestVersion ~= false and systemPackages.Settings.LatestVersion ~= systemPackages.Settings.Version[1] then
			systemPackages.API.Players.hint(Client, "System", "Commander is outdated, latest version available is " .. systemPackages.Settings.LatestVersion)
		elseif systemPackages.Settings.LatestVersion == false then
			systemPackages.API.Players.hint(Client, "System", "Unable to fetch latest version info for Commander")
		end
	end
	
	if not systemPackages.Settings.Misc.DisableCredits then
		systemPackages.API.Players.notify(Client, "System", "This game uses Commander 4 from Evo")
	end
end

Players.PlayerAdded:Connect(function(Client)
	setupUIForPlayer(Client)
end)

-- for situations where PlayerAdded will not work as expected in Studio
if not isPlayerAddedFired then
	for i,v in pairs(Players:GetPlayers()) do
		setupUIForPlayer(v)
	end
end