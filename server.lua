-- server module.
-----------------------------------------------------------
local Utils  =  require("utils")
local Cjson =  require("cjson")
local Coding = require("coding")
local Db =  require("db")

-----------------------------------------------------------
local Server = {}

-----------------------------------------------------------
-- const define.
-----------------------------------------------------------
-----------------------------------------------------------
-- Add new appinfo.
-----------------------------------------------------------
function Server:newappinfo(request)

	-- app 名称
	local _appname = request.appname	

	local val = Utils:db_hget(Db.AppName_AppId_Map,_appname)

	if val ~= nil  then
		return 10001,""
	end

	-- app appid   
	local appid = Db:newAppId()
	-- app secret
	local secret = Db:newSecret(_appname)
	-- app 默认版本
	local version = "0.0.0.1"

	-- 保存 appname-appid 映射关系
	Utils:db_hset(Db.AppName_AppId_Map,_appname,appid)
	-- 保存 app 签名秘钥
	Utils:db_set(Db:getAppSecretById(appid),secret)
	-- 保存 app 初始版本
	Utils:db_set(Db:getAppVersionById(appid),version)

	local response = {}

	response.appid = appid
	response.appname = _appname
	response.secret = secret
	response.version = version

	return 200,Cjson.encode(response)

end

-----------------------------------------------------------
-- Add new app server.
-----------------------------------------------------------
function Server:addAppServer(request)

	local _appid = request.appid

	local _server_name = request.name
	local _server_host = request.host
	local _server_port = request.port
	local _server_version = request.version

	local serverid = Db:newServerIdByAppId(_appid)

	Utils:db_set(Db:getServerNameByAppIdAndServerId(_appid,serverid),_server_name)
	Utils:db_set(Db:getServerHostByAppIdAndServerId(_appid,serverid),_server_host)
	Utils:db_set(Db:getServerPortByAppIdAndServerId(_appid,serverid),_server_port)
	Utils:db_set(Db:getServerVersionByAppIdAndServerId(_appid,serverid),_server_version)

	--写入当前app的当前服务器的在线人数
	Utils:db_hset(Db:getServerIdSizeMapByAppId(_appid),serverid,0)

	return 200,""
end

-----------------------------------------------------------
-- Random get app server.
-----------------------------------------------------------
function Server:getAppServer(request,token)
	



end

return Server