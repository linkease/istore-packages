--[[
LuCI - Lua Configuration Interface
Copyright 2021 jjm2473
]]--

require "luci.util"
module("luci.controller.admin.cpufreq",package.seeall)

function index()

  entry({"admin", "system", "cpufreq"}, alias("admin", "system", "cpufreq", "main"), _("CPU Tuning"), 59)
  entry({"admin", "system", "cpufreq", "main"}, cbi("cpufreq/main"), nil).leaf = true
  entry({"admin", "system", "cpufreq", "get_cpu_info"}, call("get_cpu_info"), nil).leaf = true
end

function get_cpu_info()
  local fs = require "nixio.fs"
  -- fs.readfile("/sys/devices/system/cpu/cpufreq/policy0/scaling_governor")
  -- local util = require "luci.util"; util.split(fs.readfile("/sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors"), " ")
  local freq = tonumber(fs.readfile("/sys/devices/system/cpu/cpufreq/policy0/cpuinfo_cur_freq")) / 1000; -- MHz
  local temp = tonumber(fs.readfile("/sys/class/thermal/thermal_zone0/temp")) / 1000; -- ˚C
  luci.http.status(200, "ok")
  luci.http.prepare_content("application/json")
  luci.http.write_json({freq=freq, temp=temp})
end
