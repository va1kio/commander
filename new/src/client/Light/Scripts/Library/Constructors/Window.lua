local module, Latte, Elements, isActive, currentPage = {}, nil, nil, true, nil

module.Toggle = function()
	module.Window.Toggle()
end

module.SwitchPage = function(Page: string)
	module.Window.switchPage(Page)
end

module.init = function()
	Elements = module.Elements
	Latte = module.Latte
	module.Window = Latte.Components.Window.new("Panel", "Commander <b>4</b>", nil, true, Elements)
end

module.setup = function()
	
end

return module