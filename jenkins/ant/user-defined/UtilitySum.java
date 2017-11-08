package hayden;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

public class UtilitySum  extends Task {
	   private String srcFile=null; //�ļ��嵥
	   private String destFile=null;  //����ļ�
	   private Boolean log=false; //�Ƿ����log��Ĭ��Ϊ��
	   
	   public void execute() throws BuildException {
		   try {
			   if(srcFile==null)throw new BuildException("srcFile not set");
			   if(destFile==null)throw new BuildException("destFile not set");
			   
			   BufferedWriter writer = new BufferedWriter(
	                   new OutputStreamWriter(new FileOutputStream(destFile)));
			   BufferedReader reader = new BufferedReader(
	      			 new InputStreamReader(new FileInputStream(srcFile)));
			   String line = "";
			   String utilitySum=null;
			   String tmpStr=null;
	           while((line = reader.readLine()) != null){
	        	   if(line.length()>10)
	        	   {
		        	   line=line.replace("\\", "/");
		        	   tmpStr=line.substring(0,line.indexOf("/"));//��¼�漰ϵͳ
		        	   if(line.endsWith(".java")||line.endsWith(".xml")||line.endsWith(".class"))
		        		   tmpStr=tmpStr+".java";//�������java��xml��������.java
		        	   
		        	   if(utilitySum==null){
		        		   utilitySum=tmpStr+",";
		        	   }
		        	   if(!utilitySum.contains(tmpStr)){
		        		   utilitySum=utilitySum+tmpStr+",";
		        	   }
		        	   if(log)
		        	   {
		        		   log(utilitySum);
		        		   log(tmpStr);
		        		   log(line);
		        	   }
		           }
	           }
	           writer.write(utilitySum);
	           reader.close();
	           writer.close();
		   }catch (Exception e) {
			   e.printStackTrace();
	           throw new BuildException(e.toString());
		   	}
	   }

	public String getSrcFile() {
		return srcFile;
	}

	public void setSrcFile(String srcFile) {
		this.srcFile = srcFile;
	}

	public String getDestFile() {
		return destFile;
	}

	public void setDestFile(String destFile) {
		this.destFile = destFile;
	}

	public Boolean getLog() {
		return log;
	}

	public void setLog(Boolean log) {
		this.log = log;
	}

}
