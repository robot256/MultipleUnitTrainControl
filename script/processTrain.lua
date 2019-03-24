
require("processTrainPurge")
require("processTrainBasic")
require("processTrainWireless")
require("addPairToGlobal")


--------------------
-- Process a train and queue all the locomotives that need replacing
-- Arguments:
--   t: reference to the LuaTrain entity being processed
--   basic_enable: boolean, whether MU locomotives are allowed or not
--   wireless_enable: boolean, whether MU locomotives can be separated by wagons
--
-- Accesses global variables:
--   global.upgrade_pairs
--   global.downgrade_pairs
--   global.mu_pairs
--   global.replacement_queue

function processTrain(t,basic_enable,wireless_enable)

	local found_pairs = {}
	local upgrade_locos = {}
	
	if basic_enable == false then
		found_pairs,upgrade_locos = processTrainPurge(t)
		
	else
		-- Mod is Enabled, let's go to town!
		if wireless_enable == false then
			-- We must convert locos in contiguous blocks
			found_pairs,upgrade_locos = processTrainBasic(t)
		else
			-- We can convert locos paired anywhere in the train
			found_pairs,upgrade_locos = processTrainWireless(t)
		end
	end


	-- Add replacements to the replacement queue
	for _,entry in pairs(upgrade_locos) do
		table.insert(globals.replacement_queue,entry)
	end
	
	-- Add pairs to the pair lists.  (pairs will need to be updated when the replacements are made)
	for _,entry in pairs(found_pairs) do
		addPairToGlobal(entry)
	end
	
	
end



return processTrain
