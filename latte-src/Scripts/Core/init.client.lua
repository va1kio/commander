local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Classes = {}
local Remotes = ReplicatedStorage:WaitForChild("Commander Remotes")
local Elements = script.Parent.Parent.Elements

local function setupModules()
	local latteTable = {}
	for _, folder in pairs(script.Parent.Library:GetChildren()) do
		Classes[folder.Name] = {}
		for i,v in pairs(folder:GetChildren()) do
			if v:IsA("ModuleScript") and type(require(v)) == "table" then
				Classes[folder.Name][v.Name] = require(v)
				warn("Brewing " .. v.Name .. " to " .. folder.Name)
			end
		end
	end

	for name, entry in pairs(Classes) do
		warn("Setting up connections for " .. name)
		latteTable[name] = setmetatable({},{
			__index = function(self, key: string)
				return Classes[name][key]
			end
		})
	end

	for name, entry in pairs(Classes) do
		for i, v in pairs(entry) do
			warn("Linking Latte to " .. i)
			v.Latte = latteTable
			if name == "Constructors" then
				warn("Setting up constructor " .. i)
				v.Elements = Elements
				v.setup()
			end
		end
	end
end

setupModules()