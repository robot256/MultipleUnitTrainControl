--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: sat_add_mu.lua
 * Description: Integration with Schall's Armoured Train
--]]


if mods["SchallArmouredTrain"] then

	-- Generate an MU version of the Armoured Locomotives
	createMuLoco("Schall-armoured-locomotive","Schall-armoured-locomotive-mu","item-with-entity-data",false)
	createMuLoco("Schall-armoured-locomotive-mk1","Schall-armoured-locomotive-mk1-mu","item-with-entity-data",false)
	createMuLoco("Schall-armoured-locomotive-mk2","Schall-armoured-locomotive-mk2-mu","item-with-entity-data",false)
	if data.raw["locomotive"]["Schall-armoured-locomotive-mk3"] then
		createMuLoco("Schall-armoured-locomotive-mk3","Schall-armoured-locomotive-mk3-mu","item-with-entity-data",false)
	end
	
end
