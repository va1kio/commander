local module = {}

local reaction = function(Button: guiobject, State: string)
	module.Latte.Modules.Animator.Button.Flat[State](Button)
end

module.new = function(Name: string, Text: string?, Parent: instance, Callback, Arguments: any?)
	local Comp = script.Comp:Clone()
	Comp.Name = Name
	Comp.Title.Text = Text or Name
	Comp.Hover.BackgroundColor3 = module.Latte.Modules.Stylesheet.ThemeColor
	
	module.Latte.Modules.Trigger.new(Comp, reaction, 3, false):Connect(function()
		Callback(Arguments)
	end)
	
	Comp.Parent = Parent
	return Comp
end

return module