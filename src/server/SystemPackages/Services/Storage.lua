local module = {}
local Storages = {}
local GlobalDisallowed = {"assign", "delete", "create", "globalallowed"}

local updateGlobal = function()
	rawset(_G, "Storage", setmetatable({}, {
		__index = function(_, key: string, index: string)
			if not GlobalDisallowed[string.lower(key)] then
				module[key](key, index)
			else
				error("This method is not available in _G", 2)
			end
		end,
		__newindex = function() error("Attempt to modify a readonly table", 2) end,
		__metatable = "The metatable is locked"
	}))
end

module.GlobalAllowed = true

module.Assign = function(self, index: string, key: any)
	if self.GlobalAllowed and self.Container then
		self.Container[index] = key
		updateGlobal()
	end
end

module.Delete = function(self, key: string)
	if self.GlobalAllowed and self.Container then
		self.Container[key] = nil
		updateGlobal()
	end
end

module.Create = function(name: string)
	if not Storages[name] then
		Storages[name] = setmetatable(module, {
			Container = {},
			__metatable = "The metatable is locked",
			__newindex = function() error("Attempt to modify a readonly table", 2) end
		})
		updateGlobal()
		
		return Storages[name]
	end
end

return setmetatable({}, {
	__index = module,
	__metatable = "The metatable is locked",
	__newindex = function() error("Attempt to modify a readonly table", 2) end
})
