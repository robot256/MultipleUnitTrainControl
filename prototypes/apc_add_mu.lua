--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: apc_add_mu.lua
 * Description: Integration with Angel's Addons Petrochem Train mod
--]]


if mods["angelsaddons-petrotrain"] then

	-- Generate an MU version of the Petrochem Locomotives
	
	-- Create New Items
	local petroMuItem = createMuLocoItemPrototype("item-with-entity-data", "petro-locomotive-1", "petro-locomotive-1-mu")
	
	data:extend({petroMuItem})

	-- Create New Entities
	local petroMuEntity = createMuLocoEntityPrototype("petro-locomotive-1", "petro-locomotive-1-mu")
	
	data:extend({petroMuEntity})
	
	-- Create Dummy Recipes
	local petroLocoRecipe = createMuLocoRecipePrototype("petro-locomotive-1", "petro-locomotive-1-mu")
	data:extend({petroLocoRecipe})

	-- Add the MU versions to the dummy technology list
	table.insert(data.raw.technology["multiple-unit-train-control-locomotives"].effects, {type = "unlock-recipe", recipe = "petro-locomotive-1-mu"})
	
end
