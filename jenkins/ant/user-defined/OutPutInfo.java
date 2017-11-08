package hayden;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

public class OutPutInfo extends Task{
	String srcFile=null; //输出文件路径
	Boolean log=true;  //是否输出日志
	public void execute() throws BuildException {
		try{
		BufferedReader reader = new BufferedReader(
                new InputStreamReader(new FileInputStream(srcFile)));
		String line=null;
		File tmp=new File(srcFile);
		if(!tmp.exists()){
       			 tmp.createNewFile();
       		      }
		while((line = reader.readLine()) != null){
  		  	if(log){ 		  		
  		  		log(line);
  		  	}
		 }
		 reader.close();
		}catch(Exception e){
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
	public Boolean getLog() {
		return log;
	}
	public void setLog(Boolean log) {
		this.log = log;
	}
	
}
