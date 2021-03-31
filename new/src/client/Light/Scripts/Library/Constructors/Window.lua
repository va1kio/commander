local module, Latte, Elements, isActive, currentPage = {}, nil, nil, true, nil

module.Toggle = function()
	if isActive then
		Latte.Modules.Animator.Window.animateOut(Elements.Panel, Elements.Panel.UIScale)
	else
		Latte.Modules.Animator.Window.animateIn(Elements.Panel, Elements.Panel.UIScale)
	end
	
	isActive = not isActive
end

module.SwitchPage = function(Page: string)
	if tostring(currentPage):lower() == Page:lower() then return end
	if currentPage then
		Latte.Modules.Animator.Window.animateOut(currentPage, currentPage.UIScale)
	end
	
	currentPage = Elements.Panel.Container.Body[Page]
	Latte.Modules.Animator.Window.animateIn(currentPage, currentPage.UIScale)
end

module.init = function()
	Elements = module.Elements
	Latte = module.Latte
end

module.setup = function()
	Elements.Panel.Container.BackgroundColor3 = Latte.Modules.Stylesheet.Window.BackgroundColor
end

return module