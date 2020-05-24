--[[ Copyright (c) 2020 robot256 (MIT License)
 * Project: Multiple Unit Train Control
 * File: generate_all_mu.lua
 * Description: Procedurally generate MU Locomotives for any remaining locos that we have not addressed
--]]

local blacklist = {
-- YIR Industries Railways
  "y_loco_fs_steam_green",
  "yir_loco_sel_blue",
  "y_loco_steam_wt450",
  "y_loco_ses_std",
  "y_loco_ses_red",
-- YIR Railwas Addons
  "yir_mre044",
  "yir_loco_steam_wt580of",
  "yir_kr_green",
-- Laser Tank (MU is broken when 
--  "electric-vehicles-electric-locomotive",
}


local has_description = {
-- Base
  "locomotive",
-- Batteries Not Included
  "bni_electric-locomotive",
-- YIR American
  "yir_emdf7a_mn",
  "yir_emdf7b_mn",
  "yir_emdf7b_cr",
  "yir_emdf7a_cr",
  "yir_es44cr",
-- YIR Railways Addons
  --"yir_ns2200wr",
  --"yir_ns2200gg",
  "y_loco_diesel_620",
  "yir_usl",
  "yir_lsw_r790orange",
  "yir_lsw_r790red",
  "yir_lsw_840green",
  "y_loco_desw_blue",
-- YIR Uranium Locomotive
  "yir_atom_header",
  "yir_atom_mitte",
-- Yuoki Industries - Railways
  "yir_loco_del_bluegray",
  "y_loco_emd3000_white",
  "yir_loco_del_KR",
  "yir_loco_fut_red",
  "yir_loco_del_mk1400",
  "yir_loco_fesw_op",
  "y_loco_desw",
  "y_loco_desw_orange",
  "y_loco_desw_blue",
  "y_loco_emd1500black",
  "y_loco_emd1500blue",
  "y_loco_emd1500blue_v2",
  "y_loco_emd1500black_v2",
-- FARL
  "farl",
-- Industrial Revolution
  "electric-locomotive",
-- Nuclear Locomotive
  "nuclear-locomotive",
-- Train Overhaul
  "heavy-locomotive",
  "express-locomotive",
  "nuclear-locomotive",
-- X12 Nuclear Locomotive
  "x12-nuclear-locomotive-powered",
-- Schall Armoured Train
  "Schall-nuclear-locomotive",
  "Schall-armoured-locomotive",
-- Steam Locomotive
  "SteamTrains-locomotive",
-- Diesel locomotive
  "Diesel-Locomotive-fluid-locomotive",
-- Neocky's Trains
  "nt-train-electric",
  "nt-train-fusion",
  "nt-train-nuclear",
}




local mu_blacklist = {}
for _,name in pairs(blacklist) do
  mu_blacklist[name] = true
end

local mu_has_description = {}
for _,name in pairs(has_description) do
  mu_has_description[name] = true
end


local mu_make_new = {}

for name,loco in pairs(data.raw["locomotive"]) do
  local make_mu = true
  -- Check if this is a MU or if it already has a MU
  if mu_blacklist[name] then
    make_mu = false
  elseif string.find(name, "%-mu$") ~= nil then
    -- ends in MU, make sure regular loco exists. If not, then the vanilla loco ended with -mu, and the new one will be -mu-mu
    if data.raw["locomotive"][string.sub(name, 1, -4)] then
      -- This MU has a regular loco, do nothing
      make_mu = false
    end
  elseif data.raw["locomotive"][name.."-mu"] then
    -- Already made an MU of this loco
    make_mu = false
  end
  
  if make_mu then
    -- no MU of this loco, make a new one assuming it is basic
    table.insert(mu_make_new, name)
  end
end

for _,name in pairs(mu_make_new) do
  createMuLoco{std=name, mu=name.."-mu", hasDescription=mu_has_description[name]}
end
