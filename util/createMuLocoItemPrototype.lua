--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: createMuLocoPrototype.lua
 * Description: Copies a locomotive prototype and creates the "-mu" version
 *   with twice as much power output.
--]]


function createMuLocoItemPrototype(item_type,name,newName)
	-- Check that source exists
	if not data.raw[item_type][name] then
		error("locomotive item " .. name .. " doesn't exist")
	end
	
	-- Copy source locomotive prototype
	local newItem = copyPrototype(item_type, name, newName)
	
	newItem.order = "a[train-system]-fc[locomotive]" -- this doesn't get copied??
	
	-- Fix the localization
	newItem.localised_name = {'template.mu-name',{'entity-name.'..name}}
	newItem.localised_description = {'template.mu-item-description',{'entity-name.'..name}}
	
	return newItem
end
return createMuLocoItemPrototype