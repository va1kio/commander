-- Wonuf
--[[
	
	EXAMPLE USAGE:
	
	local GUITransparency = require(module)
	
	-- fade the object out
	GUITransparency:SetTransparency(object, 1, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
	
	wait(10)
	
	-- revert object back to normal
	GUITransparency:Revert(object)
]]

-- services
local TweenService = game:GetService('TweenService')

-- variables

local defaultTweenInfo = TweenInfo.new(0)

-- module table
local transparency = {
	Cache = {}
}

-- the cacheable properties
local properties = {
	'BackgroundTransparency',
	'ImageTransparency',
	'TextTransparency',
	'TextStrokeTransparency'
}

-- local functions
local function CreateCache(object, mainCache)
	local cache = {}

	for _, property in next, properties do
		if pcall(function() return object[property] end) then
			cache[property] = object[property]
		end
	end

	mainCache[object] = cache
end

local function Set(cache, transparency, tweenInfo)
	for object, properties in next, cache do
		local tbl = {}
		for property, value in next, properties do
			tbl[property] = value + ((1 - value) * transparency)
		end

		local tween = TweenService:Create(object, tweenInfo or defaultTweenInfo, tbl)
		tween:Play()
		tween.Completed:Connect(function()
			tween:Destroy()
		end)
	end
end

-- revert the object back to normal transparency
function transparency:Revert(object, tweenInfo)
	local cache = self.Cache[object]
	if cache then
		Set(cache, 0, tweenInfo)
	end
end

-- set the transparency of the object and descendants
function transparency:Set(object, transparency, tweenInfo)
	local cache = self.Cache[object]

	if not cache then
		cache = {}

		CreateCache(object, cache)
		for _, child in next, object:GetDescendants() do
			CreateCache(child, cache)
		end

		self.Cache[object] = cache
	end

	Set(cache, transparency, tweenInfo)
end

-- return module
return transparency