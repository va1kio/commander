local module = {}

local reaction = function(Button: guiobject, State: string)
	module.Latte.Modules.Animator.Button.Menu[State](Button)
end

local returnItemOnStatement = function(Result: boolean, ItemWhenTrue: any, ItemWhenFalse: any)
	if Result then
		return ItemWhenTrue
	else
		return ItemWhenFalse
	end
end

module.new = function(Name: string, Text: string?, Parent: instance, Callback: (string) -> void)
	local Stylesheet = module.Latte.Modules.Stylesheet
	local Comp = script.Comp:Clone()
	local t = {}
	t.Object =  Comp
	Comp.Name = Name
	Comp.Title.Text = Text or Name
	Comp.isActive.ImageColor3 = Stylesheet.ThemeColor
	Comp.BackgroundColor3 = Stylesheet.Button.MenuHoverColor
	
	t.setActive = function(Status: boolean)
		Comp.isActive.Visible = Status
		Comp.Title.TextColor3 = returnItemOnStatement(Status == true, Stylesheet.ThemeColor, Stylesheet.Menu.DefaultTextColor)
		Comp.Title.Font = returnItemOnStatement(Status == true, Enum.Font.GothamSemibold, Enum.Font.Gotham)
	end

	module.Latte.Modules.Trigger.new(Comp, reaction, 2, false):Connect(function()
		t.setActive(true)
		Callback()
	end)

	Comp.Parent = Parent
	return t
end

return module