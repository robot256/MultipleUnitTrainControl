--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: 5dt_add_mu.lua
 * Description: Integration with 5dim - Trains mod
--]]


if mods["5dim_trains"] then

	-- Generate an MU version of the 5dim Locomotive
	createMuLoco("5d-locomotive-hs","5d-locomotive-hs-mu","item-with-entity-data",false)
	createMuLoco("5d-locomotive-reinforced","5d-locomotive-reinforced-mu","item-with-entity-data",false)
	
end
