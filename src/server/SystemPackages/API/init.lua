local Classes = {}
local Import = require(script.Parent.Import)

for _, v in pairs(script.Categories:GetChildren()) do
	if v:IsA("ModuleScript") then
		Classes[v.Name] = require(v)
		Classes[v.Name].Import = Import
		Classes[v.Name].init()
		Classes[v.Name].init = nil
	end
end

return setmetatable({}, {
	__index = function(_, key: string)
		return Classes[key]
	end
})