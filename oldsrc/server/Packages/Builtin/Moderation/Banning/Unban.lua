local module = {}
local private = {}

module.Name = "Unban"
module.Description = "Unbans a player from the game globally, or locally"
module.Location = "Player"

function module.Execute(Client: player?, Type: string, Attachment)
    if Type == "command" then
        local possiblyUserId = module.API.Players.getUserIdFromName(Attachment)
        if type(possiblyUserId) == "string" then
            return false
        end

        local data = private.DataStore:GetAsync("data")
        if not data then data = {} end

        if module.Shared.LocalBans and module.Shared.LocalBans[possiblyUserId] then
            module.Shared.LocalBans[possiblyUserId] = nil
            module.API.Players.hint(Client, "System", "Successfully unbanned player " .. possiblyUserId .. " locally")
            warn(module.Shared.LocalBans[possiblyUserId])
            return true
        end

        if data[tostring(possiblyUserId)] then
            data[tostring(possiblyUserId)] = nil

            local ok, response = pcall(private.DataStore.SetAsync, private.DataStore, "data", data)
            module.API.Players.hint(Client, "System", ok and "Successfully unbanned player " .. possiblyUserId .. " globally" or "An error occured while trying to unban player " .. possiblyUserId .. "\n\nError message:\n" .. response)
            return true
        end
    end
end

function module.Init()
    private.DataStore = module.Services.DataStoreService:GetDataStore(module.Settings.Misc.DataStoresKey.Ban or "commander.bans")
end

return module