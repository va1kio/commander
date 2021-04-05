local Players = game:GetService("Players")
local Audio = Instance.new("Sound")
local Client = Players.LocalPlayer
local Mouse = Client:GetMouse()
local module = {}

function module.processClick(Mouse, Button)
	local Data = Mouse.X >= Button.AbsolutePosition.X and Mouse.X <= Button.AbsolutePosition.X+Button.AbsoluteSize.X and Mouse.Y >= Button.AbsolutePosition.Y and Mouse.Y <= Button.AbsolutePosition.Y+Button.AbsoluteSize.Y
	if Data then
		return true
	end
	return false
end

function module.register(Button, ReactionCallback)
	local bindable = Instance.new("BindableEvent")
	
	if not ReactionCallback then
		ReactionCallback = function() end
	end
	
	Button.InputBegan:Connect(function(Object)
		if Object.UserInputType == Enum.UserInputType.MouseButton1 then
			ReactionCallback(Button, "Hold")
		elseif Object.UserInputType == Enum.UserInputType.Touch or Object.UserInputType == Enum.UserInputType.MouseMovement then
			ReactionCallback(Button, "Hover")
		end
	end)
	
	Button.InputEnded:Connect(function(Object)
		ReactionCallback(Button, "Over")
		if Object.UserInputType == Enum.UserInputType.MouseButton1 or Object.UserInputType == Enum.UserInputType.Touch then
			if module.processClick(Mouse, Button) then
				bindable:Fire(Mouse.X, Mouse.Y)
				Audio:Play()
			end
		end
	end)
	
	return bindable.Event
end

Audio.Volume = 0.25
Audio.SoundId = "rbxassetid://6518836794"
Audio.Parent = script

return module