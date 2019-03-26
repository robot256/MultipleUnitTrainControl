--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: processTrainPurge.lua
 * Description: Reads a train and locates locomotives to replace per the "purge" algorithm.
 *    All upgraded locomotives that are found will be downgraded.
--]]


function processTrainPurge(t)

	-- Mod is Disabled, we must revert all MU locomotives!
	local found_pairs = {}
	local upgrade_locos = {}
	for i,c in ipairs(t.carriages) do
		if c.type == "locomotive" and global.downgrade_pairs[c.name] then
			table.insert(upgrade_locos,{c,global.downgrade_pairs[c.name]})
		end
	end

	return found_pairs, upgrade_locos 

end

return processTrainPurge
