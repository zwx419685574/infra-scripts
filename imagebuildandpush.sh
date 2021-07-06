#!/bin/bash

jar=$1

tmp=${jar%.jar*}
version=${tmp#*-service-}

if [ $1 ];then
  echo docker build -t harbor_url/${jar%-*}:${version}-develop .
  sleep 3
  echo docker push harbor_url/${jar%-*}:${version}-develop
  sleep 3
  echo push success
else 
  echo please input jar
fi

# jar like send-service-1.0.6.jar 
# harbor_url the true harbor url
