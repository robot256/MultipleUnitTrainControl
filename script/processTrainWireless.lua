



function processTrainWireless(t)

	local front_movers = t.locomotives["front_movers"]
	local back_movers = t.locomotives["back_movers"]
	
	-- We can convert locos paired anywhere in the train
	-- Don't bother mapping the train, just see if each loco in front_movers has a partner in back_movers
	-- Start with trying to map existing MUs to each other. If that doesn't work, we have to upgrade
	local found_pairs = {}
	local upgrade_locos = {}
	-- For every front_mover, look for its twin in back_movers
	for _,loco1 in pairs(front_movers) do
		local loco1_done = false
		if global.downgrade_pairs[loco1.name] then
			local mu_name = loco1.name
			local std_name = global.downgrade_pairs[mu_name]
			-- Found an MU, look for its twin as an MU first
			for _,loco2 in pairs(back_movers) do
				if loco2.name == mu_name then
					-- Potential twin, make sure it's not in a pair already
					local loco2_free = true
					for _,this_pair in pairs(found_pairs) do
						if this_pair[2] == loco2 then  -- (back_mover is always 2nd member of a pair)
							loco2_free = false
							break
						end
					end
					if loco2_free then
						-- Found an MU twin, they are already a pair
						table.insert(found_pairs,{loco1,loco2})
						loco1_done = true
						break
					end
				end
			end
			if not loco1_done then
				-- Didn't find an MU twin, look for a normal twin to this MU so we can upgrade it
				for _,loco2 in pairs(back_movers) do
					if loco2.name == std_name then
						-- Potential twin, make sure it's not in a pair already
						local loco2_free = true
						for _,this_pair in pairs(found_pairs) do
							if this_pair[2] == loco2 then  -- (back_mover is always 2nd member of a pair)
								loco2_free = false
								break
							end
						end
						if loco2_free then
							-- Found a normal twin, upgrade loco2
							table.insert(found_pairs,{loco1,loco2})
							table.insert(upgrade_locos,{loco2,mu_name})
							loco1_done = true
							break
						end
					end
				end
				
				if not loco1_done then
					-- Didn't find a twin to upgrade, have to downgrade this one :(
					table.insert(upgrade_locos,{loco1,std_name})
				end
			end
			
		elseif global.upgrade_pairs[loco1.name]
			local std_name = loco1.name
			local mu_name = global.upgrade_pairs[std_name]
			-- Found a normal, look for its twin as an MU first
			for _,loco2 in pairs(back_movers) do
				if loco2.name == mu_name then
					-- Potential twin, make sure it's not in a pair already
					local loco2_free = true
					for _,this_pair in pairs(found_pairs) do
						if this_pair[2] == loco2 then  -- (back_mover is always 2nd member of a pair)
							loco2_free = false
							break
						end
					end
					if loco2_free then
						-- Found an MU twin, upgrade loco1
						table.insert(found_pairs,{loco1,loco2})
						table.insert(upgrade_locos,{loco1,mu_name})
						loco1_done = true
						break
					end
				end
			end
			if not loco1_done then
				-- Didn't find an MU twin, look for a normal twin to this MU so we can upgrade it
				for _,loco2 in pairs(back_movers) do
					if loco2.name == std_name then
						-- Potential twin, make sure it's not in a pair already
						local loco2_free = true
						for _,this_pair in pairs(found_pairs) do
							if this_pair[2] == loco2 then  -- (back_mover is always 2nd member of a pair)
								loco2_free = false
								break
							end
						end
						if loco2_free then
							-- Found a normal twin, upgrade loco1 and loco2
							table.insert(found_pairs,{loco1,loco2})
							table.insert(upgrade_locos,{loco1,mu_name})
							table.insert(upgrade_locos,{loco2,mu_name})
							loco1_done = true
							break
						end
					end
				end
			end
		end
	end
	
	
	
	
	return found_pairs, upgrade_locos
end

return processTrainWireless

