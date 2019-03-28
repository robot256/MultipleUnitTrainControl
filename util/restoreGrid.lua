--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: saveGrid.lua
 * Description: Saves the contents of an equipment grid.
 *    Table format is {name,position} so that it can be easily restored.
--]]


function restoreGrid(grid,savedItems)
	for _,v in pairs(savedItems) do
		grid.put(v)
	end
end

return restoreGrid
