--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: control.lua
 * Description: Runtime operation script for replacing locomotives and balancing fuel.
 * Functions:
 *  => On Train Created (any built, destroyed, coupled, or uncoupled rolling stock)
 *  ===> Check if forwards_locomotives and backwards_locomotives contain matching pairs
 *  =====> Replace them with MU locomotives, add to global list of MU pairs, reconnect train, etc.
 *  ===> Check if train contains existing MU pairs, and if those pairs are intact.
 *  =====> Replace any partial MU pairs with normal locomotives, remove from global list, reconnect trains
 *
 *  => On Mod Settings Changed (disabled flag changes to true)
 *  ===> Read through entire global list of MU pairs and replace them with normal locomotives
 
 *  => On Nth Tick (once per 5 seconds)
 *  ===> Read through entire global list of MU pairs.  
 *  ===> Move among each pair if one has more of any item than the other.
 *
 --]]


require("util.replaceLocomotive")
require("util.balanceInventories")
require("util.isLocoForward")
require("util.isLocoBackward")

local settings_enabled = settings.global["multiple-unit-train-control-enabled"].value
local settings_nth_tick = settings.global["multiple-unit-train-control-on_nth_tick"].value
local current_nth_tick = settings_nth_tick


-----------------------------
-- Set up the mapping between normal and MU locomotives
local upgrade_pairs =  {["locomotive"]="locomotive-mu",
						["heavy-locomotive"]="heavy-locomotive-mu", 
						["express-locomotive"]="express-locomotive-mu",
						["nuclear-locomotive"]="nuclear-locomotive-mu"}
local downgrade_pairs = {["locomotive-mu"]="locomotive",
						["heavy-locomotive-mu"]="heavy-locomotive", 
						["express-locomotive-mu"]="express-locomotive",
						["nuclear-locomotive-mu"]="nuclear-locomotive"}
						

------------------------- FUEL BALANCING CODE --------------------------------------


-- Takes inventories from the queue and process them, one per tick
local function ProcessInventoryQueue()
	local idle = true
	
	if global.inventories_to_balance and next(global.inventories_to_balance) then
		--game.print("Taking from inventory queue, " .. #global.inventories_to_balance .. " remaining")
		local inventories = table.remove(global.inventories_to_balance, 1)
		balanceInventories(inventories[1], inventories[2])
		idle = false
	end

	return idle
end


------------------------- LOCOMOTIVE REPLACEMENT CODE -------------------------------

------------------------
-- Takes a train and looks for locomotives to replace.
-- Expected to be run in a blocking manner (only one train processed at a time).
------------------------
local function ProcessTrain(t)
	
	local id = t.id
	local f = t.locomotives["front_movers"]
	local b = t.locomotives["back_movers"]
	local enoughLocos = (#f>0) and (#b>=0)
	
	--game.print("Processing train ".. id .." with ".. #f .." front-movers, ".. #b .." back-movers")
	
	-- Check for locos to upgrade or downgrade
	--   For each carriage, check if it is a locomotive.
	--     Check if it is in the upgrade keys, or the downgrade keys
	--     Then check if there is a locomotive in the next slot
	local numCars = #t.carriages
	local d
	local pairCreated = false
	for i,c in ipairs(t.carriages) do
		-- Make sure this isn't one we just placed during a replacement
		if c.type == "locomotive" then
			if upgrade_pairs[c.name] and enoughLocos then
				-- This is a locomotive that can be upgraded
				
				-- Check to see if the adjacent carriage are a complementary locomotive.
				if isLocoForward(t,c) then
					-- c is forwards, search later in the train
					if i < numCars then   -- 1 indexed arrays FTW
						d = t.carriages[i+1]
						if d.type == "locomotive" and (d.name == c.name or d.name == upgrade_pairs[c.name]) then
							-- It is either the base or the upgraded version of this loco
							-- Check if it is in the complementary direction
							if isLocoBackward(t,d) then
								-- It is backwards!  We make an MU!
								--game.print("Making MU with carriages ".. i .." and ".. i+1)
								local nc = replaceLocomotive(c,upgrade_pairs[c.name])
								if d.name == nc.name then
									-- Done upgrading this pair, add to fuel balance list
									--game.print("Adding pair of ".. nc.name .." in train " .. nc.train.id)
									table.insert(global.mu_pairs,{d,nc})
									pairCreated = true
								end
								break
							end
						end
					end
				else
					-- c is backwards, search earlier in the train
					if i > 1 then
						d = t.carriages[i-1]
						if d.type == "locomotive" and (d.name == c.name or d.name == upgrade_pairs[c.name]) then
							-- It is either the base or the upgraded version of this loco
							-- Check if it is in the complementary direction
							if isLocoForward(t,d) then
								-- It is backwards!  We make an MU!
								--game.print("Making MU with carriages ".. i .." and ".. i+1)
								local nc = replaceLocomotive(c,upgrade_pairs[c.name])
								if d.name == nc.name then
									-- Done upgrading this pair, add to fuel balance list
									--game.print("Adding pair of ".. nc.name .." in train " .. nc.train.id)
									table.insert(global.mu_pairs,{d,nc})
									pairCreated = true
								end
								break
							end
						end
					end
				end
			
			elseif downgrade_pairs[c.name] then
				-- This is a locomotive that can be downgraded
				-- Check to see if the next carriage is NOT a complementary locomotive.
				local needToDowngrade = true
				if isLocoForward(t,c) then
					-- c is forwards, search later in the train
					if i < numCars then   -- 1 indexed arrays FTW
						d = t.carriages[i+1]
						if d.type == "locomotive" and (d.name == c.name or d.name == downgrade_pairs[c.name]) then
							-- It is either the base or the upgraded version of this loco
							-- Check if it is in the complementary direction
							if isLocoBackward(t,d) then
								-- It is backwards!  It's okay to leave it as an MU.
								needToDowngrade = false
							end
						end
					end
				else
					-- c is backwards, search earlier in the train
					if i > 1 then
						d = t.carriages[i-1]
						if d.type == "locomotive" and (d.name == c.name or d.name == downgrade_pairs[c.name]) then
							-- It is either the base or the upgraded version of this loco
							-- Check if it is in the complementary direction
							if isLocoForward(t,d) then
								-- It is backwards!  It's okay to leave it as an MU.
								needToDowngrade = false
							end
						end
					end
				end
				-- If we didn't find a matching MU pair, then we need to downgrade this locomotive
				if needToDowngrade==true then
					--game.print("Removing MU locomotive ".. i)
					-- Remove this pair from fuel balancing list
					for k,q in pairs(global.mu_pairs) do
						if (q[1] and q[1] == c) or (q[2] and q[2] == c) then
							--game.print("Removing pair of ".. c.name .." in train " .. c.train.id)
							table.remove(global.mu_pairs,k)
							break
						end
					end
					replaceLocomotive(c,downgrade_pairs[c.name])
					break
				end
			end
		end
	end
	--game.print("Done processing train ".. id)
	return pairCreated
end


-- Takes a train and reverts all MU locomotives to normal ones
local function RevertTrain(t)

	local id = t.id
	
	-- Check for locos to upgrade or downgrade
	--   For each carriage, check if it is a locomotive.
	--     Check if it is in the upgrade keys, or the downgrade keys
	--     Then check if there is a locomotive in the next slot
	for i,c in ipairs(t.carriages) do
		-- Serialize the position of this locomotive
		-- Make sure this isn't one we just placed during a replacement
		if c.type == "locomotive" then
			if downgrade_pairs[c.name] then
				-- This is a locomotive that can be downgraded
				game.print("Removing MU locomotive ".. i)
				replaceLocomotive(c,downgrade_pairs[c.name])
				break
			end
		end
	end
	game.print("Done reverting train ".. id)
end



-- Process up to one valid train from the queue per tick
--   The queue prevents us from processing another train until we finish with the first one.
--   That way we don't process "intermediate" trains created while replacing a locomotive by the script.
local function ProcessTrainQueue()
	local idle = true

	if global.trains_in_queue and next(global.trains_in_queue) then
		--game.print("ProcessTrainQueue has a train in the queue")
		while next(global.trains_in_queue) do
			local t = table.remove(global.trains_in_queue,1)
			if t and t.valid then
				if settings_enabled==true then
					ProcessTrain(t)
					idle = false
				else
					-- Mod disabled, go through the process of reverting every engine
					RevertTrain(t)
					idle = false
					break
				end
			end
		end
	else
		-- No trains in queue, stop checking
		
		-- Disabled and done reverting trains, don't new ones to queue anymore
		if not settings_enabled then
			script.on_event(defines.events.on_train_created, nil)
		end
	end
	
	return idle
end


----------------------------------------------
------ EVENT HANDLING ---


local function OnTick(event)
	-- process any new trains and inventory balancing
	local idle = ProcessTrainQueue()
	
	-- if we didn't spend time on a train this tick, check for inventory updates
	if idle then
		idle = ProcessInventoryQueue()
	end
	
	if idle then
		-- Both queues are empty, turn off tick updates
		--game.print("Turning off OnTick")
		script.on_event(defines.events.on_tick, nil)
	end
		
end

local function OnTrainCreated(event)
-- Event contains train, old_train_id_1, old_train_id_2
	if not global.trains_in_queue then
		--game.print("assigning empty table to trains_in_queue...")
		global.trains_in_queue = {}
	end
	
	if not global.mu_pairs then
		--game.print("assigning empty table to mu_pairs...")
		global.mu_pairs = {}
	end
	
	-- Add this train to the train processing queue
	-- on_train_created only executes once for every train object, no duplicate checking required.
	table.insert(global.trains_in_queue,event.train)
	
	-- Set up the on_tick action to process trains
	script.on_event(defines.events.on_tick, OnTick)
	
end
		
-- Initiates balancing of every MU consist
local function OnNthTick(event)
	if not global.inventories_to_balance then
		global.inventories_to_balance = {}
	end
	if next(global.mu_pairs) then
		local minTicks = 0
		local pairs_to_purge = {}
		for i,locos in pairs(global.mu_pairs) do
			if (not locos[1] or not locos[1].valid) or (not locos[2] or not locos[2].valid) then
				table.insert(pairs_to_purge,i)
			else
				--game.print("Adding to inventory queue ("..locos[1].backer_name .. " & " .. locos[2].backer_name)
				table.insert(global.inventories_to_balance, {locos[1].burner.inventory, locos[2].burner.inventory})
				minTicks = minTicks + 1
				if locos[1].burner.burnt_result_inventory.valid and locos[2].burner.burnt_result_inventory.valid then
					table.insert(global.inventories_to_balance, 
							{locos[1].burner.burnt_result_inventory, locos[2].burner.burnt_result_inventory})
					minTicks = minTicks + 1
				end
			end
		end
		
		-- Only pop one invalid pair per refresh cycle
		if next(pairs_to_purge) then
			table.remove(global.mu_pairs,pairs_to_purge[1])
		end
		
		-- Set up the on_tick action to process trains
		--game.print("Nth tick starting OnTick")
		script.on_event(defines.events.on_tick, OnTick)
		
		-- Update the Nth tick interval to make sure we have enough time to update all the trains
		local newVal = current_nth_tick
		if minTicks+10 > current_nth_tick then
			newVal = minTicks*2
		elseif minTicks < current_nth_tick / 2 then
			newVal = math.max(minTicks*2,settings_nth_tick)
		end
		if newVal ~= current_nth_tick then
			game.print("Changing Nth Tick duration to " .. newVal)
			current_nth_tick = newVal
			script.on_nth_tick(nil)
			script.on_nth_tick(current_nth_tick, OnNthTick)
		end
	end

end



-- Enables the on_nth_tick event according to the mod setting value
local function StartBalanceUpdates()
	if settings_nth_tick > 0 then
		game.print("Enabling Nth Tick with setting " .. settings_nth_tick)
		script.on_nth_tick(nil)
		current_nth_tick = settings_nth_tick
		script.on_nth_tick(settings_nth_tick, OnNthTick)
	else
		-- Value of zero disables fuel balancing
		game.print("Disabling Nth Tick due to setting")
		script.on_nth_tick(nil)
		global.inventories_to_balance = {}
	end
end




---- Bootstrap ----
do
local function init_events()
	if settings_enabled then
		script.on_event(defines.events.on_train_created, OnTrainCreated)
		current_nth_tick = settings_nth_tick
		script.on_nth_tick(settings_nth_tick, OnNthTick)
	else
		script.on_event(defines.events.on_train_created, nil)
		script.on_nth_tick(nil)
		
	end
	
end

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
	game.print("in mod_settings_changed!")
	if event.setting == "multiple-unit-train-control-enabled" then
		settings_enabled = settings.global["multiple-unit-train-control-enabled"].value
		if settings_enabled then
			-- Enable events for new trains
			script.on_event(defines.events.on_train_created, OnTrainCreated)
			
			-- Scrub existing trains and add MU locomotives when necessary
			for _, surface in pairs(game.surfaces) do
				local trains = surface.get_trains()
				for _,train in pairs(trains) do
					table.insert(global.trains_in_queue,train)
				end
			end
			if not script.get_event_handler(defines.events.on_tick) then
				script.on_event(defines.events.on_tick, OnTick)
			end
			
			-- if there were saved pairs, start the fuel balancer
			if global.mu_pairs and next(global.mu_pairs) then
				StartBalanceUpdates()
			end
			
		else
			-- Mod is disabled
			script.on_nth_tick(nil)  -- stop fuel updates
			-- Revert the MU locomotives using the on_train_created and on_tick handlers
			for _, surface in pairs(game.surfaces) do
				local trains = surface.get_trains()
				for _,train in pairs(trains) do
					table.insert(global.trains_in_queue,train)
				end
			end
			if not script.get_event_handler(defines.events.on_tick) then
				script.on_event(defines.events.on_tick, OnTick)
			end
			-- Clean globals
			global.mu_pairs = {}
			global.inventories_to_balance = {}
		end
	end
	
	if event.setting == "multiple-unit-train-control-on_nth_tick" then
		-- When interval changes, clear all on_nth_tick handlers and add it back to the new one
		settings_nth_tick = settings.global["multiple-unit-train-control-on_nth_tick"].value
		script.on_nth_tick(nil)
		if global.mu_pairs and next(global.mu_pairs) then
			StartBalanceUpdates()
		end
	end
end)



script.on_load(function()
	init_events()
end)

script.on_init(function()
	game.print("In on_init!")
	global.trains_in_queue = global.trains_in_queue or {}
	global.mu_pairs = global.mu_pairs or {}
	global.inventories_to_balance = global.inventories_to_balance or {}
	init_events()
end)

script.on_configuration_changed(function(data)
	game.print("In on_configuration_changed!")
	global.trains_in_queue = global.trains_in_queue or {}
	global.mu_pairs = global.mu_pairs or {}
	global.inventories_to_balance = global.inventories_to_balance or {}
	init_events()
end)
end
