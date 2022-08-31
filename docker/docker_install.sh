#!/bin/bash 

cp docker-ce.repo /etc/yum.repos.d/
yum list docker-ce --showduplicates | sort -r

yum install -y docker-ce-20.10.5-3.el7

systemctl enable docker
docker info | grep 'Docker Root Dir' 查看是否是更改后的路径

vi /usr/lib/systemd/system/docker.service
修改 ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --graph /mnt/docker

systemctl daemon-reload
systemctl restart docker

