
from __future__ import print_function

import sys
from operator import add
from pyspark import SparkContext
#from pyspark.sql import SparkSession

def snoopyMapper(s):
    
    line = s.strip()

    check_snoopy = 'snoopy[' in line

    if check_snoopy:
       #print '==> find snoopy'
       list=line.split()
       #Get snoopy filds 
       month=list[0]
       day=list[1]
       hour=list[2]
       host=list[3]
       snoopy_pid=list[4][8:][:-2]
       uid=list[5][5:]
       sid=list[6][4:] 
       tty=list[7] 
       cwd=list[8][4:]
       filename=list[9][9:][:-2]
       cmd= ' '.join(list[10:]) 
       s_date= day + '/' + month
       # Uid filename host s_date sid snoopy_pid tty cwd cmd
       #return '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s' % (uid, host, s_date, hour, sid, snoopy_pid, cwd, filename, cmd) 
       return '%s' % (uid) 
    

def snoopyUidReducer(data_acum, data):
    data = yield s.rstrip().split('\t', 1)

    #for current_uid, group in groupby(data, itemgetter(0)):
    #    try:
    #        total_count = sum(1 for _ in group)
    #        return '%s%s%s' % (current_uid, '\t', total_count)
    #    except ValueError:
    #        # count was not a number, so silently discard this item
    #        # print 'Error!!!'
    #        pass
    #return data 


def main(argv):

 
    #spark = SparkSession\
    #    .builder\
    #    .appName("PythonSort")\
    #    .getOrCreate()     

    sc = SparkContext("local", "Snoopy Uid Count")

    data = sc.textFile("/user/etl/auth/*")

    # mapped /var/log/auth.log filtering by snoopy and format fields and return uids
    mapped = data.map(snoopyMapper)
  
    # count uids occurences  
    count = mapped.countByValue()
  
    # sort by num of ocurences 
    sort_by_value = sorted(count.iteritems(),key=lambda (k,v): v,reverse=False)

    for item in sort_by_value:
        print('%s %d' % (item[0],item[1]))


if __name__ == "__main__":
   main(sys.argv[1:])
