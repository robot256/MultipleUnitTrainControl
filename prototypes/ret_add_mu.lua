--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: ret_add_mu.lua
 * Description: Integration with J_Aetherwing's Realistic Electric Trains
--]]

if mods["Realistic_Electric_Trains"] then

	local r = {0,4,2} -- required version
	local ver = mods["Realistic_Electric_Trains"]
	local f = {tonumber(string.match(ver,"^(%d+)%.")),  -- found version
	           tonumber(string.match(ver,"%.(%d+)%.")),
			   tonumber(string.match(ver,"%.(%d+)$"))}
	if (f[1] > r[1]) or (f[1] == r[1] and f[2] > r[2]) or (f[1] == r[1] and f[2] == r[2] and f[3] >= r[3]) then
		-- Generate an MU version of the Electric and Electric Mk2 Locomotives
		createMuLoco("ret-electric-locomotive","ret-electric-locomotive-mu","item-with-entity-data",false)
		createMuLoco("ret-electric-locomotive-mk2","ret-electric-locomotive-mk2-mu","item-with-entity-data",false)
		createMuLoco("ret-modular-locomotive","ret-modular-locomotive-mu","item-with-entity-data",false)
	end
end
