local module = {}

local checkMouseInBound = function(Mouse: mouse, Object: guiobject)
	return Mouse.X >= Object.AbsolutePosition.X and Mouse.X <= Object.AbsolutePosition.X+Object.AbsoluteSize.X and Mouse.Y >= Object.AbsolutePosition.Y and Mouse.Y <= Object.AbsolutePosition.Y+Object.AbsoluteSize.Y
end

module.new = function(Parent: guiobject, Reaction: (string) -> void, ZIndex: number?, UseInputEvents: boolean?): rbxscriptsignal
	local Button = Instance.new("TextButton")
	local Bindable = Instance.new("BindableEvent", Button)
	Button.Name = "Trigger"
	Button.Size = UDim2.new(1, 0, 1, 0)
	Button.ZIndex = ZIndex or Button.ZIndex
	Button.BackgroundTransparency = 1
	Button.Text = ""
	
	Button.InputBegan:Connect(function(InputObject: inputobject)
		if InputObject.UserInputType == Enum.UserInputType.Touch or InputObject.UserInputType == Enum.UserInputType.MouseMovement then
			Reaction(Parent, "Hover")
		end
	end)
	
	Button.InputEnded:Connect(function(InputObject: inputobject)
		Reaction(Parent, "Over")
	end)
	
	if UseInputEvents then
		Button.InputBegan:Connect(function(InputObject: inputobject)
			if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
				Reaction(Parent, "Hold")
			end
		end)
		
		Button.InputEnded:Connect(function(InputObject: inputobject)
			Bindable:Fire(InputObject.Position.X, InputObject.Position.Y)
		end)
	else
		Button.MouseButton1Down:Connect(function()
			Reaction(Parent, "Hold")
		end)
		
		Button.MouseButton1Up:Connect(function(X: number, Y: number)
			Bindable:Fire(X, Y)
		end)
	end
	
	Button.Parent = Parent
	return Bindable.Event
end

return module