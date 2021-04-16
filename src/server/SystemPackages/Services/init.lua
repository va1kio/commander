local modules = {}

for i,v in pairs(script:GetChildren()) do
	if v:IsA("ModuleScript") then
		modules[v.Name] = require(v)
	end
end

return setmetatable({},{
	__index = function(self, key: string)
		local object
		if modules[key] then
			object = modules[key]
		else
			object = game.GetService(game, key)
		end

		return object
	end
})