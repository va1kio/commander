local module = {}

local function GetProperty(Object)
	if Object:IsA("TextLabel") or Object:IsA("TextButton") or Object:IsA("TextBox") then
		return "TextTransparency"
	elseif Object:IsA("ViewportFrame") or Object:IsA("ImageButton") or Object:IsA("ImageLabel") then
		return "ImageTransparency"
	elseif Object:IsA("Frame") then
		return "BackgroundTransparency"
	end
end

function module.FadeIn(Object: instance, FadeTime: number|nil)
	FadeTime = FadeTime or 0.3
	local TI = module.Latte.Modules.TweenInfo.Linear(FadeTime)
	local Table = Object:GetDescendants()
	Table[#Table + 1] = Object
	for i,v in pairs(Table) do
		local Property = GetProperty(v)
		if Property then
			if v:GetAttribute("InitialTransparency") then
				module.Latte.Modules.Tween.new(v, TI, {[Property] = v:GetAttribute("InitialTransparency")})
			else
				v:SetAttribute("InitialTransparency", v[Property])
				v[Property] = 1
				module.Latte.Modules.Tween.new(v, TI, {[Property] = v:GetAttribute("InitialTransparency")})
			end
		end

		if v:IsA("ScrollingFrame") then
			if not v:GetAttribute("InitialScrollBarTransparency") then
				v:SetAttribute("InitialScrollBarTransparency", v.ScrollBarImageTransparency)
			end

			v.ScrollBarImageTransparency = 1
			module.Latte.Modules.Tween.new(v, TI, {ScrollBarImageTransparency = v:GetAttribute("InitialScrollBarTransparency")})
		end
	end
end

function module.FadeOut(Object: instance, FadeTime: number|nil)
	FadeTime = FadeTime or 0.3
	local TI = module.Latte.Modules.TweenInfo.Linear(FadeTime)
	local Table = Object:GetDescendants()
	Table[#Table + 1] = Object
	for i,v in pairs(Table) do
		local Property = GetProperty(v)
		if Property then
			if v:GetAttribute("InitialTransparency") then
				module.Latte.Modules.Tween.new(v, TI, {[Property] = 1})
			else
				v:SetAttribute("InitialTransparency", v[Property])
				module.Latte.Modules.Tween.new(v, TI, {[Property] = 1})
			end
		end

		if v:IsA("ScrollingFrame") then
			if not v:GetAttribute("InitialScrollBarTransparency") then
				v:SetAttribute("InitialScrollBarTransparency", v.ScrollBarImageTransparency)
			end

			module.Latte.Modules.Tween.new(v, TI, {ScrollBarImageTransparency = 1})
		end
	end
end

return module