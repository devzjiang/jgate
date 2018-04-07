-----------------------------------------------------------
local Cjson = require("cjson")
local Msg = require("msg")
local Utils = require("utils")
local Coding = require("coding")
-----------------------------------------------------------

ngx.req.read_body() 

local args = ngx.req.get_post_args()
local cmd = args.cmd
local data = args.data
local token = args.token

if cmd ==nil or Msg.commands[cmd] == nil then
    Msg:msginfo(1001,"")
end

if data == nil or data == "" then
    Msg:msginfo(1002,"")
end

-- param decode 
-- data = Coding:url_decode(data)
-- data = Utils:json_decode(data)

if data == nil or data=="" then
    Msg:msginfo(1003,"")
end 

--request routing.
Msg:routing(cmd,data,token)


