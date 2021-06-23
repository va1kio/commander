local module, Elements, Latte, Page, TextField = {}, nil, nil, nil, nil
local Packages = {}

local function fetch(Input: string)
	local t = {}
	local matchObject
	for i,v in pairs(Latte.Modules.Services.Players:GetPlayers()) do
		table.insert(t, #t+1, v.Name)
	end

	matchObject = Latte.Modules.Matcher.new(t, true, true)
	return matchObject:match(Input)[1]
end

module.prepare = function()
	local Padding = Latte.Components.Padding.new(Page)
	TextField = Latte.Components.CompactTextField.new("TARGET", "search for user", Page)
	local Suggestion, Suggested = Latte.Components.PackageButton.new("n/a", "n/a", Page["TARGET"]), ""
	Suggestion.Object.Visible = false
	Padding.Top = UDim.new(0, 24)
	Padding.Bottom = UDim.new(0, 24)

	TextField.Events.ContentChanged:Connect(function()
		local Text = string.gsub(TextField.Content, "%s", "")
		if Text and string.len(Text) >= 1 then
			local content = fetch(Text)
			if content then
				Suggestion.Object.Visible = true
				Suggested = content
				Suggestion.Title = Latte.Modules.Services.Players:FindFirstChild(content).DisplayName == content and Latte.Modules.Services.Players:FindFirstChild(content).Name or Latte.Modules.Services.Players:FindFirstChild(content).DisplayName .. " (@" .. content .. ")"
				Suggestion.Description = Latte.Modules.Services.Players:FindFirstChild(content).UserId
			else
				Suggestion.Object.Visible = false
			end
		else
			Suggestion.Object.Visible = false
		end
	end)

	Suggestion.Events.Clicked.Event:Connect(function()
		TextField.Content = Suggested
		Suggestion.Object.Visible = false
	end)
end

module.update = function()
	for i,v in pairs(Packages) do
		if v.Location:lower() == "player" then
			local Comp = Latte.Components.PackageButton.new(v.Name, v.Description, Page)
			Comp.Events.Clicked.Event:Connect(function()
				if string.gsub(TextField.Content, "%s", "") then
					if string.len(string.gsub(TextField.Content, "%s", "")) >= 1 then
						module.Remotes.RemoteFunction:InvokeServer("command", v.Protocol, string.gsub(TextField.Content, "%s", ""))
					else
						Latte.Constructors.Window.notifyUser(nil, "Player parameter must not be empty!")
					end
				else
					Latte.Constructors.Window.notifyUser(nil, "Player parameter must not be empty!")
				end
			end)

			Comp.Object.LayoutOrder = i + 1
		end
	end
end

module.init = function()
	Elements = module.Elements
	Latte = module.Latte
end

module.setup = function()
	Page = Latte.Constructors.Window.Window.newPage("Players", true, 2)
	Page.UIListLayout.Padding = UDim.new(0, 0)
	module.prepare()

	module.Remotes.RemoteEvent.OnClientEvent:Connect(function(Type, Protocol, Attachment)
		if Type == "fetchCommands" then
			Packages = Attachment
			module.update()
		end
	end)
end

return module