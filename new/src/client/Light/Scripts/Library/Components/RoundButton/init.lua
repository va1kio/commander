local module = {}

local reaction = function(Button: guiobject, State: string)
	module.Latte.Modules.Animator.Button.Round[State](Button)
end

module.new = function(Name: string, Image: string, Parent: instance, Callback: (string) -> void)
	local Comp = script.Comp:Clone()
	Comp.Name = Name
	Comp.Image.Image = Image
	Comp.Hover.BackgroundColor3 = module.Latte.Modules.Stylesheet.Button.RoundHoverColor
	
	module.Latte.Modules.Trigger.new(Comp, reaction, 3, false):Connect(function()
		Callback()
	end)
	
	Comp.Parent = Parent
	return Comp
end

return module