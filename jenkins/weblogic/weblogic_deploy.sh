#!/bin/bash
project=wap
export JAVA_HOME=/opt/ibm/java-x86_64-60
export PATH=$JAVA_HOME/bin:$PATH
classpath=/home/ecar/Oracle/Middleware/wlserver_10.3/server/lib
element=" weblogic.Deployer -adminurl t3://10.133.177.175:7005 -username weblogic -password weblogic1234"
builddir=/home/ebss/TFS/WAP/wap/BETA/target/wap
deploydir=/home/ebss/ebssworkareas/wapworkarea

java -cp $classpath/weblogic.jar $element -undeploy -name wap
rm -r $deploydir/${project}_lastupdate
mv /home/ebss/ebssworkareas/wapworkarea/wap /home/ebss/ebssworkareas/wapworkarea/wap_lastupdate

scp -r ebss@10.133.99.67:$builddir $deploydir
java -cp $classpath/weblogic.jar $element -deploy $deploydir/$project