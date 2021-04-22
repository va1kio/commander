local module = {}
module.__index = module

local modules = script.Parent.Parent.Modules
local promise = require(modules.Promise)
local tween = require(modules.Tween)
local fade = require(modules.Fade)
local tweeninfo = require(modules.TweenInfo)

local function playAudio(Id: number|string, Volume: number?, Parent: instance): sound
	local audio = Instance.new("Sound")
	audio.SoundId = "rbxassetid://" .. Id
	audio.Volume = Volume or 1
	audio.Parent = Parent
	audio.Ended:Connect(function()
		audio:Destroy()
	end)
	
	audio:Play()
	return audio
end

function module.new(from: string, parent: instance)
	local component = script.Comp:Clone()
	component.Name = script.Name
	component.Container.Top.Title.Text = "<font face=\"Gotham\" color=\"rgb(200,200,200)\">Replying to </font>" .. from
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
	if arguments == false then
		fade:Set(self._object, 1, tweeninfo.Linear(0.15))
		tween.new(self._object, tweeninfo.Quint(0.3), {
			Position = UDim2.new(0.5, 0, 0.9, 0)
		})
		wait(0.3)
	else
		local audio = playAudio(6696815967, 0.5, self._object)
		tween.new(self._object, tweeninfo.Back(1.2), {
			Position = UDim2.new(0.5, 0, 0, -36),
			AnchorPoint = Vector2.new(0.5, 1)
		})
		audio.Ended:Wait()
	end
	self._object:Destroy()
end

function module:deploy()
	self._object.Visible = true
	self._object.Position = UDim2.new(0.5, 0, 0.7, 0)
	tween.new(self._object, tweeninfo.Quint(0.3), {
		Position = UDim2.new(0.5, 0, 0.8, 0)
	})
	fade:Set(self._object, 0, tweeninfo.Linear(0.15))
	
	self._object.Bottom.Primary.Button.MouseButton1Click:Connect(function()
		self:dismiss(self._object.Container.Body.Content.Text)
	end)
	
	self._object.Bottom.Dismiss.Button.MouseButton1Click:Connect(function()
		self:dismiss(false)
	end)
end

return module