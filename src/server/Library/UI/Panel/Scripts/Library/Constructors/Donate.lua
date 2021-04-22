local module, Elements, Latte, Page = {}, nil, nil, nil
local Items = {
	{Value = "50", Id = 6502090560},
	{Value = "150", Id = 6502091736},
	{Value = "300", Id = 6502092150},
	{Value = "1000", Id = 6502104947}
}

module.prepare = function()
	local Top = Instance.new("Frame")
	Top.BorderSizePixel = 0
	Top.BackgroundTransparency = 1
	Top.Name = "Top"
	Top.Size = UDim2.new(1, 0, 0, 200)
	Top.Parent = Page

	local Background = Instance.new("ImageLabel")
	Background.BackgroundTransparency = 1
	Background.Image = Latte.Modules.Stylesheet.Home.TopImage
	Background.Name = "Background"
	Background.ScaleType = Enum.ScaleType.Crop
	Background.Size = UDim2.new(1, 0, 1, 0)
	Background.Parent = Top

	local Container = Instance.new("Frame")
	Container.BackgroundTransparency = 1
	Container.Name = "Container"
	Container.Size = UDim2.new(1, 0, 1, 0)
	Container.ZIndex = 2
	Container.Parent = Top

	local UIGradient = Instance.new("UIGradient")
	UIGradient.Rotation = 90
	UIGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1)
	}
	UIGradient.Parent = Background

	local Icon = Instance.new("ImageLabel")
	Icon.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.BackgroundTransparency = 1
	Icon.Image = "rbxassetid://6027381584"
	Icon.Name = "Icon"
	Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
	Icon.ScaleType = Enum.ScaleType.Fit
	Icon.Size = UDim2.new(0, 80, 0, 80)
	Icon.Parent = Container

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Parent = Container

	local Title = Instance.new("TextLabel")
	Title.BackgroundTransparency = 1
	Title.BorderSizePixel = 0
	Title.Font = Latte.Modules.Stylesheet.Fonts.Book
	Title.LayoutOrder = 1
	Title.Name = "Title"
	Title.Size = UDim2.new(1, 0, 0, 18)
	Title.Text = "Donation, please!"
	Title.TextColor3 = Latte.Modules.Stylesheet.Donate.TitleColor
	Title.TextSize = 16
	Title.TextWrapped = true
	Title.Parent = Container

	local Subtitle = Instance.new("TextLabel")
	Subtitle.BackgroundTransparency = 1
	Subtitle.BorderSizePixel = 0
	Subtitle.Font = Latte.Modules.Stylesheet.Fonts.Semibold
	Subtitle.LayoutOrder = 2
	Subtitle.Name = "Subtitle"
	Subtitle.Size = UDim2.new(0.9, 0, 0, 32)
	Subtitle.Text = "While Commander is a free and open-source project, donations are what keeping us to work on this awesome thing."
	Subtitle.TextColor3 = Latte.Modules.Stylesheet.Donate.ParagraphColor
	Subtitle.TextSize = 14
	Subtitle.TextWrapped = true
	Subtitle.TextYAlignment = Enum.TextYAlignment.Bottom
	Subtitle.Parent = Container

	local Padding = Latte.Components.Padding.new(Page)
	Padding.Bottom = UDim.new(0, 10)

	if Latte.Modules.Stylesheet.Donate.TopUseAccentInstead then
		local Accent = Instance.new("Frame")
		Accent.BackgroundColor3 = Latte.Modules.Stylesheet.Window.AccentColor
		Accent.BorderSizePixel = 0
		Accent.Size = UDim2.new(1, 0, 0, 1)
		Accent.Position = UDim2.new(0, 0, 1, 0)
		Accent.ZIndex = 3
		Accent.Parent = Top

		Background.ImageTransparency = 1
		Top.BackgroundTransparency = 0
		Top.BackgroundColor3 = Latte.Modules.Stylesheet.Donate.TopBackgroundColor
	end

	for i,v in pairs(Items) do
		local Button = Latte.Components.OutlinedButton.new(v.Value, "Donate " .. tostring(v.Value) .. " Robux", Page, function()
			Latte.Modules.Services.MarketplaceService:PromptGamePassPurchase(Latte.Modules.Services.Players.LocalPlayer, v.Id)
		end)

		Button.Size = UDim2.new(1, -20, 0, Button.Size.Y.Offset)
		Button.LayoutOrder = i + 1
	end
end

module.setup = function()
	Page = Latte.Constructors.Window.Window.newPage("Donate", true, 4)
	Page.UIListLayout.Padding = UDim.new(0, 10)
	Page.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	module.prepare()
end

module.init = function()
	Latte = module.Latte
	Elements = module.Elements
end

return module