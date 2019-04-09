--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: mapPipette.lua
 * Description: Handler for on_player_pipette.
 *    When player uses pipette on a non-craftable entity, this function will replace it with the craftable entity if possible.
 *  event: Event object passed to  event.
 *  map:   Dictionary mapping non-craftable entity names to craftable entity names.
 --]]


function mapPipette(event,map)
	local item = event.item
	if item and item.valid then
		if map[item.name] then
			local player = game.players[event.player_index]
			local newName = map[item.name]
			local cursor = player.cursor_stack
			local inventory = player.get_main_inventory()
			-- Check if the player got MU versions from inventory, and convert them
			if cursor.valid_for_read == true and event.used_cheat_mode == false then
				-- Huh, he actually had MU items.
				cursor.set_stack({name=newName,count=cursor.count})
			else
				-- Check if the player could have gotten the right thing from inventory/cheat, otherwise clear the cursor
				local newItemStack = inventory.find_item_stack(newName)
				cursor.set_stack(newItemStack)
				if not cursor.valid_for_read then
					if player.cheat_mode==true then
						cursor.set_stack({name=newName, count=game.item_prototypes[newName].stack_size})
					end
				else
					inventory.remove(newItemStack)
				end
			end
		end
	end
end

return mapPipette
