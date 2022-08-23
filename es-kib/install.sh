# 首先附上 参考连接  https://www.pudn.com/news/62b497bb405aad31f7f7122c.html
# 链接中 没有映射对应 数据和配置文件，下面映射了 参考

1 root用户下修改vim /etc/sysctl.conf
  添加: vm.max_map_count = 655360
  刷新配置：sysctl -p

2 单节点es
启动前 要更改权限和所属组 否则报错

chown -R 1000:1000 /mnt/esdata/data
chmod -R 777 /mnt/esdata/data
chmod -R 777 /mnt/esdata/logs

docker run --name elasticsearch --privileged=true -p 9200:9200 -p 9300:9300 \
-e  "discovery.type=single-node" \
-e ES_JAVA_OPTS="-Xms64m -Xmx512m" \
-v /mnt/esdata/config:/usr/share/elasticsearch/config \
-v /mnt/esdata/data:/usr/share/elasticsearch/data \
-v /mnt/esdata/plugins:/usr/share/elasticsearch/plugins \
-v /mnt/esdata/logs:/usr/share/elasticsearch/logs \
-d elasticsearch:8.2.0 

# 根据参考链接配置es登录用户名密码
# 配置IK分词器 下载地址 https://github.com/medcl/elasticsearch-analysis-ik/releases
# ELK Kibana 8.3.2登录认证 : https://www.cnblogs.com/feifei6779/p/16524927.html
3 kibana
docker run --name kibana --restart=always \
-v /mnt/kibdata/config:/usr/share/kibana/config \
-v /mnt/kibdata/logs:/usr/share/kibana/logs \
-p 5601:5601 \
-d kibana:8.2.0

4 filebeat
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.2.0-linux-x86_64.tar.gz
tar -xvf filebeat-8.2.0-linux-x86_64.tar.gz
# 进入根目录
cd filebeat-8.2.0-linux-x86_64
# 在根目录下配置filebeat.yml
vim filebeat.yml

filebeat.inputs:
- type: log
  enabled: true     #默认为false,修改为true则启用该配置
  paths:
    - /home/logs/*.log
  fields:
    filetype: test1    #自定义字段，用来区分多个类型日志
  fields_under_root: true    #如果该选项设置为true，则新增fields成为顶级目录，而不是将其放在fields目录下

- type: filestream
  id: ftplog
  paths:
    # Filebeat处理文件的绝对路径，默认部署vsftpd是在/var/log/vsftpd.log
    - /home/monitor/ftplog/vsftpd*.log
  # 使用 fields 模块添加字段
  fields:
    app_id: ftplog
    # host_ip 为字段名称，后面的值为 SERVER_IP 变量值，该变量为系统变量，可以先通过shell脚本比写入环境变量MONITOR_SERVER_IP中
    host_ip: ${MONITOR_SERVER_IP}
    service_name: vsftpd 
  # 将新增的字段放在顶级，收集后字段名称显示 host_ip。如果设置为 false，则放在子集，收集后显示为 fields.host_ip
  fields_under_root: true

# ============================== Filebeat modules ==============================

filebeat.config.modules:
  # Glob pattern for configuration loading
  path: ${path.config}/modules.d/*.yml

  # Set to true to enable config reloading
  reload.enabled: false

  # Period on which files under path should be checked for changes
  #reload.period: 10s

# ======================= Elasticsearch template setting =======================

setup.template.settings:
  index.number_of_shards: 1
  #index.codec: best_compression
  #_source.enabled: false

output.elasticsearch:
  hosts: ["localhost:9200"]
  username: "elastic"
  password: "elastic"
  
  
  
