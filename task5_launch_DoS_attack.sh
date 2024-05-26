#!/bin/bash

slowhttptest -c 2000 -H -i 80 -r 100 -t GET -u http://172.18.0.2:30080/ -x 240 -p 3 -l 600

# -c: Number of connections
# -H: Use HTTP protocol
# -i: Interval between follow-up data
# -r: Connections per second
# -t: Type of request 
# -u http://http://172.18.0.2:30080/: URL of Nginx server

