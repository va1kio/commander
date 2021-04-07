local module = {}

module.new = function(Title: string, Placeholder: string, Parent: instance)
	local Stylesheet = module.Latte.Modules.Stylesheet
	local RoundButton = module.Latte.Components.RoundButton
	local comp = script.Comp:Clone()
	local ContentChanged = Instance.new("BindableEvent")
	local clearAll
	local t = {
		["Title"] = Title,
		["Placeholder"] = Placeholder,
		["Content"] = "",
		["Parent"] = Parent,
		["Events"] = {
			["ContentChanged"] = ContentChanged.Event
		}
	}
	
	local function cook()
		comp.Name = t.Title
		comp.Title.Text = t.Title
		comp.Input.Box.PlaceholderText = t.Placeholder
		comp.Input.Box.Text = t.Content
		comp.Parent = t.Parent
	end
	
	clearAll = RoundButton.new("Exit", "rbxassetid://6235536018", comp.Input, function()
		comp.Input.Box.Text = ""
	end)
	clearAll.Position = UDim2.new(1, 0, 0, 0)
	clearAll.AnchorPoint = Vector2.new(1, 0)
	comp.Title.TextColor3 = Stylesheet.TextField.TitleColor
	comp.Input.Box.PlaceholderColor3 = Stylesheet.TextField.PlaceholderColor
	comp.Input.Box.TextColor3 = Stylesheet.TextField.ContentColor
	comp.Input.Accent.BackgroundColor3 = Stylesheet.Window.AccentColor
	
	comp.Input.Box:GetPropertyChangedSignal("Text"):Connect(function()
		t.Content = comp.Input.Box.Text
		ContentChanged:Fire(t.Content)
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