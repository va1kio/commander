local module = {
	Name = "Explode",
	Description = "Explodes a player",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment)			
	if Type == "command" then
    local char = module.API.getCharacter(module.API.getPlayerWithName(Attachment))
		local rootPart = char and char:FindFirstChildOfClass("Humanoid").RootPart
		if rootPart then
			local explosion = Instance.new("Explosion")
      explosion.Archivable, explosion.Position = false, rootPart.Position
      explosion.Parent = workspace.Terrain
			return true
		end
	end
end

return module
