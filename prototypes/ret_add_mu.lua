--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: ret_add_mu.lua
 * Description: Integration with Realistic Electric Trains
--]]

if mods["Realistic_Electric_Trains"] then

	-- Generate an MU version of the Electric and Electric Mk2 Locomotives
	
	local electric_loco = copyPrototype("item", "ret-electric-locomotive", "ret-electric-locomotive-mu")
	electric_loco.order = "a[train-system]-fc[locomotive]"
	electric_loco.localised_name = {'template.mu-name',{'entity-name.ret-electric-locomotive'}}
	electric_loco.localised_description = {'template.mu-item-description',{'entity-name.ret-electric-locomotive'}}
	
	local electricMk2_loco = copyPrototype("item", "ret-electric-locomotive-mk2", "ret-electric-locomotive-mk2-mu")
	electricMk2_loco.order = "a[train-system]-fc[locomotive]"
	electricMk2_loco.localised_name = {'template.mu-name',{'entity-name.ret-electric-locomotive-mk2'}}
	electricMk2_loco.localised_description = {'template.mu-item-description',{'entity-name.ret-electric-locomotive-mk2'}}
	
	data:extend({electric_loco,
				electricMk2_loco})
	
	
	local electricMu = createMuLocoPrototype("ret-electric-locomotive")
	local electricMk2Mu = createMuLocoPrototype("ret-electric-locomotive-mk2")
	
	-- Add all the MU versions to the data table
	data:extend({electricMu,
				electricMk2Mu})
end

