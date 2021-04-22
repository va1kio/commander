local module = {}
module.__index = module

local modules = script.Parent.Parent.Modules
local promise = require(modules.Promise)
local tween = require(modules.Tween)
local fade = require(modules.Fade)
local tweeninfo = require(modules.TweenInfo)
local defaultDuration = 10

function module.new(from: string, content: string, duration: number?, parent: instance)
	local component = script.Comp:Clone()
	component.Name = script.Name
	component.Top.Title.Text = "<font face=\"Gotham\" color=\"rgb(200,200,200)\">Hint from </font>" .. from
	component.Content.Text = content
	component.Parent = parent
	fade:Set(component, 1)
	return setmetatable({
		_object = component,
		interval = duration or defaultDuration,
		dismissed = false
	}, module)
end

function module:dismiss()
	if self.dismissed then return end
	self.payload:cancel()
	self.dismissed = true
	fade:Set(self._object, 1, tweeninfo.Linear(0.15))
	tween.new(self._object, tweeninfo.Quint(0.3), {
		Position = UDim2.new(0, 0, 0, 0),
		AnchorPoint = Vector2.new(0, 1)
	})
	wait(0.3)
	self._object:Destroy()
end

function module:payload()
	self.payload = promise.new(function(resolve, reject)
		if self.dismissed then reject("Object is already dismissed.") end
		local title = self._object.Top.Title.Text
		for i = self.interval, 0, -1 do
			self._object.Top.Title.Text = title .. " — dismissing in " .. i
			wait(1)
		end

		resolve()
	end)
	
	return self.payload
end

function module:deploy()
	self._object.Visible = true
	self._object.Position = UDim2.new(0, 0, 0, 0)
	tween.new(self._object, tweeninfo.Quint(0.3), {
		Position = UDim2.new(0, 0, 0, -36),
		AnchorPoint = Vector2.new(0, 0)
	})
	fade:Set(self._object, 0, tweeninfo.Linear(0.15))
	self:payload():andThen(function()
		self:dismiss()
	end):catch(function(argument)
		warn(argument)
	end)
	
	self._object.MouseButton1Click:Connect(function()
		self:dismiss()
	end)
end

return module