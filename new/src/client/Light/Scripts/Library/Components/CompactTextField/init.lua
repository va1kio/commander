local module = {}

module.new = function(Title: string, Placeholder: string, Parent: instance)
	local Stylesheet = module.Latte.Modules.Stylesheet
	local RoundButton = module.Latte.Components.RoundButton
	local comp = script.Comp:Clone()
	local t = {
		["Title"] = Title,
		["Placeholder"] = Placeholder,
		["Content"] = "",
		["Parent"] = Parent,
		["Events"] = {
			["ContentChanged"] = comp.Input.Box:GetPropertyChangedSignal("Text")
		}
	}
	
	local function cook()
		comp.Title.Text = t.Title
		comp.Input.Box.PlaceholderText = t.Placeholder
		comp.Input.Box.Text = t.Content
		comp.Parent = t.Parent
	end
	
	comp.Title.TextColor3 = Stylesheet.TextField.TitleColor
	comp.Input.Box.PlaceholderColor3 = Stylesheet.TextField.PlaceholderColor
	comp.Input.Box.TextColor3 = Stylesheet.TextField.ContentColor
	comp.Input.Accent.BackgroundColor3 = Stylesheet.Window.AccentColor
	
	t.Events.ContentChanged:Connect(function()
		t.Content = comp.Input.Box.Text
	end)
	
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