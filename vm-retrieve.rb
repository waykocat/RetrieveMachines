#!/usr/bin/env ruby

# TODO numero maquines noves (not possible)

require 'abiquo-api'
require 'pry'
require 'uri'
require 'trollop'

#ruby vm-retrieve.rb -u admin -p xabiquo -s https://10.60.13.64:443/api/admin/datacenters


$opts = Trollop::options do
    opt :source, "Api URL" , :type => :string , :short => "-s"          
    opt :user, "User:Password", :type => :string  , :short => "-u"  
end




##
#Defines parameters to create conexion and setup links
#  
def define_parameters
   
  $userAndPass = $opts[:user].split(':',2)
  
  if  ($userAndPass[0] == nil)
    print "Enter your username: \n"
    $username = STDIN.gets.chomp
  else $username = $userAndPass[0]
  end
  
  if  ( $userAndPass[1] == nil)
    print "Enter your password:\n"
    system 'stty -echo'
    $userpass = STDIN.gets.chomp
    system 'stty echo'
  else $userpass = $userAndPass[1]
  end
  $source = $opts[:source]
  
  if ($username == nil or $userpass == nil or $source == nil) 
    puts "Missing parameters, type --help option." 
    exit 
  end
  

end

##
#It creates the connection with the credentials given.
#  
def createConnection

   
  #Setting url for connection 
  
  @a = AbiquoAPI.new(:abiquo_api_url => $urlConnection, 
                     :abiquo_username => $username, 
                     :abiquo_password => $userpass)

end

##
#Saves the amount of retrieved virtual machines in each rack - physical machine 
#
def archiveLog(machinesRetrieved, error)
  

  unless File.directory?("~/RetrieveVM-Log")
    FileUtils.mkdir_p("~/RetrieveVM-Log")
  end 
  
  unless File.exists?("VM-Retrieve.log")
    f = File.new("VM-Retrieve.log","w")
  end   

  if(error != nil) 
    newLog = Time.new.inspect.to_s + "  :  " + error + "\n"
  else newLog = Time.new.inspect.to_s + "  :  " + machinesRetrieved + " VM retrieved in /"+ $rackName + 
           "/" + $PMName + "\n"   
  end       
  #puts newLog
  f = File.open("VM-Retrieve.log","a") { |file| file << newLog }
  
  
  
end  


##
#creates the link and gets the file asked
# 
def getLink(api_path,mtype)
  
  #href is taken from the url
  
  @l = AbiquoAPI::Link.new(:href => api_path,
                           :client => @a,
                           :type => mtype,
                           :version => 3.2)
               
  #GET
  return  @l.get
 
end

##
#Gets Virtual Machine
#
def retrieveVM(urlVM, mtype)

  result = getLink(URI(urlVM).path.to_s, mtype)

   archiveLog(result.to_a.length.to_s, nil)
  

end

##
#Gets links from all the VirtualMachines located in a Physical Machine
#
def getVMachines(urlPMachine, mtype)
  
  pathPMachines = URI(urlPMachine).path.to_s
  result = getLink(pathPMachines, mtype)
  begin
  retrieveVM(result.links[4][:virtualmachines].href,result.links[4][:virtualmachines].type )
  rescue NoMethodError # you can also add this
      archiveLog(result.to_a.length.to_s, "Error getting VM")
      exit
    end

  
end

##
#Gets links from all Physical Machines
#
def getPMachines(urlMachines, mtype)

  pathMachines = URI(urlMachines).path.to_s
  result = getLink(pathMachines, mtype)
  machineList = result.to_a
  machineList.each do |action|   
    $PMName = action.name
    begin
    getVMachines(action.links[1][:edit].href, action.links[1][:edit].type)
    rescue NoMethodError # you can also add this
      archiveLog(result.to_a.length.to_s, "Error getting Physical Machines")
      exit
    end
  end
  
end


##
#Gets links from all the Racks located in the DataCenter
#
def getRacks(urlRacks, mtype)
  
  
  pathRacks = URI(urlRacks).path.to_s
  
  result = getLink(pathRacks, mtype)
  rackList = result.to_a
  rackList.each do |action|    
    $rackName = action.name
    begin
    getPMachines(action.links[1][:machines].href, action.links[1][:machines].type)
    rescue NoMethodError # you can also add this
      archiveLog(result.to_a.length.to_s, "Error getting Racks")
      exit
    end
  end
  
  
end

##
#Gets all the private-datacenters of the platform
#
def getDatacenters

  media_type_DC = "application/vnd.abiquo.datacenters+json"
  result = getLink($pathDatacenters,media_type_DC)
  datacenterList = result.to_a
  datacenterList.each do |action|
    begin    
    getRacks(action.links[1][:racks].href, action.links[1][:racks].type)
    rescue NoMethodError # you can also add this
      archiveLog(result.to_a.length.to_s, "Error getting Datacenters")
      exit
    end
  end  
  
end

def retrieveFunction
  
  getDatacenters

end

#main

  define_parameters
  $url = URI($source)
  $pathDatacenters = $url.path.to_s
  $urlConnection = $url.scheme.to_s + "://" + $url.host.to_s + ":" + $url.port.to_s + '/api'  
  createConnection
  retrieveFunction



#end