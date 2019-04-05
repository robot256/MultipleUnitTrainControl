--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: createMuLoco.lua
 * Description: Creates new prototypes for a burner-type MU locomotive version.
--]]


function createMuLoco(oldName, newName, itemType, hasDescription, power_multiplier)
	power_multiplier = power_multiplier or 2
	-- Check that source exists
	if not data.raw["locomotive"][oldName] then
		error("MUTC Prototype Maker: locomotive " .. oldName .. " doesn't exist")
	end
	
	data:extend{
		createMuLocoItemPrototype(itemType, oldName, newName),
		createMuLocoEntityPrototype(oldName, newName, hasDescription, power_multiplier),
		createMuLocoRecipePrototype(oldName, newName)
	}
	table.insert(data.raw.technology["multiple-unit-train-control-locomotives"].effects, {type = "unlock-recipe", recipe = newName})
	
end

return createMuLoco

