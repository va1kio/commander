local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local Remotes = {
	Event = ReplicatedStorage:WaitForChild("Commander Remotes"):WaitForChild("RemoteEvent"),
	Function = ReplicatedStorage:WaitForChild("Commander Remotes"):WaitForChild("RemoteFunction"),
}
local CurrentCamera = workspace.CurrentCamera

-- UI elements
local Elements = script.Parent.Parent.Elements
local Library = script.Parent.Library
local Message = require(Library.Components.Message)
local Hint = require(Library.Components.Hint)
local Notification = require(Library.Components.Notification)
local ExpandedNotification = require(Library.Components.ExpandedNotification)
local ReplyBox = require(Library.Components.ReplyBox)
local activeElements = {}

local Bindable = Instance.new("BindableEvent")
Bindable.Name = "Event"
Bindable.Parent = Elements

local function playAudio(Id: number|string, Volume: number?, Parent: instance): sound
	local audio = Instance.new("Sound")
	audio.SoundId = "rbxassetid://" .. Id
	audio.Volume = Volume or 1
	audio.Parent = Parent
	audio.Ended:Connect(function()
		audio:Destroy()
	end)
	
	audio:Play()
	return audio
end

local function onCall(Type: string, Protocol: string?, Attachment)
	coroutine.wrap(function()
		local supportedTypes = {"newNotify", "newMessage", "newHint", "newNotifyWithAction"}
		if table.find(supportedTypes, Type) then
			if activeElements.Audio == nil then
				activeElements.Audio = true
				playAudio(Attachment.Sound, nil, Elements).Ended:Wait()
				wait(2.5)
				activeElements.Audio = nil
			end
		end
	end)()
	
	if Type == "newMessage" then
		if activeElements.Message then
			activeElements.Message:dismiss()
		end
		
		activeElements.Message = Message.new(Attachment.From, Attachment.Content, Attachment.Duration, Elements)
		activeElements.Message:deploy()
	elseif Type == "newHint" then
		if activeElements.Hint then
			activeElements.Hint:dismiss()
		end

		activeElements.Hint = Hint.new(Attachment.From, Attachment.Content, Attachment.Duration, Elements)
		activeElements.Hint:deploy()
	elseif Type == "newNotify" then
		local notification = Notification.new(Attachment.From, Attachment.Content, Elements.List)
		notification:deploy()
		
		local interacted = notification.onDismiss.Event:Wait()
		if interacted then
			local expanded = ExpandedNotification.new(Attachment.From, Attachment.Content, Elements)
			expanded._object.Bottom.Primary.Content.Text = "Okay"
			expanded:deploy()
			
			Notification.stopDismissing = true
			expanded.onDismiss.Event:Wait()
			Notification.stopDismissing = false
		end
	elseif Type == "newNotifyWithAction" then
		local notification = Notification.new(Attachment.From, Attachment.Content, Elements.List)
		notification:deploy()
		
		local interacted = notification.onDismiss.Event:Wait()
		if interacted then		
			local expanded = ExpandedNotification.new(Attachment.From, Attachment.Content, Elements)
			expanded._object.Bottom.Primary.Content.Text = Protocol.Type
			expanded:deploy()
			
			Notification.stopDismissing = true
			local response = expanded.onDismiss.Event:Wait()
			Notification.stopDismissing = false
			Remotes.Function:InvokeServer("notifyCallback", Protocol.GUID, response)
		end
	elseif Type == "setCoreGuiEnabled" then
		StarterGui:SetCoreGuiEnabled(Attachment.Type, Attachment.Status)
	elseif Type == "setCamera" then
		CurrentCamera.CFrame = Attachment.CFrame or CurrentCamera.CFrame
		CurrentCamera.CameraSubject = Attachment.CameraSubject or CurrentCamera.CameraSubject
		CurrentCamera.CameraType = Attachment.CameraType or CurrentCamera.CameraType
		CurrentCamera.FieldOfView = Attachment.FieldOfView or CurrentCamera.FieldOfView
		CurrentCamera.MaxAxisFieldOfView = Attachment.MaxAxisFieldOfView or CurrentCamera.MaxAxisFieldOfView
		CurrentCamera.DiagonalFieldOfView = Attachment.DiagonalFieldOfView or CurrentCamera.DiagonalFieldOfView
		CurrentCamera.FieldOfViewMode = Attachment.FieldOfViewMode or CurrentCamera.FieldOfViewMode
		CurrentCamera.HeadScale = Attachment.HeadScale or CurrentCamera.HeadScale
	end
end

Remotes.Event.OnClientEvent:Connect(onCall)
Bindable.Event:Connect(onCall)