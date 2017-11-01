readTemplate("HOME/Oracle/Middleware/wlserver_10.3/common/templates/domains/wls.jar")  #templatepath
cd("Server/AdminServer") 
cmo.setName("ADMIN_SERVER") #adminservername 
set("ListenAddress","") 
set("ListenPort",PORT) #adminport 
cd("/Security/base_domain/User/weblogic") 
cmo.setPassword("weblogic1234") 
setOption("OverwriteDomain",'true') 
setOption('ServerStartMode','MODE')  #mode
writeDomain("HOME/bea/user_projects/domains/DOMAIN_NAME") #domainpath 
closeTemplate() 
exit()
