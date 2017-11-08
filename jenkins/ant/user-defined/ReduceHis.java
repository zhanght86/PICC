package hayden;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

public class ReduceHis  extends Task{
	private String srcFile; //需要处理的文件
	private int limitNum=100; //定义文件最大行数
	
	public void execute() throws BuildException {
 		try{
 			if(srcFile.isEmpty()) throw new BuildException("srcFile not set");
 			//if(limitNum==0) throw new BuildException("srcFile not set");
 			
 			BufferedReader reader = new BufferedReader(
          			 new InputStreamReader(new FileInputStream(srcFile)));
 			List<String> str=new ArrayList<String>();
 			String line="";
 			while((line=reader.readLine())!=null){
 				str.add(line);
 			}
 			reader.close();
 			/**
 			 * 清空文件
 			 */
 			File file =new File(srcFile);
 			FileWriter fileWriter =new FileWriter(file);
 			fileWriter.write("");
 			fileWriter.flush();
 			fileWriter.close();
 			/**
 			 * 去重复
 			 */
 			Map<String,String> map = new HashMap<String,String>();   
				for(int i = 0;i < str.size();i++){
					if(!map.containsKey(str.get(i))){
						map.put(str.get(i), "");
					}
				}
				str = new ArrayList<String>();
				for (Map.Entry<String, String> m : map.entrySet()) { 
		            str.add(m.getKey());
		        }  
 			
 			BufferedWriter writer = new BufferedWriter(
                     new OutputStreamWriter(new FileOutputStream(srcFile)));
 			int i=0;
 			for(String strTemp:str){
 				i++;
 				writer.write(strTemp);
 				writer.newLine();
 				if(i>limitNum) break;
 			}
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
	public int getLimitNum() {
		return limitNum;
	}
	public void setLimitNum(int limitNum) {
		this.limitNum = limitNum;
	}
	

}
