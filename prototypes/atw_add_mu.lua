--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: atw_add_mu.lua
 * Description: Integration with Armored Train (Turret Wagon) mod
--]]


if mods["Armored-train"] then

	-- Generate an MU version of the 5dim Locomotive
	createMuLoco("armored-locomotive-mk1","armored-locomotive-mk1-mu","item",false)
	
end
