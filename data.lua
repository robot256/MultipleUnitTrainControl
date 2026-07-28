--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: data.lua
 * Description: Add the MU technology
--]]

require ("prototypes.technology")



-- Create mod-data prototype to store locomotive MU mappings
-- Format:
-- data.mu_map :: dictionary[ string(locomotive-name) -> {mu_name = string(locomotive-mu-name), alt_names = array[string(locomotive-alt-name)]?, fuel_item = string(fuel-item-mu)?}

data:extend{
  {
    type = "mod-data",
    name = "mutc-locomotive-data",
    data = {
      mu_map = {},
    }
  }
}
