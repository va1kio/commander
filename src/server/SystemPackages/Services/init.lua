local modules = {}

for _, v in pairs(script:GetChildren()) do
	if v:IsA("ModuleScript") then
		modules[v.Name] = require(v)
	end
end

return setmetatable({}, {
	__index = function(_, key: string)
		local object
		if modules[key] then
			object = modules[key]
		else
			object = game.GetService(game, key)
		end

		return object
	end,
	__newindex = function() return nil end,
	__metatable = "The metatable is locked"
})