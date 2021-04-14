local module = {}
local Services = require(script.Parent.Services)
local Enums = require(script.Parent.Enums)
module.__index = module

function module.new(Name: string?, Description: string?, ContextType)
	return setmetatable({
		__object = {
			["Name"] = Name,
			["Description"] = Description,
			["Context"] = ContextType
		}
	}, module)
end

function module:Deploy()
	assert(type(self.Name) == "string", "Bad property \"Name\" (string expected, got " .. type(Name) .. ")")
	assert(type(self.Description) == "string", "Bad property \"Description\" (string expected, got " .. type(Name) .. ")")
	assert(Enums.ContextType[self.Context], tostring(self.Context) .. " is not a valid Enumeration of ContextType")
	assert(type(self.OnInvoke) == "function", "Bad property \"OnInvoke\" (function expected, got " .. type(self.OnInvoke) .. ")")
	self.GUID = Services.HttpService:GenerateGUID(false)
	return self
end

return module