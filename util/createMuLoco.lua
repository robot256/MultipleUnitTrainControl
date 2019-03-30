--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: createMuLoco.lua
 * Description: Creates new prototypes for a burner-type MU locomotive version.
--]]


function createMuLoco(oldName, newName, itemType, hasDescription)

	data:extend{
		createMuLocoItemPrototype(itemType, oldName, newName),
		createMuLocoEntityPrototype(oldName, newName, hasDescription),
		createMuLocoRecipePrototype(oldName, newName)
	}
	table.insert(data.raw.technology["multiple-unit-train-control-locomotives"].effects, {type = "unlock-recipe", recipe = newName})
	
end

return createMuLoco

