--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: et_add_mu.lua
 * Description: Integration with magu5026's Electric Train
--]]


if mods["ElectricTrain"] then

	-- Generate an MU version of the Electric Train 1, 2, and 3
	
	-- Create New Items
	local electric1MuItem = createMuLocoItemPrototype("item-with-entity-data", "et-electric-locomotive-1", "et-electric-locomotive-1-mu")
	local electric2MuItem = createMuLocoItemPrototype("item-with-entity-data", "et-electric-locomotive-2", "et-electric-locomotive-2-mu")
	local electric3MuItem = createMuLocoItemPrototype("item-with-entity-data", "et-electric-locomotive-3", "et-electric-locomotive-3-mu")
	
	data:extend({electric1MuItem,
				 electric2MuItem,
				 electric3MuItem})

	-- Create New Entities
	local electric1MuEntity = createMuLocoEntityPrototype("et-electric-locomotive-1", "et-electric-locomotive-1-mu", false)
	local electric2MuEntity = createMuLocoEntityPrototype("et-electric-locomotive-2", "et-electric-locomotive-2-mu", false)
	local electric3MuEntity = createMuLocoEntityPrototype("et-electric-locomotive-3", "et-electric-locomotive-3-mu", false)
	
	data:extend({electric1MuEntity,
				 electric2MuEntity,
				 electric3MuEntity})
	
	-- Create Dummy Recipes
	local electric1LocoRecipe = createMuLocoRecipePrototype("et-electric-locomotive-1", "et-electric-locomotive-1-mu")
	local electric2MuRecipe = createMuLocoRecipePrototype("et-electric-locomotive-2", "et-electric-locomotive-2-mu")
	local electric3MuRecipe = createMuLocoRecipePrototype("et-electric-locomotive-3", "et-electric-locomotive-3-mu")
	data:extend({electric1LocoRecipe,
				 electric2MuRecipe,
				 electric3MuRecipe})

	-- Add the MU versions to the dummy technology list
	table.insert(data.raw.technology["multiple-unit-train-control-locomotives"].effects, {type = "unlock-recipe", recipe = "et-electric-locomotive-1-mu"})
	table.insert(data.raw.technology["multiple-unit-train-control-locomotives"].effects, {type = "unlock-recipe", recipe = "et-electric-locomotive-2-mu"})
	table.insert(data.raw.technology["multiple-unit-train-control-locomotives"].effects, {type = "unlock-recipe", recipe = "et-electric-locomotive-3-mu"})
	
end
