--[[ Copyright (c) 2020 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: balanceInventories.lua
 * Description: Equalizes the contents of two inventories whenever possible.
 *    Applies to all items types separately.
 *    Mixed inventories may not be balanced correctly if there are no empty slots.
 *    Last item will be repeatedly swapped between inventories until it is consumed.
--]]


local function balanceInventories(inventoryOne, inventoryTwo, roundUp)
	if inventoryOne and inventoryTwo and inventoryOne.valid and inventoryTwo.valid then
		local locoOneInventory = inventoryOne.get_contents()
		local locoTwoInventory = inventoryTwo.get_contents()
    local locoOneCount = inventoryOne.get_item_count()
    local locoTwoCount = inventoryTwo.get_item_count()
	  
		-- Find how many items to move in which direction
    local itemsToMove = (locoOneCount - locoTwoCount)/2
    -- If roundUp==true, round away from zero.  If roundup==false, round toward zero
    if (roundUp and itemsToMove > 0) or (not roundUp and itemsToMove < 0) then
      itemsToMove = math.ceil(itemsToMove)
    else
      itemsToMove = math.floor(itemsToMove)
    end
    
    if itemsToMove > 0 then
      -- Move from One to Two
      -- Try to move items until we have moved the correct number or run out of options
      for item_name,item_count in pairs(locoOneInventory) do
        local itemsMoved = inventoryTwo.insert({name=item_name, count=min(itemsToMove, item_count)})
        inventoryOne.remove({name=item_name, count=itemsMoved})
        itemsToMove = itemsToMove - itemsMoved
        if itemsToMove == 0 then
          break
        end
      end
      
    elseif itemsToMove < 0 then
		  -- Move from Two to One
      -- Try to move items until we have moved the correct number or run out of options
      for item_name,item_count in pairs(locoTwoInventory) do
        local itemsMoved = inventoryOne.insert({name=item_name, count=min(itemsToMove, item_count)})
        inventoryTwo.remove({name=item_name, count=itemsMoved})
        itemsToMove = itemsToMove - itemsMoved
        if itemsToMove == 0 then
          break
        end
      end
    
		end
	else
		game.print("MUTC Balancer ignoring invalid inventories")
	end
end

return balanceInventories
