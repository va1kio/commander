local module = {}
local animateInTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back)
local animateOutTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint)

function module.animateIn(Window)
	if not Window.Visible then
		Window.UIScale.Scale = 0.95
		module.Fader.FadeIn(Window, 0.2)
		module.Tween(Window.UIScale, animateInTweenInfo, {Scale = 1})
		Window.Visible = true
	end
end

function module.animateOut(Window)
	if Window.Visible then
		module.Fader.FadeOut(Window, 0.2)
		module.Tween(Window.UIScale, animateOutTweenInfo, {Scale = 0.95})
		coroutine.wrap(function()
			wait(0.3)
			if Window.Visible then
				Window.Visible = false
			end
		end)()
	end
end


return module
