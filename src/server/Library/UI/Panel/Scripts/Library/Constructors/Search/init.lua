local module = {}
local Latte, Elements, Packages = nil, nil, {}

local function fetch()
	Packages = {}
	for _,v in pairs(Latte.Constructors.Window.Window.Pages.Players:GetChildren()) do
		if string.lower(v.Name) ~= "target" and v:IsA("Frame") then
			table.insert(Packages, v.Name)
		end
	end

	for _,v in pairs(Latte.Constructors.Window.Window.Pages.Server:GetChildren()) do
		if v:IsA("Frame") then
			table.insert(Packages, v.Name)
		end
	end
end

module.setup = function()
	local Active = false
	local Top = Latte.Constructors.Window.Window.Pages.Parent.Top
	local Linear = Latte.Modules.TweenInfo.Linear(Latte.Modules.Stylesheet.Duration.Short)
	local SearchComp = script.SearchComp:Clone()
	local UICorner = Instance.new("UICorner")
	local Searchbox = script.SearchBox:Clone()
	local QuitSearch = nil
	UICorner.CornerRadius = Latte.Modules.Stylesheet.CornerData.Window
	Searchbox.Background.SliceScale = Latte.Modules.Stylesheet.CornerData.Window.Offset / 300
	SearchComp.Visible = false
	Searchbox.Visible = false
	UICorner.Parent = SearchComp
	Searchbox.Parent = Top
	SearchComp.Parent = Top.Parent

	Searchbox.Input:GetPropertyChangedSignal("Text"):Connect(function()
		if #Packages == 0 then fetch() end
		for _, v in pairs(SearchComp.Container:GetChildren()) do
			if v:IsA("TextButton") then
				v:Destroy()
			end 
		end

		if string.len(Searchbox.Input.Text) >= 1 then
			local matcher = Latte.Modules.Matcher.new(Packages, true, true)
			for i, v in pairs(matcher:match(Searchbox.Input.Text)) do
				if i <= 3 then
					local Location = Latte.Constructors.Window.Window.Pages.Server:FindFirstChild(v) and Latte.Constructors.Window.Window.Pages.Server or Latte.Constructors.Window.Window.Pages.Players
					local Item = script.Item:Clone()
					Item.Name, Item.Title.Text = v, v
					Item.MouseButton1Click:Connect(function()
						Active = false
						Searchbox.Visible = false
						SearchComp.Visible = false
						Searchbox.Input.Text = ""
						Latte.Constructors.Window.SwitchPage(Location.Name)
						Latte.Constructors.Window.Window.Menu.setActive(Location.Name)

						wait(Latte.Modules.Stylesheet.Duration.Short)
						Location.CanvasPosition = Vector2.new(0, 0)
						-- TODO: Find a better way to do this, the current method is pretty hardcoded.
						Latte.Modules.Tween.new(Location, Latte.Modules.TweenInfo.Quint(Latte.Modules.Stylesheet.Duration.Short) ,{CanvasPosition = Vector2.new(0, Location:FindFirstChild(v).AbsolutePosition.Y - 155)})
					end)

					Item.LayoutOrder = i
					Item.Parent = SearchComp.Container
				end
			end
		end
	end)

	QuitSearch = Latte.Components.RoundButton.new("Exit", "rbxassetid://6235536018", Searchbox, function()
		Active = false
		Searchbox.Visible = false
		SearchComp.Visible = false
	end)
	Latte.Constructors.Window.Window.newButton("Search", "rbxassetid://6521439400", "Right", 0, function()
		Active = true
		Searchbox.Input:CaptureFocus()
		Searchbox.Visible = true
		SearchComp.Visible = true
	end).Image.Size = UDim2.new(0.35, 0, 0.35, 0)

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