local module = {}
local import = nil
local Services = nil
local Settings = nil

local Players = nil

local DataStoreService = nil
local BanStore = nil

local MasterKey = "BanList"

-- TODO: Test :).

function IsExpired(BanInfo: table)
  return BanInfo.Expired or os.time() - BanInfo.Origin >= BanInfo.Time
end

function OnPlayerAdded(Player: player)
  local BanInfo = module.GetBanInfo(Player.UserId)

  if BanInfo and not BanInfo.Expired then
    Player:Kick(("You are banned! Reason: %s. Unbanned: %s."):format(
      BanInfo.Reason,
      (BanInfo.Time == 0xdeadbeef and "Permanent" or os.date("%c", BanInfo.Origin + BanInfo.Time))
    ))
  end
end

function module.Ban(TargetId: number, Time: number?, Reason: string?)
  -- Defaults.
  Time = Time or 0xdeadbeef
  Reason = Reason or "No reason provided."
  
  -- Ban data that is stored.
  local BanData = {
    ["Time"] = Time,
    ["Reason"] = Reason,
    ["Origin"] = os.time()
  }
  
  -- Update master list.
  BanStore:UpdateAsync(MasterKey, function(BanList)
    local UpdatedBanList = BanList or {}
    UpdatedBanList[TargetId] = BanData
    
    return UpdatedBanList
  end)
  
  BanStore:SetAsync(TargetId, BanData)
end

function module.Unban(TargetId: number)
  -- Update master list.
  BanStore:UpdateAsync(MasterKey, function(BanList)
    local UpdatedBanList = BanList or {}
    
    if UpdatedBanList[TargetId] then
      UpdatedBanList[TargetId].Expired = true
    end
    
    return UpdatedBanList
  end)
  
  BanStore:UpdateAsync(TargetId, function(BanInfo)
    BanInfo.Expired = true
  end)
end

function module.GetBanInfo(TargetId: number)
  local BanInfo = BanStore:GetAsync(TargetId)

  -- Update expired status.
  if BanInfo.Expired == nil and IsExpired(BanInfo) then
    BanInfo.Expired = true
    BanStore:SetAsync(TargetId, BanInfo)
  end

  return BanInfo
end

function module.GetBans(Update: boolean)
  if Update then
    BanStore:UpdateAsync(MasterKey, function(BanList)
      local UpdatedBanList = BanList or {}
      
      for i,v in pairs(UpdatedBanList) do
        if v.Expired == nil and IsExpired(v) then
          -- Ban expired.
          v.Expired = true
        end
      end
      
      return UpdatedBanList
    end)
  end

  return BanStore:GetAsync(MasterKey)
end

function module.init()
  import = module.Import
  Services = import("Services")
  Settings = import("Settings")
  
  DataStoreService = Services.DataStoreService
  BanStore = DataStoreService:GetDataStore(Settings.Misc.DataStoresKey.Ban or "commander.bans")
  
  Players = Services.Players

  Players.PlayerAdded:Connect(OnPlayerAdded)
end

return module