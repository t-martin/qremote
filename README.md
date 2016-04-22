# qremote
## About
qremote is a utility for q/kdb+ from kx systems.

It allows you to connect to remote kdb+ processes but behave as if you are using a local terminal.

## Install
To install, simply download qremote and qremote.q 

qremote will look for qremote.q first in $QREMOTE_HOME, then QHOME, and finally in the same directory as the script

## Usage
Run qremote and it will prompt for a host/port/username/password

Each option can be skipped by pressing enter and nothing else

Alternatively you can specify a config file using -config

The config file just contains

	host=<host of remote process>
	port=<port of remote process>
	user=<username of remote user>

## Example
Start a qprocess on port 5001

`$ q -p 5001`

Define some data

`q) t:([]a:1 2 3;b:2 3 4)`

Now use qremote to connect to the remote process

qremote and qremote.q are in the same directory:

	$ ls
	qremote qremote.q

Run qremote. It will prompt for server details
	
	$ ./qremote
	host:localhost
	port:5001
	user:
	password:
	
	[qremote v1.0]
	[qremote connecting to: :localhost:5001]
	[qremote connected to:  :localhost:5001]
	[\\ to exit. 'exit 0' will kill remote process]

	q)a:100	
	q)a
	100
	q)t
	a b
	---
	1 2
	2 3
	3 4

## Integration with qmulti
qremote is integrated with qmulti (https://github.com/t-martin/qmulti), a script which allows multi-line code to be entered in a kdb+ console. 

If qmulti.q is stored in QHOME,QMULTI_HOME or QREMOTE_HOME, then it will be picked up by qremote and its functionality will be available.
 
