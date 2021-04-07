return setmetatable({},{
__index = function(self, key: string)
	return game.GetService(game, key) or nil
end
})