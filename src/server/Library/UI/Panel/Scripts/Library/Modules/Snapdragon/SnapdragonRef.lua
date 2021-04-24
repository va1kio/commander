local refs = setmetatable({}, {__mode = "k"})

local SnapdragonRef = {}
SnapdragonRef.__index = SnapdragonRef

function SnapdragonRef.new(current)
	local ref = setmetatable({
		current = current
	}, SnapdragonRef)
	refs[ref] = ref
	return ref
end

function SnapdragonRef:Update(current)
	self.current = current
end

function SnapdragonRef:Get()
	return self.current
end

function SnapdragonRef.is(ref)
	return refs[ref] ~= nil
end

return SnapdragonRef