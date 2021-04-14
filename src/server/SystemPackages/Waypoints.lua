local module = {}
local items = {}

function module.fetch()
	return items
end

function module.new(client: string, action: string, attachment)
	items[#items + 1] = {
		Client = client,
		Action = action,
		Attachments = attachment,
		Timestamp = os.time()
	}
end

return module