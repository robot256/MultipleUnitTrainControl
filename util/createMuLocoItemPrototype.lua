--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: createMuLocoItemPrototype.lua
 * Description: Copies a locomotive item and creates the "-mu" version with:
 *   - MU localization text is added to name and description fields.
--]]


function createMuLocoItemPrototype(item_type,name,newName)
	-- Check that source exists
	if not data.raw[item_type][name] then
		error("locomotive item " .. name .. " doesn't exist")
	end
	
	-- Copy source locomotive prototype
	local newItem = copyPrototype(item_type, name, newName)
	
	newItem.order = "a[train-system]-fz[locomotive-mu]" -- this doesn't get copied??
	
	-- Fix the localization
	newItem.localised_name = {'template.mu-name',{'entity-name.'..name}}
	newItem.localised_description = {'template.mu-item-description',{'entity-name.'..name}}
	
	return newItem
end
return createMuLocoItemPrototype