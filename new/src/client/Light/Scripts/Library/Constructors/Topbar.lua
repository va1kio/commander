local module, Latte, Elements = {}, nil, nil
local Buttons = {
	["Menu"] = {
		Side = "Left",
		Position = 1,
		Image = "rbxassetid://6272739995",
		Callback = function()
			Latte.Constructors.Menu.Toggle()
		end,
	},
	
	["Exit"] = {
		Side = "Right",
		Position = 1,
		Image = "rbxassetid://6235536018",
		Callback = function()
			Latte.Constructors.Window.Toggle()
		end,
	}
}

module.init = function()
	Elements = module.Elements
	Latte = module.Latte
end

module.setup = function()
	if Latte.Modules.Stylesheet.Window.TopbarUseAccentInstead then
		local Accent = Instance.new("Frame")
		Accent.BackgroundColor3 = Latte.Modules.Stylesheet.Window.AccentColor
		Accent.BorderSizePixel = 0
		Accent.Size = UDim2.new(1, 0, 0, 1)
		Accent.Position = UDim2.new(0, 0, 1, 0)
		Accent.ZIndex = 3
		Accent.Parent = Elements.Panel.Container.Top
		
		Elements.Panel.Container.TopbarShadow.Visible = false
		Elements.Panel.Container.Top.Background.ImageColor3 = Latte.Modules.Stylesheet.Window.TopbarBackgroundColorIfAccentUsed
		Elements.Panel.Container.Top.Title.TextColor3 = Latte.Modules.Stylesheet.Window.TopbarElementColorIfAccentUsed
	else
		Elements.Panel.Container.Top.Background.ImageColor3 = Latte.Modules.Stylesheet.Window.TopbarColor
		Elements.Panel.Container.Top.Title.TextColor3 = Latte.Modules.Stylesheet.Window.TopbarElementsColor
		end
	for i,v in pairs(Buttons) do
		local ActualSide = Elements.Panel.Container.Top:FindFirstChild(v.Side)
		local Comp = Latte.Components.RoundButton.new(i, v.Image, ActualSide, v.Callback)
		Comp.LayoutOrder = v.Position
		if Latte.Modules.Stylesheet.Window.TopbarUseAccentInstead then
			Comp.Image.ImageColor3 = Latte.Modules.Stylesheet.Window.TopbarElementColorIfAccentUsed
		else
			Comp.Image.ImageColor3 = Latte.Modules.Stylesheet.Window.TopbarElementsColor
		end
		Comp = nil
	end
end

return module