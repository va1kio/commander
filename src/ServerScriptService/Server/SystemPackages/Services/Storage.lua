local module = {}
local Storages = {}
local GlobalDisallowed = {"assign", "delete", "create", "globalallowed"}

local updateGlobal = function()
	rawset(_G, "Storage", setmetatable(module, {
		__index = function(self, key: string, index: string)
			if not GlobalDisallowed[key:lower()] then
				self[key](key, index)
			else
				error("this method is not available in _G")
			end
		end
	}))
end

module.GlobalAllowed = true

module.Assign = function(self, index: string, key: any)
	if module.GlobalAllowed and self.Container then
		self.Container[index] = key
		updateGlobal()
	end
end

module.Delete = function(self, key: string)
	if module.GlobalAllowed and self.Container then
		self.Container[key] = nil
		updateGlobal()
	end
end

module.Create = function(name: string)
	if not Storages[name] then
		Storages[name] = setmetatable(module, {
			Container = {},
			__metatable = "table is read-only",
			__newindex = function() return end
		})
		updateGlobal()
	end
end

return setmetatable(module, {
	__metatable = "table is read-only",
	__newindex = function() return end
})