local module = {}
local Player = game:GetService("Players").LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")
local Donate

local function buttonReaction(Button, State)
	local specialFadeTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
	if State == "Hold" then
		module.Tween(Button.Background, specialFadeTweenInfo, {BackgroundTransparency = 0.85})
	elseif State == "Hover" then
		module.Tween(Button.Background, specialFadeTweenInfo, {BackgroundTransparency = 0.9})
	elseif State == "Over" then
		module.Tween(Button.Background, specialFadeTweenInfo, {BackgroundTransparency = 1})
	end
end

function module.execute()
	Donate = module.Elements.Panel.Container.Body.Donate
	module.Button.register(Donate.List.Container["50"], buttonReaction):Connect(function()
		MarketplaceService:PromptPurchase(Player, 6502090560)
	end)

	module.Button.register(Donate.List.Container["150"], buttonReaction):Connect(function()
		MarketplaceService:PromptPurchase(Player, 6502091736)
	end)

	module.Button.register(Donate.List.Container["350"], buttonReaction):Connect(function()
		MarketplaceService:PromptPurchase(Player, 6502092150)
	end)
end

return module
