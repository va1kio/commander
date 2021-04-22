local module = {}

local reaction = function(Button: guiobject, State: string)
	module.Latte.Modules.Animator.Button.Outlined[State](Button)
end

module.new = function(Name: string, Text: string?, Parent: instance, Callback: (string) -> void)
	local Comp = script.Comp:Clone()
	Comp.Name = Name
	Comp.Container.Title.Text = Text or Name
	Comp.Container.Title.Font = module.Latte.Modules.Stylesheet.Fonts.Semibold
	Comp.Background.BackgroundColor3 = module.Latte.Modules.Stylesheet.ThemeColor
	Comp.Background.Outline.ImageColor3 = module.Latte.Modules.Stylesheet.ThemeColor
	Comp.Container.Title.TextColor3 = module.Latte.Modules.Stylesheet.ThemeColor

	module.Latte.Modules.Trigger.new(Comp, reaction, 3, false):Connect(function()
		Callback()
	end)

	Comp.Parent = Parent
	return Comp
end

return module