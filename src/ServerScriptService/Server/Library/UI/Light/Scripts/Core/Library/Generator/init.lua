local module = {}
local isModalBusy = false
local fadeTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear)

local function packageButtonReaction(Button, State)
	if State == "Hover" and not isModalBusy then
		Button.Shadow.Visible = true
		Button.Container.BackgroundTransparency = 0
		Button.Container.Accent.Visible = false
	elseif State == "Over" and not isModalBusy then
		Button.Shadow.Visible = false
		Button.Container.BackgroundTransparency = 1
		Button.Container.Accent.Visible = true
	end
end

local function topBarContextButtonReaction(Button, State)
	local scalingTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint)
	if State == "Hold" then
		module.Tween(Button.Hover, fadeTweenInfo, {BackgroundTransparency = 0.65})
	elseif State == "Hover" then
		module.Tween(Button.Hover, fadeTweenInfo, {BackgroundTransparency = 0.8})
		module.Tween(Button.Hover.UIScale, scalingTweenInfo, {Scale = 1})
	elseif State == "Over" then
		module.Tween(Button.Hover, fadeTweenInfo, {BackgroundTransparency = 1})
		module.Tween(Button.Hover.UIScale, scalingTweenInfo, {Scale = 0})
	end
end

local function modalConfirmButtonReaction(Button, State)
	local specialFadeTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
	if State == "Hold" then
		module.Tween(Button.Hover, specialFadeTweenInfo, {BackgroundTransparency = 0.85})
	elseif State == "Hover" then
		module.Tween(Button.Hover, specialFadeTweenInfo, {BackgroundTransparency = 0.9})
	elseif State == "Over" then
		module.Tween(Button.Hover, specialFadeTweenInfo, {BackgroundTransparency = 1})
	end
end

function module.newPackageButton(Title: string, Description: string, Parent, Callback)
	local button = script.Assets.Button:Clone()
	local guid = game.HttpService:GenerateGUID()
	button.Name, button.Container.Text.Title.Text, button.Container.Text.Subtitle.Text = Title, Title, Description
	module.Button.register(button, packageButtonReaction):Connect(function()
		if not isModalBusy then
			Callback()
		end
	end)
	
	button.Parent = Parent
end

function module.newInputModal(Title)
	if not isModalBusy then
		local modal = script.Assets.Modal:Clone()
		local bindable = Instance.new("BindableEvent")
		bindable.Parent = modal
		isModalBusy = true
		modal.UI.Container.Top.Title.Text = Title or "Input required"
		
		module.Button.register(modal.UI.Container.Top.Exit, topBarContextButtonReaction):Connect(function()
			module.Animator.animateOut(modal.UI)
			module.Tween(modal, fadeTweenInfo, {BackgroundTransparency = 1})
			bindable:Fire(false)
			wait(0.3)
			isModalBusy = false
			modal:Destroy()
		end)
		
		module.Button.register(modal.UI.Container.Bottom.Confirm, modalConfirmButtonReaction):Connect(function()
			module.Animator.animateOut(modal.UI)
			module.Tween(modal, fadeTweenInfo, {BackgroundTransparency = 1})
			bindable:Fire(modal.UI.Container.Input.Input.Text)
			wait(0.3)
			isModalBusy = false
			modal:Destroy()
		end)
		
		module.Animator.animateIn(modal.UI)
		module.Tween(modal, fadeTweenInfo, {BackgroundTransparency = 0.5})
		modal.Visible = true
		modal.Parent = module.Elements.Panel
		
		return bindable.Event
	end
end

function module.newWindow(Name, Title, Parent)
	local window = script.Assets.Window:Clone()
	local t = {}
	t.Event = Instance.new("BindableEvent")
	t.Container = window.Container.Body
	window.Name = Name
	window.Container.Top.Title.Text = Title
	
	function t.close()
		t.Event:Fire("closed")
		module.Animator.animateOut(window)
		wait(0.3)
		window.Visible = false
	end
	
	function t.open()
		t.Event:Fire("opened")
		module.Animator.animateIn(window)
		window.Visible = true
	end
	
	function t.setTitle(Title)
		t.Event:Fire("titleChanged", Title)
		window.Container.Top.Title.Text = Title
	end
	
	module.Button.register(window.Container.Top.Exit, topBarContextButtonReaction):Connect(function()
		t.close()
	end)
	
	module.Dragger.new(window.Container.Top, window)
	window.Parent = Parent
	return t
end

function module.newList(Name, Parent)
	local t = {}
	local list = script.Assets.List:Clone()
	t.Event = Instance.new("BindableEvent")
	list.Name = Name
	
	function t.addItem(Name, Content)
		local listItem = script.Assets.ListItem:Clone()
		listItem.Name = Name
		listItem.Content.Text = Content
		
		if (#list:GetChildren() - 2) % 2 == 0 then
			listItem.BackgroundTransparency = 1
		end
		
		for i,v in pairs(list:GetChildren()) do
			if v:IsA("Frame") then
				v.LayoutOrder += 1
			end
		end
		
		listItem.Parent = list
		listItem.Size = UDim2.new(1, 0, 0, math.clamp(listItem.Content.TextBounds.Y + 8, 22, math.huge))
		t.Event:Fire("addedItem", listItem)
	end
	
	list.Parent = Parent
	return t
end

return module