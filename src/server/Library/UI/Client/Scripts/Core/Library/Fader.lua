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

function module.FadeIn(Object, FadeTime)
	local TI = TweenInfo.new(FadeTime, Enum.EasingStyle.Linear)
	local Table = Object:GetDescendants()
	Table[#Table + 1] = Object
	for i,v in pairs(Table) do
		local Property = GetProperty(v)
		if Property then
			if v:GetAttribute("InitialTransparency") then
				module.Tween(v, TI, {[Property] = v:GetAttribute("InitialTransparency")})
			else
				v:SetAttribute("InitialTransparency", v[Property])				
				v[Property] = 1
				module.Tween(v, TI, {[Property] = v:GetAttribute("InitialTransparency")})
			end
		end

		if v:IsA("ScrollingFrame") then
			if not v:GetAttribute("InitialScrollBarTransparency") then
				v:SetAttribute("InitialScrollBarTransparency", v.ScrollBarImageTransparency)
			end

			v.ScrollBarImageTransparency = 1
			module.Tween(v, TI, {ScrollBarImageTransparency = v:GetAttribute("InitialScrollBarTransparency")})
		end
	end
end

function module.FadeOut(Object, FadeTime)
	local TI = TweenInfo.new(FadeTime, Enum.EasingStyle.Linear)
	local Table = Object:GetDescendants()
	Table[#Table + 1] = Object
	for i,v in pairs(Table) do
		local Property = GetProperty(v)
		if Property then
			if v:GetAttribute("InitialTransparency") then
				module.Tween(v, TI, {[Property] = 1})
			else
				v:SetAttribute("InitialTransparency", v[Property])
				module.Tween(v, TI, {[Property] = 1})
			end
		end

		if v:IsA("ScrollingFrame") then
			if not v:GetAttribute("InitialScrollBarTransparency") then
				v:SetAttribute("InitialScrollBarTransparency", v.ScrollBarImageTransparency)
			end

			module.Tween(v, TI, {ScrollBarImageTransparency = 1})
		end
	end
end

return module