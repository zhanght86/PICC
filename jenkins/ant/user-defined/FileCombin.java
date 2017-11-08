package hayden;
/**
 * �����ļ��嵥��
 * ����srcString���Դ�������һ��Ŀ¼
 * productString�����嵥��ÿһ����ǰ������һ������
 * destFile�Ǻϲ�srcFile��destFile����
 */
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.List;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;
public class FileCombin extends Task{
    private File srcFile=null; //ԭ�ļ�
    private File destFile=null; //Ŀ���ļ�
    private File finalFile=null; //�����ļ���ÿ��ǰ�����ַ�����Ŀ���ļ�
    private String srcString=null;  //��Ҫ���ӵ��ַ���
    private String addString=null;  //ÿ�����ӵ��ַ���

    @Override
    public void execute() throws BuildException {
        try {
           /*
            * �ϲ�����txt�ļ�
            * �˴���Ҫ�Ǻϲ�list�嵥���ڲ����嵥
            */
        	if(srcFile!=null)
        	{
        		if(destFile==null) throw new BuildException("destFile not set");
        		if(srcString!=null) throw new BuildException("when srcFile seted,srcString can not set");
        		if(srcString!=null||addString!=null) throw new BuildException("when srcFile seted,only destFile should to set");
        			
        	BufferedWriter writer = new BufferedWriter(
                         new OutputStreamWriter(new FileOutputStream(destFile,true)));
            BufferedReader reader = new BufferedReader(
            			 new InputStreamReader(new FileInputStream(srcFile)));
  
            String line = "";
            while((line = reader.readLine()) != null){
            	writer.newLine();
                writer.write(line);
                
            }
            log(srcFile.getName()+"�ϲ���list");
            writer.close();
            reader.close();
        	}
        	/*
             * ���嵥�в���һ������
             * ��Ҫ���漰ѹ�����������Ҫ����һ���ļ�·��
             */
        	if(srcString!=null)
        	{
        		if(destFile==null) throw new BuildException("destFile not set");
        		if(srcFile!=null) throw new BuildException("when srcString seted,srcFile can not set");
        		if(addString!=null) throw new BuildException("when srcString seted,only destFile should to set");
        			
        		BufferedWriter writer = new BufferedWriter(
                        new OutputStreamWriter(new FileOutputStream(destFile,true)));
        		{
                writer.newLine();
                writer.write(srcString);
                log(srcString);
                 }
                writer.close();
            	}
        	/*
        	 * �˹�����Ҫ���漰�γ����������ļ����嵥ʹ��
        	 * ��ÿ��Ŀ¼ǰ��������·��
        	 * ��Ϊһ���ļ�����ͬʱ��д�����Ա���ʹ����ʱ�ļ�destFile
        	 */
        	if((finalFile!=null)&&(addString!=null)&&(destFile!=null))
        	{
//        		if(destFile==null) throw new BuildException("destFile not set");
        		if(srcFile!=null) throw new BuildException("when finalFile seted,srcFile can not set");
        		if(srcString!=null) throw new BuildException("when finalFile and addString seted,only destFile should to set");

        		
        		if(!finalFile.exists()){
        			 finalFile.createNewFile();
        		      }
        		BufferedReader reader = new BufferedReader(
                        new InputStreamReader(new FileInputStream(destFile)));
        		BufferedWriter writer = new BufferedWriter(
                        new OutputStreamWriter(new FileOutputStream(finalFile)));            	
        		String line="";
        		 while((line = reader.readLine()) != null){
        			 if(line.length()>3){
        			 line=addString.concat(line);
        			 writer.write(line);
        			 writer.newLine();
        			 }
        		 }
        		 log(addString+"�ַ������");
        	reader.close();
        	writer.close();
        	}
        	/**
        	 * ��finalfile��ÿһ�м����ַ���
        	 */
        	if((destFile==null)&&(finalFile!=null)&&(addString!=null)){
        		if(!finalFile.exists()){
       			 finalFile.createNewFile();
       		      }
        		BufferedReader reader = new BufferedReader(
                        new InputStreamReader(new FileInputStream(finalFile)));
        		List<String> str=new ArrayList<String>();
        		String line="";
        		
        		while((line=reader.readLine())!=null){
        			str.add(line);
        		}
        		reader.close();
        		BufferedWriter writer = new BufferedWriter(
                        new OutputStreamWriter(new FileOutputStream(finalFile)));  
        		for(String strTmp:str){
        			writer.write(addString+strTmp);
        			writer.newLine();
        		}
        		writer.close();
        	}
        	
        } catch (Exception e) {
            e.printStackTrace();
            throw new BuildException(e.toString());
        }
//        super.execute();
    }
    public File getSrcFile() {
        return srcFile;
    }
    public void setSrcFile(File srcFile) {
        this.srcFile = srcFile;
    }
    public File getDestFile() {
        return destFile;
    }
    public void setDestFile(File destFile) {
         this.destFile = destFile;
    }
    public String getSrcString() {
        return srcString;
   }
    public void setSrcString(String str) {
        this.srcString = str;
   }
    public String getAddString() {
        return addString;
   }
    public void setAddString(String str) {
        this.addString = str;
   }
    public File getFinalFile() {
        return finalFile;
    }
    public void setFinalFile(File finalFile) {
         this.finalFile = finalFile;
    }
}