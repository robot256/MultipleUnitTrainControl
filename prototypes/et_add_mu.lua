--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: et_add_mu.lua
 * Description: Integration with magu5026's Electric Train
--]]


if mods["ElectricTrain"] then

	-- Generate an MU version of the Electric Train 1, 2, and 3
	createMuLoco("et-electric-locomotive-1","et-electric-locomotive-1-mu","item-with-entity-data",false)
	createMuLoco("et-electric-locomotive-2","et-electric-locomotive-2-mu","item-with-entity-data",false)
	createMuLoco("et-electric-locomotive-3","et-electric-locomotive-3-mu","item-with-entity-data",false)
	
end
