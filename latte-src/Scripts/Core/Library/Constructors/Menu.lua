local module, Latte, Elements = {}, nil, nil
local ButtonNames = {"Home", "Players", "Server", "Donate", "About"}
local Buttons = {}
local isActive = false

module.Toggle = function()
	if isActive then
		Latte.Modules.Animator.Menu.animateOut(Elements.Panel.Container.Menu)
	else
		Latte.Modules.Animator.Menu.animateIn(Elements.Panel.Container.Menu)
	end
	
	isActive = not isActive
end

module.setup = function()
	Elements = module.Elements
	Latte = module.Latte
	local Exit = Latte.Components.RoundButton.new("Exit", "rbxassetid://6235536018", Elements.Panel.Container.Menu.Container.Top.Left, module.Toggle)
	Exit.Image.ImageColor3 = Latte.Modules.Stylesheet.Menu.ExitColor
	
	for i,v in pairs(ButtonNames) do
		Buttons[v] = {
			Position = i,
			Callback = function()
				Latte.Constructors.Window.SwitchPage(v)
			end,
		}
	end
	
	for i,v in pairs(Buttons) do
		local Comp = Latte.Components.MenuButton.new(i, i, Elements.Panel.Container.Menu.Container.List, function()
			module.Toggle()
			v.Callback()
			for i2, v2 in pairs(Buttons) do
				if i2 ~= i then
					v2.Toggle(false)
				end
			end
		end)
		
		v.Toggle = Comp.setActive
		Comp.Object.LayoutOrder = v.Position
		Comp = nil
	end
end

return module