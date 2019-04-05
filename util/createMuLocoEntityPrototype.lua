--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: createMuLocoEntityPrototype.lua
 * Description: Copies a locomotive entity prototype and creates the "-mu" version with:
 *    - max_power is double the standard version.
 *    - reversing_power_modifier is set to 0.1.
 *    - MU localization text is added to name and description fields.
--]]


function createMuLocoEntityPrototype(name, newName, has_description, power_multiplier)
	-- Copy source locomotive prototype
	local oldLoco = data.raw["locomotive"][name]
	local loco = table.deepcopy(oldLoco)
	
	-- Change name of prototype
	loco.name = newName
	-- Make this entity non-placeable (you're not allowed to have -mu items in your inventory), doesn't really work?
	if(loco.flags["placeable-neutral"]) then
		loco.flags["placeable-neutral"] = nil
	end
	if(loco.flags["placeable-player"]) then
		loco.flags["placeable-player"] = nil
	end
	if(loco.flags["placeable-enemy"]) then
		loco.flags["placeable-enemy"] = nil
	end
	
	-- Make it so a normal locomotive can be pasted on this blueprint, doesn't really work?
	loco.additional_pastable_entities = {name}
	
	-- Disable blueprints (don't know how to make it put a normal locomotive in the blueprint instead
	--loco.allow_copy_paste = false  --This also prevents pressing 'Q' from retrieving the normal item from your inventory. Not sure how to fix that.
	
	-- Change the power level (string contains suffix "kW"). This also increases fuel consumption.
	local max_power = string.sub(loco.max_power,1,-3) * power_multiplier
	local power_suffix = string.sub(loco.max_power,-2,-1)
	loco.max_power = max_power .. power_suffix
	
	-- Concatenate the localized name and description string of the source loco with our template.
	loco.localised_name = {'template.mu-name',{'entity-name.'..name}}
	if has_description==true then
		loco.localised_description = {'template.mu-description',{'entity-description.'..name}}
	else
		loco.localised_description = {'template.plain-mu-description'}
	end
	return loco
end

return createMuLocoEntityPrototype
