local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Classes = {}
local Remotes = {
	Function = ReplicatedStorage:WaitForChild("Commander Remotes"):WaitForChild("RemoteFunction"),
	Event = ReplicatedStorage:WaitForChild("Commander Remotes"):WaitForChild("RemoteEvent")
}

local Elements = script.Parent.Parent.Elements
local PrimaryColor3 = Color3.fromRGB(64, 157, 130)
local currentButton
local isMenuOpened = false


local function dropAllClasses(Child)
	for i,v in pairs(Classes) do
		if Classes[i] ~= Child and typeof(Child) ~= "function" then
			Child.Remotes = Remotes
			Child.Elements = Elements -- hahh so lazy
			Child[i] = v
		end
	end
end

local function loadClasses()
	for i,v in pairs(script.Library:GetChildren()) do
		if v:IsA("ModuleScript") then
			Classes[v.Name] = require(v)
		end
	end
	
	for i,v in pairs(Classes) do
		dropAllClasses(v)
	end
end

local function returnTime(Seconds: number)
	local Hours = math.floor(Seconds / 3600)
	return Hours, math.floor(Seconds / 60 - Hours * 60)
end

local function updateInfo()
	Elements.Panel.Container.Body.Home.Server.Container.Players.Value.Text = #Players:GetPlayers()
	Elements.Panel.Container.Body.Home.Server.Container.Administrators.Value.Text = Remotes.Function:InvokeServer("getAvailableAdmins")
end

local function changeAccent(Color3: Color3)
	for i,v in pairs(Elements.Panel.Container.Menu.Container.List:GetChildren()) do
		if v:IsA("Frame") then
			v.isActive.ImageColor3 = Color3
		end
	end
	
	for i,v in pairs(Elements.Panel.Container.Body.About.List.Container.Credits.Bottom.Buttons:GetChildren()) do
		if v:IsA("TextButton") then
			v.TextColor3 = Color3
		end
	end

	Elements.Panel.Container.Top.BackgroundColor3 = Color3
	Elements.Panel.Container.Top.Background.ImageColor3 = Color3
	script.Library.Generator.Assets.Window.Container.Top.BackgroundColor3 = Color3
	script.Library.Generator.Assets.Window.Container.Top.Background.ImageColor3 = Color3
	script.Library.Generator.Assets.Modal.UI.Container.Bottom.Confirm.Hover.BackgroundColor3 = Color3
	script.Library.Generator.Assets.Modal.UI.Container.Bottom.Confirm.Title.TextColor3 = Color3
	PrimaryColor3 = Color3
end

loadClasses() -- I am a bit annoyed by this

local function topBarContextButtonReaction(Button, State: string)
	local scalingTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint)
	local fadeTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear)
	if State == "Hold" then
		Classes.Tween(Button.Hover, fadeTweenInfo, {BackgroundTransparency = 0.65})
	elseif State == "Hover" then
		Classes.Tween(Button.Hover, fadeTweenInfo, {BackgroundTransparency = 0.8})
		Classes.Tween(Button.Hover.UIScale, scalingTweenInfo, {Scale = 1})
	elseif State == "Over" then
		Classes.Tween(Button.Hover, fadeTweenInfo, {BackgroundTransparency = 1})
		Classes.Tween(Button.Hover.UIScale, scalingTweenInfo, {Scale = 0})
	end
end

local function menuBarListButtonReaction(Button, State: string)
	local fadeTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
	if State == "Hold" then
		Classes.Tween(Button, fadeTweenInfo, {BackgroundTransparency = 0.85})
	elseif State == "Hover" then
		Classes.Tween(Button, fadeTweenInfo, {BackgroundTransparency = 0.95})
	elseif State == "Over" then
		Classes.Tween(Button, fadeTweenInfo, {BackgroundTransparency = 1})
	end
end

local function populateSuggestion(Text: string, UI)
	local players = {}
	local matcher
	for i,v in pairs(Players:GetPlayers()) do
		table.insert(players, v.Name)
	end
	
	matcher = Classes.Matcher.new(players, false, false):match(Text)[1]
	if matcher then
		UI.Visible = true
		UI.Container.Text.Title.Text = matcher
		UI.Container.Text.Subtitle.Text = Players:FindFirstChild(matcher).UserId
		UI.Container.Avatar.Icon.Image = "https://www.roblox.com/bust-thumbnail/image?userId=" .. UI.Container.Text.Subtitle.Text .. "&width=420&height=420&format=png"
	else
		UI.Visible = false
	end
end

local function switchTo(newButton)
	if currentButton and currentButton ~= newButton then
		currentButton.isActive.Visible = false
		currentButton.Title.TextColor3 = Color3.fromRGB(100, 100, 100)
		currentButton.Title.Font = Enum.Font.Gotham
		Classes.Animator.animateOut(Elements.Panel.Container.Body[currentButton.Name])
	end
	
	currentButton = newButton
	currentButton.isActive.Visible = true
	currentButton.Title.TextColor3 = PrimaryColor3
	currentButton.Title.Font = Enum.Font.GothamSemibold
	Classes.Animator.animateIn(Elements.Panel.Container.Body[currentButton.Name])
end

local function notifyClient(Title: string, Description: string)
	StarterGui:SetCore("SendNotification", {
		["Title"] = Title,
		["Text"] = Description,
		["Icon"] = "rbxassetid://6027381584"
	 })
end

local function makeChatMessage(Text: string, Color: Color3)
	StarterGui:SetCore("ChatMakeSystemMessage", {
		["Text"] = Text,
		["Color"] = Color
	})
end

-- Initialising 
Elements.Panel.Container.Body.Player.Input.Container.SearchBar.Input:GetPropertyChangedSignal("Text"):Connect(function()
	local Text = string.gsub(Elements.Panel.Container.Body.Player.Input.Container.SearchBar.Input.Text, "%s", "")
	if Text then
		if string.len(Text) >= 1 then
			populateSuggestion(Elements.Panel.Container.Body.Player.Input.Container.SearchBar.Input.Text, Elements.Panel.Container.Body.Player.Input.Container.SearchBar.Suggestion)
			return
		end
	end
end)

--[[
Elements.Panel.Container.Body.Player.Input.Container.SearchBar.Input.FocusLost:Connect(function()
	Elements.Panel.Container.Body.Player.Input.Container.SearchBar.Suggestion.Visible = false
end)
--]]

Elements.Panel.Container.Body.Player.Input.Container.SearchBar.Suggestion.Button.MouseButton1Click:Connect(function()
	Elements.Panel.Container.Body.Player.Input.Container.SearchBar.Input.Text = Elements.Panel.Container.Body.Player.Input.Container.SearchBar.Suggestion.Container.Text.Title.Text
	Elements.Panel.Container.Body.Player.Input.Container.SearchBar.Suggestion.Visible = false
end)

Classes.Button.register(Elements.Panel.Container.Top.Menu, topBarContextButtonReaction):Connect(function()
	if not isMenuOpened then
		Classes.Fader.FadeIn(Elements.Panel.Container.Menu, 0.1)
		Classes.Tween(Elements.Panel.Container.Menu, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, 0, 0)})
		isMenuOpened = true
	end
end)

Classes.Button.register(Elements.Panel.Container.Menu.Container.Exit, topBarContextButtonReaction):Connect(function()
	if isMenuOpened then
		Classes.Fader.FadeOut(Elements.Panel.Container.Menu, 0.2)
		Classes.Tween(Elements.Panel.Container.Menu, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = UDim2.new(-0.35, -2, 0, 0)})
		wait(0.1)
		isMenuOpened = false
	end
end)

for i,v in pairs(Elements.Panel.Container.Menu.Container.List:GetChildren()) do
	if v:IsA("Frame") and v:FindFirstChild("isActive") and v:FindFirstChild("Title") then
		Classes.Button.register(v, menuBarListButtonReaction):Connect(function()
			switchTo(v)
			Classes.Fader.FadeOut(Elements.Panel.Container.Menu, 0.2)
			Classes.Tween(Elements.Panel.Container.Menu, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = UDim2.new(-0.35, -2, 0, 0)})
			wait(0.1)
			isMenuOpened = false
		end)
	end
end

Classes.Button.register(Elements.Panel.Container.Top.Search, topBarContextButtonReaction):Connect(function()
	Elements.Panel.Container.Top.Search.Visible = false
	Elements.Panel.Container.Top.SearchBar.Visible = true
	Elements.Panel.Container.Top.Title.Visible = false
end)

Classes.Button.register(Elements.Panel.Container.Top.SearchBar.Exit, topBarContextButtonReaction):Connect(function()
	Elements.Panel.Container.Top.Search.Visible = true
	Elements.Panel.Container.Top.SearchBar.Visible = false
	Elements.Panel.Container.Top.Title.Visible = true
end)

Classes.Button.register(Elements.Panel.Container.Top.Exit, topBarContextButtonReaction):Connect(function()
	Classes.Fader.FadeOut(Elements.Panel.Container.Menu, 0.2)
	Classes.Tween(Elements.Panel.Container.Menu, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = UDim2.new(-0.35, -2, 0, 0)})
	Classes.Animator.animateOut(Elements.Panel)
end)

Classes.Button.register(Elements.Panel.Container.Body.Player.Input.Container.SearchBar.Exit, topBarContextButtonReaction):Connect(function()
	Elements.Panel.Container.Body.Player.Input.Container.SearchBar.Input.Text = ""
end)

-- Remote events & some code
Remotes.Event.OnClientEvent:Connect(function(Type, Protocol, Attachment)
	if Type == "modal" then
		local event, object = Classes.Generator.newInputModal(Attachment)
		if event then
			event:Connect(function(Text)
				Remotes.Function:InvokeServer("input", Protocol, Text)
			end)
		end
	elseif Type == "fetchCommands" then
		Elements.Panel.Container.Body.Home.System.Container.Modules.Value.Text = #Attachment
		for i,v in pairs(Attachment) do
			if v.Location:lower() == "player" then
				Classes.Generator.newPackageButton(v.Name, v.Description, Elements.Panel.Container.Body.Player.Commands.Container, function()
					if string.gsub(Elements.Panel.Container.Body.Player.Input.Container.SearchBar.Input.Text, "%s", "") then
						if string.len(string.gsub(Elements.Panel.Container.Body.Player.Input.Container.SearchBar.Input.Text, "%s", "")) >= 1 then
							Remotes.Function:InvokeServer("command", v.Name, string.gsub(Elements.Panel.Container.Body.Player.Input.Container.SearchBar.Input.Text, "%s", ""))
						else
							notifyClient("Error", "You need to specify the player")
						end
					else
						notifyClient("Error", "You need to specify the player")
					end
				end)
			elseif v.Location:lower() == "server" then
				Classes.Generator.newPackageButton(v.Name, v.Description, Elements.Panel.Container.Body.Server.Commands.Container, function()
					Remotes.Function:InvokeServer("command", v.Protocol)
				end)
			end
		end
	elseif Type == "newList" then
		if not Elements:FindFirstChild(Protocol) then
			local window = Classes.Generator.newWindow(Protocol, Protocol, Elements)
			local list = Classes.Generator.newList("List", window.Container)
			for i,v in pairs(Attachment) do
				list.addItem(i, v)
			end

			window.Event.Event:Connect(function(Type, Attachment)
				if Type == "closed" then
					wait(0.3)
					window.Container.Parent.Parent:Destroy()
				end
			end)

			window.open()
		else
			local window = Elements:FindFirstChild(Protocol)
			local list
			window.Container.Body.List:Destroy()
			list = Classes.Generator.newList("List", window.Container.Body)

			for i,v in pairs(Attachment) do
				list.addItem(i, v)
			end
		end
	elseif Type == "fetchAdminLevel" then
		Elements.Panel.Container.Body.Home.Top.Container.Subtitle.Text = Attachment
	elseif Type == "firstRun" then
		local credits = ""
		UserInputService.InputEnded:Connect(function(Input, Processed)
			if not Processed and Input.KeyCode == Attachment.UI.Keybind then
				Classes.Animator.animateIn(Elements.Panel)
			end
		end)
		
		for i,v in pairs(Attachment.Credits) do
			credits = credits .. v .. "<br/>"
		end
		
		Classes.Donations.execute()
		changeAccent(Attachment.UI.Accent)
		Elements.Panel.Container.Menu.Container.List.Donate.Visible = not Attachment.Misc.HideDonations
		Elements.Panel.Container.Body.About.List.Container.Credits.Description.Text = credits
		Elements.Panel.Container.Body.Home.Top.Container.Title.Text = Players.LocalPlayer.Name
		Elements.Panel.Container.Body.About.List.Container.Credits.Bottom.Title.Text = "Commander<br />© 2021 Evo Inc. All rights reserved."
		Elements.Panel.Container.Body.Home.Top.Container.Avatar.Icon.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
		coroutine.wrap(pcall)(function()
			local Image, IsReady = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
			if IsReady and Image then
				Elements.Panel.Container.Body.Home.Top.Container.Avatar.Icon.Image = Image
			end
		end)
		Classes.Dragger.new(Elements.Panel.Container.Top, Elements.Panel)
		switchTo(Elements.Panel.Container.Menu.Container.List.Home)
		Elements.Panel.Container.Body.Home.System.Container.Version.Value.Text, Elements.Panel.Container.Body.About.List.Container.Top.Text.Subtitle.Text = Remotes.Function:InvokeServer("getCurrentVersion")
		Elements.Panel.Container.Body.About.List.Container.Top.Text.Subtitle.Text = Elements.Panel.Container.Body.About.List.Container.Top.Text.Subtitle.Text
		updateInfo()
		notifyClient("Commander", "Use the " .. Attachment.UI.Keybind.Name .. " key to open")
	end
end)

Classes.TButton(Elements.Topbar.Right.Commander):Connect(function()
	Classes.Animator.animateIn(Elements.Panel)
end)

Players.PlayerAdded:Connect(updateInfo)
Players.PlayerRemoving:Connect(updateInfo)

coroutine.wrap(function()
	while wait(1) do
		local Hour, Minute = returnTime(workspace.DistributedGameTime)
		Elements.Panel.Container.Body.Home.Server.Container.Uptime.Value.Text = Hour .. " hr(s), " .. Minute .. " min(s)"
	end
end)()
