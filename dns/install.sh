# https://baijiahao.baidu.com/s?id=1734802327230560064&wfr=spider&for=pc

# 这个也只是其中一种方式，非专业搭建。


docker run --name dns -d --restart=always \
  -p 53:53/tcp \
  -p 53:53/udp \
  -p 10000:10000/tcp \
  --volume /home/dns-data:/data \
  sameersbn/bind:latest

参数说明：
-p 53:53/udp 绑定容器53端口到宿主机的53端口，DNS默认端口
-p 10000:10000 图形化界面管理器端口
-e WEBMIN_ENABLED=true 开启图形化界面管理器
-v ~/bind:/data 挂载本地目录作为dns配置存储

地址：https://ip:10000
账号：root 密码：password
