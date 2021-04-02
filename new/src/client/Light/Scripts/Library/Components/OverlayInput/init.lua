local module = {}


module.new = function(Title: string, Parent: instance)
	local Stylesheet = module.Latte.Modules.Stylesheet
	local Trigger = module.Latte.Modules.Trigger
	local RoundButton = module.Latte.Components.RoundButton
	--local ContainedButton = module.Latte.Components.ContainedButton
	local isDismissed = false
	
	local comp = script.Comp:Clone()
	local exit
	local t = {
		["Title"] = Title,
		["Text"] = "",
		["Parent"] = Parent,
		["Events"] = {
			["Dismissed"] = Instance.new("BindableEvent")
		}
	}
	
	local function cook()
		comp.Container.View.Top.Title.Text = t.Title
		comp.Parent = t.Parent
	end
	
	local function dismiss(Input: string|Boolean)
		if not isDismissed then
			module.Latte.Modules.Animator.Window.animateOut(comp, comp.Container.UIScale)
			t.Events.Dismissed:Fire(Input)
			isDismissed = true
		end
	end
	
	local function wrapFunc(func, arguments)
		return setmetatable({}, {
			__call = function()
				func(table.unpack(arguments))
			end
		})
	end
	
	exit = RoundButton.new("Exit", "rbxassetid://6235536018", comp.Container.View.Top, wrapFunc(dismiss, {false}))
	comp.BackgroundTransparency = 0.5
	comp.Container.Visible = true
	comp.Container.View.Top.Title.TextColor3 = Stylesheet.OverlayInput.TitleColor
	exit.Image.ImageColor3 = Stylesheet.OverlayInput.TitleColor
	comp.Container.View.BackgroundColor3 = Stylesheet.OverlayInput.BackgroundColor
	comp.Container.View.Input.BackgroundColor3 = Stylesheet.OverlayInput.InputBackgroundColor
	comp.Container.View.Top.Accent.BackgroundColor3 = Stylesheet.Window.AccentColor
	comp.Container.View.Input.Accent.BackgroundColor3 = Stylesheet.Window.AccentColor
	comp.Container.View.Input.Input.TextColor3 = Stylesheet.TextField.ContentColor
	comp.Container.View.Input.Input.PlaceholderColor3 = Stylesheet.TextField.PlaceholderColor
	exit.Position = UDim2.new(1, 0, 0, 0)
	exit.AnchorPoint = Vector2.new(1, 0)
	
	cook()
	module.Latte.Modules.Animator.Window.animateIn(comp, comp.Container.UIScale)
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