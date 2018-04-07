-- Db module.
-----------------------------------------------------------
local Utils  =  require("utils")
-----------------------------------------------------------
local Db = {}




-----------------------------------------------------------
-- Db const define.
-----------------------------------------------------------

-- 平台会话 自增长序列
Db.SessionId_Sequence = "sequence_sessionId"
-- 签名秘钥 自增长序列
Db.SecretId_Sequence = "sequence_secretId"
-- 服务器id 自增长序列
Db.ServerId_Sequence = "sequence_serverId"
-- 应用id 自增长序列
Db.AppId_Sequence = "sequence_appId"
-- 账号id 自增长序列
Db.AccountId_Sequence = "sequence_accountId"
-- 角色id 自增长序列
Db.RoleId_Sequence = "sequence_roleId"
-- 道具id 自增长序列
Db.PropId_sequence = "sequence_propId"


-- key = 游戏包名,value = 游戏id
Db.AppName_AppId_Map = "map_appName_appId"
-- key = 账号名称，value = 账号id
Db.AccName_AccId_Map = "map_accName_accId"


-----------------------------------------------------------
-- New access token .
-----------------------------------------------------------
function Db:newToken()
	local token = Utils:getDate("%Y%m%d%H%M%S").."-"..Utils:db_getid(Db.SessionId_Sequence)
	require("Sha1")
	return Sha1(token)	
end

-----------------------------------------------------------
-- New app sign secret.
-----------------------------------------------------------
function Db:newSecret(appname)
	local secret = appname.."-"..Utils:db_getid(Db.SecretId_Sequence)
	require("Sha1")
	return Sha1(secret)	
end





-----------------------------------------------------------
-- New appid
-----------------------------------------------------------
function Db:newAppId()
	return Utils:db_getid(Db.AppId_Sequence)
end


-----------------------------------------------------------
-- New serverid 
-----------------------------------------------------------
function Db:newServerIdByAppId(appid)
	return Utils:db_getid(Db.ServerId_Sequence.."-"..appid)
end

-----------------------------------------------------------
-- New accountid
-----------------------------------------------------------
function Db:newAccountId()
	return Utils:db_getid(Db.AccountId_Sequence)
end

-----------------------------------------------------------
-- New roleid
-----------------------------------------------------------
function Db:newRoleId()
	return Utils:db_getid(Db.RoleId_Sequence)
end






-----------------------------------------------------------
-- Build key session-xxx-secret
-----------------------------------------------------------
function Db:getSessionSecretByToken(token)
	return "session-"..token.."-secret"
end

-----------------------------------------------------------
-- Build key session-xxx-lastaccesstime
-----------------------------------------------------------
function Db:getSessionLastAccesstimeByToken(token)
	return "session-"..token.."-lastaccesstime"
end

-----------------------------------------------------------
-- Build key session-xxx-appid
-----------------------------------------------------------
function Db:getSessionAppIdByToken(token)
	return "session-"..token.."-appid"
end

-----------------------------------------------------------
-- Build key session-xxx-accountid
-----------------------------------------------------------
function Db:getSessionAccountIdByToken(token)
	return "session-"..token.."-accountid"
end

-----------------------------------------------------------
-- Build key session-xxx-roleid
-----------------------------------------------------------
function Db:getSessionRoleIdByToken(token)
	return "session-"..token.."-roleid"
end





-----------------------------------------------------------
-- Build key server-xxx(appid)-xxx(serverid)-name
-----------------------------------------------------------
function Db:getServerNameByAppIdAndServerId(appid,serverid)
	return "server-"..appid.."-"..serverid.."-name"
end

-----------------------------------------------------------
-- Build key server-xxx(appid)-xxx(serverid)-host
-----------------------------------------------------------
function Db:getServerHostByAppIdAndServerId(appid,serverid)
	return "server-"..appid.."-"..serverid.."-host"
end

-----------------------------------------------------------
-- Build key server-xxx(appid)-xxx(serverid)-port
-----------------------------------------------------------
function Db:getServerPortByAppIdAndServerId(appid,serverid)
	return "server-"..appid.."-"..serverid.."-port"
end

-----------------------------------------------------------
-- Build key server-xxx(appid)-xxx(serverid)-version
-----------------------------------------------------------
function Db:getServerVersionByAppIdAndServerId(appid,serverid)
	return "server-"..appid.."-"..serverid.."-version"
end



-----------------------------------------------------------
-- Build key app-xxx-secret
-----------------------------------------------------------
function Db:getAppSecretById(id)
	return "app-"..id.."-secret"
end

-----------------------------------------------------------
-- Build key app-xxx-version
-----------------------------------------------------------

function Db:getAppVersionById(id)
	return "app-"..id.."-version"
end





-----------------------------------------------------------
-- Build key acc-xxx-lname
-----------------------------------------------------------
function Db:getAccLnameById(id)
	return "acc-"..id.."-lname"
end

-----------------------------------------------------------
-- Build key acc-xxx-lpass
-----------------------------------------------------------
function Db:getAccLpassById(id)
	return "acc-"..id.."-lpass"
end








-----------------------------------------------------------
-- Build map-accountid-appid_roleid
-----------------------------------------------------------
function Db:getAppRoleMapByAccountIdAndAppId(accuntid,appid)
	return "map-"..accountid.."-"..appid
end

-----------------------------------------------------------
-- Build map-(xxxx)appid-serverid_size
-----------------------------------------------------------
function Db:getServerIdSizeMapByAppId(appid)
	return "map-"..appid.."-serverid_size"
end



















return Db