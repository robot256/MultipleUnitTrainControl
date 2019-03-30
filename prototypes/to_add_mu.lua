--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: to_add_mu.lua
 * Description: Integration with Optera's Train & Fuel Overhaul
--]]


if mods["TrainOverhaul"] then

	-- Generate an MU version of the Heavy, Express, and Nuclear Locomotives
	createMuLoco("heavy-locomotive","heavy-locomotive-mu","item-with-entity-data",true)
	createMuLoco("express-locomotive","express-locomotive-mu","item-with-entity-data",true)
	createMuLoco("nuclear-locomotive","nuclear-locomotive-mu","item-with-entity-data",true)
	
end
