local module, Latte, Elements = {}, nil, nil

module.Toggle = function()
	
end

module.SwitchPage = function(Page: string)
	warn(Page)
end

module.setup = function()
	Elements = module.Elements
	Latte = module.Latte
end

return module