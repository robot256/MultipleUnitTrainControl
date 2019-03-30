--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: as_add_mu.lua
 * Description: Integration with Angel's Addons Smelting Train mod
--]]


if mods["angelsaddons-smeltingtrain"] then

	-- Generate an MU version of the Smelting Locomotive and Smelting Mule
	createMuLoco("smelting-locomotive-1","smelting-locomotive-1-mu","item-with-entity-data",false)
	createMuLoco("smelting-locomotive-tender","smelting-locomotive-tender-mu","item-with-entity-data",false)
	
end
