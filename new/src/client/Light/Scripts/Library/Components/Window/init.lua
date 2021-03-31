local module = {}

local function stylise(UI: guiobject)
	local Stylesheet = module.Latte.Modules.Stylesheet
	UI.Container.BackgroundColor3 = Stylesheet.Window.BackgroundColor
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

local function giveMenu(Menu: guiobject)
	local t = {}
	t.Buttons = {}
	t.isActive = false
	
	t.Toggle = function()
		if isActive then
			Latte.Modules.Animator.Menu.animateOut(Menu)
		else
			Latte.Modules.Animator.Menu.animateIn(Menu)
		end
		
		isActive = not isActive
	end
	
	t.setActive = function(Name: string)
		if Buttons[Name] then
			for i,v in pairs(Buttons) do
				if i ~= Name then
					v.Toggle(false)
				else
					v.Toggle(true)
				end
			end
		end
	end
	
	t.newButton = function(Name: string, Position: number, Callback)
		if not Buttons[Name] then
			Buttons[Name] = {}
			
			local Comp = Latte.Components.MenuButton.new(Name, Name, Menu.Container.List, function()
				module.Toggle()
				Callback()
				for i,v in pairs(Buttons) do
					if i ~= Name then
						v.Toggle(false)
					end
				end
			end)
			
			Buttons[Name].Toggle = Comp.setActive
			Comp.Object.LayoutOrder = Position
			Comp = nil
		end
	end
	
	return t
end

module.new = function(Name: string, Title: string?, Size: Vector2?, Parent: instance)
	local Stylesheet = module.Latte.Modules.Stylesheet
	local comp = script.Comp:Clone()
	local Toggled = false
	local t = {
		["Title"] = Title or Name,
		["Size"] = Size or comp.UISizeConstraint.MaxSize
		["Parent"] = Parent,
		["CurrentPage"] = nil,
		["Pages"] = comp.Container.Body,
		["Events"] = {
			["Toggled"] = Instance.new("BindableEvent")
		},
		["ShowMenu"] = false,
		Menu = giveMenu(comp.Container.Menu)
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
	
	t.newPage = function(Name: string, InMenu: boolean?, Position: number?)
		Latte.Components.Page.new(Name, t.Pages)
		if InMenu then
			Menu.newButton(Name, Position or 1, function()
				t.switchPage(Name)
			end)
		end
	end
	
	t.switchPage = function(Page: string)
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
	
	local function cook()
		comp.Container.Top.Title.Text = t.Title
		comp.UISizeConstraint.MaxSize = t.Size
		comp.Parent = t.Parent
		if t.ShowMenu then
			comp.Container.Top.Left.Menu.Visible = true
		end
	end
	
	t.newButton("Exit", "rbxassetid://6235536018", "Right", 1, t.Toggle)
	t.newButton("Menu", "rbxassetid://6272739995", "Left", 1, t.Menu.Toggle).Visible = false
	stylise(comp)
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