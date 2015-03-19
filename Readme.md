# Automatic VM Retrieve


Sync-Retrieve is tool that allows the user to retrieve all VMs in all physical machines in the platform. It consists in a script that does the retrieve that can be configured easily with crontab to launch it periodically


## Setting up the environment - Use in CentOS 6

Installing ruby

```bash
# yum install ruby
```

Installing dependencies

```bash
# gem install bundler
# bundle install
```


## Using the script


### Parameters

The parameters needed to use the script are the following


1. Username and Password from your AbiquoPlatform 
		  
2. URL from the API that we want to modify
  
  
### Options


* -u  --user	
  * user:password - E.g: admim:admin	    

* -s  --url
  * URL from the API -  E.g: https://192.168.54.25/api/admin/datacenters




### Usage example

```bash
# ruby vm-retrieve.rb -u admin:admin -s https://192.168.54.25/api/admin/datacenters
```

### Usage with crontab - Examples with crontab

If crontab is not installed yet run command

```bash
# yum install vixie-cron
```
Enable the package on boot and start

```bash
# /sbin/chkconfig crond on

# /etc/init.d/crond start
```

Its necessary to add lines to <code> /etc/crontab </code> file 

If we want to retrieve VM each hour: 

```bash
0 */1 * * * /path-to-script/vm-retrieve.rb  parameters
```

If we want to retrieve VM each 30' : 

```bash
0,30 * * * * /path-to-script/vm-retrieve.rb  parameters
```
To configure mail in crontab, modify or add line

```bash
MAILTO=<email>
```


## License

This script is licensed under the Beerware License further details, see the LICENSE file.

  For comments and support: albert.navarro[at]abiquo.com

      