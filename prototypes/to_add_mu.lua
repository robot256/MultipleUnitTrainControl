--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: to_add_mu.lua
 * Description: Integration with Optera's Train & Fuel Overhaul
--]]


if mods["TrainOverhaul"] then

	-- Generate an MU version of the Heavy, Express, and Nuclear Locomotives
	
	-- Create New Items
	local heavyMuItem = createMuLocoItemPrototype("item-with-entity-data", "heavy-locomotive", "heavy-locomotive-mu")
	local expressMuItem = createMuLocoItemPrototype("item-with-entity-data", "express-locomotive", "express-locomotive-mu")
	local nuclearMuItem = createMuLocoItemPrototype("item-with-entity-data", "nuclear-locomotive", "nuclear-locomotive-mu")
	
	data:extend({heavyMuItem,
				 expressMuItem,
				 nuclearMuItem})

	-- Create New Entities
	local heavyMuEntity = createMuLocoEntityPrototype("heavy-locomotive", "heavy-locomotive-mu", true)
	local expressMuEntity = createMuLocoEntityPrototype("express-locomotive", "express-locomotive-mu", true)
	local nuclearMuEntity = createMuLocoEntityPrototype("nuclear-locomotive", "nuclear-locomotive-mu", true)
	
	data:extend({heavyMuEntity,
				 expressMuEntity,
				 nuclearMuEntity})
	
	-- Create Dummy Recipes
	local heavyLocoRecipe = createMuLocoRecipePrototype("heavy-locomotive", "heavy-locomotive-mu")
	local expressMuRecipe = createMuLocoRecipePrototype("express-locomotive", "express-locomotive-mu")
	local nuclearMuRecipe = createMuLocoRecipePrototype("nuclear-locomotive", "nuclear-locomotive-mu")
	data:extend({heavyLocoRecipe,
				 expressMuRecipe,
				 nuclearMuRecipe})

	-- Add the MU versions to the dummy technology list
	table.insert(data.raw.technology["multiple-unit-train-control-locomotives"].effects, {type = "unlock-recipe", recipe = "heavy-locomotive-mu"})
	table.insert(data.raw.technology["multiple-unit-train-control-locomotives"].effects, {type = "unlock-recipe", recipe = "express-locomotive-mu"})
	table.insert(data.raw.technology["multiple-unit-train-control-locomotives"].effects, {type = "unlock-recipe", recipe = "nuclear-locomotive-mu"})
	
end
