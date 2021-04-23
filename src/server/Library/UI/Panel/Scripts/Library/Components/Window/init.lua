local module = {}

-- Style window object.
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
		UI.Container.Top.Title.TextSize = 16
		UI.Container.Top.BackgroundColor3 = Stylesheet.Window.TopbarBackgroundColorIfAccentUsed
		UI.Container.Top.Background.ImageColor3 = Stylesheet.Window.TopbarBackgroundColorIfAccentUsed
		UI.Container.Top.Title.TextColor3 = Stylesheet.Window.TopbarElementColorIfAccentUsed
	else
		UI.Container.Top.BackgroundColor3 = Stylesheet.Window.TopbarColor
		UI.Container.Top.Background.ImageColor3 = Stylesheet.Window.TopbarColor
		UI.Container.Top.Title.TextColor3 = Stylesheet.Window.TopbarElementsColor
	end
end

-- Populate menu container.
local function giveMenu(Menu: guiobject)
	local Latte = module.Latte

	local t = {}
	t.Buttons = {}
	t.isActive = false

	local Exit
	Menu.Container.Top.Accent.BackgroundColor3 = Latte.Modules.Stylesheet.Menu.AccentColor
	Menu.Container.BackgroundColor3 = Latte.Modules.Stylesheet.Menu.BackgroundColor

	t.Toggle = function()
		if t.isActive then
			Latte.Modules.Animator.Menu.animateOut(Menu)
		else
			Latte.Modules.Animator.Menu.animateIn(Menu)
		end

		t.isActive = not t.isActive
	end

	t.setActive = function(Name: string)
		if t.Buttons[Name] then
			for i,v in pairs(t.Buttons) do
				if i ~= Name then
					v.Toggle(false)
				else
					v.Toggle(true)
				end
			end
		end
	end

	t.newButton = function(Name: string, Position: number, Callback)
		if not t.Buttons[Name] then
			t.Buttons[Name] = {}

			local comp = Latte.Components.MenuButton.new(Name, Name, Menu.Container.List, function()
				t.Toggle()
				Callback()
				for i,v in pairs(t.Buttons) do
					if i ~= Name then
						v.Toggle(false)
					end
				end
			end)

			t.Buttons[Name].Toggle = comp.setActive
			comp.Object.LayoutOrder = Position
			comp = nil
		end
	end

	Exit = Latte.Components.RoundButton.new("Exit", "rbxassetid://6521420400", Menu.Container.Top.Left, t.Toggle)
	Exit.Image.ImageColor3 = Latte.Modules.Stylesheet.Menu.ExitColor
	Exit.Image.Size = UDim2.new(0.3, 0, 0.3, 0)

	return t
end

module.new = function(Name: string, Title: string?, Size: Vector2?, ShowMenu: Boolean?, Parent: instance)
	local Latte = module.Latte
	local Stylesheet = Latte.Modules.Stylesheet
	local comp = script.Comp:Clone()
	Latte.Modules.Snapdragon.createDragController(comp.Container.Top, {SnapEnabled = true, DragGui = comp}):Connect()
	local Toggled = true

	local window = {
		["Title"] = Title or Name,
		["Size"] = Size or comp.UISizeConstraint.MaxSize,
		["Parent"] = Parent,
		["CurrentPage"] = nil,
		["ZIndex"] = 1,
		["Pages"] = comp.Container.Body,
		["Events"] = {
			["Toggled"] = Instance.new("BindableEvent")
		},
		["ShowMenu"] = ShowMenu or false,
		["Menu"] = giveMenu(comp.Container.Menu)
	}

	window.newButton = function(Name: string, Image: string, Side: string, Position: number, Callback)
		local ActualSide = comp.Container.Top:FindFirstChild(Side)
		local comp = Latte.Components.RoundButton.new(Name, Image, ActualSide, Callback)
		comp.LayoutOrder = Position

		if Stylesheet.Window.TopbarUseAccentInstead then
			comp.Image.ImageColor3 = Stylesheet.Window.TopbarElementColorIfAccentUsed
		else
			comp.Image.ImageColor3 = Stylesheet.Window.TopbarElementsColor
		end
		return comp
	end

	window.newPage = function(Name: string, InMenu: boolean?, Position: number?)
		local page = Latte.Components.Page.new(Name, window.Pages)

		if InMenu then
			window.Menu.newButton(Name, Position or 1, function()
				window.switchPage(Name)
			end)
		end

		return page
	end

	window.removePage = function(Name: string, NewPage: string)
		local page = window.Pages:FindFirstChild(Name)

		if not page then return end

		if window.CurrentPage == page then
			window.switchPage(NewPage)
		end

		if window.Menu.Buttons[Name] ~= nil then
			window.Menu.Buttons[Name]:Destroy()
			window.Menu.Buttons[Name] = nil
		end

		page:Destroy()
	end

	window.switchPage = function(Page: string)
		if tostring(window.CurrentPage):lower() == Page:lower() then return end

		if window.CurrentPage then
			Latte.Modules.Animator.Window.animateOut(window.CurrentPage, window.CurrentPage.UIScale)
		end

		window.CurrentPage = window.Pages[Page]
		Latte.Modules.Animator.Window.animateIn(window.CurrentPage, window.CurrentPage.UIScale)
	end

	window.Toggle = function(Override: boolean?)
		if Override then
			Latte.Modules.Animator.Window.animateIn(comp, comp.UIScale)
		elseif Override == false then
			Latte.Modules.Animator.Window.animateOut(comp, comp.UIScale)
		elseif Toggled then
			Latte.Modules.Animator.Window.animateOut(comp, comp.UIScale)
		else
			Latte.Modules.Animator.Window.animateIn(comp, comp.UIScale)
		end

		Toggled = Override or not Toggled
		window.Events.Toggled:Fire(Toggled)
	end

	-- Fix data.
	local function cook()
		comp.Name = window.Title
		comp.Container.Top.Title.Text = window.Title
		comp.UISizeConstraint.MaxSize = window.Size
		comp.Parent = window.Parent
		comp.Container.Top.Left.Menu.Visible = window.ShowMenu
		comp.ZIndex = window.ZIndex

		if window.Parent == nil then
			comp:Destroy()
			window = nil
		end
	end

	comp.Container.Top.Title.Font = module.Latte.Modules.Stylesheet.Fonts.Semibold
	window.newButton("Exit", "rbxassetid://6235536018", "Right", 1, window.Toggle)
	window.newButton("Menu", "rbxassetid://6272739995", "Left", 1, window.Menu.Toggle)
	window.Toggle()
	stylise(comp)
	cook()

	return setmetatable({}, {
		__index = function(_, key: string)
			return window[key]
		end,
		__newindex = function(_, key: string, value: any)
			if window[key] then
				window[key] = value
				cook()
				return window[key]
			end
		end,
	})
end

return module