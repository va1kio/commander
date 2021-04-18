local module = {}
module.__index = module

local modules = script.Parent.Parent.Modules
local replybox = require(script.Parent.ReplyBox)
local promise = require(modules.Promise)
local tween = require(modules.Tween)
local fade = require(modules.Fade)
local tweeninfo = require(modules.TweenInfo)

function module.new(from: string, content: string, parent: instance)
	local component = script.Comp:Clone()
	component.Name = script.Name
	component.Container.Top.Title.Text = "<font face=\"Gotham\" color=\"rgb(200,200,200)\">Message from </font>" .. from
	component.Container.Body.Content.Text = content
	component.Parent = parent
	fade:Set(component, 1)
	return setmetatable({
		_object = component,
		_args = {from, content},
		onDismiss = Instance.new("BindableEvent"),
		dismissed = false
	}, module)
end

function module:dismiss(arguments)
	if self.dismissed then return end
	if self._object.Bottom.Primary.Content.Text ~= "Reply" or not arguments then
		self.dismissed = true
		self.onDismiss:Fire(arguments)
		fade:Set(self._object, 1, tweeninfo.Linear(0.15))
		tween.new(self._object, tweeninfo.Quint(0.3), {
			Position = UDim2.new(0.5, 0, 0.6, 0)
		})
		wait(0.3)
		self._object:Destroy()
	elseif self._object.Bottom.Primary.Content.Text == "Reply" then
		local reply = replybox.new(self._args[1], self._object.Parent)
		reply:deploy()
		tween.new(self._object, tweeninfo.Quint(0.3), {
			Position = UDim2.new(0.5, 0, 0.1, -36),
			AnchorPoint = Vector2.new(0.5, 0)
		})
		fade:Set(self._object.Bottom, 1, tweeninfo.Linear(0.15))
		
		self.onDismiss:Fire(reply.onDismiss.Event:Wait())
		fade:Set(self._object, 1, tweeninfo.Linear(0.15))
		tween.new(self._object, tweeninfo.Quint(0.3), {
			Position = UDim2.new(0.5, 0, 0, -36)
		})
		wait(0.3)
		self._object:Destroy()
	end
end

function module:deploy()
	self._object.Visible = true
	self._object.Position = UDim2.new(0.5, 0, 0.4, 0)
	tween.new(self._object, tweeninfo.Quint(0.3), {
		Position = UDim2.new(0.5, 0, 0.5, 0)
	})
	fade:Set(self._object, 0, tweeninfo.Linear(0.15))
	
	self._object.Bottom.Primary.Button.MouseButton1Click:Connect(function()
		self:dismiss(true)
	end)
	
	self._object.Bottom.Dismiss.Button.MouseButton1Click:Connect(function()
		self:dismiss(false)
	end)
end

return module