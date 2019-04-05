--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: restoreGrid.lua
 * Description: Restores the contents of an equipment grid that was saved by saveGrid.lua.
--]]


function restoreGrid(grid,savedItems)
	for _,v in pairs(savedItems) do
		local e = grid.put(v.item)
		if v.energy then
			e.energy = v.energy
		end
		if v.shield and v.shield > 0 then
			e.shield = v.shield
		end
		if v.burner then
			restoreBurner(e.burner,v.burner)
		end
	end
end

return restoreGrid
