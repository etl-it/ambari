#!/usr/bin/env python

import sys

def read_input(file):
    for line in file:
        yield line

def main(separator='\t'):
    # input comes from STDIN (standard input)
    # for line in sys.stdin:

    lines = read_input(sys.stdin)

    for line in lines:
      # check if snoopy line
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
         print '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s' % (uid, host, s_date, hour, sid, snoopy_pid, cwd, filename, cmd)


if __name__ == "__main__":
   main()
