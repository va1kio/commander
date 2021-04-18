local module = {}
module.__index = module

local modules = script.Parent.Parent.Modules
local promise = require(modules.Promise)
local tween = require(modules.Tween)
local fade = require(modules.Fade)
local tweeninfo = require(modules.TweenInfo)

function module.new(from: string, content: string, parent: instance)
	local component = script.Comp:Clone()
	component.Name = script.Name
	component.Container.Top.Title.Text = from
	component.Container.UISizeConstraint.MaxSize = Vector2.new("inf", 120)
	component.Container.Body.Content.Text = content
	component.Parent = parent
	fade:Set(component, 1)
	return setmetatable({
		_object = component,
		onDismiss = Instance.new("BindableEvent"),
		dismissed = false
	}, module)
end

function module:dismiss(arguments)
	if self.dismissed then return end
	self.dismissed = true
	self.onDismiss:Fire(arguments)
	fade:Set(self._object.Container, 1, tweeninfo.Linear(0.15))
	tween.new(self._object.Container, tweeninfo.Quint(0.3), {
		Position = UDim2.new(1, 0, 0, 0),
	})
	wait(0.3)
	self._object:Destroy()
end

function module:deploy()
	self._object.Visible = true
	self._object.Container.Position = UDim2.new(1, 0, 0, 0)
	
	tween.new(self._object.Container, tweeninfo.Quint(0.3), {
		Position = UDim2.new(0, 0, 0, 0)
	})
	fade:Set(self._object.Container, 0, tweeninfo.Linear(0.15))
	
	self._object.Container.MouseButton1Click:Connect(function()
		self:dismiss(true)
	end)
	
	self._object.Container.Top.Exit.Button.MouseButton1Click:Connect(function()
		self:dismiss(false)
	end)
end

return module