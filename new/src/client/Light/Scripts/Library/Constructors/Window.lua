local module, Latte, Elements, isActive, currentPage = {}, nil, nil, true, nil
local allLists = {}

module.Toggle = function()
	module.Window.Toggle()
end

module.SwitchPage = function(Page: string)
	module.Window.switchPage(Page)
end

module.init = function()
	Elements = module.Elements
	Latte = module.Latte
	module.Window = Latte.Components.Window.new("Panel", "Commander <b>4</b>", nil, true, Elements)
end

module.setup = function()
	module.Remotes.RemoteEvent.OnClientEvent:Connect(function(Type, Protocol, Attachment)
		if Type == "newList" then
			if allLists[Protocol] then
				allLists[Protocol].List.Parent = nil
			else
				allLists[Protocol] = {
					Window = Latte.Components.Window.new(Protocol, Protocol, Vector2.new(300, 400), false, Elements)
				}
				
				Latte.Components.Page.new("Body", allLists[Protocol].Window.Pages).UIListLayout:Destroy()
			end
			
			allLists[Protocol]["List"] = Latte.Components.DenseList.new("List", allLists[Protocol].Window.Pages.Body)
			for i,v in pairs(Attachment) do
				allLists[Protocol]["List"].Items[i] = v
			end
			
			allLists[Protocol].Window.ZIndex = 2
			allLists[Protocol].Window.Toggle()
			allLists[Protocol].Window.switchPage("Body")
		end
	end)
end

return module