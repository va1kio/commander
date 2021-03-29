local module = {}

-- Primary color
module.ThemeColor = Color3.fromRGB(64, 157, 130)

-- Button color
module.Button = {}
module.Button.RoundHoverColor = Color3.fromRGB(0, 0, 0)
module.Button.MenuHoverColor = module.RoundButtonHoverColor
module.Button.ModalHoverColor = module.ThemeColor

-- Menu constructor colors
module.Menu = {}
module.Menu.DefaultTextColor = Color3.fromRGB(100, 100, 100)
module.Menu.ExitColor = module.Menu.DefaultTextColor

-- Duration for tweens
module.Duration = {
	VeryShort = 0.15,
	Short = 0.3
}

return module