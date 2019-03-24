--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: entity.lua
 * Description: Creates the MU version of the base locomotive
--]]


-- Generate an MU version of the base locomotive
-- Item
local baseLocoItem = createMuLocoItemPrototype("item-with-entity-data", "locomotive", "locomotive-mu")
data:extend({baseLocoItem})

-- Entity
local baseLocoEntity = createMuLocoEntityPrototype("locomotive", "locomotive-mu")
data:extend({baseLocoEntity})

-- Fake recipe
local baseLocoRecipe = createMuLocoRecipePrototype("locomotive", "locomotive-mu")
data:extend({baseLocoRecipe})



-----------------
-- Add dummy technology to catalog the MU conversions
data:extend({
  {
    type = "technology",
	name = "multiple-unit-train-control-locomotives",
	icon = "__MultipleUnitTrainControl__/graphics/icons/mu-control.png",
	icon_size = 128,
	enabled = false,
	effects = 
	{
      {
        type = "unlock-recipe",
        recipe = "locomotive-mu"
      },
    },
    unit =
    {
      count = 8,
      ingredients = {{"automation-science-pack", 1}},
      time = 1
    },
    order = "c-a"
  },
})
