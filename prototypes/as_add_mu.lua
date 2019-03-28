--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: as_add_mu.lua
 * Description: Integration with Angel's Addons Smelting Train mod
--]]


if mods["angelsaddons-smeltingtrain"] then

	-- Generate an MU version of the Smelting Locomotive and Smelting Mule
	
	-- Create New Items
	local smelting1MuItem = createMuLocoItemPrototype("item-with-entity-data", "smelting-locomotive-1", "smelting-locomotive-1-mu")
	local smelting2MuItem = createMuLocoItemPrototype("item-with-entity-data", "smelting-locomotive-tender", "smelting-locomotive-tender-mu")
	
	data:extend({smelting1MuItem,
				 smelting2MuItem})

	-- Create New Entities
	local smelting1MuEntity = createMuLocoEntityPrototype("smelting-locomotive-1", "smelting-locomotive-1-mu")
	local smelting2MuEntity = createMuLocoEntityPrototype("smelting-locomotive-tender", "smelting-locomotive-tender-mu")
	
	data:extend({smelting1MuEntity,
				 smelting2MuEntity})
	
	-- Create Dummy Recipes
	local smelting1LocoRecipe = createMuLocoRecipePrototype("smelting-locomotive-1", "smelting-locomotive-1-mu")
	local smelting2LocoRecipe = createMuLocoRecipePrototype("smelting-locomotive-tender", "smelting-locomotive-tender-mu")
	data:extend({smelting1LocoRecipe,
				 smelting2LocoRecipe})

	-- Add the MU versions to the dummy technology list
	table.insert(data.raw.technology["multiple-unit-train-control-locomotives"].effects, {type = "unlock-recipe", recipe = "smelting-locomotive-1-mu"})
	table.insert(data.raw.technology["multiple-unit-train-control-locomotives"].effects, {type = "unlock-recipe", recipe = "smelting-locomotive-tender-mu"})
	
end
