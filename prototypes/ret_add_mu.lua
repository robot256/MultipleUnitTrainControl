--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: ret_add_mu.lua
 * Description: Integration with J_Aetherwing's Realistic Electric Trains
--]]

if mods["Realistic_Electric_Trains"] then

	-- Generate an MU version of the Electric and Electric Mk2 Locomotives
	createMuLoco("ret-electric-locomotive","ret-electric-locomotive-mu","item-with-entity-data",false)
	createMuLoco("ret-electric-locomotive-mk2","ret-electric-locomotive-mk2-mu","item-with-entity-data",false)
	
end
