local module = {}

module.new = function(Name: string, Parent: instance)
	local Comp = script.Comp:Clone()
	Comp.Name = Name
	Comp.Parent = Parent
	local ActualItems = {}
	local Items = {}
	local t = {
		["Name"] = Name,
		["Items"] = {},
		["Parent"] = Parent
	}
	
	t.Items = setmetatable({}, {
		__index = function(_, key: string)
			return Items[key]
		end,
		
		__newindex = function(_, key: string, value: string)
			local Item = ActualItems[key] or script.Item:Clone()
			if not ActualItems[key] then
				Item.Container.Content.TextColor3 = module.Latte.Modules.Stylesheet.SeparatedList.Item.ValueColor
				Item.Accent.BackgroundColor3 = module.Latte.Modules.Stylesheet.Window.AccentColor
			end
			
			Items[key] = value
			Item.Container.Content.Font = module.Latte.Modules.Stylesheet.Fonts.Book
			Item.Name, Item.Container.Content.Text = key, value
			ActualItems[key] = Item
			Item.Parent = Comp
			return Items[key]
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