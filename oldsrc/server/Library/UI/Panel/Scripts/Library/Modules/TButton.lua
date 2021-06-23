local module = {}

module.new = function(Button)
	local Bindable = Instance.new("BindableEvent")
	Bindable.Parent = Button

	Button.Background.MouseEnter:Connect(function()
		Button.Background.StateOverlay.Visible = true
		Button.Background.StateOverlay.BackgroundColor3 = Color3.new(1, 1, 1)
		Button.Background.StateOverlay.BackgroundTransparency = 0.8
	end)

	Button.Background.MouseLeave:Connect(function()
		Button.Background.StateOverlay.Visible = false
	end)

	Button.Background.MouseButton1Down:Connect(function()
		Button.Background.StateOverlay.Visible = true
		Button.Background.StateOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
		Button.Background.StateOverlay.BackgroundTransparency = 0.5
	end)

	Button.Background.MouseButton1Up:Connect(function()
		Button.Background.StateOverlay.Visible = false
		Bindable:Fire()
	end)

	return Bindable.Event
end

return module