local module = {}

module.new = function(Name: string, Parent: instance)
	local Comp = script.Comp:Clone()
	local ActualItems = {}
	local t = {
		["Name"] = "",
		["Items"] = {},
		["Parent"] = nil
	}
	
	t.Items = setmetatable(ActualItems, {
		__index = function(_, key: string)
			return t.Items[key]
		end,
		
		__newindex = function(_, key: string, value: string)
			local Item = ActualItems[key] or script.Item:Clone()
			t.Items[key] = value
			Item.Name, Item.Title.Text = key, key
			Item.Value.Text = value
			ActualItems[key] = Item
			Item.Parent = Comp
			return t.Items[key]
		end,
	})
	
	return setmetatable({}, {
		__index = function(_, key: string)
			return t[key]
		end,
		__newindex = function(_, key: string, value: any)
			if t[key] and key ~= "Items" then
				t[key] = value
				Comp.Name = t["Name"]
				Comp.Parent = t["Parent"]
				
				if Comp.Parent == nil then
					Comp:Destroy()
					t = nil
					ActualItems = nil
				end
			end
		end,
	})
end

return module