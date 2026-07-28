--[[ Copyright (c) 2020 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: createMuLoco.lua
 * Description: Creates new prototypes for a burner-type MU locomotive version.
 * Arguments:
 *  std= entity name string of the standard version
 *  mu= entity name string of the mu version to be created
 *  power_multiplier= power buff to multiply, defaults to 2
 *  fuel_item= item name string of Realistic Electric Trains dummy fuel item used by the standard version
--]]


local flib = require('__flib__.data-util')

-- Copied from Optera's Train Overhaul, because their library is deprecated now
local function multiply_energy_value(energy_string, factor)
  if type(energy_string) == "string" then
    local value, unit = flib.get_energy_value(energy_string)
    if value then
      value = value * factor
      return value..unit
    end
  end
  return ""
end

local icon_overlay = { { icon = "__MultipleUnitTrainControl__/graphics/icons/mu-overlay.png", icon_size = 32, tint = {r=255, g=255, b=0, a=196} } }

local function createMuLocoItemPrototype(name,newName)
  local item = data.raw["item-with-entity-data"][name]
  if not item then
    item = data.raw["item"][name]
  end
  if not item then
    log("Can't find item prototype for \""..name.."\"")
    return nil
  end
  -- Copy source locomotive prototype
  local newItem = flib.copy_prototype(item, newName)
  
  -- Make the new icon
  newItem.icons = flib.create_icons(newItem,icon_overlay) or icon_overlay
  newItem.icon = nil
  
  -- Fix the localization
  newItem.localised_name = {'template.mu-name',{'entity-name.'..name}}
  newItem.localised_description = {'template.mu-item-description',{'entity-name.'..name}}
  
  -- Make the item hidden
  newItem.hidden = true
  
  return newItem
end

local function createMuDummyFuelItem(oldFuel, newFuel, power_multiplier)
	power_multiplier = power_multiplier or 2
	
	-- Generate dummy fuel items for base locos, because they are sized based on power consumption and we don't balance burner heat between pairs
	local dummy_fuel_mu = flib.copy_prototype(data.raw["item"][oldFuel],newFuel)
	
	-- Change the power level (string contains suffix "kW"). This also increases fuel consumption.
	dummy_fuel_mu.fuel_value = multiply_energy_value(dummy_fuel_mu.fuel_value, power_multiplier)
	
	return dummy_fuel_mu
end

local function createMuLocoEntityPrototype(name, newName, newIcons, power_multiplier)
  -- Copy source locomotive prototype
  local oldLoco = data.raw["locomotive"][name]
  
  if not oldLoco then
    log("Can't find entity prototype for \""..name.."\"")
    return nil
  end
  
  local loco = table.deepcopy(oldLoco)
  
  -- Change name of prototype
  loco.name = newName
  loco.icons = newIcons
  loco.icon = nil
  --loco.hidden = true -- Make *entity* visible so you can select it separately in upgrade planner
  
  loco.factoriopedia_alternative = name
  loco.deconstruction_alternative = name
  loco.fast_replaceable_group = oldLoco.fast_replaceable_group or name
  loco.custom_tooltip_fields = loco.custom_tooltip_fields or {}
  table.insert(loco.custom_tooltip_fields, {name="Base power", value=oldLoco.max_power})
  
  -- Make it so bots can revive ghosts with the normal item and pipette works like magic
  loco.placeable_by = loco.placeable_by or {item=name, count=1}
  
  -- Change the power level (string contains suffix "kW"). This also increases fuel consumption.
  loco.max_power = multiply_energy_value(loco.max_power, power_multiplier)
  
  -- Concatenate the localized name and description string of the source loco with our template.
  if loco.localised_name then
    -- Original mod already set dynamic localised name, use it in our template
    loco.localised_name = {'template.mu-name',table.deepcopy(loco.localised_name)}
  else
    -- Use original mod's name from locale file
    loco.localised_name = {'template.mu-name',{'entity-name.'..name}}
  end
  
  if loco.localised_description then
    -- Original mod already set dynamic localised description, use it in our template
    loco.localised_description = {'template.mu-description',table.deepcopy(loco.localised_description)}
  else
    -- Use fallback group to append our description to an existing one
    loco.localised_description = {"?", {"",{"entity-description."..name},"\n",{'template.mu-description'}},
                                       {"",{"item-description."..name},"\n",{'template.mu-description'}},
                                       {'template.mu-description'}}
  end
  
  return loco
end



local function createMuLoco(arg)
	local oldName = arg.std
	local newName = arg.mu
	local power_multiplier = arg.power_multiplier or 2
	local fuel_item = arg.fuel_item
  
  log("Creating locomotive \""..newName.."\"")
	
	-- Check that source exists
	if not data.raw["locomotive"][oldName] then
		log("MUTC Prototype Maker: locomotive " .. oldName .. " doesn't exist")
    return
	end
	
	-- RET fuel compatibility: create higher-energy fuel item
	local mu_fuel_item_name
  local mu_fuel_item
	if fuel_item then
		local mu_fuel_item = createMuDummyFuelItem(fuel_item, fuel_item.."-mu", power_multiplier)
		mu_fuel_item_name = mu_fuel_item.name
	end
	
  -- Create MU Loco Item and Entity
  local mu_item = createMuLocoItemPrototype(oldName, newName)
  local mu_entity = mu_item and createMuLocoEntityPrototype(oldName, newName, mu_item.icons, power_multiplier)
  if mu_item and mu_entity then
    data:extend{ mu_item, mu_entity, mu_fuel_item }
    data.raw["mod-data"]["mutc-locomotive-data"].data.mu_map[oldName] = {mu_name = newName, alt_names = arg.alt_names, fuel_item = mu_fuel_item_name}
  end
end

return createMuLoco
