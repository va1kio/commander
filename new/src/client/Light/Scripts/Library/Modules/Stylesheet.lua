local module = {}

-- Primary color
module.ThemeColor = Color3.fromRGB(64, 157, 130)

-- Window color
module.Window = {}
module.Window.TopbarColor = module.ThemeColor
module.Window.TopbarElementsColor = Color3.fromRGB(255, 255, 255)
module.Window.AccentColor = Color3.fromRGB(205, 205, 205)
module.Window.BackgroundColor = Color3.fromRGB(240, 240, 240)
module.Window.ScrollBarColor = Color3.fromRGB(0, 0, 0)

-- Button color
module.Button = {}
module.Button.RoundHoverColor = Color3.fromRGB(0, 0, 0)
module.Button.MenuHoverColor = module.Button.RoundHoverColor
module.Button.ModalHoverColor = module.ThemeColor

-- Menu constructor color
module.Menu = {}
module.Menu.BackgroundColor = Color3.fromRGB(250, 250, 250)
module.Menu.DefaultTextColor = Color3.fromRGB(100, 100, 100)
module.Menu.ExitColor = module.Menu.DefaultTextColor

-- Home constructor color
module.Home = {}
module.Home.UsernameColor = Color3.fromRGB(0, 0, 0)
module.Home.RankColor = Color3.fromRGB(120, 120, 120)
module.Home.AvatarBorder = module.Window.AccentColor
module.Home.AvatarBackground = Color3.fromRGB(255, 255, 255)
module.Home.TopImage = "rbxasset://textures/AvatarEditorImages/AvatarEditor_LightTheme.png"
module.Home.TopUseAccentInstead = true
module.Home.TopBackgroundColor = Color3.fromRGB(250, 250, 250)

-- SeparatedList component color
module.SeparatedList = {}
module.SeparatedList.Item = {}
module.SeparatedList.TitleColor = Color3.fromRGB(150, 150, 150)
module.SeparatedList.Item.TitleColor = Color3.fromRGB(0, 0, 0)
module.SeparatedList.Item.ValueColor = Color3.fromRGB(0, 0, 0)

-- Duration for tweens
module.Duration = {
	VeryShort = 0.15,
	Short = 0.3
}

return module