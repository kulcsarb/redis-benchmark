#!/bin/bash

# Check if at least one, but maximum three parameters are provided
if [ $# -lt 1 ] || [ $# -gt 3 ]; then
  echo "Usage: $0 <hostname> [username] [path to private key]"
  echo "    if [username] and [path to private key] are left empty, it is assumed that they are set up in ./ssh/config for <hostname>"
  exit 1
fi

# Assign the parameters to variables
hostname=$1
username=$2
key=$3

# Execute Ansible Playbook with the given parameters
ansible-playbook -i $hostname, \
  ${username:+--user=$username} \
  ${key:+--private-key=$key} \
  playbook.yaml
