#!/usr/bin/python

import os
import subprocess

os.chroot("/etc")

def read_hostname():
	f_hostname = open('hostname','r')
	hostname = f_hostname.read()
	return hostname		

def read_ip():
	os.chdir("/etc/network")
	f_addr = open('ADDRESS','r')
	addr = f_addr.read()
	
	prefix = subprocess.call(client.sh)
	
	type = 'config-'+prefix
	f_ip = open(type,'r')
	dir = f_ip.readline()
	ip_prefix = dir.replace(' ', '')[:-8].upper()
	
	ip = ip_prefix + addr
	return ip
	

def read_hosts():
	f = open('hosts','ra')
	lines = f.readlines()
	hostname = read_hostname()
	for line in lines:
		if line.find(hostname)!=-1:
			print "found hostname"
		else:
			print read_ip()		


