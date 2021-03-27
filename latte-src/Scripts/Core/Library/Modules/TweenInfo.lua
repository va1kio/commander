local module = {}

module.Linear = function(duration: number)
	return TweenInfo.new(duration, Enum.EasingStyle.Linear)
end

module.Quint = function(duration: number)
	return TweenInfo.new(duration, Enum.EasingStyle.Quint)
end

module.Sine = function(duration: number)
	return TweenInfo.new(duration, Enum.EasingStyle.Sine)
end

return module