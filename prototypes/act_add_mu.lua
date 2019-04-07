--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: act_add_mu.lua
 * Description: Integration with Angel's Industries
--]]


if mods["angelsindustries"] then
	-- Generate an MU version of the Angel's Crawler Locomotive
	createMuLoco("crawler-locomotive","crawler-locomotive-mu","item-with-entity-data",false)
	createMuLoco("crawler-locomotive-wagon","crawler-locomotive-wagon-mu","item-with-entity-data",false)
end
