local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = {
	Event = ReplicatedStorage:WaitForChild("Commander Remotes"):WaitForChild("RemoteEvent"),
	Function = ReplicatedStorage:WaitForChild("Commander Remotes"):WaitForChild("RemoteFunction"),
}
local Elements = script.Parent.Parent.Elements
local Library = script.Parent.Library
local Message = require(Library.Components.Message)
local Hint = require(Library.Components.Hint)
local Notification = require(Library.Components.Notification)
local ExpandedNotification = require(Library.Components.ExpandedNotification)
local ReplyBox = require(Library.Components.ReplyBox)
local activeElements = {}

Remotes.Event.OnClientEvent:Connect(function(Type, Protocol, Attachment)
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
		end
	elseif Type == "newNotifyWithAction" then
		local notification = Notification.new(Attachment.From, Attachment.Content, Elements.List)
		notification:deploy()
		
		local interacted = notification.onDismiss.Event:Wait()
		if interacted then
			local expanded = ExpandedNotification.new(Attachment.From, Attachment.Content, Elements)
			expanded._object.Bottom.Primary.Content.Text = Protocol.Type
			expanded:deploy()
			
			local response = expanded.onDismiss.Event:Wait()
			if Protocol.Type:lower() == "reply" and response ~= false then
				local reply = ReplyBox.new(Attachment.From, Elements)
				reply:deploy()
				Remotes.Function:InvokeServer("notifyCallback", Protocol.GUID, reply.onDismiss.Event:Wait())
			else
				Remotes.Function:InvokeServer("notifyCallback", Protocol.GUID, response)
			end
		end
	end
end)