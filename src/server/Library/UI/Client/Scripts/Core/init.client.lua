local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local Classes = {}
local messages = {}
local Remotes = {
	Function = ReplicatedStorage:WaitForChild("Commander Remotes"):WaitForChild("RemoteFunction"),
	Event = ReplicatedStorage:WaitForChild("Commander Remotes"):WaitForChild("RemoteEvent")
}

local Audio = Instance.new("Sound")
Audio.Volume = 1
Audio.Parent = script
local Elements = script.Parent.Parent.Elements

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

local function makeMessage(From: string, Content: string, Duration: number?)
	Duration = Duration or 5
	coroutine.wrap(function()
		local guid = HttpService:GenerateGUID()
		local closeButtonEvent
		messages[#messages + 1] = guid
		repeat wait() until messages[1] == guid
		local message = script.Message:Clone()
		local isActive = true
		message.Container.Top.Title.Text = "<font face=\"Gotham\" color=\"rgb(200,200,200)\">Message from </font>" .. tostring(From)
		message.Container.Body.Container.Content.Text = tostring(Content)
		message.Parent = Elements.List
		message.Container.Size = UDim2.new(1, 0, 0, math.floor(message.Container.Body.Container.Content.TextBounds.Y) + 56)
		message.Size = UDim2.new(0.45, 0, 0, 0)

		local function close()
			if messages[1] == guid then
				isActive = false
				closeButtonEvent:Disconnect()
				Classes.Tween(message, Classes.TweenInfo.Longer, {Size = UDim2.new(0.45, 0, 0, 0)})
				Classes.Fader.FadeOut(message, 0.5)
				wait(0.5)
				message:Destroy()
				table.remove(messages, 1)
			end
		end

		closeButtonEvent = Classes.Button.register(message.Container.Top.Exit):Connect(function()
			close()
		end)

		coroutine.wrap(function()
			wait(Duration)
			close()
		end)()

		if #messages == 1 then
			Elements.List.Indicator.Visible = false
		else
			Elements.List.Indicator.Text = "<font face=\"GothamSemibold\">" .. #messages - 1 .. "</font> message(s) remaining"
			Elements.List.Indicator.Visible = true
		end

		Audio.SoundId = "rbxassetid://6518811702"
		Classes.Tween(message, Classes.TweenInfo.Longer, {Size = UDim2.new(0.45, 0, 0, message.Container.Size.Y.Offset)})
		Classes.Fader.FadeIn(message, 0.5)
		Audio:Play()
	end)()
end

local function init()
	Remotes.Event.OnClientEvent:Connect(function(Type, Protocol, Attachment)
		if Type == "newMessage" then
			makeMessage(Attachment.From, Attachment.Content, Attachment.Duration)
		elseif Type == "newNotify" then
			notifyClient(Attachment.From, Attachment.Content)
		elseif Type == "newHint" then
			makeChatMessage(Attachment.From .. ":" .. Attachment.Content, Color3.fromRGB(255,255,255))
		end
	end)
end

loadClasses()
init()