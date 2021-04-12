![commander banner](https://cdn.discordapp.com/attachments/813590068090372166/816336437922234418/Banner_2.png)

# Project Thymus

A complete rewrite of the packages API

## Details

As Commander grows, more and more packages are created by the community and we’ve discovered an issue with it — **it isn’t mature enough**

Looking at other administration systems like SimpleAdmin, we see a huge difference gap between our package system and theirs, while ours are actually quite beginner friendly, it can be really difficult to use if you ran into a problem, such as controlling UI via packages. As a result, we will be redoing the packages system, which means new releases with the new packages system will be **100%** incompatible with the current packages. Once we’ve fully finished coding the new packages system, we will release a migration guide for the users of Commander, and the developers who makes packages for Commander, but first, here’s a brief summary of our new packages system:

First, the API system will be modular and each methods can will be separated into different categories to increase maintainability and readability. While the current API isn’t that huge in terms of amount of methods, future-proof is the key here. Here’s a piece of code to return the corresponding player with the name.

```lua
local API = import(“API”)
local targetPlayer: player = API.Players.GetPlayerWithName(“nana_kon”)
```

To avoid problems like cyclic tables, we decided to **not** link built-in dependencies automatically, but each package will be linked to a function called `import`, which is to import dependencies (this is not object-oriented, we find that extremely difficult for coders to navigate if they don’t happen to have a direct copy of Commander’s source code!)
___

Second, we will be redoing the packages structure, we’ve noticed the issue with our packages when we implemented the new “categories for packages” feature, so you can organise your packages easier and cleaner. However, this is all done with a simple :GetDescendants loop with a simple :IsA() check, which means stuff will go horribly wrong if the corresponding module from the loop is actually not a package (unintended code execution). To solve this, we will be changing the structure for packages, with the new structure, each package is a folder with an initialiser module in it, named `init.lua` (Rojo filesystem), here’s an example demonstrating the new structure.

```
Packages:
	ExamplePackage:
		Dependencies:
			ExampleModule.lua
		init.lua
```

With that structure, the problem mentioned above will be fixed, and the actual structure in Rojo will look much nicer than ever!
___

Apart from the name structure, we will be also redoing the internal structure, here’s a pseudo code to demonstrate.

```lua
local Package = import(“Package”).new()
local Enumeration = import(“Enum”)
local API = import(“API”)

Package.Name = script.Parent.Name
Package.Description = “This is an example command!”
Package.Location = Enumeration.PackageLocation.Player

Package.OnInvoke = function(Type, Arguments)
	if Type == Enumeration.PackageInvokeType.Execution then
		local Client = Arguments.Client
		local Player = API.Players.GetPlayerWithName(Arguments.Attachment[1])
		warn(tostring(Player))
	end
end

return Package
```

Because we no longer create a package with tables, it is much easier to verify whether the package works or not, and it reduces a lot of false positives.

## Disclaimer

This piece of software is currently in early development and potential bugs that affects your game may exist! By installing this version, you are acknowledging that we **will not** be responsible for any damages in your game, caused by this version of **Commander 4**.

As a result, you should not be using this version for your games as it is currently intended for testing only.