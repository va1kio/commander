local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local remotefolder = Instance.new("Folder")
local availableAdmins = 0 -- In order to reduce server stress, we are caching this value so less API calls will be needed to send the available admins number back to player
local currentTheme = nil
local isPlayerAddedFired = false
local remotes = {
	Function = Instance.new("RemoteFunction"),
	Event = Instance.new("RemoteEvent")
}
local packages = {}

local function setupUIForPlayer(Client)
	local UI = script.Library.UI.Client:Clone()
	UI.ResetOnSpawn = false
	UI.Scripts.Core.Disabled = false
	UI.Parent = Client.PlayerGui
	
	if systemPackages.API.checkAdmin(Client.UserId) then
		isPlayerAddedFired = true
		UI = script.Library.UI.Panel:Clone()
		UI.Name = "Panel"
		UI.ResetOnSpawn = false
		UI.Scripts.Core.Disabled = false
		UI.Parent = Client.PlayerGui
	end
end

local function assignPackage(Package: Folder)
	local status, response = pcall(function()
		if Package:FindFirstChild("Init") and Package.Init:IsA("ModuleScript") then
			table.insert(packages, require(Package))
		else
			error(Package.Name .. " is a bad package, ignoring and continuing to next item...")
		end
	end)
	
	if not status then
		warn(tostring(response))
	end
end

local function fetchPackages()
	for _,v in pairs(script.Packages:GetDescendants()) do
		if v:IsA("Folder") and string.gmatch(v.Name, ".*.cpkg") then
			assignPackage(v)
		end
	end
end

local function initialize()
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
	
	remotefolder.Name = "Commander Remotes"
	remotes.Function.Parent, remotes.Event.Parent = remotefolder, remotefolder
	remotefolder.Parent = ReplicatedStorage
	remotefolder = nil
	
	script.waypointBindable.OnInvoke = function()
		return systemPackages.Services.Waypoints.fetch()
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
end