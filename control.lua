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
 
 *  => On Nth Tick (once per ~10 seconds)
 *  ===> Read through entire global list of MU pairs.  
 *  ===> Move among each pair if one has more of any item than the other.
 *
 --]]

require("util.saveItemRequestProxy")
require("util.saveGrid")
require("util.restoreGrid")
require("util.replaceLocomotive")
require("util.balanceInventories")
require("script.processTrainPurge")
require("script.processTrainBasic")
require("script.processTrainWireless")
require("script.addPairToGlobal")


local settings_mode = settings.global["multiple-unit-train-control-mode"].value
local settings_nth_tick = settings.global["multiple-unit-train-control-on_nth_tick"].value
local current_nth_tick = settings_nth_tick


-----------------------------
-- Set up the mapping between normal and MU locomotives
-- Extract from the game prototypes list what MU locomotives are enabled
local function InitEntityMaps()

	global.upgrade_pairs = {}
	global.downgrade_pairs = {}
	if game.active_mods["Realistic_Electric_Trains"] then
		global.ret_locos = {}
	else
		global.ret_locos = nil
	end
	
	-- Retrieve entity names from dummy technology, store in global variable
	for _,effect in pairs(game.technology_prototypes["multiple-unit-train-control-locomotives"].effects) do
		if effect.type == "unlock-recipe" then
			local recipe = game.recipe_prototypes[effect.recipe]
			local std = recipe.products[1].name
			local mu = recipe.ingredients[1].name
			global.upgrade_pairs[std] = mu
			global.downgrade_pairs[mu] = std
			------------
			-- RET Compatibility
			local mod_name = ""
			if game.active_mods["Realistic_Electric_Trains"] and recipe.ingredients[2] then
				global.ret_locos[std] = recipe.ingredients[2].name
				global.ret_locos[mu] = recipe.ingredients[2].name
				mod_name = "Realistic Electric Trains "
				--game.print("MU Control registered Realistic Electric Trains upgrade mapping " 
				--            .. std .. " to " .. mu .. " with fuel " .. recipe.ingredients[2].name)
			--else
				--game.print("MU Control registered upgrade mapping " .. std .. " to " .. mu)
			end
			game.print({"debug-message.mu-mapping-message",mod_name,std,mu})
		end
	end
end


------------------------- BLUEPRINT HANDLING ---------------------------------------
-- Finds the blueprint a player created and changes all MU locos to standard
local function purgeBlueprint(bp)
	-- Get Entity table from blueprint
	local entities = bp.get_blueprint_entities()
	-- Find any downgradable items and downgrade them
	if entities and next(entities) then
		for _,e in pairs(entities) do
			if global.downgrade_pairs[e.name] then
				--game.print("MU Control fixing blueprint by changing ".. e.name .." to ".. global.downgrade_pairs[e.name])
				e.name = global.downgrade_pairs[e.name]
			end
		end
		-- Write tables back to the blueprint
		bp.set_blueprint_entities(entities)
	end
	-- Find icons too
	local icons = bp.blueprint_icons
	if icons and next(icons) then
		for _,i in pairs(icons) do
			if i.signal.type == "item" then
				if global.downgrade_pairs[i.signal.name] then
					--game.print("MU Control fixing blueprint icons by changing ".. i.signal.name .." to ".. global.downgrade_pairs[i.signal.name])
					i.signal.name = global.downgrade_pairs[i.signal.name]
				end
			end
		end
		-- Write tables back to the blueprint
		bp.blueprint_icons = icons
	end
end




------------------------- FUEL BALANCING CODE --------------------------------------
-- Takes inventories from the queue and process them, one per tick
local function ProcessInventoryQueue()
	local idle = true
	
	if global.inventories_to_balance and next(global.inventories_to_balance) then
		--game.print("Taking from inventory queue, " .. #global.inventories_to_balance .. " remaining")
		local inventories = table.remove(global.inventories_to_balance, 1)
		balanceInventories(inventories[1], inventories[2])
		
		idle = false  -- Tell OnTick that we did something useful
	end

	return idle
end


------------------------- LOCOMOTIVE REPLACEMENT CODE -------------------------------


-- Process replacement orders from the queue
--   Need to preserve mu_pairs across replacement
local function ProcessReplacementQueue()
	local idle = true
	
	if global.replacement_queue then
		while next(global.replacement_queue) do
			local r = table.remove(global.replacement_queue, 1)
			if r[1] and r[1].valid then
				-- Replace the locomotive
				--game.print("MU Control is replacing ".. r[1].name .. " '"..r[1].backer_name.."' with " .. r[2])
				game.print({"debug-message.mu-replacement-message",r[1].name,r[1].backer_name,r[2]})
				local newLoco = replaceLocomotive(r[1], r[2])
				-- Find which mu_pair the old one was in and put the new one instead
				for _,p in pairs(global.mu_pairs) do
					if p[1] == r[1] then
						p[1] = newLoco
						break
					elseif p[2] == r[1] then
						p[2] = newLoco
						break
					end
				end
				
				idle = false  -- Tell OnTick that we did something useful
				break
			end
		end
	end
	
	return idle
end



-- Read the mod settings and technology of the given force to decide what mode we're in
local function getAllowedMode(force)
	if settings_mode ~= "tech-unlock" then
		return settings_mode
	elseif force.technologies["adv-multiple-unit-train-control"] and force.technologies["adv-multiple-unit-train-control"].researched then
		return "advanced"
	elseif force.technologies["multiple-unit-train-control"] and force.technologies["multiple-unit-train-control"].researched then
		return "basic"
	else
		return "disabled"
	end
end


-- Process up to one valid train from the queue per tick
--   The queue prevents us from processing another train until we finish with the first one.
--   That way we don't process "intermediate" trains created while replacing a locomotive by the script.
local function ProcessTrainQueue()
	local idle = true
	local found_pairs = {}
	local upgrade_locos = {}
	
	if global.trains_in_queue then
		--game.print("ProcessTrainQueue has a train in the queue")
		while next(global.trains_in_queue) do
			local t = table.remove(global.trains_in_queue,1)
			if t and t.valid then
				local mode = getAllowedMode(t.carriages[1].force)
				if mode=="advanced" then
					found_pairs,upgrade_locos = processTrainWireless(t)
				elseif mode=="basic" then
					found_pairs,upgrade_locos = processTrainBasic(t)
				else
					-- Mod disabled, go through the process of reverting every engine
					found_pairs,upgrade_locos = processTrainPurge(t)
				end
				
				-- Add replacements to the replacement queue
				for _,entry in pairs(upgrade_locos) do
					table.insert(global.replacement_queue,entry)
				end
				
				-- Add pairs to the pair lists.  (pairs will need to be updated when the replacements are made)
				for _,entry in pairs(found_pairs) do
					addPairToGlobal(entry)
				end
				
				idle = false  -- Make sure OnTick stays enabled to process our queued replacements
				break
			end
		end
		
		
	
	end
	
	return idle
end


----------------------------------------------
------ EVENT HANDLING ---

--== ONTICK EVENT ==--
-- Process items queued up by other actions
-- Only one action allowed per tick
local function OnTick(event)
	local idle = true
	
	-- Replacing Locomotives has first priority
	idle = ProcessReplacementQueue()
	
	-- Processing new Trains has second priority
	if idle then
		idle = ProcessTrainQueue()
	end
	
	-- Balancing inventories has third priority
	if idle then
		idle = ProcessInventoryQueue()
	end
	
	if idle or ((not next(global.replacement_queue)) and 
	            (not next(global.trains_in_queue)) and 
				(not next(global.inventories_to_balance))) then
		-- All three queues are empty, unsubscribe from OnTick to save UPS
		--game.print("Turning off OnTick")
		script.on_event(defines.events.on_tick, nil)
	end
	
end

--== ON_TRAIN_CREATED EVENT ==--
-- Record every new train in global queue, so we can process them one at a time.
--   Many of these events will be triggered by our own replacements, and those
--   "intermediate" trains will be invalid by the time we pull them from the queue.
--   This is the desired behavior. 
local function OnTrainCreated(event)
	-- Event contains train, old_train_id_1, old_train_id_2
	
	-- These are a hack to make sure our global variables get created.
	if not global.trains_in_queue then
		global.trains_in_queue = {}
	end
	if not global.mu_pairs then
		global.mu_pairs = {}
	end
	if not global.replacement_queue then
		global.replacement_queue = {}
	end
	
	
	-- Add this train to the train processing queue
	table.insert(global.trains_in_queue,event.train)
	
	--game.print("Train " .. event.train.id .. " queued.")
	
	-- Set up the on_tick action to process trains
	script.on_event(defines.events.on_tick, OnTick)
	
end

--== ON_NTH_TICK EVENT ==--
-- Initiates balancing of fuel inventories in every MU consist
local function OnNthTick(event)
	if not global.inventories_to_balance then
		global.inventories_to_balance = {}
	end
	if global.mu_pairs and next(global.mu_pairs) then
		local minTicks = 0
	
	
		local n = #global.mu_pairs
		local done = false
		for i=1,n do
			entry = global.mu_pairs[i]
			if (entry[1] and entry[2] and entry[1].valid and entry[2].valid) then
				-- This pair is good, balance if not electric
				------ RET COMPATIBILITY
				if not global.ret_locos or not global.ret_locos[entry[1].name] then
					table.insert(global.inventories_to_balance, {entry[1].burner.inventory, entry[2].burner.inventory})
					minTicks = minTicks + 1
				end
				-------
			else
				-- This pair is not good
				global.mu_pairs[i] = nil
			end
		end
		local j=0
		for i=1,n do  -- Condense the list
			if global.mu_pairs[i] ~= nil then
				j = j+1
				global.mu_pairs[j] = global.mu_pairs[i]
			end
		end
		for i=j+1,n do
			global.mu_pairs[i] = nil
		end
			
		-- Set up the on_tick action to process trains
		--game.print("Nth tick starting OnTick")
		if next(global.inventories_to_balance) then
			script.on_event(defines.events.on_tick, OnTick)
			
			-- Update the Nth tick interval to make sure we have enough time to update all the trains
			local newVal = current_nth_tick
			if minTicks+10 > current_nth_tick then
				newVal = minTicks*2
			elseif minTicks < current_nth_tick / 2 then
				newVal = math.max(minTicks*2,settings_nth_tick)
			end
			if newVal ~= current_nth_tick then
				--game.print("Changing MU Control Nth Tick duration to " .. newVal)
				game.print({"debug-message.mu-changing-tick-message",newVal})
				current_nth_tick = newVal
				global.current_nth_tick = current_nth_tick
				script.on_nth_tick(nil)
				script.on_nth_tick(current_nth_tick, OnNthTick)
			end
		end
	end
end

--== ON_PLAYER_CONFIGURED_BLUEPRINT EVENT ==--
-- ID 70, fires when you select a blueprint to place
--== ON_PLAYER_SETUP_BLUEPRINT EVENT ==--
-- ID 68, fires when you select an area to make a blueprint or copy
local function OnPlayerSetupBlueprint(event)
	--game.print("MU Control handling Blueprint from ".. event.name .." event.")
	
	-- Get Blueprint from player (LuaItemStack object)
	-- If this is a Copy operation, BP is in cursor_stack
	-- If this is a Blueprint operation, BP is in blueprint_to_setup
	-- Need to use "valid_for_read" because "valid" returns true for empty LuaItemStack
	
	local item1 = game.get_player(event.player_index).blueprint_to_setup
	local item2 = game.get_player(event.player_index).cursor_stack
	if item1 and item1.valid_for_read==true then
		purgeBlueprint(item1)
	elseif item2 and item2.valid_for_read==true then
		purgeBlueprint(item2)
	end
end


--== ON_PLAYER_PIPETTE ==--
-- Fires when player presses 'Q'.  We need to sneakily grab the correct item from inventory if it exists,
--  or sneakily give the correct item in cheat mode.
local function OnPlayerPipette(event)
	--game.print("MUTC: OnPlayerPipette, cheat mode="..tostring(event.used_cheat_mode))
	local item = event.item
	if item and item.valid then
		--game.print("item: " .. item.name)
		if global.downgrade_pairs[item.name] then
			local player = game.players[event.player_index]
			local newName = global.downgrade_pairs[item.name]
			local cursor = player.cursor_stack
			local inventory = player.get_main_inventory()
			-- Check if the player got MU versions from inventory, and convert them
			if cursor.valid_for_read == true and event.used_cheat_mode == false then
				-- Huh, he actually had MU items.
				--game.print("Converting cursor to "..newName)
				cursor.set_stack({name=newName,count=cursor.count})
			else
				-- Check if the player could have gotten the right thing from inventory/cheat, otherwise clear the cursor
				--game.print("Looking for " .. newName .. " in inventory")
				local newItemStack = inventory.find_item_stack(newName)
				cursor.set_stack(newItemStack)
				if not cursor.valid_for_read then
					--game.print("Not found!")
					if player.cheat_mode==true then
						--game.print("Giving free " .. newName)
						cursor.set_stack({name=newName, count=game.item_prototypes[newName].stack_size})
					end
				else
					--game.print("Found!")
					inventory.remove(newItemStack)
				end
			end
		end
	end


end




---------
-- Enables the on_nth_tick event according to the mod setting value
--  Stores current interval in global.current_nth_tick
local function StartBalanceUpdates()
	global.current_nth_tick = settings_nth_tick
	current_nth_tick = global.current_nth_tick
	if current_nth_tick > 0 then
		--game.print("Enabling Nth Tick with setting " .. settings_nth_tick)
		script.on_nth_tick(nil)
		script.on_nth_tick(current_nth_tick, OnNthTick)
	else
		-- Value of zero disables fuel balancing
		--game.print("Disabling Nth Tick due to setting")
		script.on_nth_tick(nil)
		global.inventories_to_balance = {}
	end
end

-- Queues all existing trains for updating with new settings
local function QueueAllTrains()
	if not global.replacement_queue then
		global.replacement_queue = {}
	end
	for _, surface in pairs(game.surfaces) do
		local trains = surface.get_trains()
		for _,train in pairs(trains) do
			table.insert(global.trains_in_queue,train)
		end
	end
	script.on_event(defines.events.on_tick, OnTick)
end

---- Bootstrap ----
do
local function init_events()

	-- Subscribe to Blueprint activity always
	script.on_event({defines.events.on_player_setup_blueprint,defines.events.on_player_configured_blueprint}, OnPlayerSetupBlueprint)
	script.on_event(defines.events.on_player_pipette, OnPlayerPipette)

	-- Subscribe to On_Nth_Tick according to saved global setting
	current_nth_tick = global.current_nth_tick
	if not current_nth_tick then
		current_nth_tick = 0
	end
	
	-- Subscribe to On_Train_Created according to mod enabled setting
	if settings_mode ~= "disabled" then
		script.on_event(defines.events.on_train_created, OnTrainCreated)
		if current_nth_tick > 0 then
			script.on_nth_tick(current_nth_tick, OnNthTick)
		end
		
	else
		script.on_event(defines.events.on_train_created, nil)
		script.on_nth_tick(nil)
	end
	
	-- Set conditional OnTick event handler correctly on load, so we can sync with a multiplayer game.
	if (global.trains_in_queue and next(global.trains_in_queue)) or
	      (global.replacement_queue and next(global.replacement_queue)) or
	      (global.inventories_to_balance and next(global.inventories_to_balance)) then
		script.on_event(defines.events.on_tick, OnTick)
	end
	
end

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
	--game.print("in mod_settings_changed!")
	if event.setting == "multiple-unit-train-control-mode" then
		settings_mode = settings.global["multiple-unit-train-control-mode"].value
		if settings_mode ~= "disabled" then
			-- Scrub existing trains and add MU locomotives when necessary
			QueueAllTrains()
			
			-- if there were saved pairs, start the fuel balancer
			if global.mu_pairs and next(global.mu_pairs) then
				StartBalanceUpdates()
			end
			
			-- Enable or disable events based on setting state
			init_events()
		else
			-- Mod is disabled
			-- Revert the MU locomotives using the on_train_created and on_tick handlers
			QueueAllTrains()
			
			-- Clean globals
			global.mu_pairs = {}
			global.inventories_to_balance = {}
			
			-- Enable or disable events based on setting state
			init_events()
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
	--game.print("In on_init!")
	global.replacement_queue = {}
	global.trains_in_queue = {}
	global.mu_pairs = {}
	global.inventories_to_balance = {}
	InitEntityMaps()
	init_events()
end)

script.on_configuration_changed(function(data)
	--game.print("In on_configuration_changed!")
	global.replacement_queue = global.replacement_queue or {}
	global.trains_in_queue = global.trains_in_queue or {}
	global.mu_pairs = global.mu_pairs or {}
	global.inventories_to_balance = global.inventories_to_balance or {}
	InitEntityMaps()
	-- On config change, scrub the list of trains
	QueueAllTrains()
	StartBalanceUpdates()
	init_events()
end)
end
