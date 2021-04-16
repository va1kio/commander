local module, Page, Latte, Elements = {}, nil, nil, nil

module.prepare = function()
	local Top = Instance.new("Frame")
	Top.BackgroundColor3 = Latte.Modules.Stylesheet.Home.TopBackgroundColor
	Top.BorderSizePixel = 0
	Top.Name = "Top"
	Top.Size = UDim2.new(1, 0, 0, 62)
	Top.Parent = Page

	local Update = Instance.new("Frame")
	Update.BackgroundTransparency = 1
	Update.LayoutOrder = 1
	Update.Name = "Update"
	Update.Size = UDim2.new(1, 0, 0, 62)
	Update.Parent = Page

	local Bottom = Instance.new("Frame")
	Bottom.BackgroundTransparency = 1
	Bottom.LayoutOrder = 2
	Bottom.Name = "Bottom"
	Bottom.Size = UDim2.new(1, 0, 1, -126)
	Bottom.Parent = Page

	local Container = Instance.new("Frame")
	Container.BackgroundTransparency = 1
	Container.Name = "Container"
	Container.Size = UDim2.new(1, 0, 1, 0)
	Container.Parent = Top

	local Accent = Instance.new("Frame")
	Accent.BackgroundColor3 = Latte.Modules.Stylesheet.Window.AccentColor
	Accent.BorderSizePixel = 0
	Accent.LayoutOrder = 1
	Accent.Name = "Accent"
	Accent.Position = UDim2.new(0, 0, 1, 0)
	Accent.Size = UDim2.new(1, 0, 0, 1)
	Accent.Parent = Top

	local Container2 = Instance.new("Frame")
	Container2.BackgroundTransparency = 1
	Container2.Name = "Container"
	Container2.Size = UDim2.new(1, 0, 1, 0)
	Container2.Parent = Update

	local Accent2 = Instance.new("Frame")
	Accent2.BackgroundColor3 = Latte.Modules.Stylesheet.Window.AccentColor
	Accent2.BorderSizePixel = 0
	Accent2.LayoutOrder = 1
	Accent2.Name = "Accent"
	Accent2.Position = UDim2.new(0, 0, 1, 0)
	Accent2.Size = UDim2.new(1, 0, 0, 1)
	Accent2.Parent = Update

	local Container3 = Instance.new("Frame")
	Container3.BackgroundTransparency = 1
	Container3.Name = "Container"
	Container3.Size = UDim2.new(1, 0, 1, 0)
	Container3.Parent = Bottom

	local UIPadding = Instance.new("UIPadding")
	UIPadding.PaddingBottom = UDim.new(0, 12)
	UIPadding.PaddingLeft = UDim.new(0, 12)
	UIPadding.PaddingTop = UDim.new(0, 12)
	UIPadding.Parent = Container

	local UIListLayout2 = Instance.new("UIListLayout")
	UIListLayout2.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout2.Padding = UDim.new(0, 10)
	UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout2.Parent = Container

	local Text = Instance.new("Frame")
	Text.BackgroundTransparency = 1
	Text.LayoutOrder = 1
	Text.Name = "Text"
	Text.AutomaticSize = Enum.AutomaticSize.X
	Text.Size = UDim2.new(0, 0, 1, 0)
	Text.Parent = Container

	local Icon = Instance.new("ImageLabel")
	Icon.BackgroundTransparency = 1
	Icon.Image = "rbxassetid://6027381584"
	Icon.Name = "Icon"
	Icon.ScaleType = Enum.ScaleType.Fit
	Icon.Size = UDim2.new(1, 0, 1, 0)
	Icon.Parent = Container

	local UIPadding2 = Instance.new("UIPadding")
	UIPadding2.PaddingBottom = UDim.new(0, 12)
	UIPadding2.PaddingLeft = UDim.new(0, 12)
	UIPadding2.PaddingTop = UDim.new(0, 12)
	UIPadding2.Parent = Container2

	local UIListLayout3 = Instance.new("UIListLayout")
	UIListLayout3.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout3.Padding = UDim.new(0, 10)
	UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout3.Parent = Container2

	local Text2 = Instance.new("Frame")
	Text2.BackgroundTransparency = 1
	Text2.LayoutOrder = 1
	Text2.Name = "Text"
	Text2.AutomaticSize = Enum.AutomaticSize.X
	Text2.Size = UDim2.new(0, 0, 1, 0)
	Text2.Parent = Container2

	local Icon2 = Instance.new("ImageLabel")
	Icon2.BackgroundTransparency = 1
	Icon2.ImageTransparency = 1
	Icon2.Name = "Icon"
	Icon2.ScaleType = Enum.ScaleType.Fit
	Icon2.Size = UDim2.new(1, 0, 1, 0)
	Icon2.Parent = Container2

	local UIPadding3 = Instance.new("UIPadding")
	UIPadding3.PaddingBottom = UDim.new(0, 12)
	UIPadding3.PaddingLeft = UDim.new(0, 12)
	UIPadding3.PaddingRight = UDim.new(0, 12)
	UIPadding3.PaddingTop = UDim.new(0, 12)
	UIPadding3.Parent = Container3

	local UIListLayout4 = Instance.new("UIListLayout")
	UIListLayout4.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout4.Padding = UDim.new(0, 10)
	UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout4.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout4.Parent = Container3

	local Evo = Instance.new("Frame")
	Evo.BackgroundTransparency = 1
	Evo.LayoutOrder = 2
	Evo.Name = "Evo"
	Evo.Size = UDim2.new(1, 0, 0, 19)
	Evo.Parent = Container3

	local Credits = Instance.new("Frame")
	Credits.BackgroundTransparency = 1
	Credits.LayoutOrder = 1
	Credits.Name = "Credits"
	Credits.AutomaticSize = Enum.AutomaticSize.Y
	Credits.Size = UDim2.new(1, 0, 0, 0)
	Credits.Parent = Container3

	local UIListLayout5 = Instance.new("UIListLayout")
	UIListLayout5.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout5.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout5.Parent = Text

	local Title = Instance.new("TextLabel")
	Title.AnchorPoint = Vector2.new(0.5, 0.5)
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1
	Title.BorderSizePixel = 0
	Title.Font = Latte.Modules.Stylesheet.Fonts.Book
	Title.Name = "Title"
	Title.AutomaticSize = Enum.AutomaticSize.X
	Title.Position = UDim2.new(0.5, 0, 0.5, 0)
	Title.Size = UDim2.new(0, 0, 0, 16)
	Title.Text = "Commander <b>4</b>"
	Title.RichText = true
	Title.TextColor3 = Latte.Modules.Stylesheet.About.TitleColor
	Title.TextSize = 16
	Title.TextWrapped = false
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.ZIndex = 3
	Title.Parent = Text

	local Subtitle = Instance.new("TextLabel")
	Subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
	Subtitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Subtitle.BackgroundTransparency = 1
	Subtitle.BorderSizePixel = 0
	Subtitle.Font = Latte.Modules.Stylesheet.Fonts.Semibold
	Subtitle.LayoutOrder = 1
	Subtitle.Name = "Subtitle"
	Subtitle.AutomaticSize = Enum.AutomaticSize.X
	Subtitle.Position = UDim2.new(0.5, 0, 0.5, 0)
	Subtitle.Size = UDim2.new(0, 0, 0, 14)
	Subtitle.Text = "Version 1.0.0 (Official Build)"
	Subtitle.TextColor3 = Latte.Modules.Stylesheet.About.SubtitleColor
	Subtitle.TextSize = 12
	Subtitle.TextWrapped = false
	Subtitle.TextXAlignment = Enum.TextXAlignment.Left
	Subtitle.ZIndex = 3
	Subtitle.Parent = Text

	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	UIAspectRatioConstraint.Parent = Icon

	local UIListLayout6 = Instance.new("UIListLayout")
	UIListLayout6.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout6.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout6.Parent = Text2

	local Title2 = Instance.new("TextLabel")
	Title2.AnchorPoint = Vector2.new(0.5, 0.5)
	Title2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title2.BackgroundTransparency = 1
	Title2.BorderSizePixel = 0
	Title2.Font = Latte.Modules.Stylesheet.Fonts.Book
	Title2.Name = "Title"
	Title2.AutomaticSize = Enum.AutomaticSize.X
	Title2.Position = UDim2.new(0.5, 0, 0.5, 0)
	Title2.Size = UDim2.new(0, 0, 0, 16)
	Title2.Text = "Unable to fetch version info"
	Title2.RichText = true
	Title2.TextColor3 = Latte.Modules.Stylesheet.About.TitleColor
	Title2.TextSize = 16
	Title2.TextWrapped = false
	Title2.TextXAlignment = Enum.TextXAlignment.Left
	Title2.ZIndex = 3
	Title2.Parent = Text2

	local Subtitle2 = Instance.new("TextLabel")
	Subtitle2.AnchorPoint = Vector2.new(0.5, 0.5)
	Subtitle2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Subtitle2.BackgroundTransparency = 1
	Subtitle2.BorderSizePixel = 0
	Subtitle2.Font = Latte.Modules.Stylesheet.Fonts.Semibold
	Subtitle2.LayoutOrder = 1
	Subtitle2.Name = "Subtitle"
	Subtitle2.AutomaticSize = Enum.AutomaticSize.X
	Subtitle2.Position = UDim2.new(0.5, 0, 0.5, 0)
	Subtitle2.Size = UDim2.new(0, 0, 0, 14)
	Subtitle2.Text = "Try again later"
	Subtitle2.TextColor3 = Latte.Modules.Stylesheet.About.SubtitleColor
	Subtitle2.TextSize = 12
	Subtitle2.TextWrapped = false
	Subtitle2.TextXAlignment = Enum.TextXAlignment.Left
	Subtitle2.ZIndex = 3
	Subtitle2.Parent = Text2

	local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")
	UIAspectRatioConstraint2.Parent = Icon2

	local Symbol = Instance.new("ImageLabel")
	Symbol.AnchorPoint = Vector2.new(0.5, 0.5)
	Symbol.BackgroundTransparency = 1
	Symbol.Image = "http://www.roblox.com/asset/?id=6521419672"
	Symbol.ImageColor3 = Latte.Modules.Stylesheet.About.IconColor
	Symbol.Name = "Symbol"
	Symbol.Position = UDim2.new(0.5, 0, 0.5, 0)
	Symbol.ScaleType = Enum.ScaleType.Fit
	Symbol.Size = UDim2.new(0.7, 0, 0.7, 0)
	Symbol.Parent = Icon2

	local Icon3 = Instance.new("ImageLabel")
	Icon3.BackgroundTransparency = 1
	Icon3.Image = "http://www.roblox.com/asset/?id=6610459865"
	Icon3.ImageColor3 = Latte.Modules.Stylesheet.About.ParagraphColor
	Icon3.LayoutOrder = 1
	Icon3.Name = "Icon"
	Icon3.ScaleType = Enum.ScaleType.Fit
	Icon3.Size = UDim2.new(0, 30, 0, 19)
	Icon3.Parent = Evo

	local UIListLayout7 = Instance.new("UIListLayout")
	UIListLayout7.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout7.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout7.Padding = UDim.new(0, 10)
	UIListLayout7.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout7.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout7.Parent = Evo

	local UIListLayout8 = Instance.new("UIListLayout")
	UIListLayout8.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout8.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout8.Padding = UDim.new(0, 10)
	UIListLayout8.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout8.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout8.Parent = Credits

	local Title3 = Instance.new("TextLabel")
	Title3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title3.BackgroundTransparency = 1
	Title3.Font = Latte.Modules.Stylesheet.Fonts.Book
	Title3.Name = "Title"
	Title3.AutomaticSize = Enum.AutomaticSize.XY
	Title3.RichText = true
	Title3.Text = "Commander is made possible with Latte and other open sourced softwares<br />learn more at our GitHub repository"
	Title3.TextColor3 = Latte.Modules.Stylesheet.About.ParagraphColor
	Title3.TextSize = 12
	Title3.TextWrapped = false
	Title3.Parent = Credits
end

module.update = function()
	Page.Top.Container.Text.Title.Text = "Commander <b>" .. Settings.Version[3] .. "</b>"
	Page.Top.Container.Text.Subtitle.Text = "Version " .. Settings.Version[2]
end

module.setup = function()
	module.Remotes.RemoteEvent.OnClientEvent:Connect(function(Type, Protocol, Attachment)
		if Type == "firstRun" then
			Settings = Attachment
			module.update()
		end
	end)

	Page = Latte.Constructors.Window.Window.newPage("About", true, 5)
	Page.UIListLayout.Padding = UDim.new(0, 1)
	module.prepare()
end

module.init = function()
	Latte = module.Latte
	Elements = module.Elements
end

return module