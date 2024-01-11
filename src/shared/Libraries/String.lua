local Strings = {}

function Strings.firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

--[[
	@title ConvertPathToInstance

	@summary Convert a PathString ("ReplicatedStorage.Temp") to it's location's instance/table value

	@param str: string = PathString
	@param start: ...? = StartingLocation or game

	@return value: any = location instance/table
]]

function Strings.convertPathToInstance(str: string, start: any, ignoreError: boolean?, divider: string?)
	local segments = str:split(divider or ".")
	local current = start or game
	local success, err = pcall(function()
		for _,v in pairs(segments) do
			current=current[v]
		end
	end)
	if not success then
		return ignoreError and "nil" or error(err)
	end
	return current
end

--[[
	@title ConvertPathToInstance
	@summary Do something to the found instance/value from PathString
	@param str: string = PathString
	@param callback: function = Action you would like to do
	@return value: any = returned function value
]]

function Strings.doActionViaPath(path: string, start: any, callback: (...any) -> (...any))
	local segments = path:split(".")
	local current = start or game
	local success, err = pcall(function()
		for i,v in pairs(segments) do

			-- this will return the location the entire Path prefix except the last segment
			-- we will do what we need to do to the table in callback by current[segments[#segments]] = ...
			if i == #segments then
				return callback(current, segments[i], segments)
			end

			current = current[v]
		end
	end)
	
	if err then return error(err) end
	return success
end

return Strings