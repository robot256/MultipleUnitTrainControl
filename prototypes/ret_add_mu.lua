--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: ret_add_mu.lua
 * Description: Integration with Realistic Electric Trains
--]]

if mods["Realistic_Electric_Trains"] then

	-- Generate an MU version of the Electric and Electric Mk2 Locomotives
	
	-- Create Item prototypes
	local electricMuItem = createMuLocoItemPrototype("item", "ret-electric-locomotive", "ret-electric-locomotive-mu")
	local advElectricMuItem = createMuLocoItemPrototype("item", "ret-electric-locomotive-mk2", "ret-electric-locomotive-mk2-mu")
	data:extend({electricMuItem,
				 advElectricMuItem})
	
	-- Create Entity prototypes
	local electricMuEntity = createMuLocoEntityPrototype("ret-electric-locomotive", "ret-electric-locomotive-mu")
	local advElectricMuEntity = createMuLocoEntityPrototype("ret-electric-locomotive-mk2", "ret-electric-locomotive-mk2-mu")
	data:extend({electricMuEntity,
				 advElectricMuEntity})
	
	-- Create Dummy recipe prototypes
	-- Second ingredient is the fuel item to use for this type of locomotive
	local electricMuRecipe = createMuLocoRecipePrototype("ret-electric-locomotive", "ret-electric-locomotive-mu")
	table.insert(electricMuRecipe.ingredients, {"ret-dummy-fuel-1",1})
	local advElectricMuRecipe = createMuLocoRecipePrototype("ret-electric-locomotive-mk2", "ret-electric-locomotive-mk2-mu")
	table.insert(advElectricMuRecipe.ingredients, {"ret-dummy-fuel-2",1})
	data:extend({electricMuRecipe,
				 advElectricMuRecipe})
	
	-- Add Recipes to Dummy technology
	table.insert(data.raw.technology["multiple-unit-train-control-locomotives"].effects, {type = "unlock-recipe", recipe = "ret-electric-locomotive-mu"})
	table.insert(data.raw.technology["multiple-unit-train-control-locomotives"].effects, {type = "unlock-recipe", recipe = "ret-electric-locomotive-mk2-mu"})
	
	
end

