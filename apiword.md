
server 启动流程
|
-> 1.启动redis数据库节点，发布服务器节点主题
|
-> 2.启动服务器节点(节点包括更新，逻辑，统计等类型),提交节点启动通知
|
-> 3.启动nginx网关监听，处理分发客户端请求


client 运行流程
|
-> 1.app发起服务器请求,建立平台会话,获取访问token(加密通道发起秘钥种子交换)
|
-> 2.player注册/登录平台账号，获取指定app访问授权
|
-> 3.app发起版本更新请求，以及获取服务器访问地址(分布式节点或者组服列表选择)
|
-> 4.player 创建app角色，进入app应用逻辑流程 
|
-> 平台SDK支持： 
---> a.逻辑(角色属性,道具,排行榜)
---> b.支付(渠道支付)
|
-> 5. 玩家登出