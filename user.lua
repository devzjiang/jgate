-- server module.
-----------------------------------------------------------
local Utils  =  require("utils")
local Cjson =  require("cjson")
local Coding = require("coding")

-----------------------------------------------------------
local User = {}

-----------------------------------------------------------
-- Const define.
-----------------------------------------------------------
User.UserMap = "userinfo"
User.UserInfoId = "userinfoId"

-----------------------------------------------------------
-- New userinfo.
-----------------------------------------------------------
function User:newUser(request)
	
	local accountid = request.accountid 
	
	if accountid == nil then
		return 2006,""
	end

	-- local userid = Utils:db_getid(User.UserInfoId)
	local userid = accountid

	local nickname = request.nickname or ("玩家"..userid)
	Utils:db_set(self:getUserAttr(userid,"nickname"),nickname)

	local level = request.level or 1
	Utils:db_set(self:getUserAttr(userid,"level"),level)

	local exp = request.exp or 0
	Utils:db_set(self:getUserAttr(userid,"exp"), exp)

	local gold = request.gold  or 100
	Utils:db_set(self:getUserAttr(userid,"gold"),gold)

	local diamond = request.diamond or 10
	Utils:db_set(self:getUserAttr(userid,"diamond"),diamond)

	local gift = request.gift or 10
	Utils:db_set(self:getUserAttr(userid,"gift"),gift)

	local vip = 0 
	Utils:db_set(self:getUserAttr(userid,"vip"),vip)

	local p = {}
	p.userid = userid
	p.attr = ""

	return self:getUser(p)
end


-----------------------------------------------------------
-- Get userinfo.
-----------------------------------------------------------
function User:getUser(request)
		
	local userid = request.userid

	if userid == nil then
		return 1002,""
	end

	local attr = request.attr
		
	local userinfo ={}
	
	if attr == nil or attr == "" then
		-- get all attr
		userinfo.nickname = Utils:db_get(self:getUserAttr(userid,"nickname"))
		userinfo.level = Utils:db_get(self:getUserAttr(userid,"level"))
		userinfo.exp = Utils:db_get(self:getUserAttr(userid,"exp"))
		userinfo.gold = Utils:db_get(self:getUserAttr(userid,"gold"))
		userinfo.diamond = Utils:db_get(self:getUserAttr(userid,"diamond"))
		userinfo.gift = Utils:db_get(self:getUserAttr(userid,"gift"))
		userinfo.vip = Utils:db_get(self:getUserAttr(userid,"vip"))
	else
		--get attr
		userinfo[attr] = Utils:db_get(self:getUserAttr(userid,attr))
	end

	return 200,Cjson.encode(userinfo)

end


-----------------------------------------------------------
-- Set userinfo.
-----------------------------------------------------------
function User:setUser(request)
	
	local userid = request.userid

	if userid == nil or userid =="" then
		return 1002,""
	end

	local userinfo = {}

	local level = request.level 
	if level ~= nil then
		local levelKey = self:getUserAttr(userid,"level")
		local  val = Utils:db_get(levelKey) + level
		Utils:db_set(levelKey,val)
		userinfo.level = level
	end


	local exp = request.exp
	if exp ~= nil then 
		local expKey = self:getUserAttr(userid,"exp")
		local  val = Utils:db_get(expKey) + exp
		Utils:db_set(expKey,val)
		userinfo.exp = val
	end
	
	local gold = request.gold
	if gold ~=nil then
		local goldKey = self:getUserAttr(userid,"gold")
		local  val = Utils:db_get(goldKey) + gold
		Utils:db_set(goldKey,val)
		userinfo.gold = val
	end

	local diamond = request.diamond 
	if diamond ~=nil then
		local diamondKey = self:getUserAttr(userid,"diamond")
		local  val = Utils:db_get(diamondKey) + diamond
		Utils:db_set(diamondKey,val)
		userinfo.diamond = val
	end

	local gift = request.gift 
	if gift ~=nil then
		local giftKey = self:getUserAttr(userid,"gift")
		local  val = Utils:db_get(giftKey) + gift
		Utils:db_set(giftKey,val)
		userinfo.gift = val
	end

	local vip = request.vip
	if vip ~=nil then
		local vipKey = self:getUserAttr(userid,"vip")
		local  val = Utils:db_get(vipKey) + vip
		Utils:db_set(vipKey,val)
		userinfo.vip = val
	end

	return 200,Cjson.encode(userinfo)
end




-----------------------------------------------------------
-- Get user key.
-----------------------------------------------------------
function User:getUserAttr(userid,attr)	
	return  User.UserMap.."-"..userid.."-"..attr
end

return User