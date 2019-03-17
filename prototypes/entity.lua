--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: entity.lua
 * Description: Creates the MU version of the base locomotive
--]]

local base_loco = copyPrototype("item-with-entity-data", "locomotive", "locomotive-mu")
base_loco.order = "a[train-system]-fc[locomotive]"
base_loco.localised_name = {'template.mu-name',{'entity-name.locomotive'}}
base_loco.localised_description = {'template.mu-item-description',{'entity-name.locomotive'}}
data:extend({base_loco})

-- Generate an MU version of the base locomotive
local newLoco = createMuLocoPrototype("locomotive")

-- Add all the MU versions to the data table
data:extend({newLoco})
