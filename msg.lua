-----------------------------------------------------------
local Cjson = require("cjson")
local Utils  = require("utils")
local Coding = require("coding")


local Auth  = require("auth")
local Server = require("server")
local User = require("user")

local _MSG = {}

-------------------------------------------------------------
--Error code and  message.
-------------------------------------------------------------
_MSG.errormsg = {}
_MSG.errormsg[1001] = "Request cmd not found!"
_MSG.errormsg[1002] = "Request param is null!"
_MSG.errormsg[1003] = "Request param format error!"
_MSG.errormsg[1004] = "access token is null!"
_MSG.errormsg[1005] = "access token error!"

_MSG.errormsg[2001] = "Server no response!"
_MSG.errormsg[2002] = "Account name already exists!"
_MSG.errormsg[2003] = "Account or passwd error!"
_MSG.errormsg[2004] = "Repeated account login!"
_MSG.errormsg[2005] = "Account forbidden!"
_MSG.errormsg[2006] = "AccountId is null!"


_MSG.errormsg[9998] =  "sign error!"
_MSG.errormsg[9999] = "Function is not open!"


_MSG.errormsg[10001] = "Appinfo name already exists"
-------------------------------------------------------------
-- Request commands.
-------------------------------------------------------------
_MSG.commands = {
    connect = "connect",		--发起连接
    register = "register",		--账号注册
    login = "login",            --账号登录
    logout = "logout",			--账号登出
    version = "version",	    --版本更新
    server = "server", 			--获取节点
    newuser = "newuser",		--创建玩家
    getuser = "getuser",		--获取玩家
    setuser = "setuser",		--修改玩家
    test = "test" 
}

--request routing.
function _MSG:routing(cmd,param,token)
	
	local code,data = nil 
	if cmd == "connect" then
		param = Cjson.decode(param)
		code,data = Auth:connect(param)
	elseif cmd =="test" then
		-- param = Cjson.decode(param)
		-- code,data =Server:newappinfo(param)
	else

        if token == nil or token == "" then
       		code,data = 1004,""   
	  	elseif cmd == "logout" then
			code,data = Auth:logout(token)
		else
			
			local status,enparam = Auth:check(param,token)
			
			if not status then		
				code,data = 1005,""   
			elseif cmd == "version" then
				code,data = 9999,""
			elseif cmd == "register" then
				code,data = Auth:register(enparam,token)
			elseif cmd == "login" then
	            code,data = Auth:login(enparam,token)
			elseif cmd == "server" then	
       			code,data = Server:getServer(enparam)
       		elseif cmd == "newuser" then
       			code,data = User:newUser(enparam)
       		elseif cmd == "getuser" then
       			code,data = User:getUser(enparam)
       		elseif cmd == "setuser" then
       			code,data = User:setUser(enparam)
       		end

        end
	end

	_MSG:msginfo(code,data,token)

end

--response msginfo.
function _MSG:msginfo(code,data,token)
	
	local msg ={}
	msg.code = code
	msg.info = _MSG.errormsg[code]
	
	-- return data encrypt
	if code == 200 and data~="" then
		-- local tokeninfo =Utils:db_get(token)
		-- tokeninfo = Cjson.decode(tokeninfo)
		-- data =Coding:encrypt(data,tokeninfo.secret)
	end
	
	msg.data = data
	ngx.print(Cjson.encode(msg))
	ngx.flush()
	ngx.exit(400)
end

return _MSG