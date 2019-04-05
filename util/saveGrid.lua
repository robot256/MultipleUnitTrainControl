--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: saveGrid.lua
 * Description: Saves the contents of an equipment grid.
 *    Includes energy, shield, and burner equipment properties.
--]]


function saveGrid(grid)
	if grid and grid.valid then
		gridContents = {}
		for _,v in pairs(grid.equipment) do
			local item = {name=v.name,position={x=v.position.x,y=v.position.y}}
			local burner = saveBurner(v.burner)
			table.insert(gridContents,{item=item,energy=v.energy,shield=v.shield,burner=burner})
		end
		return gridContents
	else
		return nil
	end
end

return saveGrid
