local module = {}

module.new = function(Name: string, Title: string?, Parent: instance)
	local Comp = script.Comp:Clone()
	Comp.Name = Name
	Comp.Container.Title.TextColor3 = module.Latte.Modules.Stylesheet.SeparatedList.TitleColor
	Comp.Container.Title.Text = Title or Name
	Comp.Parent = Parent
	local ActualItems = {}
	local Items = {}
	local t = {
		["Name"] = Name,
		["Title"] = Comp.Container.Title.Text,
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
				Item.Title.Font = module.Latte.Modules.Stylesheet.Fonts.Book
				Item.Value.Font = module.Latte.Modules.Stylesheet.Fonts.Semibold
				Item.Title.TextColor3 = module.Latte.Modules.Stylesheet.SeparatedList.Item.TitleColor
				Item.Value.TextColor3 = module.Latte.Modules.Stylesheet.SeparatedList.Item.ValueColor
				Item.Accent.BackgroundColor3 = module.Latte.Modules.Stylesheet.Window.AccentColor
			end
			
			Items[key] = value
			Item.Name, Item.Title.Text = key, key
			Item.Value.Text = value
			ActualItems[key] = Item
			Item.Parent = Comp.Container
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
				Comp.Container.Title.Font = module.Latte.Modules.Stylesheet.Fonts.Book
				Comp.Container.Title.Text = t["Title"]
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