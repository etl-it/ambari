#!/bin/bash
 
mount -o remount,rw /usr
mount -o remount,rw /usr/local

#if [ -d /usr/lib/ambari-agent ] ; then 
#   cp -a /usr/lib/ambari-agent /var/bigdata/lib
#   rm -r /usr/lib/ambari-agent
#fi 
 
#ln -s /var/bigdata/lib/ambari-agent /usr/lib/ambari-agent
 
 
#cd /tmp
 
##wget https://issues.apache.org/jira/secure/attachment/12797962/AMBARI-15796.patch
##patch /usr/lib/python2.6/site-packages/ambari_agent/main.py   AMBARI-15796.patch
#patch -N /usr/lib/python2.6/site-packages/ambari_agent/main.py <<EOF
#diff --git a/ambari-agent/src/main/python/ambari_agent/main.py b/ambari-agent/src/main/python/ambari_agent/main.py
#index b146ba8..c6ea92b 100644
#--- a/ambari-agent/src/main/python/ambari_agent/main.py
#+++ b/ambari-agent/src/main/python/ambari_agent/main.py
#@@ -311,9 +311,9 @@ if __name__ == "__main__":
#     heartbeat_stop_callback = bind_signal_handlers(agentPid)
# 
#     main(heartbeat_stop_callback)
#-  except SystemExit as e:
#-    raise e
#-  except BaseException as e:
#+  except SystemExit:
#+    raise
#+  except BaseException:
#     if is_logger_setup:
#-      logger.exception("Exiting with exception:" + e)
#-  raise
#+      logger.exception("Exiting with exception:")
#+    raise
# 
#EOF
 
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

chown -R root:hadoop /usr/hdp/current/hadoop-client/conf/secure

# NameNode Start


if [ ! -d /usr/hdp/current/hadoop-hdfs-namenode ] ; then 

   ln -s /usr/local/hadoop-2.7.1.2.3.4.0-3347 /usr/hdp/current/hadoop-hdfs-namenode

fi


#patch -N /usr/bin/hdp-select <<EOF 
#--- /usr/bin/hdp-select.org     2016-09-02 11:58:06.000000000 +0200
#+++ /usr/bin/hdp-select 2016-09-02 11:59:05.000000000 +0200
#@@ -23,7 +23,8 @@
# import sys
# 
# # The global prefix and current directory
#-root = "/usr/hdp"
#+#root = "/usr/hdp" 
#+root = "/var/bigdata/hdp"
# current = root + "/current"
# versionRegex = re.compile('[-.]') 
#    
#EOF


#patch -N /usr/bin/hdp-select <<EOF 
#--- /usr/bin/hdp-select	2016-09-06 17:09:28.000000000 +0200
#+++ hdp-select	2016-09-06 17:29:08.000000000 +0200
#@@ -211,10 +211,12 @@
#   for pkg in packages:
#     linkname = current + "/" + pkg
#     if os.path.isdir(linkname):
#-      print (pkg + " - " +
#-             os.path.basename(os.path.dirname(os.readlink(linkname))))
#-             
#+      if os.path.islink(linkname): 
#+         print (pkg + " - " +
#+                os.path.basename(os.path.dirname(os.readlink(linkname))))
#+      else:
#+         print (pkg + " - " + 
#+                os.path.basename(os.path.dirname(linkname)))
#     else:
#       print pkg + " - None"
# 
# 
#EOF


#patch -N /var/bigdata/ambari-agent/cache/common-services/HDFS/2.1.0.2.0/package/scripts/hdfs.py <<EOF 
#--- /var/bigdata/ambari-agent/cache/common-services/HDFS/2.1.0.2.0/package/scripts/hdfs.py.bak	2016-09-07 12:49:47.527994816 +0200
#+++ /var/bigdata/ambari-agent/cache/common-services/HDFS/2.1.0.2.0/package/scripts/hdfs.py	2016-09-07 12:51:02.987571620 +0200
#@@ -74,13 +74,13 @@
#               group=params.user_group
#     )
# 
#-
#-    Directory(params.hadoop_conf_secure_dir,
#-              recursive=True,
#-              owner='root',
#-              group=params.user_group,
#-              cd_access='a',
#-              )
#+    #Goyo 07/09/2016: comented 
#+    #Directory(params.hadoop_conf_secure_dir,
#+    #          recursive=True,
#+    #          owner='root',
#+    #          group=params.user_group,
#+    #          cd_access='a',
#+    #          )
# 
#     XmlConfig("ssl-client.xml",
#               conf_dir=params.hadoop_conf_secure_dir,
#
#       
#EOF

#chown -R root:hadoop /usr/hdp/current/hadoop-client/conf/secure


#if [ ! -d /etc/hadoop/conf ] ; then 
#   mkdir -p /etc/hadoop/conf
#fi

#chown -R root:hadoop /etc/hadoop

#if [ ! -d /usr/hdp/current/hadoop-yarn-client/bin ] ; then 
#   mkdir -p /usr/hdp/current/hadoop-yarn-client/bin 
#fi


#patch -N /var/bigdata/ambari-agent/cache/common-services/YARN/2.1.0.2.0/package/scripts/yarn.py <<EOF 
#--- /var/bigdata/ambari-agent/cache/common-services/YARN/2.1.0.2.0/package/scripts/yarn.py.bak	2016-09-07 13:18:11.061006290 +0200
#+++ /var/bigdata/ambari-agent/cache/common-services/YARN/2.1.0.2.0/package/scripts/yarn.py	2016-09-07 13:19:13.744475744 +0200
#@@ -399,12 +399,13 @@
#               group=params.user_group
#     )
# 
#-    Directory(params.hadoop_conf_secure_dir,
#-              recursive=True,
#-              owner='root',
#-              group=params.user_group,
#-              cd_access='a',
#-              )
#+    #Goyo 07/09/2016: comented 
#+    #Directory(params.hadoop_conf_secure_dir,
#+    #          recursive=True,
#+    #          owner='root',
#+    #          group=params.user_group,
#+    #          cd_access='a',
#+    #          )
# 
#     XmlConfig("ssl-client.xml",
#               conf_dir=params.hadoop_conf_secure_dir,
#EOF



#patch -N /var/bigdata/ambari-agent/cache/common-services/AMBARI_METRICS/0.1.0/package/scripts/ams.py<<EOF 
#--- /var/bigdata/ambari-agent/cache/common-services/AMBARI_METRICS/0.1.0/package/scripts/ams.py.bak	2016-09-07 16:22:40.137870945 +0200
#+++ /var/bigdata/ambari-agent/cache/common-services/AMBARI_METRICS/0.1.0/package/scripts/ams.py	2016-09-07 16:22:10.465627046 +0200
#@@ -367,11 +367,12 @@
#     )
# 
# 
#-    Directory(format("{ams_monitor_dir}/psutil/build"),
#-              owner=params.ams_user,
#-              group=params.user_group,
#-              cd_access="a",
#-              recursive=True)
#+    #Goyo: 07/09/2016
#+    #Directory(format("{ams_monitor_dir}/psutil/build"),
#+    #          owner=params.ams_user,
#+    #          group=params.user_group,
#+    #          cd_access="a",
#+    #          recursive=True)
# 
#     Execute(format("{sudo} chown -R {ams_user}:{user_group} {ams_monitor_dir}")
#     )
#EOF

 
mount -o remount,ro /usr/local
mount -o remount,ro /usr
