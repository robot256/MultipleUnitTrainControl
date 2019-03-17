--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: to_add_mu.lua
 * Description: Integration with Optera's Train & Fuel Overhaul
--]]


if mods["TrainOverhaul"] then

	-- Generate an MU version of the Heavy, Express, and Nuclear Locomotives
	
	local heavy_loco = copyPrototype("item-with-entity-data", "heavy-locomotive", "heavy-locomotive-mu")
	heavy_loco.order = "a[train-system]-fc[locomotive]"
	heavy_loco.localised_name = {'template.mu-name',{'entity-name.heavy-locomotive'}}
	heavy_loco.localised_description = {'template.mu-item-description',{'entity-name.heavy-locomotive'}}
	
	local express_loco = copyPrototype("item-with-entity-data", "express-locomotive", "express-locomotive-mu")
	express_loco.order = "a[train-system]-fc[locomotive]"
	express_loco.localised_name = {'template.mu-name',{'entity-name.express-locomotive'}}
	express_loco.localised_description = {'template.mu-item-description',{'entity-name.express-locomotive'}}
	
	local nuclear_loco = copyPrototype("item-with-entity-data", "nuclear-locomotive", "nuclear-locomotive-mu")
	nuclear_loco.order = "a[train-system]-fc[locomotive]"
	nuclear_loco.localised_name = {'template.mu-name',{'entity-name.nuclear-locomotive'}}
	nuclear_loco.localised_description = {'template.mu-item-description',{'entity-name.nuclear-locomotive'}}
	


	data:extend({heavy_loco,
				express_loco,
				nuclear_loco})

	
	local heavyMu = createMuLocoPrototype("heavy-locomotive")
	local expressMu = createMuLocoPrototype("express-locomotive")
	local nuclearMu = createMuLocoPrototype("nuclear-locomotive")

	-- Add all the MU versions to the data table
	data:extend({heavyMu,
				expressMu,
				nuclearMu})
end
