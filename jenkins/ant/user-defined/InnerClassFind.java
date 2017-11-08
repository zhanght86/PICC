package hayden;
/**
 * ������Ҫ�Ǽ���ڲ���
 * �ڲ�����Ҫ�ڲ������ɵ�class�ļ�Ϊ��$��β
 */
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

public class InnerClassFind  extends Task {
	   private File listFile=null; //�ļ��嵥
	   private String srcDir=null;  //�ļ�Ŀ¼
	   private Boolean log=false; //�Ƿ����log��Ĭ��Ϊ��
	   //private File destFile=null;
	   public void execute() throws BuildException {
	        try {
        		if(listFile==null) throw new BuildException("listFile not set");
	           /*
	            * ����ڲ��࣬������嵥
	            * 
	            */
        		String tmpFile="temp.txt";
	        	if(listFile!=null)
	        	{	        		
	            BufferedReader reader = new BufferedReader(
	                new InputStreamReader(new FileInputStream(listFile)));
	            BufferedWriter writer = new BufferedWriter(
		                new OutputStreamWriter(new FileOutputStream(tmpFile)));
	            String line = "";
	            while((line = reader.readLine()) != null){
		            if(line.endsWith(".class")){
		            	String className=line.substring(line.lastIndexOf("/")+1, line.lastIndexOf("."));
		            	if(log){
		            	log(className);
		            	}
		            	String dir=line.substring(0, line.lastIndexOf("/"));
		            	if(log){
		            	log(dir);
		            	}
		            	srcDir=srcDir.replace("\\", "/");
		            	if(log){
		            	log(srcDir);
		            	}
		            	if(log){
			            	log("Դ�ļ����һ��:"+srcDir.substring(srcDir.lastIndexOf("/")+1, srcDir.length()));
			            	log("Ŀ¼�ļ���һ�У�"+dir.substring(0, dir.indexOf("/")));
			            	}
		            	String dirEnd=srcDir.substring(srcDir.lastIndexOf("/")+1, srcDir.length());
		            	String dirStart=dir.substring(0, dir.indexOf("/"));
		            	if(dirEnd.equals(dirStart)||dirEnd.equals("cardManagement")||dirEnd.equals("i-card")||dirEnd.equals("iCardConfig")){
		            		File baseDir = new File(srcDir+"/"+dir);    // ����һ��File����  
		            		if(log){
		            		 log(baseDir.getPath());
		            		}
			                if (!baseDir.exists() || !baseDir.isDirectory()) {  // �ж�Ŀ¼�Ƿ����  
			                	log(baseDir.getPath());
//			                	throw new BuildException("�ļ�����ʧ�ܣ�" + srcDir+"/"+dir + "����һ��Ŀ¼��,�����ļ��嵥");
			                	continue;
			                  }
		            	
			                String tempName = null; 
			                File tempF;
			                File[] files = baseDir.listFiles(); 
			                for (int i = 0; i <  files.length; i++){
			                	tempF = files[i];  
			                	if(log){
			                	log(tempF.getPath());
			                	}
			                	if(tempF.isFile()){
			                		tempName=tempF.getName();
			                		if(log){
			                			log(tempName);
			                		}
			                		if(tempName.startsWith(className+"$")){
			                			log("�����ڲ���"+tempName+"����籾�θ����ļ��嵥");
			                			writer.write(dir+"/"+tempName);
			                			writer.newLine();
			                		}
			                	}
			                }
		            	}
		            	else continue;
		            
		            }
	            }
	            writer.close();
	            reader.close();
	            
	        	writer = new BufferedWriter(
                        new OutputStreamWriter(new FileOutputStream(listFile,true)));
	        	reader = new BufferedReader(
		                new InputStreamReader(new FileInputStream(tmpFile)));
	        	
	        	   while((line = reader.readLine()) != null){
	        		   writer.newLine(); 
	        		   writer.write(line);
		                
		                
		            }
	            log(listFile.getName()+"�ϲ���list");
	            writer.close();
	            reader.close();
	        	}
	        	
	        } catch (Exception e) {
	            e.printStackTrace();
	            throw new BuildException(e.toString());
	            
	        }
//	        super.execute();
	    }
	public Boolean getLog() {
		return log;
	}
	public void setLog(Boolean log) {
		this.log = log;
	}
	public File getListFile() {
		return listFile;
	}
	public void setListFile(File listFile) {
		this.listFile = listFile;
	}
	public String getSrcDir() {
		return srcDir;
	}
	public void setSrcDir(String srcDir) {
		this.srcDir = srcDir;
	}
}
