module("luci.controller.nextcloud", package.seeall)

function index()
	
	entry({'admin', 'services', 'nextcloud'}, alias('admin', 'services', 'nextcloud', 'client'), _('nextcloud'), 10).dependent = true -- 首页
	entry({"admin", "services", "nextcloud",'client'}, cbi("nextcloud/status", {hideresetbtn=true, hidesavebtn=true}), _("nextcloud"), 20).leaf = true
    entry({'admin', 'services', 'nextcloud', 'script'}, form('nextcloud/script'), _('Script'), 20).leaf = true -- 直接配置脚本

	entry({"admin", "services", "nextcloud","status"}, call("container_status"))
	entry({"admin", "services", "nextcloud","stop"}, call("stop_container"))
	entry({"admin", "services", "nextcloud","start"}, call("start_container"))
	entry({"admin", "services", "nextcloud","install"}, call("install_container"))
	entry({"admin", "services", "nextcloud","uninstall"}, call("uninstall_container"))
end

local sys  = require "luci.sys"
local uci  = require "luci.model.uci".cursor()
local keyword  = "nextcloud"
local util  = require("luci.util")

function container_status()
	local docker_path = util.exec("which docker")
	local docker_server_version = util.exec("docker info | grep 'Server Version'")
	local docker_install = (string.len(docker_path) > 0)
	local docker_start = (string.len(docker_server_version) > 0)
	local port = tonumber(uci:get_first(keyword, keyword, "port"))
	local container_id = util.trim(util.exec("docker ps -aqf'name='"..keyword.."''"))
	local container_install = (string.len(container_id) > 0)
	local container_running = (sys.call("docker ps | grep '"..container_id.."' >/dev/null") == 0)

	local status = {
		docker_install = docker_install,
		docker_start = docker_start,
		container_id = container_id,
		container_install = container_install,
		container_running = container_running,
		container_port = (port or 8080),
	}

	luci.http.prepare_content("application/json")
	luci.http.write_json(status)
	return status
end

function stop_container()
	local status = container_status()
	local container_id = status.container_id
	util.exec("docker stop '"..container_id.."'")
end

function start_container()
	local status = container_status()
	local container_id = status.container_id
	util.exec("docker start '"..container_id.."'")
end

function install_container()
	luci.sys.call('sh /usr/share/nextcloud/install.sh')
	container_status()
end

function uninstall_container()
	local status = container_status()
	local container_id = status.container_id
	util.exec("docker container rm '"..container_id.."'")
end

-- 总结：
-- docker是否安装
-- 容器是否安装
-- 缺少在lua和htm中运行命令的方法
-- 获取容器id docker ps -aqf'name=nextcloud'
-- 启动容器 docker start 78a8455e6d38
-- 停止容器 docker stop 78a8455e6d38


--[[
todo
网络请求提示框
 --]]