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
 * �����Ǹ������svn����������svn status�������־�����з���
 * ���ѷ����������ļ���������ļ�
 * @author �ź���
 *
 */
public class SvnStatusLogParse extends Task{
	private String statusInfoFile="";//svn status·��
	private String listFile=""; //����ļ���·�����ļ�
	private String jarDir="WEB-INF/lib/";//��������·����Ĭ��Ϊlib�ļ���
	private String status="?";//Ҫ���˵�״̬��Ĭ�ϵ�Ϊ�ް汾״̬
	private String excludeFile=".svn";//��Ҫ�ų����ļ�����Ĭ��Ϊ��
	private Boolean log=false; //�Ƿ����log
	
	public void execute() throws BuildException {
		if("".equals(listFile)) throw new BuildException("output list file not set");
		if("".equals(statusInfoFile)) throw new BuildException("status log file not set");
		
		try {
			//��ȡ�ļ���������ļ�
			BufferedReader reader = new BufferedReader(
                    new InputStreamReader(new FileInputStream(statusInfoFile)));

			String line="";
			List<String> str =new ArrayList<String>();
			//����ȡ���ļ��洢��str������
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
					log("����jar���嵥��"+strTmp);
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
