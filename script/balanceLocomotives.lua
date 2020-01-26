--[[ Copyright (c) 2020 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: balanceInventories.lua
 * Description: Equalizes the contents of two inventories whenever possible.
 *    Applies to all items types separately.
 *    Mixed inventories may not be balanced correctly if there are no empty slots.
 *    Last item will be repeatedly swapped between inventories until it is consumed.
--]]

local balanceInventories = require("script.balanceInventories")

function balanceLocomotives(entry)
  local loco1 = entry[1]
  local loco2 = entry[2]
  local loco1_previous = entry[3]
  local loco2_previous = entry[4]
  
  -- First balance the Fuel inventories
  -- Priority Two: If one locomotive is empty and the other has more than one fuel item.
  -- Priority One: If one locomotive has zero remaining burning fuel and the other has any fuel
  -- Priority Three: If the sum of fuel items is even and less than the last time we measured it.
  local loco1_count = loco1.get_fuel_inventory().get_item_count()
  local loco2_count = loco2.get_fuel_inventory().get_item_count()
  local loco1_fuel = loco1.burner.remaining_burning_fuel
  local loco2_fuel = loco2.burner.remaining_burning_fuel
  local previous_count = loco1_previous + loco2_previous
  local current_count = loco1_count + loco2_count
  
  if (loco1_count == 0 and loco2_count > 1) or (loco2_count == 0 and loco1_count > 1) then
    -- One loco has zero items and the other has enough to split evenly.  Move minimum amount (round down)
    balanceInventories(loco1.get_fuel_inventory(), loco2.get_fuel_inventory(), false)
  
  elseif (loco1_fuel == 0 and loco2_count > 0) or (loco2_fuel == 0 and loco1_count > 0) then
    -- One loco has zero fuel and the other has at least one.  Move at least one item, even if it leaves the other one empty. (round up)
    balanceInventories(loco1.get_fuel_inventory(), loco2.get_fuel_inventory(), true)
  
  elseif current_count < previous_count and loco1.train.state ~= defines.train_state.wait_station then
    -- Fuel was consumed, try to split evenly
    -- Only perform non-critical transfers when we are not waiting at a station
    balanceInventories(loco1.get_fuel_inventory(), loco2.get_fuel_inventory(), false)
  
  elseif current_count > previous_count and settings.global["multiple-unit-train-control-enable-cross-feed"] then
    -- Mod setting allows fueling both locos with one inserter, and fuel was added this cycle
    local loco1_added = loco1_count - loco1_previous
    local loco2_added = loco2_count - loco2_previous
    -- Only shift from loading loco to non-loading loco
    if (loco1_added > 0 and loco2_added == 0) or (loco2_added > 0 and loco1_added == 0) then
      -- Only one loco is being fueld (or the other is filled up)
      balanceInventories(loco1.get_fuel_inventory(), loco2.get_fuel_inventory(), true)
    end
  
  end
  
  
  -- Now balance the Burnt Result Inventories if necessary
  
  -- Save inventory counts after balancing items changes
  entry[3] = loco1.burner.inventory.get_item_count()
  entry[4] = loco2.burner.inventory.get_item_count()
  
end

return balanceLocomotives
