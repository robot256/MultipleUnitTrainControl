--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: farl_add_mu.lua
 * Description: Integration with Fully Automated Rail Layer
--]]


if mods["FARL"] then
	-- Check version number
	local r = {3,1,3}
	local ver = mods["FARL"]
	local f = {tonumber(string.match(ver,"^(%d+)%.")),
	           tonumber(string.match(ver,"%.(%d+)%.")),
			   tonumber(string.match(ver,"%.(%d+)$"))}
	local version_good = false
	if (f[1] > r[1]) or (f[1] == r[1] and f[2] > r[2]) or (f[1] == r[1] and f[2] == r[2] and f[3] >= r[3]) then
		-- Generate an MU version of the Fully Automated Rail Layer
		createMuLoco("farl","farl-mu","item-with-entity-data",true)
	end
end
