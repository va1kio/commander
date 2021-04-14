local CustomEnums = require(script.CustomEnum)
local module = {}

module.ContextType = CustomEnums {"Player", "Server"}

return setmetatable({}, {
	__metatable = "table is locked",
	__newindex = function() end,
	__index = function(_, key: string)
		return module[key]
	end
})