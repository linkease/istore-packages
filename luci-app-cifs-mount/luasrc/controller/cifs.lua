
module("luci.controller.cifs", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/cifs") then
		return
	end
	
	entry({"admin", "services", "cifs"}, cbi("cifs"), _("Mount NetShare")).dependent = true
end
