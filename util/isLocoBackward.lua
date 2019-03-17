--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: isLocoBackward.lua
 * Description: Functions to search a train for specific rolling stock entities.
--]]


function isLocoBackward(train,loco)
	-- Search the forward locomotive list to see if this one is backwards
	--game.print("received train "..train.id)
	if train.locomotives["back_movers"] then
		for _,q in pairs(train.locomotives["back_movers"]) do
			if q == loco then
				return true
			end
		end
	end
	return false
end

return isLocoBackward
