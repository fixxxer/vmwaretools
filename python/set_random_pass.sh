#!/bin/bash

# Script: Execute workflow to assign a new ramdom password and note on vSphere Console.
# Author: Anibal Avelar <aavelar@vmware.com>
# Date: Sep 16, 2018
# Version: 1.0


PYTHON=/usr/bin/python


if [ -z "$vcoserver" ]; then
    vcoserver="vra-01a.corp.local"
fi 

if [ -z "$workflow" ]; then
    workflow="89c88a5c-033e-431b-ac26-ab2833df98e4"
fi

if [ -z "$username" ]; then
    username='administrator@vsphere.local'
fi

if [ -z "$password" ]; then
     password='VMware1!'
fi

if [ -z "$special_chars" ]; then
    special_chars="#+-*.,$%;"
fi

if [ -z "$size_pass" ]; then
    size_pass="15"
fi

python_script=$(cat <<'EOF'


import urllib2
import base64
import time
import random
import socket
import sys
import string
import os
import subprocess


if ( len(sys.argv) != 7 ):
    sys.exit(0)


vcoserver = sys.argv[1]
workflow = sys.argv[2]
username = sys.argv[3]
password = sys.argv[4]
special_chars = sys.argv[5]
size_pass = sys.argv[6]

vmname = socket.gethostname()
print ("VMname:",vmname)

print ("Username",username)
print ("Password",password)

url = "https://"+vcoserver+"/vco/api/workflows/"+workflow+"/executions/"
print ("URL:",url)


def password_generator(size_pass=15, chars=""):
    """
    Returns a string of random characters, useful in generating temporary
    passwords for automated password resets.
    size: default=8; override to provide smaller/larger passwords
    chars: default=A-Za-z0-9; override to provide more/less diversity
    """
    print ("Size",size_pass)
    print ("Chars",chars)
    return ''.join(random.choice(string.ascii_letters + string.digits + chars) for i in range(int(size_pass)))



def add_note_vm (vmname="", newpass=""):
    request_data =  '<execution-context xmlns="http://www.vmware.com/vco"> \
    <parameters> \
    <parameter type="string" name="vmname">\
        <string>'+vmname+'</string>\
    </parameter>\
    <parameter type="string" name="desc">\
        <string>Password: '+newpass+'</string>\
    </parameter>\
    </parameters></execution-context>'
    print ("Request_data:",request_data)
    return request_data


def run_workflow(username="",password="",vmname="",newpass="",url=""):
    base64string = base64.encodestring('%s:%s' % (username, password)).replace('\n', '')
    headers = {'X_REQUESTED_WITH': 'urllib2', 'Content-Type': 'application/xml','Accept': 'application/xml', 'Authorization': 'Basic %s' % base64string}
    request = urllib2.Request(url=url,data=add_note_vm(vmname,newpass),headers=headers)
    response = urllib2.urlopen(request)
    response_status = response.read()
    xml_output = response.geturl()
    return xml_output

def chpasswd(user, passwd):
    if os.getuid() != 0:
        syslog.syslog("Error: chpasswd.py must be run as root")
        return

    proc = subprocess.Popen(
        ['/usr/sbin/chpasswd'], 
        stdin = subprocess.PIPE, 
        stdout = subprocess.PIPE, 
        stderr = subprocess.PIPE
    )
    print "Changing: " + user + ':' + passwd
    out, err = proc.communicate(user + ':' + passwd)
    proc.wait()
    print out
    if proc.returncode != 0:
        print "Error: Return code", proc.returncode, ", stderr: ", out, err
        if out:
            syslog.syslog("stdout: " + out)
        if err:
            syslog.syslog("stderr: " + err)
    return proc.returncode


if __name__ == '__main__':
    generated_pass = password_generator(size_pass,special_chars)
    print ("Generated_pass",generated_pass)
    status = chpasswd ('root',generated_pass)
    if status == 0:
        status = run_workflow(username, password, vmname, generated_pass, url)
        print ("Response:",status)
        time.sleep( 3 )

EOF
)

$PYTHON -c "$python_script" "$vcoserver" "$workflow" "$username" "$password" "$special_chars" $size_pass








