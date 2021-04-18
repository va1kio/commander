local ReplicatedStorage = game:GetService("ReplicatedStorage")
local events = ReplicatedStorage:WaitForChild("Commander Remotes")
local classes = {}
local elements = script.Parent.Parent.Elements

local function setupModules()
	local latteTable = {}
	for _, folder in pairs(script.Parent.Library:GetChildren()) do
		classes[folder.Name] = {}
		for _, module in pairs(folder:GetChildren()) do
			if module:IsA("ModuleScript") and type(require(module)) == "table" then
				classes[folder.Name][module.Name] = require(module)
			end
		end
	end

	for name, entry in pairs(classes) do
		latteTable[name] = setmetatable({},{
			__index = function(self, key: string)
				return classes[name][key]
			end
		})
	end

	for name, entry in pairs(classes) do
		for _, module in pairs(entry) do
			module.Latte = latteTable
		end
	end
	
	for _, constructor in pairs(classes.Constructors) do
		constructor.Elements = elements
		constructor.Remotes = events
		constructor.init()
	end
	
	for _, constructor in pairs(classes.Constructors) do
		constructor.setup()
	end
end

setupModules()
events.RemoteFunction:InvokeServer("setupUIForPlayer")