--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: createMuLocoPrototype.lua
 * Description: Copies a locomotive prototype and creates the "-mu" version
 *   with twice as much power output.
--]]


function createMuLocoEntityPrototype(name, newName)
	-- Check that source exists
	if not data.raw["locomotive"][name] then
		error("locomotive " .. name .. " doesn't exist")
	end
	
	-- Copy source locomotive prototype
	local oldLoco = data.raw["locomotive"][name]
	local loco = table.deepcopy(oldLoco)
	
	-- Change name of prototype
	loco.name = newName
	-- Make this entity non-placeable (you're not allowed to have -mu items in your inventory)
	if(loco.flags["placeable-neutral"]) then
		loco.flags["placeable-neutral"] = nil
	end
	if(loco.flags["placeable-player"]) then
		loco.flags["placeable-player"] = nil
	end
	if(loco.flags["placeable-enemy"]) then
		loco.flags["placeable-enemy"] = nil
	end
	
	-- Make it so a normal locomotive can be pasted on this blueprint
	loco.additional_pastable_entities = {name}
	
	-- Disable blueprints (don't know how to make it put a normal locomotive in the blueprint instead
	--loco.allow_copy_paste = false  --This also prevents pressing 'Q' from retrieving the normal item from your inventory. Not sure how to fix that.
	
	-- Change the power level (string contains suffix "kW"). This also increases fuel consumption.
	local max_power = string.sub(loco.max_power,1,-3) * 2
	local power_suffix = string.sub(loco.max_power,-2,-1)
	loco.max_power = max_power .. power_suffix
	
	-- Change the reverse power modifier, because the other loco
	--   provides all the reverse power for this pair in both auto and manual.
	--   (But don't make it zero, because then you get stranded even in manual mode.)
	loco.reversing_power_modifier = 0.1
	
	-- Concatenate the localized name and description string of the source loco with our template.
	loco.localised_name = {'template.mu-name',{'entity-name.'..name}}
	loco.localised_description = {'template.mu-description',{'entity-description.'..name}}
	
	return loco
end

return createMuLocoEntityPrototype