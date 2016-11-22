#!/usr/bin/python

import os
import glob
import subprocess

hadoop="/usr/hdp/2.4.3.0-227/hadoop/bin/hadoop"
logdir="/var/log/"

#/usr/hdp/2.4.3.0-227/hadoop/bin/hadoop fs -put /var/log/auth.log.1.gz  /user/etl/auth/doc028.auth.log.1.gz


def main():

       #hostname=subprocess.call("hostname")
       hostname = os.uname()[1]    
 
       for auth_f in glob.glob(logdir + 'auth.*'): 
           (p, f_src) = os.path.split(auth_f)
           f_dst= '/user/etl/auth/' + hostname + '.' + f_src
           
           subprocess.call([hadoop, "fs", "-put", auth_f, f_dst])

       subprocess.call([hadoop, "fs", "-ls", "/user/etl/auth"])


main()

