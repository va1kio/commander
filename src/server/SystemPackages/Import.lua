return function(ModuleName: string)
	return require(script.Parent.SystemPackages:FindFirstChild(ModuleName))
end