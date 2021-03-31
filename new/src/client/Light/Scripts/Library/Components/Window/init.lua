local module = {}

local function stylise(UI: guiobject)
	if Stylesheet.Window.TopbarUseAccentInstead then
		local Accent = Instance.new("Frame")
		Accent.BackgroundColor3 = Stylesheet.Window.AccentColor
		Accent.BorderSizePixel = 0
		Accent.Size = UDim2.new(1, 0, 0, 1)
		Accent.Position = UDim2.new(0, 0, 1, 0)
		Accent.ZIndex = 3
		Accent.Parent = UI.Container.Top
		
		UI.Container.TopbarShadow.Visible = false
		UI.Container.Top.Background.ImageColor3 = Stylesheet.Window.TopbarBackgroundColorIfAccentUsed
		UI.Container.Top.Title.TextColor3 = Stylesheet.Window.TopbarElementColorIfAccentUsed
	else
		UI.Container.Top.Background.ImageColor3 = Stylesheet.Window.TopbarColor
		UI.Container.Top.Title.TextColor3 = Stylesheet.Window.TopbarElementsColor
	end
end

module.new = function(Name: string, Title: string?, Size: UDim2?, Parent: instance)
	local Stylesheet = module.Latte.Modules.Stylesheet
	local comp = script.Comp:Clone()
	local Toggled = false
	local t = {
		["Title"] = Title or Name,
		["Description"] = Description,
		["Parent"] = Parent,
		["CurrentPage"] = nil,
		["Pages"] = comp.Container.Body,
		["Events"] = {
			["Toggled"] = Instance.new("BindableEvent")
		}
	}
	
	t.newButton = function(Name: string, Image: string, Side: string, Position: number, Callback)
		local ActualSide = Comp.Container.Top:FindFirstChild(Side)
		local Comp = Latte.Components.RoundButton.new(Name, Image, ActualSide, Callback)
		Comp.LayoutOrder = Position
		
		if Stylesheet.Window.TopbarUseAccentInstead then
			Comp.Image.ImageColor3 = Stylesheet.Window.TopbarElementColorIfAccentUsed
		else
			Comp.Image.ImageColor3 = Stylesheet.Window.TopbarElementsColor
		end
		Comp = nil
	end
	
	t.switchPage = function(Page: name)
		if tostring(t.CurrentPage):lower() == Page:lower() then return end
		if t.CurrentPage then
			Latte.Modules.Animator.Window.animateOut(t.CurrentPage, t.CurrentPage.UIScale)
		end
		
		t.CurrentPage = Elements.Panel.Container.Body[Page]
		Latte.Modules.Animator.Window.animateIn(t.CurrentPage, t.CurrentPage.UIScale)
	end
	
	t.Toggle = function()
		if Toggled then
			Latte.Modules.Animator.Window.animateOut(Comp, Comp.UIScale)
		else
			Latte.Modules.Animator.Window.animateIn(Comp, Comp.UIScale)
		end
		
		Toggled = not Toggled
		Events.Toggled:Fire(Toggled)
	end
	
	t.newButton("Exit", "rbxassetid://6235536018", "Right", 1, v.Toggle)
	stylise(comp)
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