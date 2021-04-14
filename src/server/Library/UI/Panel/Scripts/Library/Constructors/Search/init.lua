local module = {}
Latte, Elements = nil, nil

module.setup = function()
	local Active = false
	local Top = Latte.Constructors.Window.Window.Pages.Parent.Top
	local Linear = Latte.Modules.TweenInfo.Linear(Latte.Modules.Stylesheet.Duration.Short)
	local SearchComp = script.SearchComp:Clone()
	local Searchbox = script.SearchBox:Clone()
	local QuitSearch = nil
	SearchComp.Visible = false
	Searchbox.Visible = false
	Searchbox.Parent = Top
	SearchComp.Parent = Top.Parent
	
	Searchbox.Input:GetPropertyChangedSignal("Text"):Connect(function()
		-- TODO: Finish search
	end)
	
	QuitSearch = Latte.Components.RoundButton.new("Exit", "rbxassetid://6235536018", Searchbox, function()
		Active = false
		Searchbox.Visible = false
	end)
	Latte.Constructors.Window.Window.newButton("Search", "rbxassetid://6521439400", "Right", 0, function()
		Active = true
		Searchbox.Input:CaptureFocus()
		Searchbox.Visible = true
	end)
	
	QuitSearch.ZIndex = 3
	QuitSearch.Image.ImageColor3 = Color3.fromRGB(150, 150, 150)
	QuitSearch.Position = UDim2.new(1, 0, 0, 0)
	QuitSearch.AnchorPoint = Vector2.new(1, 0)
end

module.init = function()
	Latte = module.Latte
	Elements = module.Elements
end

return module