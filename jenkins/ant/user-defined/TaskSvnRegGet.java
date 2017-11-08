package hayden;
/* 
 * 本程序检查svnlog中的commitmessage中的jira编号
 * 根据jira编号检索本次更新涉及的文件清单以及版本
 * 输出版本号到ant的property文件中
 */


import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.OutputStreamWriter;
import java.io.IOException;   
import java.util.ArrayList;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

public class TaskSvnRegGet extends Task{
	    private String xmlFile=null;  //解析的xml地址
	    private String listFile=null;  //文件清单地址
	    private String propertyFile=null;  //输出版本号文件路径
	    private String versionStr=null;  //版本信息
	    private String jiraTask=null;  //jira编号
	    private String xmlPath="/SourceCode/XML"; //xml文件目录
	    private String sqlPath="/Document/"; //sql文件目录
//	    private String xmlPath=null;
	    Boolean log=false; //是否输出日志
	    Boolean findPath=false;  //是否找到jira对应的文件目录，未找到则抛出异常
	    Boolean includeDir=true; //是否记录目录
	    Boolean xmlCheck = false; //是否是只检查xml规范性

		@SuppressWarnings("resource")
		public void execute() throws BuildException {
	    	    if (xmlFile == null) throw new BuildException("xmlFile not set");
	    	    if(!xmlCheck){
	            if (listFile == null) throw new BuildException("listFile not set");
//	            if (propertyFile==null)throw new BuildException("propertyFile not set");
	            if (jiraTask==null)throw new BuildException("jiraTask not set");
	    	    }
	    	SAXBuilder builder = new SAXBuilder();
	    	
//	    	DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
	    	try {
	    		List<String> strTmp=new ArrayList<String>();
	    		String ver=null;  //版本号
	    		//打开list文件

	    		//打开版本清单文件
//	            BufferedWriter antProFile = new BufferedWriter(
//                        new OutputStreamWriter(new FileOutputStream(propertyFile)));
	            //DOM parser instance   
//	            DocumentBuilder builder = builderFactory.newDocumentBuilder();   
	            //parse an XML file into a DOM tree   
	    		Document doc = builder.build(new File(xmlFile));   
	    		Element rootEl = doc.getRootElement();
	    		List<Element> logentry = rootEl.getChildren("logentry");
	    		String commitMsg="0";
	    		String temStr="0";
	    		if(!xmlCheck){
	    			jiraTask=jiraTask.toUpperCase();
			        
	            for (Element el : logentry) {
	            	//获取paths
	            	Element paths=el.getChild("paths");
	            	List<Element> path=paths.getChildren("path");
	            	Element temPath=path.get(0);
	                //获取版本号
	                ver=el.getAttributeValue("revision");
	                
	                //获取子元素msg文本值
	                String msg = el.getChildText("msg");
//	                if(checkStr(msg,xmlCheck)){
//	                	continue;
//	                }
//                	String taskNo=msg.substring(msg.indexOf("-")+1, msg.indexOf("|"));//主任务号
//                	String subTaskNo=msg.substring(msg.indexOf("-",msg.indexOf("|"))+1, msg.indexOf("#"));//子任务号
//                	subTaskNo=subTaskNo.trim(); //去掉前后空格
//                	taskNo=taskNo.trim();//去掉前后空格
	                /**
	                 * 以上去掉taskNO，不对备注进行检查
	                 */
                	msg=msg.trim();//去掉前后空格

//                	if(jiraTask.contains(taskNo)||jiraTask.contains(subTaskNo)){  //安盟使用
                	if(msg.contains(jiraTask)){  //此种情况只支持单个jira号码
                		if(log){
                		log("当前task号:"+jiraTask);
                		}
                		findPath=true;
                		/**
                		 * 去掉对xml和sql的版本过滤，不需要，有可能会漏掉版本
                		 */
//                		if((!temPath.getText().startsWith(xmlPath))||(!temPath.getText().startsWith(sqlPath))) //如果是文件以xml开头或sqlpath开头，则不记录版本信息
//                		{
		                	versionStr=ver+","+versionStr; //存储版本号
		                	
		                	if(temStr.length()<ver.length())
		                	{
		                		temStr=ver;
		                		commitMsg=el.getChildText("msg");
		                	}
		                	else if(temStr.length()>ver.length()){
		                		//do nothing
		                	}
		                	else if(temStr.compareTo(ver)<0){
		                		temStr=ver;
		                		commitMsg=el.getChildText("msg");
		                		} 
		                	log(msg);
//                		}
                		
	                	for(Element listpath : path){
		                //获取svn修改属性
		                String kind = listpath.getAttributeValue("kind");
		                //获取svn版本修改类型
		                String action=listpath.getAttributeValue("action");
		                //获取子元素path文本值
		                String filePath = listpath.getText();
		                //排除各系统互打jar包路径--安盟需要，picc暂时去掉
//		                boolean jar=filePath.endsWith("visa.jar")||filePath.endsWith("prpall.jar")||filePath.endsWith("platfrom.jar")||filePath.endsWith("reins.jar")||filePath.endsWith("undwrt.jar");
		                /*
		                 * 判断目录类型，且是新增，则将此path加入到list中
		                 * 否则不加入list
		                 */
		                if((kind.equals("dir")&&action.equals("M"))||action.equals("D")){
		                	//如果是修改的文件夹或删除类型，则不输出
		                	log("文件夹未添加清单"+filePath+"修改类型"+action);
		                	continue;
		                }
		                else
		                	{
			                	if(log){
			                	log("添加清单"+filePath);
			                	}
	
	                			if(filePath.endsWith(".sql")||filePath.endsWith(".SQL"))
	                			{
	                				String str="sql#"+ver+"#-"+filePath;
	                				if(!strTmp.contains(str)){
				                		strTmp.add(str);
				                	}
	                			}
	                			else if(!strTmp.contains(filePath)){
			                		strTmp.add(filePath);
			                	}
		                	} 
	                	}
	                }
	            }
	            if(findPath){
	            BufferedWriter writer = new BufferedWriter(
		                   new OutputStreamWriter(new FileOutputStream(listFile,true)));
            	for(int i=0;i<strTmp.size();i++)
            	{
            		writer.newLine();
            		writer.write(strTmp.get(i));
            	}
            	strTmp.removeAll(strTmp);
                writer.close();
	            }
	            
	            if(propertyFile!=null){
	            	if(findPath){
	            		versionStr=versionStr.substring(0, versionStr.length()-5); //需要减去版本字符串中起始的null长度
		            	Document mergDoc = builder.build(new File(propertyFile));
		            	rootEl = mergDoc.getRootElement();
		            	List<Element> target=rootEl.getChildren("target");
		            	for(Element pr:target){
		            		List<Element> property = pr.getChildren("property");
			            	for(Element el:property){
			            		if("version".equals(el.getAttributeValue("name"))){
			            			el.setAttribute("value", versionStr);
			            			if(log){
			            			log(el.getAttributeValue("value"));
			            			}
		  	            		}
			            		else if("commitmsg".equals(el.getAttributeValue("name"))){
			            			el.setAttribute("value", commitMsg);
			            			if(log){
			            			log(el.getAttributeValue("value"));	      
			            			}
			            		}
			            		else if("find".equals(el.getAttributeValue("name"))){
			            			el.setAttribute("value", "true");
			            			if(log){
			            			log(el.getAttributeValue("value"));	      
			            			}
			            		}
			            	}
		            	}
			             XMLOutputter xmlopt = new XMLOutputter();
			           	 FileWriter xmlWriter = new FileWriter(propertyFile);
//			           	 log(xmlWriter.toString());
			           	 Format fm = Format.getPrettyFormat();
			             fm.setEncoding("gb2312");
			           	 xmlopt.setFormat(fm);
			           	 xmlopt.output(mergDoc, xmlWriter);
//			           	xmlopt.output(doc,new FileOutputStream(propertyFile,""));
			           	xmlWriter.close();	            		
	            	}
	            	else if(!findPath){ //如果没有找到对应的目录，则将commit设置为false
	            		Document mergDoc = builder.build(new File(propertyFile));
		            	rootEl = mergDoc.getRootElement();
		            	List<Element> target=rootEl.getChildren("target");
		            	for(Element pr:target){
		            		List<Element> property = pr.getChildren("property");
			            	for(Element el:property){
			            		 if("commitmsg".equals(el.getAttributeValue("name"))){
			            			el.setAttribute("value", "");   //设置为false
			            		}
			            		 if("version".equals(el.getAttributeValue("name"))){
				            			el.setAttribute("value", "");
				            			if(log){
				            			log(el.getAttributeValue("value"));
				            			}
			  	            		}
			            		 if("find".equals(el.getAttributeValue("name"))){
				            			el.setAttribute("value", "false");
				            			if(log){
				            			log(el.getAttributeValue("value"));
				            			}
			  	            		}
			            	}
		            	}
			             XMLOutputter xmlopt = new XMLOutputter();
			           	 FileWriter xmlWriter = new FileWriter(propertyFile);
//			           	 log(xmlWriter.toString());
			           	 Format fm = Format.getPrettyFormat();
			             fm.setEncoding("gb2312");
			           	 xmlopt.setFormat(fm);
			           	 xmlopt.output(mergDoc, xmlWriter);
//			           	xmlopt.output(doc,new FileOutputStream(propertyFile,""));
			           	xmlWriter.close();	 
			           	
			           	log(jiraTask+"未找到对应版本清单，请检查是否输入有误");	
	            	}
	            	
	            }
	            else if(propertyFile==null){
	            	if(findPath){
	            		log(jiraTask+"--------------------清单输出完毕-----------------");
	            	}
	            	else {
	    	            	log(jiraTask+"-----------------无清单处理-----------------");
	            	}
	            	
	            }	            
	            

	
	    		}
	    		else if(xmlCheck){
	    			 for (Element el : logentry) {
	 	                //获取子元素msg文本值
	 	                String msg = el.getChildText("msg");
	 	                //检查“msg”文本值是否符合注释提交规范
	 	                checkStr(msg,xmlCheck);
	    			 }
	    		}
	    		
	         } catch (JDOMException  e) {   
	            e.printStackTrace();  
	            throw new BuildException(e.toString());
	         } catch (IOException e) {   
	            e.printStackTrace();  
	            throw new BuildException(e.toString());
	         }    

//	        super.execute();
	    }
	    //判断标准
		public Boolean checkStr(String str,Boolean bl){
             if((str.indexOf("|")==-1)||str.indexOf("#")==-1||(str.indexOf("-",str.indexOf("|"))==-1)){
            	 if(bl){
              	log(str+"----------注释不规范，请修改注释，此版本已忽略");
            	 }
              	return true;
              }
              if((str.indexOf("-")+1)>str.indexOf("|")){
            	  if(bl){
          		log(str+"----------注释不规范，请修改注释，此版本已忽略");
            	  }
              	return true;
          	}
          	//容错处理
          	if((str.indexOf("-",str.indexOf("|")+1))>str.indexOf("#")){
          		if(bl){
          		log(str+"----------注释不规范，请修改注释，此版本已忽略");
          	}
              	return true;
          	}
			return false;
		}
	       
	    public String getXmlPath() {
			return xmlPath;
		}

		public void setXmlPath(String xmlPath) {
			this.xmlPath = xmlPath;
		}

		public String getSqlPath() {
			return sqlPath;
		}

		public void setSqlPath(String sqlPath) {
			this.sqlPath = sqlPath;
		}

		public Boolean getIncludeDir() {
			return includeDir;
		}

		public void setIncludeDir(Boolean includeDir) {
			this.includeDir = includeDir;
		}

		public Boolean getLog() {
			return log;
		}

		public void setLog(Boolean log) {
			this.log = log;
		}

		public String getXmlFile() {
			return xmlFile;
		}

		public void setXmlFile(String xmlFile) {
			this.xmlFile = xmlFile;
		}

		public String getListFile() {
			return listFile;
		}

		public void setListFile(String listFile) {
			this.listFile = listFile;
		}

		public String getPropertyFile() {
			return propertyFile;
		}

		public void setPropertyFile(String propertyFile) {
			this.propertyFile = propertyFile;
		}

		public String getVersionStr() {
			return versionStr;
		}

		public void setVersionStr(String versionStr) {
			this.versionStr = versionStr;
		}

		public String getJiraTask() {
			return jiraTask;
		}

		public void setJiraTask(String jiraTask) {
			this.jiraTask = jiraTask;
		}
	    public Boolean getFindPath() {
			return findPath;
		}

		public void setFindPath(Boolean findPath) {
			this.findPath = findPath;
		}
		public Boolean getXmlCheck() {
			return xmlCheck;
		}
		public void setXmlCheck(Boolean xmlCheck) {
			this.xmlCheck = xmlCheck;
		}


//		public String getXmlPath() {
//			return xmlPath;
//		}
//
//		public void setXmlPath(String xmlPath) {
//			this.xmlPath = xmlPath;
//		}
}
