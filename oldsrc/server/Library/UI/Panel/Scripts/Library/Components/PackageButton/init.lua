local module = {}

local reaction = function(Button: guiobject, State: string)
	module.Latte.Modules.Animator.Button.Package[State](Button)
end

module.new = function(Title: string, Description: string, Parent: instance)
	local Stylesheet = module.Latte.Modules.Stylesheet
	local Trigger = module.Latte.Modules.Trigger
	local comp = script.Comp:Clone()
	local t = {
		["Title"] = Title,
		["Description"] = Description,
		["Visible"] = true,
		["Object"] = comp,
		["Parent"] = Parent,
		["Events"] = {
			["Clicked"] = Instance.new("BindableEvent")
		}
	}

	local function cook()
		comp.Name = t.Title
		comp.Visible = t.Visible
		comp.Container.Text.Title.Text = t.Title
		comp.Container.Text.Description.Text = t.Description
		comp.Parent = t.Parent
	end

	module.Latte.Modules.Trigger.new(comp, reaction, 3, false):Connect(function()
		t.Events.Clicked:Fire()
	end)

	comp.Container.Text.Title.Font = Stylesheet.Fonts.Book
	comp.Container.Text.Description.Font = Stylesheet.Fonts.Semibold
	comp.Container.Text.Description.TextSize = 13
	comp.Container.UICorner.CornerRadius = Stylesheet.CornerData.PackageButton
	comp.Container.Text.Title.TextColor3 = Stylesheet.PackageButton.TitleColor
	comp.Container.Text.Description.TextColor3 = Stylesheet.PackageButton.DescriptionColor
	comp.Container.BackgroundColor3 = Stylesheet.PackageButton.BackgroundColor
	comp.Container.Accent.BackgroundColor3 = Stylesheet.Window.AccentColor

	cook()
	return setmetatable({}, {
		__index = function(_, key: string)
			return t[key]
		end,
		__newindex = function(_, key: string, value: any)
			if t[key] then
				t[key] = value
				cook()
				return t[key]
			end
		end,
	})
end

return module