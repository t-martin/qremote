# qremote
## Table of Contents
- [About](#about)
- [Install](#install)
- [Usage](#usage)
- [Example](#example)
- [Integration with qmulti](#integration-with-qmulti)
- [Color](#color)
  - [Color schemes](#color-schemes)
    - [qremote](#qremote-scheme)
    - [zenburn](#zenburn)
    - [obsidian](#obsidian)
    - [solarized_light](#solarized_light)

## About
qremote is a utility for q/kdb+

It allows you to connect to remote kdb+ processes but behave as if you are using a local terminal.

## Install
Clone this repository.

Define an environment variable QREMOTE_HOME which points to he base of this repository.

## Usage 
Run qremote and it will prompt for a host/port/username/password

Each option can be skipped by pressing enter and nothing else

Alternatively you can specify an ini config file using `-config` and a connection from that file

The config file is of the format

    
    [CONNECTION.NAME]
    host=my_host
    port=1234
    user=my_username
    password=my_password       

Autocompletion comes via `rlwrap`. Autocompletion dictionaries are compiled by qremote when connecting to a remote process and saved in `$HOME/.qremote-autocomplete`. See `q/autocomplete.q` for options.

## Example
Start a qprocess on port 5001

`$ q -p 5001`

Define some data

`q) t:([]a:1 2 3;b:2 3 4)`

Now use qremote to connect to the remote process

Run qremote. It will prompt for server details
	
	$ ./qremote
	host:localhost
	port:5001
	user:
	password:
	
	[qremote v1.1]
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

We could achieve the same result using a config file.

    $ cat config/test.ini
    [TEST.CONN.A]
    host=localhost
    port=5001
    user=u
    password=p
  
    [TEST.CONN.B]
    host=localhost
    port=6001
    user=u
    password=p

    $ qremote -config config/test.ini -connection TEST.CONN.A
    [qremote v1.1]
    [qremote connecting to: :localhost:5001]
    [qremote connected to:  :localhost:5001]
    [\\ to exit. 'exit 0' will kill remote process]

    q)

## Integration with qmulti
qremote is integrated with [qmulti](https://github.com/t-martin/qmulti), a script which allows multi-line code to be entered in a kdb+ console. 

If qmulti.q is stored in QHOME,QMULTI_HOME or QREMOTE_HOME, then it will be picked up by qremote and its functionality will be available.

## Color
qremote will colorise the output of any executed commands using an adapted version of Michael Keenan's [color.q](https://github.com/mkeenan-kdb/color)

![alt text](img/qremote-color.PNG?raw=true)

Color schemes are configured in `csv/schemes.csv`. The colorscheme can be changed to color scheme `X` by typing `\scheme X`
### Color schemes
#### qremote <a name="qremote-scheme"></a>

![alt text](img/qremote-scheme.PNG?raw=true)

#### zenburn

![alt text](img/zenburn-scheme.PNG?raw=true)

#### obsidian

![alt text](img/obsidian-scheme.PNG?raw=true)

#### solarized_light

![alt text](img/solarized_light-scheme.PNG?raw=true)

