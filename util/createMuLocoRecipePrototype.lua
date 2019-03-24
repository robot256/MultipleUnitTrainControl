--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: createMuLocoPrototype.lua
 * Description: Copies a locomotive prototype and creates the "-mu" version
 *   with twice as much power output.
--]]


function createMuLocoRecipePrototype(name, newName)
	-- Check that source exists
	if not data.raw["locomotive"][name] then
		error("locomotive " .. name .. " doesn't exist")
	end
	
	-- Don't copy anything, make it directly convertible
	local newRecipe = 
	{
		type = "recipe",
		name = newName,
		ingredients = {{newName, 1}},
		result = name,
		hidden = true
	}
	
	return newRecipe
end

return createMuLocoRecipePrototype