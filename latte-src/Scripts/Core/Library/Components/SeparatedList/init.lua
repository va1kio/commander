local module = {}

module.new = function(Name: string, Parent: instance)
	local Comp = script.Comp:Clone()
	local t = {
		["Name"] = "",
		["Items"] = {},
		["Parent"] = nil
	}
	
	return setmetatable(t, {
		__index = function(_, key: string)
			return t[key]
		end,
		__newindex = function(_, key: string, value: any)
			if t[key] then
				t[key] = value
				Comp.Name = t["Name"]
				Comp.Parent = t["Parent"]
			elseif not t.Items[key] then
				local t2 = {
					["Name"] = "",
					["Value"] = "",
					["Parent"] = Comp
				}
				local Item = script.Item:Clone()
				
				t.Items[key] = setmetatable(t2, {
					__index = function(_, key: string)
						return t2[key]
					end,

					__newindex = function(_, key: string, value: any)
						if t2[key] then
							t2[key] = value
							Item.Name, Item.Title.Text = t2["Name"], t2["Name"]
							Item.Value.Text = t2["Value"]
							Item.Parent = t2["Parent"]
							return t2[key]
						end
					end
				})
				
				return t.Items[key]
			end
		end,
	})
end

return module