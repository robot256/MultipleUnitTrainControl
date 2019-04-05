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
	local player_driving = loco.get_driver()
	
	-- Save equipment grid contents
	local grid_equipment = saveGrid(loco.grid)
	
	-- Save item requests left over from a blueprint
	local item_requests = saveItemRequestProxy(loco)
	
	-- Save the burner progress
	local saved_burner = saveBurner(loco.burner)
	
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
	
	-- Destroy the old Locomotive so we have space to make the new one
	loco.destroy({raise_destroy=true})
	
	-- Create the new locomotive in the same spot and orientation
	local newLoco = surface.create_entity{name=newName, position=position, direction=newDirection, force=force}
	
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
	restoreBurner(newLoco.burner, saved_burner)
	
	-- Restore the equipment grid
	if grid_equipment and newLoco.grid and newLoco.grid.valid then
		restoreGrid(newLoco.grid, grid_equipment)
	end
	
	-- Restore the player driving
	if player_driving then
		newLoco.set_driver(player_driving)
	end
	
	-- Restore the train schedule and mode
	newLoco.train.schedule = train_schedule
	
	-- After all that, fire an event so other scripts can reconnect to it
	script.raise_event(defines.events.script_raised_built, {entity = newLoco})
				
	
	--game.print("Finished replacing. Used direction "..newDirection..", new orientation: " .. newLoco.orientation)
	return newLoco
end

return replaceLocomotive
