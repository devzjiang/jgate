
------------------------------------------------------------------------------
local Cjson = require("cjson")
local Md5  =  require("resty.md5")
local Redis = require("resty.redis")
local Conf  = require("conf")
------------------------------------------------------------------------------
local Utils ={}

------------------------------------------------------------------------------
-- Check handler
------------------------------------------------------------------------------
function Utils:sign_check(secret,appid,sign)

	if secret == nil or appid ==nil or sign == nil then
		return false
	end

	--sign = md5(appid+appsecret)
	local _server_sign = ngx.md5(appid.."-"..secret)
		
	if _server_sign == sign then
		return true
	end

	return false
end

------------------------------------------------------------------------------
-- String handler
------------------------------------------------------------------------------
function Utils:json_decode(str)
    local json_value = nil
    pcall(function (str) json_value = Cjson.decode(str) end, str)
    return json_value
end


------------------------------------------------------------------------------
-- Date handler
------------------------------------------------------------------------------
-- "%Y%m%d%H%M%S"   	20150302152233
-- "%Y-%m-%d %X"        2015-03-22 22:12:11
function Utils:getDate(format)	
    return os.date(format,os.time())
end

------------------------------------------------------------------------------
-- Redis handler
------------------------------------------------------------------------------

-- Get redis connet object.
function Utils:getRedis()
	local red = Redis:new()
    red:set_timeout(1000) -- 1 sec
    local ok, err = red:connect(Conf.REDIS_HOST, Conf.REDIS_PORT)
    if not ok then
       ngx.say("failed to connect: ", err)
       return nil
    end
    return red
end

-- Get parimary key.
function Utils:db_getid(key)
	local redis = self:getRedis()
	if redis == nil then
		return 0
	end
	return 10000+redis:incr(key)
end

-- Save values and cover.
function Utils:db_set(key,val)
	local redis = self:getRedis()
	if redis == nil then
		return 0
	end
	return redis:set(key,val)
end

-- Save values and duplication .
function Utils:db_setnx(key,val)
	local redis = self:getRedis()
	if redis == nil then
		return 0
	end
	return redis:setnx(key,val)
end

-- Save hash values and cover.
function Utils:db_hset(h,key,val)
	local redis = self:getRedis()
	if redis == nil then
		return 0
	end
	return redis:hset(h,key,val)
end

-- Save hash values and duplication .
function Utils:db_hsetnx(h,key,val)
	local redis = self:getRedis()
	if redis == nil then
		return 0
	end
	return redis:hsetnx(h,key,val)
end

-- Get value by key
function Utils:db_get(key)	
	local redis = self:getRedis()	
	if redis == nil then
		return nil
	end	
	local val = redis:get(key)	
	if tostring(val) == "userdata: NULL"  then
		val = nil
	end
	return val
end

--Del key
function Utils:db_del(key)
	local redis = self:getRedis()	
	if redis == nil then
		return nil
	end	
	return redis:del(key) > 0 
end

--Del hash key
function Utils:db_hdel(h,key)	
	local redis = self:getRedis()	
	if redis == nil then
		return nil
	end	
	return redis:hdel(key) > 0 
end

-- Get value by hash and key
function Utils:db_hget(h,key)	
	local redis = self:getRedis()	
	if redis == nil then
		return nil
	end	
	local val = redis:hget(h,key)	
	if tostring(val) == "userdata: NULL"  then
		val = nil
	end
	return val
end

return Utils