--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: restoreBurner.lua
 * Description: Restores the state and contents of a burner that was saved by saveBurner.lua.
--]]


function restoreBurner(target,saved)
	target.heat = saved.heat
	target.currently_burning = saved.currently_burning
	target.remaining_burning_fuel = saved.remaining_burning_fuel
	for k,v in pairs(saved.inventory) do
		target.inventory.insert({name=k, count=v})
	end
	if ( saved.burnt_result_inventory ) then
		for k,v in pairs(saved.burnt_result_inventory) do
			target.burnt_result_inventory.insert({name=k, count=v})
		end
	end
end

return restoreBurner
