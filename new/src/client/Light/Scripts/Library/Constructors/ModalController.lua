local module, Latte, Elements = {}, nil, nil
local Buttons = {}
local isActive = false

module.init = function()
	Elements = module.Elements
	Latte = module.Latte
end

module.setup = function()
	module.Remotes.RemoteEvent.OnClientEvent:Connect(function(Type, Protocol, Attachment)
		if Type == "modal" then
			if not isActive then
				isActive = true
				local Comp = Latte.Components.OverlayInput.new(Attachment or "Input required", Elements.Panel.Container)
				local Input = Comp.Events.Dismissed.Event:Wait()
				module.Remotes.RemoteEvent:FireServer("input", Protocol, Input)
				isActive = false
			end
		end
	end)
end

return module