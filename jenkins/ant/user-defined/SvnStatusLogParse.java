package hayden;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.List;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

/**
 * 此类是负责分析svn命令行命令svn status输出的日志，进行分析
 * 并把符合条件的文件名输出到文件
 * @author 张海亮
 *
 */
public class SvnStatusLogParse extends Task{
	private String statusInfoFile="";//svn status路径
	private String listFile=""; //输出文件名路径的文件
	private String jarDir="WEB-INF/lib/";//输出文添加路径，默认为lib文件夹
	private String status="?";//要过滤的状态，默认的为无版本状态
	private String excludeFile=".svn";//需要排除的文件名，默认为空
	private Boolean log=false; //是否输出log
	
	public void execute() throws BuildException {
		if("".equals(listFile)) throw new BuildException("output list file not set");
		if("".equals(statusInfoFile)) throw new BuildException("status log file not set");
		
		try {
			//读取文件，打开输出文件
			BufferedReader reader = new BufferedReader(
                    new InputStreamReader(new FileInputStream(statusInfoFile)));

			String line="";
			List<String> str =new ArrayList<String>();
			//将读取的文件存储到str链表中
			while((line=reader.readLine())!=null){
				if(log){
					log(line);
					log("status"+status);
					log("excludeFile"+excludeFile);
				}
				if(line.contains(status)&&!line.contains(excludeFile)){
					str.add(line);
					if(log) log(line);
				}			
			}
			if(!str.isEmpty()){
				BufferedWriter writer = new BufferedWriter(
		                   new OutputStreamWriter(new FileOutputStream(listFile,true)));
				for(String strTmp:str){
					strTmp=strTmp.substring(strTmp.indexOf(" "),strTmp.length());
					strTmp=strTmp.trim();
					if(!("".equals(jarDir))) strTmp=jarDir+strTmp;
					writer.newLine();
					writer.write(strTmp);
					log("增加jar包清单："+strTmp);
				}
				writer.close();
			}
			
			reader.close();
			
		}catch (IOException e) {   
            e.printStackTrace();  
            throw new BuildException(e.toString());
		}
	}

	public Boolean getLog() {
		return log;
	}

	public void setLog(Boolean log) {
		this.log = log;
	}

	public String getStatusInfoFile() {
		return statusInfoFile;
	}

	public void setStatusInfoFile(String statusInfoFile) {
		this.statusInfoFile = statusInfoFile;
	}

	public String getListFile() {
		return listFile;
	}

	public void setListFile(String listFile) {
		this.listFile = listFile;
	}



	public String getJarDir() {
		return jarDir;
	}

	public void setJarDir(String jarDir) {
		this.jarDir = jarDir;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getExcludeFile() {
		return excludeFile;
	}

	public void setExcludeFile(String excludeFile) {
		this.excludeFile = excludeFile;
	}

}
