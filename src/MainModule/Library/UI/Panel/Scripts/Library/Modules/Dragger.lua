local module = {}
local UserInputService = game:GetService("UserInputService")
local draggingTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quint)

function module.new(Trigger, Window, Callback)
	local isDragging, dragInput, dragStart, startPosition, lastUDim2

	local function updatePosition(Input)
		local delta = Input.Position - dragStart
		local calculatedPosition = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
		if lastUDim2 ~= calculatedPosition then
			module.Latte.Modules.Tween.new(Window, draggingTweenInfo, {Position = calculatedPosition})
		end
	end

	Trigger.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			isDragging, dragStart, startPosition = true, Input.Position, Window.Position
			Callback(Window, "Hold")

			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					isDragging = false
					Callback(Window, "Over")
				end
			end)
		end
	end)

	Trigger.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			dragInput = Input
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if Input == dragInput and isDragging then
			updatePosition(Input)
		end
	end)

	if not Callback then
		Callback = function()

		end
	end
end

return module