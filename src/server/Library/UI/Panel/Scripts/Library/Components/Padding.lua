local module = {}

module.new = function(Parent: instance)
	local Comp = Instance.new("UIPadding")
	local t = {
		["Left"] = UDim.new(0, 0),
		["Right"] = UDim.new(0, 0),
		["Top"] = UDim.new(0, 0),
		["Bottom"] = UDim.new(0, 0),
		["Parent"] = Parent
	}

	local function cook()
		for i,v in pairs(t) do
			if typeof(v) == "UDim" then
				Comp["Padding" .. i] = v
			elseif i == "Parent" then
				Comp.Parent = Parent
			end
		end
	end

	return setmetatable({}, {
		__index = function(_, key: string)
			return t[key]
		end,
		__newindex = function(_, key: string, value: any)
			if t[key] then
				t[key] = value
				cook()
				return t[key]
			end
		end,
	})
end

return module