local module, Elements, Latte, Page = {}, nil, nil, nil
local Packages = {}

module.prepare = function()
	local Padding = Latte.Components.Padding.new(Page)
	Padding.Top = UDim.new(0, 24)
end

module.update = function()
	
end

module.init = function()
	Elements = module.Elements
	Latte = module.Latte
end

module.setup = function()
	Page = Latte.Components.Page.new("Server", Elements.Panel.Container.Body)
	Page.UIListLayout.Padding = UDim.new(0, 24)
	Latte.Constructors.Menu.newButton("Server", 3)
	module.prepare()
	
	module.Remotes.RemoteEvent.OnClientEvent:Connect(function(Type, Protocol, Attachment)
		if Type == "fetchCommands" then
			Packages = Attachment
			module.update()
		end
	end)
end

return module