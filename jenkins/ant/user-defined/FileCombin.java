package hayden;
/**
 * 处理文件清单类
 * 其中srcString可以处理新增一行目录
 * productString是在清单的每一行最前面增加一串数字
 * destFile是合并srcFile和destFile功能
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
    private File srcFile=null; //原文件
    private File destFile=null; //目标文件
    private File finalFile=null; //处理文件中每行前增加字符串的目标文件
    private String srcString=null;  //需要增加的字符串
    private String addString=null;  //每行增加的字符串

    @Override
    public void execute() throws BuildException {
        try {
           /*
            * 合并两个txt文件
            * 此处主要是合并list清单和内部类清单
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
            log(srcFile.getName()+"合并到list");
            writer.close();
            reader.close();
        	}
        	/*
             * 向清单中插入一条数据
             * 主要是涉及压缩的情况，需要新增一个文件路径
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
        	 * 此功能主要是涉及形成生产备份文件的清单使用
        	 * 在每条目录前加入生产路径
        	 * 因为一个文件不能同时读写，所以必须使用临时文件destFile
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
        		 log(addString+"字符已添加");
        	reader.close();
        	writer.close();
        	}
        	/**
        	 * 在finalfile中每一行加入字符串
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