# qremote
## about
qremote is a linux utility for q/kdb+ from kx systems

it allows you to connect to remote kdb+ processes but behave as if you are using a local terminal

## install
to install, simply download qremote and qremote.q and place them in the same directory. 

alternatively, if you want to place qremote.q in a separate directory then just set QREMOTE_HOME to the directory containing the .q file before running qremote

## usage
run qremote and it will prompt for a host/port/username/password

each option can be skipped by pressing enter and nothing else

alternatively you can specify a config file using -config

the config file just contains

	host=<host of remote process>
	port=<port of remote process>
	user=<username of remote user>

## example
start a qprocess on port 5001

`$ q -p 5001`

define some data

`q) t:([]a:1 2 3;b:2 3 4)`

now user qremote to connect to the remote process

qremote and qremote.q are in the same directory:

	$ ls
	qremote qremote.q

run qremote. it will prompt for server details
	
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
