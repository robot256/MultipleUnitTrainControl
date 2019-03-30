--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: bob_add_mu.lua
 * Description: Integration with Bob's Logistics trains
--]]


if mods["boblogistics"] then

	-- Generate an MU version of the new locomotives
	createMuLoco("bob-locomotive-2","bob-locomotive-2-mu","item-with-entity-data",false)
	createMuLoco("bob-locomotive-3","bob-locomotive-3-mu","item-with-entity-data",false)
	createMuLoco("bob-armoured-locomotive","bob-armoured-locomotive-mu","item-with-entity-data",false)
	createMuLoco("bob-armoured-locomotive-2","bob-armoured-locomotive-2-mu","item-with-entity-data",false)
	
end
