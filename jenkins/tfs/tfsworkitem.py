#!/usr/bin/env python2
#coding:utf-8
#Create for test
#需要修改source和target，注释获取变更集的code在下面，直接替换对应位置即可

import sys
reload(sys)
sys.setdefaultencoding('utf-8')
import traceback
#sys.path.append(r"C:\Users\harry\Desktop\tfs\redist\lib\com.microsoft.tfs.sdk-11.0.0.jar")
sys.path.append(r"/home/weblogic/Jenkins/redist/lib/com.microsoft.tfs.sdk-11.0.0.jar")

#connection
from com.microsoft.tfs.core.httpclient import UsernamePasswordCredentials
from com.microsoft.tfs.core import TFSTeamProjectCollection
from com.microsoft.tfs.core.util import URIUtils

#undo
from com.microsoft.tfs.core.clients.versioncontrol.specs import ItemSpec

#update
from com.microsoft.tfs.core.clients.versioncontrol import GetOptions

#merge
from com.microsoft.tfs.core.clients.versioncontrol.specs.version import ChangesetVersionSpec
from com.microsoft.tfs.core.clients.versioncontrol.soapextensions import RecursionType
from com.microsoft.tfs.core.clients.versioncontrol.soapextensions import LockLevel
from com.microsoft.tfs.core.clients.versioncontrol import MergeFlags

#checkin 
from com.microsoft.tfs.core.clients.versioncontrol.soapextensions import WorkItemCheckinInfo
from com.microsoft.tfs.core.clients.versioncontrol.exceptions import CheckinException

def getChangesetid(changeset):
        return changeset.getChangesetID()

#TFS Information
connection_url = "http://tfs.piccnet.com.cn:8080/tfs/PICCCollection"
username = "renguoqiang"
password = "P2ssw0rd"
project_name = u"客户俱乐部系统"

#TFS源路径和目标路径，根据应用和环境需要修改
source=sys.argv[2]
target=sys.argv[3]
ID = sys.argv[1]
ID = int(ID)
print source
print target
print "输入的工作项ID为：",ID
#IDs = IDs.split(',')


#Connect to TFS
print u"登陆账号为：", username
print u"登陆团队资源集合为：", project_name

#连接到团队资源集合
credentials = UsernamePasswordCredentials(username,password)
url = URIUtils.newURI(connection_url)
tpc = TFSTeamProjectCollection(url,credentials)

#确认是否存在输入的WorkitemID
workitemclient = tpc.getWorkItemClient()
workitem = workitemclient.getWorkItemByID(ID)
if not workitem:
    raise Exception("There in no workitem you entered, Please check!")
    print "There in no workitem you entered, Please check!"
#   sys.exit()

else:
    #getMergeCandidate
    versioncontrolclient = tpc.getVersionControlClient()
    mergeCandidates = versioncontrolclient.getMergeCandidates(source,target,RecursionType.FULL,MergeFlags.BASELESS)
    #判断未合并变更集列表关联的工作项中是否有输入的workitem ID，如果有，则提取变更集列表changesets
    changesets = []
    for i in mergeCandidates:
        comment = i.getChangeset().getComment()
        changesetid = i.getChangeset().getChangesetID()
        print  changesetid,": ",comment
        workitems = i.getChangeset().getWorkItems(workitemclient)
        if not workitems:
            print "This changeset hasn`t relate to any workitems:",i.getChangeset().getChangesetID(),"Please check!"
        else:
            for x in workitems:
                if x.getID() == ID:
                    changesets.append(i.getChangeset())
    #如果根据rem ID查询到了相关联的可合并变更集，则开始执行合并
    if not changesets:
        print "There is no changesets to merge,Please check!"
        tpc.close()
        raise Exception("There is no changesets to merge,Please check")
    else:
        print "*"*30
        print "Start to merge changesets:",changesets
        workspace = versioncontrolclient.getWorkspace(target)
        #先撤销本地更改，再更新本地工作区，最后开始合并
        itemspecs = [ItemSpec(target,RecursionType.FULL),]
        print "undo changes count is :",workspace.undo(itemspecs)
        workspace.get(GetOptions.GET_ALL)
        print "Update workspace successfull!"
        for i in changesets:
            print "*"*30
            print "Merging Changeset：", i.getChangesetID()
            v_spec = ChangesetVersionSpec(i.getChangesetID())
            mergestatus = workspace.merge(source,target,v_spec,v_spec,LockLevel.NONE,RecursionType.FULL,MergeFlags.NONE)
            if mergestatus.getFailures():
                print "error code is : ",mergestatus.getFailures()[0].getCode()
                print "Please merge Changeset",i," manually！"
                tpc.close()
                raise Exception("Please merge Changeset",i," manually!")
            elif mergestatus.getNumConflicts():
                print "conflicts count is : ",mergestatus.getNumConflicts()
                print "Please merge Changeset",i," manually！"
                tpc.close()
                raise Exception("Please merge Changeset",i," manually!")
            else:
                print "Changeset: ",i.getChangesetID()," merging successfully!"
                print "*"*30
                print "Start to checkin this changset."
                #开始单个变更集的合并完成后就开始签入
                workitemcheckininfos = [WorkItemCheckinInfo(workitem),]
                #pendingchanges = workspace.getPendingChanges().getPendingChanges()
                #pendingchanges = workspace.getPendingChanges(serverpath,RecursionType.FULL,None).getPendingChanges()
                pendingchanges = workspace.getPendingChanges(itemspecs,False).getPendingChanges()
                print "签入项为："
                for x in pendingchanges:
                    print x.getLocalItem()
                #print pendingchanges[0].getLocalItem()
                try:
                    workspace.checkIn(pendingchanges,i.getComment(),None,workitemcheckininfos,None)
                    print "checin sucessfully!"
                    print "*"
                except CheckinException as e:
                    print "There is a checkin conflict!"
                    tpc.close()
                    raise Exception("There is a checkin conflict,Please merge it manually！")
tpc.close()
	

'''
#一个ID的下所有的变更集合并完成后开始签入
#关联工作项ID 	
workitemcheckininfos = [WorkItemCheckinInfo(workitem),]
pendingchanges = workspace.getPendingChanges().getPendingChanges()
print "合并项为："
print pendingchanges[0].getLocalItem()
try:
	workspace.checkIn(pendingchanges,i.getComment(),None,workitemcheckininfos,None)
	tpc.close()
except CheckinException as e:
	print "There is a checkin conflict!"
	sys.exit()


#判断未合并变更集列表的注释中是否有输入的workitemid，如果有，则提取出changeset list
for i in mergeCandidates:
	comment = i.getChangeset().getComment()
	changesetid = i.getChangeset().getChangesetID()
	print  changesetid,": ",comment
	
	rem_no = comment[4:comment.find('#')]
	if rem_no == ID:
		changesets.append(i.getChangeset())

'''
	
		
