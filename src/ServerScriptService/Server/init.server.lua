-- stuff to be worked on: well-developed API, more built-in commands, code cleanup

local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local remotefolder = Instance.new("Folder")
local availableAdmins = 0 -- In order to reduce server stress, we are caching this value so less API calls will be needed to send the available admins number back to player
local isDataStoreEnabled = ({pcall(function() DataStoreService:GetDataStore("_"):GetAsync("_")end)})[2] ~= "502: API Services rejected request with error. HTTP 403 (Forbidden)"

if isDataStoreEnabled then
	local isPlayerAddedFired = false
	local remotes = {
		Function = Instance.new("RemoteFunction"),
		Event = Instance.new("RemoteEvent")
	}
	local packages = {}
	local packagesButtons = {}
	local systemPackages = {}


	remotefolder.Name = "Commander Remotes"
	remotes.Function.Parent, remotes.Event.Parent = remotefolder, remotefolder
	remotefolder.Parent = ReplicatedStorage
	remotefolder = nil

	for i,v in pairs(script.Packages:GetChildren()) do
		if v:IsA("ModuleScript") then
			v = require(v)
			if v.Execute and v.Name and v.Description and v.Location then
				packagesButtons[#packagesButtons + 1] = {
					Name = v.Name,
					Protocol = v.Name,
					Description = v.Description,
					Location = v.Location
				}
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

		for i,v in pairs(systemPackages) do
			for index, value in pairs(systemPackages) do
				if systemPackages[index] ~= v and typeof(value) == "table" then
					v.Remotes = remotes
					v[index] = value
					warn("brew " .. index .. " for " .. i)
				end
			end
		end

		for i,v in pairs(script.Packages:GetChildren()) do
			if v:IsA("ModuleScript") then
				v = require(v)
				v.API = systemPackages.API
				v.Remotes = remotes
				if v and v.Name and v.Description and v.Location then
					packages[v.Name] = v
				end
				v.Execute(nil, "firstrun")
			end
		end
	end
	loadPackages()
	
	systemPackages.Settings.UI.Credits = systemPackages.Credits
	if not script.Library.UI:FindFirstChild(systemPackages.Settings.UI.Theme) or systemPackages.Settings.UI.Theme == "Client" then
		error("Please choose a valid theme!")
	end

	remotes.Function.OnServerInvoke = function(Client, Type, Protocol, Attachment)
		if systemPackages.API.checkAdmin(Client.UserId) then
			if Type == "command" and packages[Protocol] then
				coroutine.wrap(function()
					packages[Protocol].Execute(Client, Type, Attachment)
				end)()
				return
			elseif Type == "input" then
				-- bindable aren't really good for this, yikes
				local Event = script.Bindables:FindFirstChild(Protocol)
				if Event and Attachment ~= false then
					Event:Fire(Attachment)
					Event:Destroy()
				elseif Event and not Attachment then
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
			end
		end
	end

	local function setupUIForPlayer(Client)
		local UI = script.Library.UI.Client:Clone()
		UI.Scripts.Core.Disabled = false
		UI.Parent = Client.PlayerGui
		if systemPackages.API.checkAdmin(Client.UserId) then
			isPlayerAddedFired = true
			UI = script.Library.UI[systemPackages.Settings.UI.Theme]:Clone()
			UI.Name = "UI"
			UI.Scripts.Core.Disabled = false
			UI.Parent = Client.PlayerGui
			remotes.Event:FireClient(Client, "fetchCommands", "n/a", packagesButtons)
			remotes.Event:FireClient(Client, "firstRun", "n/a", systemPackages.Settings.UI)
			availableAdmins = systemPackages.API.getAvailableAdmins()
		end
	end

	Players.PlayerAdded:Connect(function(Client)
		setupUIForPlayer(Client)
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
else
	error("API services for Studio is not enabled yet, Commander will not function")
end