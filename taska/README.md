# Task A
## Prerequisities

1. Create an EC2 instance, either from the AWS console or via cli. Use Debian 12 image.
2. Download the private key and save it to this directory as `redis-benchmark-vm.pem`
3. Edit the `hosts` file in this directory and add the public url of the vm:
    ```
   [redis-benchmark]
    <EC2-INSTANCE-URL> ansible_user=admin ansible_ssh_private_key_file=redis-benchmark-vm.pem
   ```
4. Install ansible dependencies:
    ```
   ansible-galaxy install -r requirements.yaml
    ```

## Configuration

Edit `vars.yaml` and replace the admin password for Grafana and Redis


## Deployment

Run 
```
ansible playbook.yaml
```

After it finished, Grafana should be reachable at port 3000. After logging in, look for the dashboard "Node Exporter Full"


## Possible issues
In some cases, the grafana role might fail at step "change default admin password". This is because the server is 
starting slowly and still hasn't finished initializing its database in /var/lib/grafana, and the cli util interferes with it. 
Currently the role just waits for 10s (which is more than enough), but a nicer solution would be to check the logs and wait till
it is sure that Grafana started up successfully. 

Solution: just run the notebook again

## Design notes

### Debian 12 
   The default amazon linux image is not compatible EPEL, so installing software packages is a bit difficult. 
   I chose Debian because I'm more familiar with it 

### Prometheus
   Installation was straightforward, I created customized config files to restrict its network inferface to localhost

### Grafana
   I've run into several issues with this one. 
   1. Official support for Ansible (grafana.grafana collection) seems to deal only with Grafana Cloud so I had to fall 
      back to the community modules.
   2. Community modules has several flaws and bugs:
      - users module is unable to change password for a user (so it is impossible to change the default admin password)
      - users module can add a new user, but won't set its admin flag even if explicitly asked to do it 
      - dashboards module can install public dashboards, but unable to change their data sources (or any other variables)
   3. I had assign a manually spefified uuid for the prometheus datasource, then export a manually installed dashboard, 
      store it as a json file, and change the uuid for every reference to the datasources manually, and upload the json with ansible. 
   
### Redis Benchmark

I choose to create a home directory for the linux user which runs the service, so all files and the venv was put under
`/home/benchmark`. I was thinking of putting it under `/opt` or `/usr/shared/` but I settled with this solution for now,
as it could be easier to find each part of the service if someone wants to modify it manually. 

Environment variables were moved from `.env` to `/etc/redis-benchmark/redis-benchmark.conf` and this file got included
in the service definition.

To launch the benchmark itself, I've created a small script which activates the venv and then starts the benchmark
   
ps: I'm not a huge fan of putting source code files in an ansible role as it quicly can spin out of control,
      but since this project scope is limited, it was the simplest decision. 

