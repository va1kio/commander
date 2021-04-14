--[=[
	Version 1.0.0 - 13 May 2020
	This is intended for Roblox ModuleScripts
	BSD 2-Clause Licence
	Copyright ©, 2020 - Blockzez (devforum.roblox.com/u/Blockzez and github.com/Blockzez)
	All rights reserved.
	
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:
	
	1. Redistributions of source code must retain the above copyright notice, this
	   list of conditions and the following disclaimer.
	
	2. Redistributions in binary form must reproduce the above copyright notice,
	   this list of conditions and the following disclaimer in the documentation
	   and/or other materials provided with the distribution.
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
	FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
	SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
	OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
	OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]=]--

-- Disables the warning if 'customenum:method()' was called --
local _DISABLE_WARNING = false;
--------------------------------------------------------------

local reserved_keywords =
{
	['abstract'] = true, ['bool'] = true, ['continue'] = true, ['decimal'] = true, ['default'] = true, ['event'] = true,
	['explicit'] = true, ['extern'] = true, ['char'] = true, ['checked'] = true, ['class'] = true, ['const'] = true,
	['break'] = true, ['as'] = true, ['base'] = true, ['delegate'] = true, ['is'] = true, ['lock'] = true,
	['long'] = true, ['num'] = true, ['byte'] = true, ['case'] = true, ['catch'] = true, ['false'] = true,
	['finally'] = true, ['fixed'] = true, ['float'] = true, ['for'] = true, ['foreach'] = true, ['goto'] = true,
	['if'] = true, ['implicit'] = true, ['in'] = true, ['int'] = true, ['interface'] = true, ['internal'] = true,
	['do'] = true, ['double'] = true, ['else'] = true, ['namespace'] = true, ['new'] = true, ['null'] = true,
	['object'] = true, ['operator'] = true, ['out'] = true, ['override'] = true, ['params'] = true, ['private'] = true,
	['protected'] = true, ['public'] = true, ['readonly'] = true, ['sealed'] = true, ['short'] = true, ['sizeof'] = true,
	['ref'] = true, ['return'] = true, ['sbyte'] = true, ['stackalloc'] = true, ['static'] = true, ['string'] = true,
	['struct'] = true, ['void'] = true, ['volatile'] = true, ['while'] = true, ['true'] = true, ['try'] = true,
	['switch'] = true, ['this'] = true, ['throw'] = true, ['unchecked'] = true, ['unsafe'] = true, ['ushort'] = true,
	['using'] = true, ['virtual'] = true, ['typeof'] = true, ['uint'] = true, ['ulong'] = true, ['and'] = true,
	['elseif'] = true, ['end'] = true, ['function'] = true, ['local'] = true, ['nil'] = true, ['not'] = true,
	['or'] = true, ['repeat'] = true, ['then'] = true, ['until'] = true, ['overload'] = true, ['optional'] = true,
	
	-- Enum items
	['GetName'] = true, ['GetNames'] = true, ['GetValues'] = true, ['CompareTo'] = true, ['Equals'] = true,
	['ToString'] = true, ['TryParse'] = true, ['Parse'] = true, ['GetHexAddress'] = true, ['Extensions'] = true,
	['GetType'] = true,
};
local function isvalid(str)
	if type(str) ~= "string" then
		return false;
	end;
	return reserved_keywords[str] or (str:match("[^%d%s_]") and not (str:sub(1, 1):match("%d")));
end;

local function assertint(int)
	if type(int) ~= "number" then
		error("Cannot implicitly convert type '" .. typeof(int) .. "' to 'int'", 2)
	end;
	if int % 1 ~= 0 then
		error("Cannot implicitly convert type 'double' to 'int'", 2);
	end
	if int > 4294967295 or int < -4294967296 then
		error("Integral constant is too large", 2);
	end;
	if int > 2147483647 or int < -2147483648 then
		error("Cannot implicitly convert type 'uint' to 'int'", 2);
	end;
end;

local proxy_data = { };
local proxy_extension = { };

local function eq_item(left, right)
	if proxy_data[left].parent ~= proxy_data[right].parent then
		return false;
	end;
	return proxy_data[left].value == proxy_data[right].value;
end;
local function lt_item(left, right)
	if proxy_data[left].parent ~= proxy_data[right].parent then
		error("Operator '<' and '>' cannot be applied to operands of different customenums");
	end;
	return proxy_data[left].value < proxy_data[right].value;
end;
local function le_item(left, right)
	if proxy_data[left].parent ~= proxy_data[right].parent then
		error("Operator '<=' and '>=' cannot be applied to operands of different customenums");
	end;
	return proxy_data[left].value > proxy_data[right].value;
end;

local enum_methods = { };
function enum_methods.TryParse(self, value, ignore_case)
	if value == "GetHexAddress" then
		return false, nil;
	end;
	local success = false;
	local ret;
	for name, val in next, proxy_data[self] do
		if value == name or (ignore_case and value:lower() == name:lower()) then
			success = true;
			ret = val;
			break;
		end;
	end;
	return success, ret;
end;

function enum_methods.Parse(self, value, ignore_case)
	if value == "GetHexAddress" then
		return nil;
	end;
	local ret;
	for name, val in next, proxy_data[self] do
		if value == name or (ignore_case and value:lower() == name:lower()) then
			ret = val;
			break;
		end;
	end;
	return ret;
end;

function enum_methods.GetHexAddress(self)
	return proxy_data[self].GetHexAddress;
end;

function enum_methods.GetNames(self)
	local ret = { };
	local i = 0;
	for name, item in next, proxy_data[self] do
		if name ~= "GetHexAddress" then
			i = i + 1;
			ret[i] = name;
		end;
	end;
	table.sort(ret, function(a, b) return proxy_data[proxy_data[self][a]].value < proxy_data[proxy_data[self][b]].value end);
	return ret;
end;

function enum_methods.GetName(self, value)
	for name, val in next, proxy_data[self] do
		if name ~= "GetHexAddress" then
			if value == val or value == proxy_data[val].value then
				return name;
			end;
		end;
	end;
	return nil;
end;

function enum_methods.GetValues(self)
	local ret = { };
	local i = 0;
	for name, item in next, proxy_data[self] do
		if name ~= "GetHexAddress" then
			i = i + 1;
			ret[i] = proxy_data[item].value;
		end;
	end;
	table.sort(ret, function(a, b) return a < b end);
	return ret;
end;

function enum_methods.GetType(self)
	return "userdata";
end;

local function enum_extensions(self, tbl, ...)
	if type(tbl) ~= "table" or (#{ ... } > 0) then
		error("Invalid syntax for customenum", 2);
	end;
	
	local tbl_copy = { };
	for key, val in next, tbl do
		if (not isvalid(key)) or ({ ToInt32 = true; ToFloat = true; GetType = true; })[key] then
			error("Invalid syntax for customenum", 2);
		end;
		tbl_copy[key] = val;
	end;
	
	local proxy = newproxy(true);
	
	getmetatable(proxy).__call = function(_, ...)
		-- We'll throw then :() is called
		enum_extensions(self, ...);
	end;
	getmetatable(proxy).__index = function(self, index)
		error("Invalid syntax for customenum", 2);
	end;
	getmetatable(proxy).__newindex = function(self, index, value)
		if (isvalid(index)) and not (({ ToInt32 = true; ToFloat = true; GetType = true; })[value]) then
			tbl_copy[index] = value;
		else
			error("Invalid syntax for customenum", 2);
		end;
	end;
	getmetatable(proxy).__tostring = function(self, index, value)
		error("Invalid syntax for customenum", 2);
	end;
	getmetatable(proxy).__metatable = "The metatable is locked";
	
	proxy_extension[self] = { data = tbl_copy; value = proxy; };
end;

local function new(self, tbl, ...)
	if type(tbl) ~= "table" or (#{ ... } > 0) then
		error("Invalid syntax for customenum", 2);
	end;
	
	local proxy = newproxy(true);
	local addr = tostring(proxy):sub(11);
	proxy_data[proxy] = { GetHexAddress = addr; };
	enum_extensions(proxy, { });
	
	getmetatable(proxy).__index = function(self, index)
		if proxy_data[self][index] then
			return proxy_data[self][index];
		elseif index == "Extensions" then
			return proxy_extension[self].value;
		elseif not(({ ['function'] = true; ['nil'] = true; })[type(proxy_extension[proxy].data[index])]) then
			return proxy_extension[proxy].data[index];
		elseif enum_methods[index] then
			return function(self2, ...)
				if self2 == self then
					if not _DISABLE_WARNING then
						warn("It's recommended to use' 'customenum." .. index .."()' instead of 'customenum."
						.. index .."()' and 'customenum." .. index .. '('
						.. "customenum)", 2);
					end;
					return enum_methods[index](self2, ...);
				end;
				return enum_methods[index](self, self2, ...);
			end;
		end;
		error("customenum does not contain a definition for '" .. index .. "'");
	end;
	getmetatable(proxy).__newindex = function(self, index, value)
		if index == "Extensions" then
			enum_extensions(self, value);
		else
			error("Property or indexer 'customenum." .. index .. "' cannot be assigned to -- it is read only", 2);
		end;
	end;
	getmetatable(proxy).__tostring = function()
		return "customenum: " .. addr;
	end;
	getmetatable(proxy).__call = function(self, value)
		for name, val in next, proxy_data[self] do
			if name ~= "GetHexAddress" then
				if value == val or value == proxy_data[val].value then
					return val;
				end;
			end;
		end;
		return nil;
	end;
	getmetatable(proxy).__metatable = "The metatable is locked";
	
	local i = 0;
	local arr = (tbl[1] ~= nil);
	for key, val in next, tbl do
		if isvalid(val) and type(key) == "number" and arr then
			if i == 4294967295 then
				error("the enumerator value is too large to fit in its type", 2);
			end;
			key = val;
			val = i;
			i = i + 1;
		elseif isvalid(key) and not arr then
			assertint(val);
		else
			error("Invalid syntax for customenum", 2);
		end;
		
		local item_proxy = newproxy(true);
		local item_addr = tostring(item_proxy):sub(11);
		getmetatable(item_proxy).__eq = eq_item;
		getmetatable(item_proxy).__le = le_item;
		getmetatable(item_proxy).__lt = lt_item;
		getmetatable(item_proxy).__tostring = function()
			return key;
		end;
		getmetatable(item_proxy).__index = function(self, index)
			if index == "ToString" then
				return function() return tostring(self); end;
			elseif index == "ToInt32" or index == "ToFloat" then
				return function() return val; end;
			elseif index == "GetHexAddress" then
				return function() return item_addr; end;
			elseif type(proxy_extension[proxy].data[index]) == "function"
				or index == "Equals"  or index == "CompareTo"
				or index == "GetType"
				then
				return function(self2, ...)
					local func = proxy_extension[proxy].data[index];
					if index == "Equals" then
						func = eq_item;
					elseif index == "CompareTo" then
						function func(left, right)
							if lt_item(left, right) then
								return -1;
							elseif eq_item(left, right) then
								return 0;
							end;
							return 1;
						end;
					elseif index == "GetType" then
						function func(self)
							return proxy;
						end;
					end;
					if self2 == self then
						if not _DISABLE_WARNING then
							warn("It's recommended to use' 'customenum." .. key .. '.'.. index .."()' instead of 'customenum."
							.. key .. ':'.. index .."()' and 'customenum." .. key .. '.'.. index .. '('
							.. "customenum." .. key .. ")");
						end;
						return func(self2, ...);
					end;
					return func(self, self2, ...);
				end;
			end;
			error("'customenum." .. key .. "' does not contain a definition for '" 
				.. index .. "' and no accessible extension method '" .. index 
				.. "' accepting a first argument of type 'customenum." .. key .."' could be found",
				2
			);
		end;
		getmetatable(item_proxy).__metatable = "The metatable is locked";
		proxy_data[proxy][key] = item_proxy;
		proxy_data[item_proxy] = { value = val; parent = proxy; name = key; };
	end;
	return proxy;
end;

local module_proxy = newproxy(true);
local module_mt = getmetatable(module_proxy);

module_mt.__call = new;
module_mt.__newindex = function()
	error("Invalid syntax for customenum", 2);
end;
module_mt.__metatable = "The metatable is locked";
module_mt.__index = function(self, index)
	error("Invalid syntax for customenum", 2);
end;
module_mt.__tostring = function(self, index)
	error("Invalid syntax for customenum", 2);
end;

return module_proxy;