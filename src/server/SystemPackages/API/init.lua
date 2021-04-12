local Classes = {}

for _, v in pairs(script.Categories:GetChildren()) do
	if v:IsA("ModuleScript") then
		Classes[v.Name] = require(v)
	end
end

return setmetatable({}, {
	__index = function(_, key: string)
		return Classes[key]
	end
})