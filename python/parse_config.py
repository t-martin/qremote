#!/usr/bin/python3


import configparser
import argparse

arg_parser = argparse.ArgumentParser(description = "ini config parser for qremote")
arg_parser.add_argument('config', help = "path to xml config file")
arg_parser.add_argument('option', help = "name of connection")
args = arg_parser.parse_args()

config = configparser.ConfigParser()
config.read(args.config)
if (args.option == 'all'):
    for section in config.sections():
        print(section)
else: 
    for key in config[args.option]:
        print(key + "=" + config[args.option][key])
