local module, Latte, Elements, isActive, currentPage, Settings, bindable = {}, nil, nil, true, nil, {}, nil
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
	module.Window = Latte.Components.Window.new("Panel", "Commander", nil, true, Elements)
end

module.notifyUser = function(Title: string?, Content: string, Duration: number?)
	if not bindable then
		Latte.Modules.Services.StarterGui:SetCore("SendNotification", {
			["Title"] = Title or "Commander",
			["Text"] = Content,
			["Duration"] = Duration or 5,
			["Icon"] = "rbxassetid://6027381584"
		})
	else
		bindable:Fire("newNotify", "", {["From"] = Title or "System", ["Content"] = Content, ["Sound"] = Settings.UI.AlertSound})
	end
end

module.setup = function()
	bindable = Elements.Parent.Parent:WaitForChild("Client")
	if bindable:WaitForChild("Elements", 5) then
		bindable = bindable:FindFirstChild("Elements"):FindFirstChild("Event")
	else
		bindable = nil
	end

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
			allLists[Protocol].Window.Toggle(true)
			allLists[Protocol].Window.switchPage("Body")
		elseif Type == "firstRun" then
			Settings = Attachment
			module.Window.Title = Attachment.UI.Title or "Commander"
		end
	end)
end

return module