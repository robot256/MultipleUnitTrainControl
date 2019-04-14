--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: createMuLocoRETFuelItem.lua
 * Description: Creates a new dummy fuel item for the "-mu" version of a Realistic Electric Trains locomotive:
--]]


function createMuLocoRETFuelItem(oldFuel, newFuel, power_multiplier)
	power_multiplier = power_multiplier or 2
	-- Check that source exists
	if not data.raw.item[oldFuel] then
		error("item " .. oldFuel .. " doesn't exist")
	end
	
	
	-- Generate dummy fuel items for base locos, because they are sized based on power consumption and we don't balance burner heat between pairs
	local dummy_fuel_mu = table.deepcopy(data.raw.item[oldFuel])
	dummy_fuel_mu.name = newFuel
	
	-- Change the power level (string contains suffix "kW"). This also increases fuel consumption.
	local max_power = string.sub(dummy_fuel_mu.fuel_value ,1,-3) * 2
	local power_suffix = string.sub(dummy_fuel_mu.fuel_value ,-2,-1)
	dummy_fuel_mu.fuel_value = max_power .. power_suffix
	
	return dummy_fuel_mu
end

return createMuLocoRETFuelItem
