local module = {}

local reaction = function(Button: guiobject, State: string)
	module.Latte.Modules.Animator.Button.Round[State](Button)
end

module.new = function(Name: string, Image: string, Parent: instance, Callback: (string) -> void, Arguments: any?)
	local Comp = script.Comp:Clone()
	Comp.Name = Name
	Comp.Image.Image = Image
	Comp.Hover.UICorner.CornerRadius = module.Latte.Modules.Stylesheet.CornerData.RoundButton
	Comp.Hover.BackgroundColor3 = module.Latte.Modules.Stylesheet.Button.RoundHoverColor

	module.Latte.Modules.Trigger.new(Comp, reaction, 3, false):Connect(function()
		Callback(Arguments)
	end)

	Comp.Parent = Parent
	return Comp
end

return module