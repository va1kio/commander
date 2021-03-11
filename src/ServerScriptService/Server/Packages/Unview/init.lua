local module = {
	Name = "Unview",
	Description = "Reset CameraSubject to your character",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
		local char = module.API.getCharacter(Client)
		if char then
			local execScript = script.Execute:Clone()
			execScript.Object.Value = Client.Character
			execScript.Parent = Client.Backpack
			execScript.Disabled = false
		end
	end
end

return module