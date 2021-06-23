return setmetatable({},{
	__index = function(_, key: string)
		return function(duration: number?)
			return TweenInfo.new(duration or 0, Enum.EasingStyle[key])
		end
	end,
})