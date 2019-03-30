--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: apc_add_mu.lua
 * Description: Integration with Angel's Addons Petrochem Train mod
--]]


if mods["angelsaddons-petrotrain"] then

	-- Generate an MU version of the Petrochem Locomotives
	createMuLoco("petro-locomotive-1","petro-locomotive-1-mu","item-with-entity-data",false)
	
end
