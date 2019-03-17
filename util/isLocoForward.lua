--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: isLocoForward.lua
 * Description: Functions to search a train for specific rolling stock entities.
--]]


function isLocoForward(train,loco)
	-- Search the forward locomotive list to see if this one is forwards
	--game.print("received train "..train.id)
	if train.locomotives["front_movers"] then
		--game.print("searching among "..#train.locomotives["front_movers"].." front movers")
		for _,q in pairs(train.locomotives["front_movers"]) do
			if q == loco then
				return true
			end
		end
	end
	return false
end


return isLocoForward
