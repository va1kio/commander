local module = {}
local private = {}

module.Name = "Local Ban"
module.Description = "Bans a player from the game locally"
module.Location = "Player"

function module.Execute(Client: player?, Type: string, Attachment)
    if Type == "command" then
        local possiblyUserId = module.API.Players.getUserIdFromName(Attachment)
        if type(possiblyUserId) == "string" then
            return false
        end

        local possiblyUser = module.API.Players.getPlayerByUserId(possiblyUserId)
        local input = module.API.Players.sendModal(Client, "What's the reason?").Event:Wait()
        if not input then
            return false
        end
        local ok, content = module.API.Players.filterString(Client, input)
        if not ok then
            module.API.Players.hint(Client, "System", "An error occured while trying to filter string message")
            return false
        end

        local data = {
            ["By"] = {Client.UserId, Client.Name},
            ["At"] = os.date("%c", os.time()),
            ["End"] = "PERM",
            ["Reason"] = content
        }

        module.Shared.LocalBans[possiblyUserId] = data
        module.API.Players.hint(Client, "System", "Successfully banned player " .. possiblyUserId .. " locally!")
        if ok and possiblyUser then
            possiblyUser:Kick("Banned by " .. Client.Name .. " at " .. data[possiblyUserId].At .. "\n\nReason: " .. content .. "\n\nNote: This is a local ban, you can still visit other servers in this game")
        end
    end
end

function module.Init()
    module.Shared.LocalBans = module.Shared.LocalBans or {}
    module.API.Players.listenToPlayerAdded(function(Player: player)
        if module.Shared.LocalBans[Player.UserId] then
            local data = module.Shared.LocalBans[Player.UserId]
            if data.End == "PERM" then
                Player:Kick("Banned by " .. data.By[2] .. " at " .. data.At .. "\n\nReason: " .. data.Reason .. "\n\nNote: This ban is a local ban, you can still visit other servers in this game")
            elseif type(data.End) == "number" and data.End > os.time() then
                Player:Kick("Banned by " .. data.By[2] .. " at " .. data.At .. "\n\nReason: " .. data.Reason .. "\n\nNote: This ban is a timed local ban, you will not be allowed to join this server until " .. os.date("%c", data.End))
            end
        end
    end)
end

return module