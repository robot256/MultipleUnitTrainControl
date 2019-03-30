--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: replaceLocomotive.lua
 * Description: Replaces one Locomotive Entity with a new one of a different entity-name.
 *    Preserves as many properties of the original as possible.
 *    Currently does not support preserving equipment grids.
--]]


function replaceLocomotive(loco, newName)

	
	-- Save basic parameters
	local position = loco.position
	local force = loco.force
	local surface = loco.surface
	local orientation = loco.orientation
	local backer_name = loco.backer_name
	local color = loco.color
	local health = loco.health
	local to_be_deconstructed = loco.to_be_deconstructed(force)
	
	-- Save equipment grid contents
	local grid_equipment = nil
	if loco.grid and loco.grid.valid then
		grid_equipment = saveGrid(loco.grid)
	end
	
	-- Save item requests left over from a blueprint
	local item_requests = saveItemRequestProxy(loco)
	
	-- Save the burner progress
	local burner_heat = loco.burner.heat
	local burner_remaining_burning_fuel = loco.burner.remaining_burning_fuel
	local burner_currently_burning = loco.burner.currently_burning
	
	-- Save the fuel inventory
	local burner_inventory = loco.burner.inventory.get_contents()
	if ( loco.burner.burnt_result_inventory.valid ) then
		local burner_burnt_result_inventory = loco.burner.burnt_result_inventory.get_contents()
	end
	
	-- Adjust the direction of the new locomotive
	-- This mapping was determined by brute force because direction and orientation for trains are stupid.
	local newDirection = 0
	if orientation > 0 and orientation <= 0.5 then
		newDirection = 2
	end
	
	-- Save the train schedule.  If we are replacing a lone MU with a regular loco, the train schedule will be lost when we delete it.
	local train_schedule = loco.train.schedule
	
	-- Save its coupling state.  By default, created locos couple to everything nearby, which we have to undo
	--   if we're replacing after intentional uncoupling.
	local disconnected_back = loco.disconnect_rolling_stock(defines.rail_direction.back)
	local disconnected_front = loco.disconnect_rolling_stock(defines.rail_direction.front)
	
	-----------
	-- RET Compatibility
	if global.ret_locos and global.ret_locos[newName] then
		remote.call("realistic_electric_trains", "unregister_locomotive", loco)
	end
	-----------
	
	-- Destroy the old Locomotive so we have space to make the new one
	loco.destroy({raise_destroy=true})
	
	-- Create the new locomotive in the same spot and orientation
	local newLoco = surface.create_entity{name=newName, position=position, direction=newDirection, force=force, raise_built=true}
	
	-- Restore coupling state
	if not disconnected_back then
		newLoco.disconnect_rolling_stock(defines.rail_direction.back)
	end
	if not disconnected_front then
		newLoco.disconnect_rolling_stock(defines.rail_direction.front)
	end
	
	
	-- Restore parameters
	newLoco.backer_name = backer_name
	if color then   -- color is nil if you never changed it!
		newLoco.color = color 
	end
	newLoco.health = health
	if to_be_deconstructed == true then
		newLoco.order_deconstruction(force)
	end
	
	-- Restore item_request_proxy by creating a new one
	if item_requests then
		newProxy = surface.create_entity{name="item-request-proxy", position=position, force=force, target=newLoco, modules=item_requests}
	end
	
	-- Restore the partially-used burner fuel
	newLoco.burner.currently_burning = burner_currently_burning
	newLoco.burner.heat = burner_heat
	newLoco.burner.remaining_burning_fuel = burner_remaining_burning_fuel
	
	-----------
	-- RET Compatibility
	if global.ret_locos and global.ret_locos[newName] then
		local prototype = newLoco.prototype
		local efficiency_modifier = 1.05
		local ticks_per_update = remote.call("realistic_electric_trains","get_ticks_per_update")
		if prototype.burner_prototype.effectivity < 1 then
			efficiency_modifier = efficiency_modifier / prototype.burner_prototype.effectivity
		end
		local ret_transfer = prototype.max_energy_usage * efficiency_modifier * ticks_per_update
		remote.call("realistic_electric_trains", "register_locomotive", newLoco, {item=global.ret_locos[newName], transfer=ret_transfer})
	end
	-----------
	
	-- Translate the inventory results so we can insert the stacks.
	for k,v in pairs(burner_inventory) do
		--game.print("Inserting fuel " .. k.." = "..v)
		newLoco.burner.inventory.insert({name=k, count=v})
	end
	if ( burner_burnt_result_inventory ) then
		for k,v in pairs(burner_burnt_result_inventory) do
			--game.print("Inserting burnt fuel " .. k.." = "..v)
			newLoco.burner.burnt_result_inventory.insert({name=k, count=v})
		end
	end
	
	-- Restore the equipment grid
	if grid_equipment and newLoco.grid and newLoco.grid.valid then
		restoreGrid(newLoco.grid, grid_equipment)
	end
	
	-- Restore the train schedule and mode
	newLoco.train.schedule = train_schedule
	
	
	
	--game.print("Finished replacing. Used direction "..newDirection..", new orientation: " .. newLoco.orientation)
	return newLoco
end

return replaceLocomotive
