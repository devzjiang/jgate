-- auth module.
-----------------------------------------------------------
local Utils  =  require("utils")
local Cjson =  require("cjson")
local Coding = require("coding")
local Db = require("db")
-----------------------------------------------------------
local Auth = {}
-----------------------------------------------------------
-- const define.
-----------------------------------------------------------
-- normal
Auth.Status_normal =  0
-- online
Auth.Status_online = 1
-- forbidden.
Auth.Status_forbidden  = 2
-- token timeout.
Auth.TOKEN_TIMEOUT = 60*120



-----------------------------------------------------------
-- Build client connect.
-----------------------------------------------------------
function Auth:connect(request)

	--client 秘钥种子
	local _seed = request.seed 
	--game appid
	local _appid = request.appid
	--游戏签名= md5(appid+appsecret)
	local _appsign = request.sign 

	local secret = Utils:db_get(Db:getAppSecretById(_appid))

	--验证应用客户端连接来源是否合法
	if not Utils:sign_check(secret,_appid,_appsign) then
		return 9998,""
	end

	-- --根据client发送的种子计算会话秘钥
	local randval,s_seed = Coding:randseed()
	local secret = Coding:getsecret(randval,_seed)

	local token = Db:newToken()

	--记录会话lastaccesstime
	Utils:db_set(Db:getSessionLastAccesstimeByToken(token),os.time())
	--记录会话appid
	Utils:db_set(Db:getSessionAppIdByToken(token),_appid)
	--记录会话secret
	Utils:db_set(Db:getSessionSecretByToken(token),secret)	

	local response ={}
	response.seed = s_seed
	response.token = token
	return 200,Cjson.encode(response)
end

-----------------------------------------------------------
-- Check request token and decode param.
-----------------------------------------------------------
function Auth:check(param,token)

	local lastaccesstime = Utils:db_get(Db:getSessionLastAccesstimeByToken(token))
	
	--访问token不存在
	if lastaccesstime == nil then
		return false,nil 
	end

	--访问token过期
	if (os.time() - tonumber(lastaccesstime)) > Auth.TOKEN_TIMEOUT then
		
		--清除会话信息
		self:logout(token)

		return false,nil
	end

	--更新会话最后访问时间
	Utils:db_set(Db:getSessionLastAccesstimeByToken(token),os.time())

	--使用会话秘钥解密请求参数
	-- local session_secret = Utils:db_get(Db:getSessionSecretByToken(token))
	-- local jsonstr = Coding:encrypt(param,session_secret)
	-- local enparam = Cjson.decode(jsonstr)

	local enparam = Cjson.decode(param)

	return true,enparam
end

-----------------------------------------------------------
-- Register account.
-----------------------------------------------------------
function Auth:register(request,token)
	
	local _account = request.account
	local _passwd = request.passwd

	--账号名称已经被使用
	if Utils:db_hget(Db.AccName_AccId_Map,_account) then
		return 	2002,""
	end

	local accountid  = Db:newAccountId()

	--保存账户名和账户ID映射关系
	Utils:db_hset(Db.AccName_AccId_Map,_account,accountid)

	--保存账户名和账户密码
	Utils:db_set(Db:getAccLnameById(accountid),_account)
	Utils:db_set(Db:getAccLpassById(accountid),_passwd)

	--设置当前的会话账户ID
	Utils:db_set(Db:getSessionAccountIdByToken(token),accountid)

	return 200,""
end	

-----------------------------------------------------------
-- Account login.
-----------------------------------------------------------
function Auth:login(request,token)	
	
	local _account = request.account
	local _passwd =  request.passwd
		
	local accountid = Utils:db_hget(Db.AccName_AccId_Map,_account)

	if accountid == nil then
		return 2003,""
	end

	if Utils:db_get(Db:getAccLpassById(accountid))~=_passwd then
		return 2003,""
	end

	--设置当前的会话账户ID
	Utils:db_set(Db:getSessionAccountIdByToken(token),accountid)

	return 200,""
end 

-----------------------------------------------------------
--  Account logout.
-----------------------------------------------------------
function Auth:logout(token)

	--清除会话appid
	Utils:db_del(Db:getSessionAppIdByToken(token))
	--清除会话secret
	Utils:db_del(Db:getSessionSecretByToken(token))
	--清除会话accontid
	Utils:db_del(Db:getSessionAccountIdByToken(token))	
	--清除会话roleid
	Utils:db_del(Db:getSessionRoleIdByToken(token))
	--清除过期的访问token信息
	Utils:db_del(Db:getSessionLastAccesstimeByToken(token))

	return 200,""
end


-----------------------------------------------------------
-- Bind account phone.
-----------------------------------------------------------
function Auth:bindphone()
	
end


return Auth