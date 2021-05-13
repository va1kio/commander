local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

-- Considering we are just renaming the folder, and connect the function to a function.
-- It's fine to parent them to ReplicatedStorage for the time being
local remoteFolder = Instance.new("Folder", ReplicatedStorage)
local remotes = {
    ["Function"] = Instance.new("RemoteFunction", remoteFolder),
    ["Event"] = Instance.new("RemoteEvent", remoteFolder)
}
local logTemplate = "[Commander]: "

local packages, systemPackages = {}, {}
local permissionTable, disableTable = {}, {}
local packagesButtons = {}
local cachedData = {}
local sharedCommons = {}
local holdedWarns = {} -- Settings is not loaded at first, so we need to hold the warns!
local currentTheme = nil
local isPlayerAddedFired = false

local function newWarn(...)
    if systemPackages.Settings and systemPackages.Settings.Misc.IsVerbose then
        warn(logTemplate .. ...)

        if #holdedWarns ~= 0 then
            local reference = holdedWarns
            holdedWarns = {}
            for _, message in ipairs(holdedWarns) do
                warn(logTemplate .. message)
            end
        end
    elseif not systemPackages.Settings then
        table.insert(holdedWarns, ...)
    end
end

local function BuildPermissions()
    local permissions = systemPackages.Settings["Permissions"]

    for rank, data in pairs(permissions) do
    	newWarn("building permission table for " .. rank)
        permissionTable[rank] = {}

        if data["Permissions"] then
            for _, permission in ipairs(data["Permissions"]) do
                permissionTable[rank][permission] = true
            end
        end

        if data["Inherits"] and permissions[data["Inheirits"]] and permissions[data["Inherits"]]["Permissions"] then
            for _, permission in ipairs(permissions[data["Inherits"]]["Permissions"]) do
                permissionTable[rank][permission] = true
            end
        end
     end
end

local function BuildDisableds()
    local permissions = systemPackages.Settings["Permissions"]
    
    for rank, data in pairs(permissions) do
    	newWarn("building disabled table for " .. rank)
        disableTable[rank] = {}

        if data["DisallowedPrefixes"] then
            for _, disallowed in ipairs(data["DisallowedPrefixes"]) do
                disableTable[rank][string.lower(disallowed)] = true
            end
        end
    end
end

local function LoadSystemPackages()
    -- We are unsure whether the object is actually a module, hence named it possiblyModule
    newWarn("fetching SystemPackages...")
    for _, possiblyModule in ipairs(script.SystemPackages:GetChildren()) do
        if possiblyModule:IsA("ModuleScript") then
            systemPackages[possiblyModule.Name] = require(possiblyModule)
        end
    end

    -- Separated this for loop away from the loop above, as everything is not fully inserted
    -- It is better to run the loop again to assign all packages into each other.
    for currentName, currentModule in pairs(systemPackages) do
        if typeof(currentModule) ~= "function" and currentName ~= "Settings" then
            currentModule.Remotes = remotes
            for name, module in pairs(systemPackages) do
                if module ~= currentModule then
                    currentModule[name] = module
                    newWarn("loaded SystemPackage " .. name)
                end
            end
        end
    end
end

local function LoadPackages()
	newWarn("fetching packages...")
    -- This function only loads packages, but not initialize them, they should be done
    -- in the Initialize() function independently
    for _, possiblyPackage in ipairs(script.Packages:GetChildren()) do
        if possiblyPackage:IsA("ModuleScript") and not possiblyPackage.Parent:IsA("ModuleScript") then
            local ok, response = pcall(function()
                local package = require(possiblyPackage)
                if package and package.Name and package.Description and package.Location then
                    package.SystemPackages = systemPackages
                    package.Remotes = remotes
                    package.Shared = sharedCommons
                    package.fetchLogs = script.waypointBindable

                    -- I know this may sound rebundant, but this is to make stuff compatible with
                    -- packages coded way before this sudden code refactor, hopefully you will understand.
                    package.Services = package.SystemPackages.Services
                    package.API = package.SystemPackages.API
                    package.Settings = package.SystemPackages.Settings

                    packages[package.Name] = package
                    newWarn("loaded package " .. possiblyPackage.Name)
                else
                    return false, "Unknown package, have you filled in the name, description and the location of the package?"
                end
            end)

            if not ok then
                warn(logTemplate .. "failed to load package " .. possiblyPackage.Name .. " with response: \n" .. response)
            end
        end
    end

    for _, possiblyPackage in pairs(script.Packages:GetDescendants()) do
        if possiblyPackage:IsA("ModuleScript") then
            pcall(function()
                local package = require(possiblyPackage)
                -- No need to warn for unknown package again, the loop earlier does that for us already
                if package.Execute and package.Name and package.Description and package.Location then
                    packagesButtons[#packagesButtons + 1] = {
                        Name = package.Name,
                        Protocol = package.Name,
                        Description = package.Description,
                        Location = package.Location,
                        PackageId = possiblyPackage.Name
                    }
                end
            end)
        end
    end
end

local function OverrideInformation()
    -- Some settings are optional, but as a result, we need to override them
    -- if they happened to be not assigned, or not present in the module
	systemPackages.Settings.LatestVersion, systemPackages.Settings.IsHttpEnabled = systemPackages.GetRelease()
	systemPackages.Settings.UI.AlertSound = systemPackages.Settings.UI.AlertSound or 6518811702
	systemPackages.Settings.Misc.DataStoresKey = systemPackages.Settings.Misc.DataStoresKey or {}
	systemPackages.Settings.Misc.IsVerbose = systemPackages.Settings.Misc.IsVerbose or false
end

local function SetTheme()
	newWarn("applying theme " .. systemPackages.Settings.UI.Theme .. "...")
    local possiblyTheme = script.Library.UI.Stylesheets:FindFirstChild(systemPackages.Settings.UI.Theme)
    local themeColor = Instance.new("Color3Value")
    themeColor.Name = "ThemeColor"
    themeColor.Value = systemPackages.Settings.UI.Accent

    if possiblyTheme and possiblyTheme:IsA("ModuleScript") then
        currentTheme = possiblyTheme:Clone()
    else
        warn("[Commander]:  cannot find custom theme, falling back to default theme: Minimal")
        currentTheme = script.Parent.UI.Stylesheets:FindFirstChild("Minimal")
        if not currentTheme then
            -- Come on, why would you do this...
            error(logTemplate .. "failed to compile, default theme is missing")
        end
        currentTheme = currentTheme:Clone()
    end

    currentTheme.Name = "Stylesheet"
    themeColor.Parent = currentTheme
    currentTheme.Parent = script.Library.UI.Panel.Scripts.Library.Modules
    newWarn("complete setting up themes for panel")
end

local function setupUIForPlayer(Client: player)
    local interface = script.Library.UI.Client:Clone()
    interface.ResetOnSpawn = false
    interface.Parent = Client.PlayerGui
    newWarn("cloned client interface to player " .. Client.Name)

    if systemPackages.API.checkAdmin(Client.UserId) then
        isPlayerAddedFired = true
        CollectionService:AddTag(Client, "commander.admins")
        newWarn(Client.Name .. " is a person in authority")
        
        interface = script.Library.UI.Panel:Clone()
        interface.Name = "Panel"
        interface.ResetOnSpawn = false
        interface.Parent = Client.PlayerGui
        newWarn("cloned panel interface to player " .. Client.Name)

        systemPackages.API.Players.notify(Client, "System", "Press the \"" .. systemPackages.Settings.UI.Keybind.Name .. "\" key, or click the Command icon on the top to toggle Commander")
		if systemPackages.Settings.LatestVersion ~= false and systemPackages.Settings.LatestVersion ~= systemPackages.Settings.Version[1] then
			systemPackages.API.Players.hint(Client, "System", "Commander is outdated, latest version available is " .. systemPackages.Settings.LatestVersion, 5)
		elseif systemPackages.Settings.LatestVersion == false and systemPackages.Settings.IsHttpEnabled then
			systemPackages.API.Players.hint(Client, "System", "Unable to fetch latest version info for Commander", 5)
		elseif not systemPackages.Settings.IsHttpEnabled then
			systemPackages.API.Players.hint(Client, "System", "HttpService is not enabled, functions are limited", 5)
		end

        if not systemPackages.Settings.Misc.DisableCredits then
            systemPackages.API.Players.hint(Client, "System", "This game uses Commander 4 from Evo", 5)
        end
    end
end

local function OnRemoteFunctionInvoke(Client: player, Type: string, Protocol: string?, Attachment: any): any
	newWarn(Client.Name .. " is invoking RemoteFunction with type " .. Type .. ", protocol " .. Protocol)
    local administratorOnlyMethods = {"command", "getAdmins", "getAvailableAdmins", "getCurrentVersion", "getHasPermission", "getElapsedTime", "getSettings", "getLocale", "setupUIForPlayer", "getPlaceVersion"}
    if table.find(administratorOnlyMethods, Type) and CollectionService:HasTag(Client, "commander.admins") then
        if Type == "command" and packages[Protocol] and systemPackages.API.checkHasPermission(Client.UserId, packages[Protocol].PackageId) then
            local ok = pcall(function()
                local status = packages[Protocol].Execute(Client, Type, Attachment)
                if status then
                    systemPackages.Services.Waypoints.new(Client.Name, packages[Protocol].Name, {Attachment})
                elseif status == nil then
                    -- Compatability support, might be removed one day
                    newWarn("package did not return a boolean at execution, marked usage as [TRY]")
                    systemPackages.Services.Waypoints.new(Client.Name, packages[Protocol].Name .. " (TRY)", {Attachment})
                end
            end)

            return ok
        elseif Type == "input" then
            local event = script.Bindables:FindFirstChild(Protocol)
            if event and Attachment then
                event:Fire(Attachment or false)
                event:Destroy()
                return true
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
        elseif Type == "getSettings" then
            return systemPackages.Settings
        elseif Type == "getPlaceVersion" then
            return game.PlaceVersion
        elseif Type == "getLocale" then
            if cachedData.serverlocale then
				return cachedData.serverlocale
			else
				local ok , response = systemPackages.Services.Promise.new(function(Resolve, Reject)
					local ok, data = pcall(systemPackages.Services.HttpService.GetAsync, systemPackages.Services.HttpService, "http://ip-api.com/json/")
					if ok then
						data = systemPackages.Services.HttpService:JSONDecode(data).countryCode
						Resolve(data)
					else
						Reject(data)
					end
				end):await()
	
				if ok then
					cachedData.serverlocale = response
					return response
				else
					warn("[Commander]:  " .. response)
				end
			end
        elseif Type == "setupUIForPlayer" then
            local filteredPackagesButtons = {}
            CollectionService:AddTag(Client, "commander.admins")
            newWarn("setting up interface for client " .. Client.Name)

            -- Simple filter, to filter out packages that user has no permission to use
            for _, package in ipairs(packagesButtons) do
                if systemPackages.API.checkHasPermission(Client.UserId, package.PackageId) then
                    table.insert(filteredPackagesButtons, package)
                end
            end

            remotes.Event:FireClient(Client, "firstRun", nil, systemPackages.Settings)
            remotes.Event:FireClient(Client, "fetchAdminLevel", nil, systemPackages.API.getAdminLevel(Client.UserId))
            remotes.Event:FireClient(Client, "fetchCommands", nil, filteredPackagesButtons)
            newWarn("completed setting up interface for client " .. Client.Name)
            return true
        end
    end

    if Type == "notifyCallback" then
        local event = script.Bindables:FindFirstChild(Protocol)
        if event and Attachment then
            event:Fire(Attachment or false)
            event:Destroy()
            return true
        end
    end

    return false
end

local function Initialize()
    newWarn("loading...")
    newWarn("building server...")
    LoadSystemPackages()
    BuildPermissions()
    BuildDisableds()
    OverrideInformation()

    systemPackages.API.PermissionTable = permissionTable
    systemPackages.API.DisableTable = disableTable
    systemPackages.Settings.Credits = systemPackages.GetCredits()
	
	newWarn("building packages and client...")
    LoadPackages()
    SetTheme()

    remoteFolder.Name = "Commander Remotes"
    remotes.Function.OnServerInvoke = OnRemoteFunctionInvoke
    Players.PlayerAdded:Connect(function(Client)
        setupUIForPlayer(Client)
    end)

    if not isPlayerAddedFired then
    	newWarn("firing setupUIForPlayer...")
        for i,v in pairs(Players:GetPlayers()) do
            setupUIForPlayer(v)
        end
    end
    newWarn("complete loading")
    newWarn("listening to clients...")
end

Initialize()