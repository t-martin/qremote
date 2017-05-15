#!/usr/bin/python3

import argparse
import xml.etree.ElementTree as ET

def validate_option(option):
  if (option != 'all' and not option.startswith('alias=')):
    print(argparse.ArgumentTypeError("error: option must be either 'all' or 'alias=X'\n"))
    arg_parse.print_help()
    exit(1)
  return option

arg_parser = argparse.ArgumentParser(description = "xml config parser for qremote")
arg_parser.add_argument('config', help = "path to xml config file")
arg_parser.add_argument('option', type = validate_option, help = "'all' to print all connection aliases or 'alias=X' to get the config for X")
args = arg_parser.parse_args()

tree = ET.parse(args.config)
root = tree.getroot()

if (args.option == 'all'):
  xpath = "./connection/[@name]"
  for elem in root.findall(xpath):
    print(elem.attrib['name'])
elif (args.option.startswith('alias=')):
  alias = args.option.split('=')[1]
  xpath = "./connection/[@name='%s']//" % alias
  for elem in root.findall(xpath):
    if(elem.text):
      print(elem.tag + '=' + elem.text)
else:
  arg_parser.print_help()
 

