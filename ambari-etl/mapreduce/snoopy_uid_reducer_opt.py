#!/usr/bin/env python

from itertools import groupby
from operator import itemgetter
import sys

def read_mapper_output(file, separator='\t'):
    for line in file: 
        yield line.rstrip().split(separator, 1)

def main(separator='\t'):

    #current_uid = None
    #current_count = 0
    #uid = None

    data = read_mapper_output(sys.stdin, separator=separator)

    for current_uid, group in groupby(data, itemgetter(0)):
        try:
            total_count = sum(1 for _ in group)
            print "%s%s%s" % (current_uid, separator, total_count)
        except ValueError:
            # count was not a number, so silently discard this item
            print 'Error!!!'
            pass


if __name__ == "__main__":
   main()
