
------------------------------------------------------------------------------
local Coding ={}
Coding.DH_P = 10093
Coding.DH_G = 2
------------------------------------------------------------------------------


------------------------------------------------------------------------------
--  密钥交换(Diffie–Hellman key exchange)
------------------------------------------------------------------------------
--  生成随机数以及交换的密码种子(seed =  g ^ n % p)
--  n 本地保存随机数
--  seed 发送给对方密码种子数
------------------------------------------------------------------------------
function Coding:randseed()
	local n = math.random(1,25)	
	local seed =math.pow(Coding.DH_G,n) % Coding.DH_P 
	return n,seed
end

------------------------------------------------------------------------------
--  根据本地保存的随机数以及密码种子推算秘钥( seed ^ n % p)
------------------------------------------------------------------------------
function Coding:getsecret(n,seed)	
	local val = math.pow(seed,n) % Coding.DH_P   
	require("Sha1")
	return Sha1(tostring(val))
end

------------------------------------------------------------------------------
-- 加密解密算法(RC4 encryption algorithm)
-- text 要加密的字符串
-- key 加密秘钥
------------------------------------------------------------------------------
function Coding:encrypt(text,key)

    local function KSA(key)
        local keyLen = string.len(key)
        local schedule = {}
        local keyByte = {}
        for i = 0, 255 do
        	schedule[i] = i
        end
        for i = 1, keyLen do
        	keyByte[i - 1] = string.byte(key, i, i)
        end
        local j = 0
        for i = 0, 255 do
            j = (j + schedule[i] + keyByte[ i % keyLen]) % 256
            schedule[i], schedule[j] = schedule[j], schedule[i]
        end
		return schedule
    	end

    	local function PRGA(schedule, textLen)
	           local i = 0
	           local j = 0
	           local k = {}
	           for n = 1, textLen do
		            i = (i + 1) % 256
		            j = (j + schedule[i]) % 256
		            schedule[i], schedule[j] = schedule[j], schedule[i]
		            k[n] = schedule[(schedule[i] + schedule[j]) % 256]
	           end
   		return k
   	end

	local function output(schedule, text)
       local len = string.len(text)
       local c = nil
       local res = {}
       for i = 1, len do
            c = string.byte(text, i,i)
            res[i] = string.char(ZZMathBit.xorOp(schedule[i], c))
       end
       return table.concat(res)
	end

	local textLen = string.len(text)
	local schedule = KSA(key)
	local k = PRGA(schedule, textLen)
	require("ZZMathBit")
	return output(k,text)
end

------------------------------------------------------------------------------
-- Url param decode.
------------------------------------------------------------------------------

function Coding:test()
    
	local encrypt = self:encrypt("abcde1235","zyp")
	ngx.say(encrypt)
	local decrypt = self:encrypt(encrypt, "zyp")
	ngx.say(decrypt)

end



------------------------------------------------------------------------------
-- Url param decode.
------------------------------------------------------------------------------
function Coding:url_decode(param)
	return string.gsub(param, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
end

return Coding