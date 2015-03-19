#Get N Put
getNput is tool that allows the user to make gets and puts using the API from Abiquo in an easy way. To run the script propely the computer needs to use the abiquo-api library, otherwise it won't work.
	  
## Requeriments - Installing dependencies

To run the script there're some necessary gems that must be installed. They can be added easily following the next steps in source folder:

<code>         
gem install bundler

bundle install 
</code>

## Using the script

### Parameters
The parameters needed to use the script are the following


1. Username and Password from your AbiquoPlatform 
		  
2. URL from the API that we want to modify
		  
3. Media Type: is not mandatory but the script could fail without. Without that <code>GET</code> method could response unexpected formats makinh them unreadable for the code

4. Editor: is not mandatory, if not specified script will open editor by default if exists, if not it will ask for it during runtime

	    
### About PUT methods
		  
Remember that PUT methods can't be thrown against all urls from the API. Trying to do it the script will fail.them.
          

### Options         
There're two ways to input parameters shown adobe: in runtime or using the following options when executing the script from command line,

* -u  --user	
  * user:password - E.g: admim:admin	    

* -s  --url
  * URL from the API -  E.g: https://192.168.54.25/api/admin/enterprises/1

* -m  --mtype  
  * Media type of the resource - E.g: application/vnd.abiquo.enterprise+json

* -e  --editor  :     
  *  Text editor to be opened after <code>GET</code> - E.g: vim, vi, gedit, etc.

	  
	   
If some of the mandatory parameters adove are missing the script will ask for them in runtime. 

###Usage example

If we want to modify the Enterprise we need to get the information of 
<code> 
https://192.168.50.51:/api/admin/enterprises/1
</code>

And we can type one of the command:

<code>
ruby getNput.rb -u admin:admin -s https://192.168.50.51:/api/admin/enterprises/1 -m application/vnd.abiquo.enterprise+json
</code>

<code> 
ruby getNput.rb -u admin:admin -s https://192.168.50.51:/api/admin/enterprises/1 -e vim
</code>

<code> 
ruby getNput.rb -s https://192.168.50.51:/api/admin/enterprises/1 -m application/vnd.abiquo.enterprise+json
</code>

        
Otherwise we could just run and the missing parameters will be requested

<code> 
ruby getNput.rb 
</code>        

           
For comments and support: albert.navarro[at]abiquo.com

      
