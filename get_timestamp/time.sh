#!/bin/bash 

current=`date "+%Y-%m-%d %H:%M:%S"`
echo $current

timeStamp=`date -d "$current" +%s` 
echo $timeStamp

currentTimeStamp=$(((timeStamp*1000+10#`date "+%N"`/1000000)/1000)) #将current转换为时间戳，精确到秒
echo $currentTimeStamp


timestamp=`date "+%Y%m%d%H%M%S"`
echo $timestamp
