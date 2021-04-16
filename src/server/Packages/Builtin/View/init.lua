local module = {
	Name = "View",
	Description = "Watches a player",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local char = module.API.getCharacter(module.API.getPlayerWithName(Attachment))
		if char then
			local execScript = script.Execute:Clone()
			execScript.Object.Value = char
			execScript.Parent = Client.Backpack
			execScript.Disabled = false
			return true
		end
	elseif Type == "firstrun" then
		local object = Instance.new("ObjectValue")
		object.Name = "Object"
		object.Parent = script.Execute
	end
end

return module