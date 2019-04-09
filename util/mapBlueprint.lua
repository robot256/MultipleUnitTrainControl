--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: mapBlueprint.lua
 * Description: Handler for on_player_setup_blueprint and on_player_configured_blueprint.
 *    When player creates or edits a blueprint with a non-craftable entity, 
 *    this function will replace it with the craftable entity if possible.
 *  event: Event parameter object.
 *  map:   Dictionary mapping non-craftable entity names to craftable entity names.
 --]]
 
 

function purgeBlueprint(bp,map)
	-- Get Entity table from blueprint
	local entities = bp.get_blueprint_entities()
	-- Find any downgradable items and downgrade them
	if entities and next(entities) then
		for _,e in pairs(entities) do
			if map[e.name] then
				e.name = map[e.name]
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
				if map[i.signal.name] then
					i.signal.name = map[i.signal.name]
				end
			end
		end
		-- Write tables back to the blueprint
		bp.blueprint_icons = icons
	end
end


function mapBlueprint(event,map)
	-- Get Blueprint from player (LuaItemStack object)
	-- If this is a Copy operation, BP is in cursor_stack
	-- If this is a Blueprint operation, BP is in blueprint_to_setup
	-- Need to use "valid_for_read" because "valid" returns true for empty LuaItemStack in cursor
	
	local item1 = game.get_player(event.player_index).blueprint_to_setup
	local item2 = game.get_player(event.player_index).cursor_stack
	if item1 and item1.valid_for_read==true then
		purgeBlueprint(item1,map)
	elseif item2 and item2.valid_for_read==true and item2.is_blueprint==true then
		purgeBlueprint(item2,map)
	end
	
end

return purgeBlueprint,mapBlueprint
