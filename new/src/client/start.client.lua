-- this should be removed when we're done with coding the UI

local Players = game:GetService("Players")
local Client = script.Parent.Light:Clone()
Client.Parent = Players.LocalPlayer.PlayerGui
Client.Scripts.Core.Disabled = false
script.Parent:Destroy()