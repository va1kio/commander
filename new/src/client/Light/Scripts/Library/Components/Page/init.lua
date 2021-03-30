local module = {}

module.new = function(Name: string, Parent: instance)
	local Comp = script.Comp:Clone()
	Comp.Name = Name
	Comp.Parent = Parent
	
	return Comp
end

return module