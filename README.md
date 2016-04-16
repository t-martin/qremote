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
