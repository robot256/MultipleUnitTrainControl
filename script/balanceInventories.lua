--[[ Copyright (c) 2020 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: balanceInventories.lua
 * Description: Equalizes the contents of two inventories whenever possible.
 *    Applies to all items types separately.
 *    Mixed inventories may not be balanced correctly if there are no empty slots.
 *    Last item will be repeatedly swapped between inventories until it is consumed.
--]]


function balanceInventories(inventoryOne, inventoryTwo)
	if inventoryOne and inventoryTwo and inventoryOne.valid and inventoryTwo.valid then
		local locoOneInventory = inventoryOne.get_contents()
		local locoTwoInventory = inventoryTwo.get_contents()
	  
	  -- loop for each item in locoTwo, add it to locoOne if it's not already there
		for k,v in pairs(locoTwoInventory) do
			if not locoOneInventory[k] then
				locoOneInventory[k] = 0
			end
		end
	  
		-- loop over items in locoOne and locoTwo
		for k,v in pairs(locoOneInventory) do
			if not locoTwoInventory[k] then
			  locoTwoInventory[k] = 0
			end
      
      local itemsToMove = (locoOneInventory[k] - locoTwoInventory[k])/2
			if itemsToMove > 0 then
				-- locoOne has more items. Round up to continuously swap the odd item
				local itemsMoved = inventoryTwo.insert({name=k, count=math.ceil(itemsToMove)})
				if itemsMoved > 0 then
					inventoryOne.remove({name=k, count=itemsMoved})  -- Remove what we actually inserted
				end
			elseif itemsToMove < 0 then
				-- locoTwo has more items. Round up to continuously swap the odd item
				local itemsMoved = inventoryOne.insert({name=k, count=math.ceil(-1*itemsToMove)})
				if itemsMoved > 0 then
					inventoryTwo.remove({name=k, count=itemsMoved})  -- Remove what we actually inserted
				end
			end
		end
	else
		game.print("MUTC Balancer ignoring invalid inventories")
	end
end

return balanceInventories
