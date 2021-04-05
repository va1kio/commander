local module, Elements, Latte, Page = {}, nil, nil, nil
local Settings, Packages = nil, {}
local PlayersCount, AdministratorsCount, Level = 0, 0, ""
local Server, System = nil, nil

local function returnTime(Seconds: number)
	local Hours = math.floor(Seconds / 3600)
	return Hours, math.floor(Seconds / 60 - Hours * 60)
end

module.prepare = function()
	local Top = Instance.new("Frame")
	Top.BackgroundTransparency = 1
	Top.BorderSizePixel = 0
	Top.Name = "Top"
	Top.Size = UDim2.new(1, 0, 0, 125)
	Top.Parent = Page

	local Background = Instance.new("ImageLabel")
	Background.BackgroundTransparency = 1
	Background.Image = Latte.Modules.Stylesheet.Home.TopImage
	Background.Name = "Background"
	Background.ScaleType = Enum.ScaleType.Crop
	Background.Size = UDim2.new(1, 0, 1, 0)
	Background.Parent = Top

	local Container = Instance.new("Frame")
	Container.BackgroundTransparency = 1
	Container.Name = "Container"
	Container.Size = UDim2.new(1, 0, 1, 0)
	Container.ZIndex = 2
	Container.Parent = Top

	local UIGradient = Instance.new("UIGradient")
	UIGradient.Rotation = 90
	UIGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1)
	}
	UIGradient.Parent = Background

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Parent = Container

	local Avatar = Instance.new("Frame")
	Avatar.AnchorPoint = Vector2.new(0.5, 0.5)
	Avatar.BackgroundColor3 = Latte.Modules.Stylesheet.Home.AvatarBorder
	Avatar.BorderSizePixel = 0
	Avatar.Name = "Avatar"
	Avatar.Position = UDim2.new(0.5, 0, 0.5, 0)
	Avatar.Size = UDim2.new(0, 50, 0, 50)
	Avatar.ZIndex = 2
	Avatar.Parent = Container

	local Title = Instance.new("TextLabel")
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.Gotham
	Title.LayoutOrder = 1
	Title.Name = "Title"
	Title.Size = UDim2.new(1, 0, 0, 22)
	Title.Text = Latte.Modules.Services.Players.LocalPlayer.Name
	Title.TextColor3 = Latte.Modules.Stylesheet.Home.UsernameColor
	Title.TextSize = 18
	Title.TextYAlignment = Enum.TextYAlignment.Bottom
	Title.Parent = Container

	local Subtitle = Instance.new("TextLabel")
	Subtitle.BackgroundTransparency = 1
	Subtitle.Font = Enum.Font.GothamSemibold
	Subtitle.LayoutOrder = 2
	Subtitle.Name = "Subtitle"
	Subtitle.Size = UDim2.new(1, 0, 0, 14)
	Subtitle.Text = "Administrator"
	Subtitle.TextColor3 = Latte.Modules.Stylesheet.Home.RankColor
	Subtitle.TextSize = 12
	Subtitle.TextWrapped = true
	Subtitle.Parent = Container

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = Avatar

	local Backdrop = Instance.new("Frame")
	Backdrop.AnchorPoint = Vector2.new(0.5, 0.5)
	Backdrop.BackgroundColor3 = Latte.Modules.Stylesheet.Home.AvatarBackground
	Backdrop.BorderSizePixel = 0
	Backdrop.Name = "Backdrop"
	Backdrop.Position = UDim2.new(0.5, 0, 0.5, 0)
	Backdrop.Size = UDim2.new(1, -2, 1, -2)
	Backdrop.ZIndex = 2
	Backdrop.Parent = Avatar

	local Icon = Instance.new("ImageLabel")
	Icon.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.BackgroundTransparency = 1
	Icon.Image = "rbxthumb://type=AvatarHeadShot&id=" .. Latte.Modules.Services.Players.LocalPlayer.UserId .. "&w=420&h=420"
	Icon.Name = "Icon"
	Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
	Icon.ScaleType = Enum.ScaleType.Fit
	Icon.Size = UDim2.new(1, -2, 1, -2)
	Icon.ZIndex = 2
	Icon.Parent = Avatar

	local UICorner2 = Instance.new("UICorner")
	UICorner2.CornerRadius = UDim.new(1, 0)
	UICorner2.Parent = Backdrop

	local UICorner3 = Instance.new("UICorner")
	UICorner3.CornerRadius = UDim.new(1, 0)
	UICorner3.Parent = Icon
	
	Server = Latte.Components.SeparatedList.new("Server", "SERVER STATS", Page)
	Server.Items["Players count"] = "1"
	Server.Items["Administrators ingame"] = "1"
	Server.Items["Server uptime"] = "00:00"
	
	System = Latte.Components.SeparatedList.new("System", "SYSTEM STATS", Page)
	System.Items["Modules loaded"] = "0"
	System.Items["Version"] = "Commander ft. Latte"
	
	if Latte.Modules.Stylesheet.Home.TopUseAccentInstead then
		local Accent = Instance.new("Frame")
		Accent.BackgroundColor3 = Latte.Modules.Stylesheet.Window.AccentColor
		Accent.BorderSizePixel = 0
		Accent.Size = UDim2.new(1, 0, 0, 1)
		Accent.Position = UDim2.new(0, 0, 1, 0)
		Accent.ZIndex = 3
		Accent.Parent = Top
		
		Background.ImageTransparency = 1
		Top.BackgroundTransparency = 0
		Top.BackgroundColor3 = Latte.Modules.Stylesheet.Home.TopBackgroundColor
	end
end

module.update = function()
	Server.Items["Players count"] = PlayersCount
	Server.Items["Administrators ingame"] = AdministratorsCount
	
	System.Items["Modules loaded"] = #Packages
	if Settings then
		System.Items["Version"] = Settings.Version[1]
	end
end

module.init = function()
	Elements = module.Elements
	Latte = module.Latte
end

module.setup = function()
	Page = Latte.Constructors.Window.Window.newPage("Home", true, 1)
	Page.UIListLayout.Padding = UDim.new(0, 24)
	module.prepare()
	
	module.Remotes.RemoteEvent.OnClientEvent:Connect(function(Type, Protocol, Attachment)
		if Type == "fetchCommands" then
			Packages = Attachment
		elseif Type == "fetchAdminLevel" then
			Level = Attachment
		elseif Type == "firstRun" then
			Settings = Attachment
			Latte.Constructors.Window.notifyUser(nil, "Press the \"" .. Settings.UI.Keybind.Name .. "\" or click the Command icon on the top to toggle Commander.")
		end
		module.update()
	end)
	
	PlayersCount = #Latte.Modules.Services.Players:GetPlayers()
	AdministratorsCount = module.Remotes.RemoteFunction:InvokeServer("getAvailableAdmins")
	module.update()
	
	coroutine.wrap(function()
		while true do
			local Hour, Minute = returnTime(workspace.DistributedGameTime)
			Server.Items["Server uptime"] = Hour .. " hr(s), " .. Minute .. " min(s)"
			wait(60)
		end
	end)()
	
	Latte.Constructors.Window.Window.Menu.setActive("Home")
	Latte.Constructors.Window.Window.switchPage("Home")
end

return module