local TweenService = game:GetService("TweenService")

return function(Object, TweenInfo, Goal)
	local tweenObject = TweenService:Create(Object, TweenInfo, Goal)
	tweenObject:Play()
	return tweenObject
end