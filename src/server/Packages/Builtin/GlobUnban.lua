local module = {}
local private = {}

module.Name = "Global Unban"
module.Description = "Unbans a player from the game globally"
module.Location = "Player"

function module.Execute(Client: player?, Type: string, Attachment)
    if Type == "command" then
        local possiblyUserId = module.API.Players.getUserIdFromName(Attachment)
        if type(possiblyUserId) == "string" then
            return false
        end

        local data = private.DataStore:GetAsync("data")
        if not data then data = {} 
        else
            table.remove(data, possiblyUserId)
        end

       local ok, response = pcall(private.DataStore.SetAsync, private.DataStore, "data", data)
       module.API.Players.hint(Client, "System", ok and "Successfully unbanned player " .. possiblyUserId .. "!" or "An error occured while trying to unban player " .. possiblyUserId .. "\n\nError message:\n" .. response)
    end
end

function module.Init()
    private.DataStore = module.Services.DataStoreService:GetDataStore(module.Settings.Misc.DataStoresKey.Ban or "commander.bans")
end

return module