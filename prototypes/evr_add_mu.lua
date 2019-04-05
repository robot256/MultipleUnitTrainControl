--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: evr_add_mu.lua
 * Description: Integration with Electric Vehicles Reborn
--]]


if mods["electric-vehicles-lib-reborn"] then

	-- Generate an MU version of the EVR Electric Locomotive
	createMuLoco("electric-vehicles-electric-locomotive","electric-vehicles-electric-locomotive-mu",
						"item-with-entity-data",true)
	
end
