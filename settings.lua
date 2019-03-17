--[[ Copyright (c) 2019 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: settings.lua
 * Description: Setting to control MU operation.
--]]

data:extend({
  {
    type = "bool-setting",
	name = "multiple-unit-train-control-enabled",
	order = "aa",
	setting_type = "runtime-global",
	default_value = true
  },
  {
    type = "int-setting",
	name = "multiple-unit-train-control-on_nth_tick",
	order = "aa",
	setting_type = "runtime-global",
	minimum_value = 0,
	default_value = 300
  },
})
