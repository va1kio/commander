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
module.Button.MenuHoverColor = module.RoundButtonHoverColor
module.Button.ModalHoverColor = module.ThemeColor

-- Menu constructor colors
module.Menu = {}
module.Menu.BackgroundColor = Color3.fromRGB(250, 250, 250)
module.Menu.DefaultTextColor = Color3.fromRGB(100, 100, 100)
module.Menu.ExitColor = module.Menu.DefaultTextColor

-- Duration for tweens
module.Duration = {
	VeryShort = 0.15,
	Short = 0.3
}

return module