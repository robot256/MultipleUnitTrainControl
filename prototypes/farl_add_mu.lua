--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: farl_add_mu.lua
 * Description: Integration with Fully Automated Rail Layer
--]]


if mods["FARL"] then
	-- Generate an MU version of the Fully Automated Rail Layer
	createMuLoco("farl","farl-mu","item-with-entity-data",true)
end
