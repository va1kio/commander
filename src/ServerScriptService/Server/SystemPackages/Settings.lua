--[[[
	
	Command icon being distorted? Consider using a monospaced font.
	
											 WXKOkkxxxxkO0XW        
										   WXOkxxxkkkkxxxxxOKW      
			WWNXXKKKXXNW                  N0kxxk0KNNNNXKOxxxx0N     
		  WXKOOOOOkkkkO0KNW              WKkxxOXW       WKkxxx0W    
		WN0OOOO00KKK0OkkkOKW             NOxxkKW         WKxdxkN    
		XOOOOKNW    WNKOkkk0N            NOxxkK          WKxddkX    
		0OOOKW         XOkkkKW           N0xxx0W        WXkddxOW    
		OOO0N          WKkkk0N           WKxxxON     WWX0kddxON     
		OOkOX           XOkkOX          WWKkxxk0KK00OOkxxddx0N      
		KOkk0XW         N0kkk0NNXXKKK000OOkxxxxxxxxdddxxxOKNW       
		NKOkkO0KXNNNXXKK0OkxkkkkkxxxxxxxxxxxxxxxkO00KKXXNW          
		 WX0OkkkkkkkkkkkkkxkxxkkkOO000KKKXX0kxxkKW                  
		   WNK00OOOOO000K0Oxxx0NWWW        NOxdx0W                  
			   WWWWWWW   W0xxx0N           W0xxdON                  
						  XkxxkX            KxddkX                  
						  NOxxkKW           Nkddx0W                 
						  W0xxx0W           W0xddkXNXKKK0000KXNW    
						   KkxxkXWWWNNNXXKK00kddddxxddddddddddxOKN  
					WWWNNNX0kxxxkOkkkxxxxddddddddddxxkkkOOOkxdoodkKW
				 NXK0OOkkxxxxxxxxxxxxxxxkkOO00kdddkKNWWW   WNKkdood0
			  WN0Okxxxxxkkkkkxxxx0KXXNNNWWW  WKxddxX          WOdoox
			 WKkxxxk0KXXNNWWXkxxxK            Xkddd0W          Xxooo
			WKkxxk0N        NOxdx0W           NOdddON          Kdood
			NOxxx0W         WKxddkN           WKxoddON       WKxoook
			NOxxkK           KxddkX            WKxdodxOKXXXK0kdoookX
			N0xxxON         NOxddON              XOxooooddooooodx0N 
			 XkxxxOXWW    WXOxddkX                WNKOkxddddxk0XW   
			 WXOxxxxkO000OkxddxkXW                    WWNNNNWW      
			   WXOkxxxdddddxxOKW                                    
				 WX0Oxxdxxk0XW                                      
	
	
									Commander 4
									 from Evo
								 
		## FAQs
		
		Q: How to add a new admin?
		A: You can add a new entry to the administrator list by putting down their name or user Id. Builds after A1149 supports
		group permission, here's an example of an administrator entry
		["Admins"] = {
			"Roblox", -- This is username, remember to add a comma after each entry.
			123123123, -- This is UserId
			"123432:>100", -- This is group rank, > means greater than or equal to, and < means lesser than or equal to. The number before : is the group Id, and the number after :>/< is the rank id
			game.CreatorId, -- If your game is published under your account, you can use game.CreatorId to give yourself administrator. This won't work for games published under a group.
		},
		
		Q: How can I change the theme colour?
		A: You can change it by modifying the Accent settings below
		
		Q: How can I change the toggle keybind?
		A: You can change it by modifying the Keybind settings below.
		
	--]]
	
	return {
		["Admins"] = {
			[game.CreatorId] = "Owner",
			["nana_kon"] = "Owner",
		},

		["Permissions"] = {
			["Moderator"] = {
				["Priority"] = 1,
				["DisallowPrefixes"] = {
					"All",
					"Others"
				},
				["Permissions"] = {
					"Kick"
				}
			},
			["Admin"] = {
				["Inherits"] = "Moderator",
				["Priority"] = 2,
				["Permissions"] = {
					"Ban",
					"Shutdown",
					"TimeBan"
				}
			},
			["Owner"] = {
				["Inherits"] = "Admin",
				["Priority"] = 3,
				["Permissions"] = {
					"*"
				}
			}
		},
		
		["UI"] = {
			["Accent"] = Color3.fromRGB(64, 157, 130),
			["Keybind"] = Enum.KeyCode.Semicolon,
			["Theme"] = "Light"
		},
		
		["Version"] = {"DP2 (A1151)", "Developer Preview 2 (A1151)"}
	}