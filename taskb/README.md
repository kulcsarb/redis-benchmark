# Log collector for EC2 instances

## Description 
 
This script is designed to execute an Ansible playbook which collects logs of an EC2 instance using
https://github.com/aws/amazon-ecs-logs-collector. After the logs are collected, it downloads and extract the log archive 
to the current directory.

## Parameters
-  `<hostname>` : The hostname of the target server. 
-  `[username]`  (optional): The username to use for authentication. 
   If left empty, it assumes the username is set up in `./ssh/config` for the specified hostname. 
-  `[path to private key]`  (optional): The path to the private key file for authentication. 
   If left empty, it assumes the private key is set up in `./ssh/config` for the specified hostname.

## Execution 
 
To execute the script, run the following command:
```
  ./get_logs.sh <hostname> [username] [path to private key]
```

Make sure to replace  <hostname> ,  [username] , and  [path to private key]  with actual values.


## Output 

The script extracts the downloaded logs into a nested directory structure. The first level of the path corresponds to the hostname, while the second level represents the timestamp of the log collection.
For instance:
```
 ./ec2-XXXXXXXXXXX.eu-central-1.compute.amazonaws.com
    /202311011204
    /202311021831
    ....
```
