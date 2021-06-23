return setmetatable({}, {
	__index = function(_, key: string)
		return function(duration: number, direction: string)
			return TweenInfo.new(duration or 0, Enum.EasingStyle[key], Enum.EasingDirection[direction or "Out"])
		end
	end
})