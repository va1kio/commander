local module = {}
module.Window = {}
module.Menu = {}
module.Button = {
	["Round"] = {},
	["Menu"] = {},
	["Package"] = {}
}

function module.Window.animateIn(Object: guiobject, UIScale: uiscale, Duration: number|nil)
	Duration = Duration or 0.3
	UIScale.Scale = 0.95
	Object.Visible = true
	module.Latte.Modules.Fader.FadeIn(Object, Duration/2)
	module.Latte.Modules.Tween.new(UIScale, module.Latte.Modules.TweenInfo.Quint(Duration), {Scale = 1})
end

function module.Window.animateOut(Object: guiobject, UIScale: uiscale, Duration: number|nil)
	Duration = Duration or 0.3
	module.Latte.Modules.Fader.FadeOut(Object, Duration/2)
	module.Latte.Modules.Tween.new(UIScale, module.Latte.Modules.TweenInfo.Quint(Duration), {Scale = 0.95}).Completed:Wait()
	Object.Visible = false
end

function module.Menu.animateIn(Object: guiobject, Duration: number|nil)
	Duration = Duration or 0.3
	module.Latte.Modules.Fader.FadeIn(Object, Duration/2)
	module.Latte.Modules.Tween.new(Object, module.Latte.Modules.TweenInfo.Quint(Duration), {Position = UDim2.new(0, 0, 0, 0)})
end

function module.Menu.animateOut(Object: guiobject, Duration: number|nil)
	Duration = Duration or 0.3
	module.Latte.Modules.Fader.FadeOut(Object, Duration/2)
	module.Latte.Modules.Tween.new(Object, module.Latte.Modules.TweenInfo.Quint(Duration), {Position = UDim2.new(-0.35, -2, 0, 0)})
end

function module.Button.Round.Hover(Object: guiobject)
	local short = module.Latte.Modules.Stylesheet.Duration.Short
	local scalingTweenInfo = module.Latte.Modules.TweenInfo.Quint(short)
	local fadingTweenInfo = module.Latte.Modules.TweenInfo.Linear(short)
	module.Latte.Modules.Tween.new(Object.Hover, fadingTweenInfo, {BackgroundTransparency = 0.8})
	module.Latte.Modules.Tween.new(Object.Hover.UIScale, scalingTweenInfo, {Scale = 1})
end

function module.Button.Round.Hold(Object: guiobject)
	local short = module.Latte.Modules.Stylesheet.Duration.Short
	local fadingTweenInfo = module.Latte.Modules.TweenInfo.Linear(short)
	module.Latte.Modules.Tween.new(Object.Hover, fadingTweenInfo, {BackgroundTransparency = 0.65})
end

function module.Button.Round.Over(Object: guiobject)
	local short = module.Latte.Modules.Stylesheet.Duration.Short
	local scalingTweenInfo = module.Latte.Modules.TweenInfo.Quint(short)
	local fadingTweenInfo = module.Latte.Modules.TweenInfo.Linear(short)
	module.Latte.Modules.Tween.new(Object.Hover, fadingTweenInfo, {BackgroundTransparency = 1})
	module.Latte.Modules.Tween.new(Object.Hover.UIScale, scalingTweenInfo, {Scale = 0})
end

function module.Button.Menu.Hover(Object: guiobject)
	local veryShort = module.Latte.Modules.Stylesheet.Duration.VeryShort
	local fadingTweenInfo = module.Latte.Modules.TweenInfo.Linear(veryShort)
	module.Latte.Modules.Tween.new(Object, fadingTweenInfo, {BackgroundTransparency = 0.95})
end

function module.Button.Menu.Hold(Object: guiobject)
	local veryShort = module.Latte.Modules.Stylesheet.Duration.VeryShort
	local fadingTweenInfo = module.Latte.Modules.TweenInfo.Linear(veryShort)
	module.Latte.Modules.Tween.new(Object, fadingTweenInfo, {BackgroundTransparency = 0.8})
end

function module.Button.Menu.Over(Object: guiobject)
	local veryShort = module.Latte.Modules.Stylesheet.Duration.VeryShort
	local fadingTweenInfo = module.Latte.Modules.TweenInfo.Linear(veryShort)
	module.Latte.Modules.Tween.new(Object, fadingTweenInfo, {BackgroundTransparency = 1})
end

module.Button.Flat.Hover(Object: guiobject)
	module.Button.Menu.Hover(Object.Hover)
end

module.Button.Flat.Hold(Object: guiobject)
	module.Button.Menu.Hold(Object.Hover)
end

module.Button.Flat.Over(Object: guiobject)
	module.Button.Menu.Over(Object.Hover)
end

function module.Button.Package.Hover(Object: guiobject)
	Object.Container.BackgroundTransparency = 0
	Object.Container.Accent.Visible = false
	Object.Shadow.Visible = true
end

function module.Button.Package.Hold(Object: guiobject)
end

function module.Button.Package.Over(Object: guiobject)
	Object.Container.BackgroundTransparency = 1
	Object.Container.Accent.Visible = true
	Object.Shadow.Visible = false
end

return module