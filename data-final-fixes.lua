--[[ Copyright (c) 2022 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: data-final-fixes.lua
 * Description: Update fuel categories and grids for MU locomotives to match the originals
--]]

for mu_name,std_name in pairs(data.raw["mod-data"]["mutc-locomotive-data"].data.mu_map) do
  -- Update fuel category
  if data.raw.locomotive[std_name].burner then
    -- This MU has a regular loco with burner, copy fuel categories to MU version
    -- Link the fuel_categories table so it gets updated here even if the base changes later, no dependencies required!
    data.raw.locomotive[mu_name].burner.fuel_categories = data.raw.locomotive[std_name].burner.fuel_categories
  end

  -- Update grid assignment (or set to nil) to match base loco
  data.raw.locomotive[mu_name].equipment_grid = data.raw.locomotive[std_name].equipment_grid
end
