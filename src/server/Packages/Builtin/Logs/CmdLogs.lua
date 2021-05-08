local module = {
	Name = "Command logs",
	Description = "Shows a list of used commands",
	Location = "Server",
}
local t = {}

module.Execute = function(Client, Type, Attachment)
	if Type == "command" then
		local logs = module.fetchLogs:Invoke()
		for i,v in pairs(logs) do
			local logmsg = os.date("%x %H:%M", tonumber(v.Timestamp)) .. " | " .. tostring(v.Client) .. "; " .. tostring(v.Action) .. "("
			if v.Attachments and #v.Attachments >= 1 then
				logmsg = logmsg .. tostring(table.unpack(v.Attachments)) .. ")"
			else
				logmsg = logmsg .. "n/a)"
			end
			logs[i] = logmsg
		end

		module.API.sendListToPlayer(Client, "Command logs", logs)
		return true
	end
end

return module