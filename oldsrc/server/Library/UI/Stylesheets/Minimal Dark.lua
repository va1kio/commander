local module = {}

-- Primary color
module.ThemeColor = script.ThemeColor.Value or Color3.fromRGB(64, 157, 130)

-- Window color
module.Window = {}
module.Window.TopbarColor = module.ThemeColor
module.Window.TopbarElementsColor = Color3.fromRGB(255, 255, 255)
module.Window.AccentColor = Color3.fromRGB(45, 45, 45)
module.Window.BackgroundColor = Color3.fromRGB(25, 25, 25)
module.Window.ScrollBarColor = Color3.fromRGB(250, 250, 250)
module.Window.TopbarBackgroundColorIfAccentUsed = Color3.fromRGB(35,35,35)
module.Window.TopbarElementColorIfAccentUsed = Color3.fromRGB(150, 150, 150)
module.Window.TopbarUseAccentInstead = true

-- Button color
module.Button = {}
module.Button.RoundHoverColor = Color3.fromRGB(100, 100, 100)
module.Button.MenuHoverColor = module.Button.RoundHoverColor
module.Button.ModalHoverColor = module.ThemeColor

-- Menu constructor color
module.Menu = {}
module.Menu.BackgroundColor = Color3.fromRGB(35, 35, 35)
module.Menu.AccentColor = module.Window.AccentColor
module.Menu.DefaultTextColor = Color3.fromRGB(125, 125, 125)
module.Menu.ExitColor = module.Menu.DefaultTextColor

-- Home constructor color
module.Home = {}
module.Home.UsernameColor = Color3.fromRGB(250, 250, 250)
module.Home.RankColor = Color3.fromRGB(150, 150, 150)
module.Home.AvatarBorder = module.Window.AccentColor
module.Home.AvatarBackground = Color3.fromRGB(30, 30, 30)
module.Home.TopImage = "rbxasset://textures/AvatarEditorImages/AvatarEditor_LightTheme.png"
module.Home.TopUseAccentInstead = true
module.Home.TopBackgroundColor = Color3.fromRGB(30, 30, 30)

-- SeparatedList component color
module.SeparatedList = {}
module.SeparatedList.Item = {}
module.SeparatedList.TitleColor = Color3.fromRGB(125, 125, 125)
module.SeparatedList.Item.TitleColor = Color3.fromRGB(150, 150, 150)
module.SeparatedList.Item.ValueColor = Color3.fromRGB(250, 250, 250)

-- TextField component color
module.TextField = {}
module.TextField.TitleColor = module.SeparatedList.TitleColor
module.TextField.ContentColor = Color3.fromRGB(250, 250, 250)
module.TextField.PlaceholderColor = Color3.fromRGB(125, 125, 125)

-- PackageButton component color
module.PackageButton = {}
module.PackageButton.TitleColor = module.TextField.ContentColor
module.PackageButton.DescriptionColor = module.SeparatedList.Item.TitleColor
module.PackageButton.BackgroundColor = module.Window.TopbarBackgroundColorIfAccentUsed

-- OverlayInput component color
module.OverlayInput = {}
module.OverlayInput.TitleColor = module.SeparatedList.Item.TitleColor
module.OverlayInput.BackgroundColor = module.Window.TopbarBackgroundColorIfAccentUsed
module.OverlayInput.InputBackgroundColor = module.Window.BackgroundColor

-- Donate constructor color
module.Donate = {}
module.Donate.TitleColor = Color3.fromRGB(250, 250, 250)
module.Donate.ParagraphColor = Color3.fromRGB(150, 150, 150)
module.Donate.TopImage = module.Home.TopImage
module.Donate.TopUseAccentInstead = module.Home.TopUseAccentInstead
module.Donate.TopBackgroundColor = module.Home.TopBackgroundColor

-- About constructor color
module.About = {}
module.About.IconColor = module.ThemeColor
module.About.TitleColor = module.Donate.TitleColor
module.About.ParagraphColor = module.Donate.ParagraphColor
module.About.SubtitleColor = module.TextField.PlaceholderColor

-- Duration for tweens
module.Duration = {
	VeryShort = 0.15,
	Short = 0.3
}

return module