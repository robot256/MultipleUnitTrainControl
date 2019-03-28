--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: saveGrid.lua
 * Description: Saves the contents of an equipment grid.
 *    Table format is {name,position} so that it can be easily restored.
--]]


function saveGrid(grid)
	gridContents = {}
	for _,v in pairs(grid.equipment) do
		table.insert(gridContents,{name=v.name,position={x=v.position.x,y=v.position.y}})
	end
    return gridContents
end

return saveGrid
