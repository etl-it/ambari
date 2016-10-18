#!/bin/bash
 
mount -o remount,rw /usr
mount -o remount,rw /usr/local

#if [ -d /usr/lib/ambari-agent ] ; then 
#   cp -a /usr/lib/ambari-agent /var/bigdata/lib
#   rm -r /usr/lib/ambari-agent
#fi 
 
#ln -s /var/bigdata/lib/ambari-agent /usr/lib/ambari-agent
 
 
 
if [ ! -d /var/bigdata/ambari-agent ] ; then

   mkdir /var/bigdata/ambari-agent 

fi

if [ -d /usr/lib/ambari-agent ] && [ ! -h /usr/lib/ambari-agent ] ; then

   cp -a /usr/lib/ambari-agent/* /var/bigdata/ambari-agent
   mv /usr/lib/ambari-agent /usr/lib/ambari-agent.org

   ln -s /var/bigdata/ambari-agent /usr/lib/ambari-agent

fi

if [ /usr/lib/python2.6/site-packages/ambari_commons ] ; then 

   if [ -h /usr/lib/python2.6/site-packages/ambari_commons ] ; then 

    link=`ls -la /usr/lib/python2.6/site-packages/ambari_commons | cut -d\> -f2 | grep /usr/lib/ambari-agent/lib/ambari_commons`

    if [ -z "$link" ] ; then 

       mv /usr/lib/python2.6/site-packages/ambari_commons /usr/lib/python2.6/site-packages/ambari_commons.not_ambari-agent

       ln -s /usr/lib/ambari-agent/lib/ambari_commons /usr/lib/python2.6/site-packages/ambari_commons 

    fi

   fi

fi

if [ /usr/lib/python2.6/site-packages/resource_management ] ; then 

   if [ -h /usr/lib/python2.6/site-packages/resource_management ] ; then 

    link=`ls -la /usr/lib/python2.6/site-packages/resource_management | cut -d\> -f2 | grep /usr/lib/ambari-agent/lib/resource_management`

    if [ -z "$link" ] ; then 

       mv /usr/lib/python2.6/site-packages/resource_management /usr/lib/python2.6/site-packages/resource_management.not_ambari-agent

       ln -s /usr/lib/ambari-agent/lib/resource_management /usr/lib/python2.6/site-packages/resource_management 

    fi

   fi

fi

# For DataNode Install

if [ -d /usr/jdk64 ] && [ ! -h /usr/jdk64 ] ; then

   if [ ! -d /var/bigdata/jdk64 ] ; then

      mkdir /var/bigdata/jdk64

   fi
  

   cp -a /usr/jdk64/* /var/bigdata/jdk64
   mv /usr/jdk64 /usr/jdk64.org

   ln -s /var/bigdata/jdk64 /usr/jdk64

fi


# For Metrics Monitor Install

chown -R ams:hadoop /var/ambari-agent/python2.6/site-packages/resource_monitoring

# HDFS Client Install
 
if [ -d /usr/hdp ] ; then
   mv /usr/hdp /var/bigdata/
else
   mkdir /var/bigdata/hdp
fi
 
if [ ! -d /usr/hdp ] ; then    
   ln -s /var/bigdata/hdp /usr/hdp
fi


# DataNode Start

if [ -d /usr/hdp/current/hadoop-client ] ; then
  mv /usr/hdp/current/hadoop-client /usr/hdp/current/hadoop-client.org
fi

if [ ! -d /usr/hdp/current/hadoop-client.conf ] ; then 
   mkdir -p /usr/hdp/current/hadoop-client.conf
fi

if [ ! -d /usr/hdp/current/hadoop-client.conf/conf ] ; then 
   mkdir -p /usr/hdp/current/hadoop-client.conf/conf
fi

if [ ! -d /usr/hdp/current/hadoop-client ] && [ ! -h /usr/hdp/current/hadoop-client ] ; then 

   ln -s /usr/local/hadoop-2.7.1.2.3.4.0-3347 /usr/hdp/current/hadoop-client

fi


if [ ! -d /usr/local/hadoop-2.7.1.2.3.4.0-3347/conf ] ; then 

   ln -s /var/bigdata/hdp/current/hadoop-client.conf/conf /usr/local/hadoop-2.7.1.2.3.4.0-3347/conf 

fi

if [ -d /usr/hdp/current/hadoop-yarn-client ] ; then 
   mv /usr/hdp/current/hadoop-yarn-client /usr/hdp/current/hadoop-yarn-client.org
fi

if [ ! -d /usr/hdp/current/hadoop-yarn-client ] && [ ! -h /usr/hdp/current/hadoop-yard-client ] ; then 

   ln -s /usr/local/hadoop-2.7.1.2.3.4.0-3347 /usr/hdp/current/hadoop-yarn-client

fi


# For Metrics Monitor Start


if [ /usr/lib/python2.6/site-packages/resource_monitoring ] ; then 

   if [ -h /usr/lib/python2.6/site-packages/resource_monitoring ] ; then 

    link=`ls -la /usr/lib/python2.6/site-packages/resource_monitoring | cut -d\> -f2 | grep /usr/lib/ambari-agent/lib/resource_monitoring`

    if [ -z "$link" ] ; then 

       mv /usr/lib/python2.6/site-packages/resource_monitoring /usr/lib/python2.6/site-packages/resource_monitoring.not_ambari-agent

       ln -s /usr/lib/ambari-agent/lib/resource_monitoring /usr/lib/python2.6/site-packages/resource_monitoring 

    fi

   else
   
     if [ ! -d /usr/lib/ambari-agent/lib/resource_monitoring ] ; then 

       mv /usr/lib/python2.6/site-packages/resource_monitoring /usr/lib/ambari-agent/lib/resource_monitoring

     else

       mv /usr/lib/python2.6/site-packages/resource_monitoring /usr/lib/python2.6/site-packages/resource_monitoring.org

     fi

     ln -s /usr/lib/ambari-agent/lib/resource_monitoring /usr/lib/python2.6/site-packages/resource_monitoring 
     
   fi

fi

if [ ! -d /usr/lib/python2.6/site-packages/resource_monitoring/psutil/build ] ; then
   mkdir -p /usr/lib/python2.6/site-packages/resource_monitoring/psutil/build
fi

chown -R ams:hadoop /usr/lib/python2.6/site-packages/resource_monitoring/*

# DataNode Start

mkdir -p /usr/hdp/current/hadoop-client/conf/secure

chown -R root:hadoop /usr/hdp/current/hadoop-client/conf/secure

# NameNode Start


if [ ! -d /usr/hdp/current/hadoop-hdfs-namenode ] ; then 

   ln -s /usr/local/hadoop-2.7.1.2.3.4.0-3347 /usr/hdp/current/hadoop-hdfs-namenode

fi

# NodeManager Start 

if [ ! -d /usr/hdp/current/hadoop-yarn-nodemanager ] ; then 

   ln -s /usr/local/hadoop-2.7.1.2.3.4.0-3347 /usr/hdp/current/hadoop-yarn-nodemanager

fi


# ZooKeeper Server Start


if [ -d /usr/hdp/current/zookeeper-server ] ; then 

    mv /usr/hdp/current/zookeeper-server /usr/hdp/current/zookeeper-server.conf

fi


if [ ! -h /usr/hdp/current/zookeeper-server ] ; then 

   ln -s /usr/share/zookeeper /usr/hdp/current/zookeeper-server  

fi 


if [ ! -d /usr/hdp/current/zookeeper-server.conf ] ; then 

   mkdir -p /usr/hdp/current/zookeeper-server.conf

fi 


if [ -d /usr/share/zookeeper ] ; then 

   if [ ! -h /usr/share/zookeeper/conf ] ; then 

      ln -s /etc/zookeeper/conf /usr/share/zookeeper/conf

   fi

fi

update-alternatives --install /etc/zookeeper/conf zookeeper-conf /var/bigdata/hdp/current/zookeeper-server.conf/conf 100

if [ ! -h /etc/zookeeper/conf/environment ] ; then 

 ln -s /var/bigdata/hdp/current/zookeeper-server.conf/conf/zookeeper-env.sh /etc/zookeeper/conf/environment

fi


for jarfile in zookeeper.jar log4j-1.2.jar slf4j-api.jar slf4j-log4j12.jar ; do 

  if [ -h /usr/share/zookeeper/$jarfile ] ; then

     ln -s /usr/share/java/$jarfile /usr/share/zookeeper/jarfile 

  fi

done


#if [ ! -x /usr/hdp/current/zookeeper-server/bin/zkServer.sh  ] ; then 
#
#   ln -s /var/lib/ambari-agent/cache/common-services/ZOOKEEPER/3.4.5/package/files/zkServer.sh /usr/hdp/current/zookeeper-server/bin/zkServer.sh
#
#fi 


# Metrics Collector Start

if [ -d /usr/lib/ams-hbase ] ; then 

   mv /usr/lib/ams-hbase /usr/lib/ams-hbase.org 

   if [ ! -d /var/bigdata/ams-hbase ] ; then 

      mkdir /var/bigdata/ams-hbase

      cp -a /usr/lib/ams-hbase.org/* /var/bigdata/ams-hbase

   fi
  
   ln -s /var/bigdata/ams-hbase /usr/lib/ams-hbase

fi
  
# SNameNode Start 

if [ ! -d /etc/hadoop ] ; then 

   mkdir -p /etc/hadoop

fi

ln -s /var/bigdata/hdp/current/hadoop-client.conf/conf  /etc/hadoop/conf 

# History Server Start 

if [ -d /usr/hdp/current/hadoop-mapreduce-historyserver ] ; then 

   mv /usr/hdp/current/hadoop-mapreduce-historyserver /usr/hdp/current/hadoop-mapreduce-historyserver.conf

fi

if [ ! -h /usr/hdp/current/hadoop-mapreduce-historyserver ] ; then 

  ln -s /usr/local/hadoop-2.7.1.2.3.4.0-3347 /usr/hdp/current/hadoop-mapreduce-historyserver

fi


# App Timeline Server Start 

if [ -d /usr/hdp/current/hadoop-yarn-timelineserver ] ; then 

  mv /usr/hdp/current/hadoop-yarn-timelineserver /usr/hdp/current/hadoop-yarn-timelineserver.conf

fi

if [ ! -h /usr/hdp/current/hadoop-yarn-timelineserver ] ; then 

  ln -s /usr/local/hadoop-2.7.1.2.3.4.0-3347 /usr/hdp/current/hadoop-yarn-timelineserver 

fi 

# ResourceManager Start 

if [ -d /usr/hdp/current/hadoop-yarn-resourcemanager ] ; then 

  mv /usr/hdp/current/hadoop-yarn-resourcemanager /usr/hdp/current/hadoop-yarn-resourcemanager.conf

fi

if [ ! -h /usr/hdp/current/hadoop-yarn-resourcemanager ] ; then 

  ln -s /usr/local/hadoop-2.7.1.2.3.4.0-3347 /usr/hdp/current/hadoop-yarn-resourcemanager

fi 


# Grafana Start

chown ams:root /var/log/ambari-metrics-grafana

if [ ! -d /var/run/ambari-metrics-grafana ] ; then 
 
   mkdir /var/run/ambari-metrics-grafana
 
fi

chown ams:root /var/run/ambari-metrics-grafana


# RegionServer Start

if [ -d /usr/hdp/current/hbase-regionserver ] ; then 

   mv /usr/hdp/current/hbase-regionserver /usr/hdp/current/hbase-regionserver.org

fi

if [ ! -h /usr/hdp/current/hbase-regionserver ] ; then 

   ln -s /var/bigdata/ams-hbase /usr/hdp/current/hbase-regionserver 

fi

# HBase Master Start

if [ -d  /usr/hdp/current/hbase-master ] ; then 

   mv /usr/hdp/current/hbase-master /usr/hdp/current/hbase-master.conf

fi


if [ ! -h /usr/hdp/current/hbase-master ] ; then 

   ln -s /var/bigdata/ams-hbase /usr/hdp/current/hbase-master 

fi 


#######################################################################


#chown -R root:hadoop /usr/hdp/current/hadoop-client/conf/secure


#if [ ! -d /etc/hadoop/conf ] ; then 
#   mkdir -p /etc/hadoop/conf
#fi

#chown -R root:hadoop /etc/hadoop

#if [ ! -d /usr/hdp/current/hadoop-yarn-client/bin ] ; then 
#   mkdir -p /usr/hdp/current/hadoop-yarn-client/bin 
#fi

 
mount -o remount,ro /usr/local
mount -o remount,ro /usr
