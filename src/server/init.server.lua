local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local remotefolder = Instance.new("Folder")
local availableAdmins = 0 -- In order to reduce server stress, we are caching this value so less API calls will be needed to send the available admins number back to player

local isPlayerAddedFired = false
local remotes = {
	Function = Instance.new("RemoteFunction"),
	Event = Instance.new("RemoteEvent")
}

local packages = {}
local packagesButtons = {}
local systemPackages = {}
local permissionTable = {}
local disableTable = {}
local currentTheme = nil

remotefolder.Name = "Commander Remotes"
remotes.Function.Parent, remotes.Event.Parent = remotefolder, remotefolder
remotefolder.Parent = ReplicatedStorage
remotefolder = nil

for i,v in pairs(script.Packages:GetDescendants()) do
	if v:IsA("ModuleScript") then
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
			warn("loaded systemPackage " .. name)
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
		if v:IsA("ModuleScript") then
			local mod = require(v)
			mod.Services = systemPackages.Services
			mod.API = systemPackages.API
			mod.Remotes = remotes
			mod.fetchLogs = script.waypointBindable
			mod.PackageId = v.Name
			if mod and mod.Name and mod.Description and mod.Location then
				packages[mod.Name] = mod
			end
			mod.Execute(nil, "firstrun")
		end
	end
end

loadPackages()

systemPackages.Settings.Credits = systemPackages.Credits()

if not script.Library.UI.Stylesheets:FindFirstChild(systemPackages.Settings.UI.Theme) then
	error("ERR! | Theme " .. systemPackages.Settings.UI.Theme .. " is not installed")
else
	currentTheme = script.Library.UI.Stylesheets:FindFirstChild(systemPackages.Settings.UI.Theme):Clone()
	currentTheme.Name = "Stylesheet"
	currentTheme.Parent = script.Library.UI.Panel.Scripts.Library.Modules
end

script.waypointBindable.OnInvoke = function()
	return systemPackages.Services.Waypoints.fetch()
end

remotes.Function.OnServerInvoke = function(Client, Type, Protocol, Attachment)
	if systemPackages.API.checkAdmin(Client.UserId) then
		if Type == "command" and packages[Protocol] then
			if systemPackages.API.checkHasPermission(Client.UserId, packages[Protocol].PackageId) then
				local status = packages[Protocol].Execute(Client, Type, Attachment)
				if status then
					systemPackages.Services.Waypoints.new(Client.Name, packages[Protocol].Name, {Attachment})
				elseif status == nil then
					remotes.Event:FireClient(Client, "newMessage", "", {From = "System; " .. packages[Protocol].Name, Content = "This command may have failed due to incompatability issue, this will not be logged."})
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
			return availableAdmins
		elseif Type == "getCurrentVersion" then
			return systemPackages.Settings.Version[1], systemPackages.Settings.Version[2]
		elseif Type == "getHasPermission" then
			return systemPackages.API.checkHasPermission(Client.UserId, Protocol)
		elseif Type == "setupUIForPlayer" then
			remotes.Event:FireClient(Client, "firstRun", "n/a", systemPackages.Settings)
			availableAdmins = systemPackages.API.getAvailableAdmins()
			
			-- Filter out commands that the user doesn't have access to.
			local packagesButtonsFiltered = {};
			
			for i,v in ipairs(packagesButtons) do
				if systemPackages.API.checkHasPermission(Client.UserId, v.PackageId) then
					table.insert(packagesButtonsFiltered, v)
				end
			end
			
			remotes.Event:FireClient(Client, "fetchCommands", "n/a", packagesButtonsFiltered)
			remotes.Event:FireClient(Client, "fetchAdminLevel", "n/a", systemPackages.API.getAdminLevel(Client.UserId))
		end
	end
end

local function setupUIForPlayer(Client)
	local UI = script.Library.UI.Client:Clone()
	UI.Scripts.Core.Disabled = false
	UI.Parent = Client.PlayerGui
	
	if systemPackages.API.checkAdmin(Client.UserId) then
		isPlayerAddedFired = true
		UI = script.Library.UI.Panel:Clone()
		UI.Name = "Panel"
		UI.Scripts.Core.Disabled = false
		UI.Parent = Client.PlayerGui
	end
end

Players.PlayerAdded:Connect(function(Client)
	setupUIForPlayer(Client)
	availableAdmins = systemPackages.API.getAvailableAdmins()
	if not systemPackages.Settings.Misc.DisableCredits then
		remotes.Event:FireClient(Client, "newNotify", "n/a", {From = "System", Content = "This game uses Commander 4 from Evo"})
	end
end)

Players.PlayerRemoving:Connect(function(Client)
	availableAdmins = systemPackages.API.getAvailableAdmins()
end)

-- for situations where PlayerAdded will not work as expected in Studio
if not isPlayerAddedFired then
	for i,v in pairs(Players:GetPlayers()) do
		setupUIForPlayer(v)
	end
end