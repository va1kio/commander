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

module.setup = function()
	Elements = module.Elements
	Latte = module.Latte
	Elements.Panel.Container.Top.Background.ImageColor3 = Latte.Modules.Stylesheet.Window.TopbarColor
	Elements.Panel.Container.Top.Title.TextColor3 = Latte.Modules.Stylesheet.Window.TopbarElementsColor
	for i,v in pairs(Buttons) do
		local ActualSide = Elements.Panel.Container.Top:FindFirstChild(v.Side)
		local Comp = Latte.Components.RoundButton.new(i, v.Image, ActualSide, v.Callback)
		Comp.LayoutOrder = v.Position
		Comp.Image.ImageColor3 = Latte.Modules.Stylesheet.Window.TopbarElementsColor
		Comp = nil
	end
end

return module