local module = {}

module.init = function()
	local Stylesheet = module.Latte.Modules.Stylesheet
	if not Stylesheet.Duration then
		Stylesheet.Duration = {
			["VeryShort"] = 0.15,
			["Short"] = 0.3
		}
	end

	if not Stylesheet.Fonts then
		Stylesheet.Fonts = {
			["Light"] = Enum.Font.Gotham,
			["Book"] = Enum.Font.Gotham,
			["Semibold"] = Enum.Font.GothamSemibold,
			["Bold"] = Enum.Font.GothamSemibold,
			["Heavy"] = Enum.Font.GothamSemibold
		}
	end

	if not Stylesheet.EasingData then
		Stylesheet.EasingData = {
			["Window"] = "Quint",
			["WindowOut"] = "Quint",
			["Menu"] = "Quint",
			["MenuOut"] = "Quint",
			["Round"] = "Quint",
			["RoundOut"] = "Quint",
			["Fading"] = "Linear",
		}
	end

	if not Stylesheet.CornerData then
		Stylesheet.CornerData = {
			["RoundButton"] = UDim.new(1, 0),
			["FlatButton"] = UDim.new(0, 3),
			["OutlinedButton"] = UDim.new(0, 4),
			["PackageButton"] = UDim.new(0, 4),
			["MenuButton"] = 1, -- lol do not do funny, it messes up
			["ProfileIcon"] = UDim.new(1, 0),
			["Window"] = UDim.new(0, 6),
			["OverlayInput"] = UDim.new(0, 6)
		}
	end

	module.Latte.Modules.Animator.EasingData = Stylesheet.EasingData
end

module.setup = function()

end

return module