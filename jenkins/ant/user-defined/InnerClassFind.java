package hayden;
/**
 * 本类主要是检查内部类
 * 内部类需要内部类生成的class文件为以$结尾
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
	   private File listFile=null; //文件清单
	   private String srcDir=null;  //文件目录
	   private Boolean log=false; //是否输出log，默认为否
	   //private File destFile=null;
	   public void execute() throws BuildException {
	        try {
        		if(listFile==null) throw new BuildException("listFile not set");
	           /*
	            * 检测内部类，并添加清单
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
			            	log("源文件最后一行:"+srcDir.substring(srcDir.lastIndexOf("/")+1, srcDir.length()));
			            	log("目录文件第一行："+dir.substring(0, dir.indexOf("/")));
			            	}
		            	String dirEnd=srcDir.substring(srcDir.lastIndexOf("/")+1, srcDir.length());
		            	String dirStart=dir.substring(0, dir.indexOf("/"));
		            	if(dirEnd.equals(dirStart)||dirEnd.equals("cardManagement")||dirEnd.equals("i-card")||dirEnd.equals("iCardConfig")){
		            		File baseDir = new File(srcDir+"/"+dir);    // 创建一个File对象  
		            		if(log){
		            		 log(baseDir.getPath());
		            		}
			                if (!baseDir.exists() || !baseDir.isDirectory()) {  // 判断目录是否存在  
			                	log(baseDir.getPath());
//			                	throw new BuildException("文件查找失败：" + srcDir+"/"+dir + "不是一个目录！,请检查文件清单");
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
			                			log("发现内部类"+tempName+"添加如本次更新文件清单");
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
	            log(listFile.getName()+"合并到list");
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
