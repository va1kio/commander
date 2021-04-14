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
end

module.setup = function()
	
end

return module