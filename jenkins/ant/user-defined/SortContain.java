package hayden;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
//import java.util.HashSet;
import java.util.List;
import java.util.Map;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

/**
 * 对txt内容进行排序
 * 主要是对sql执行进行排序
 * @author zhanghailiang
 *
 */
public class SortContain extends Task{
	 	private String srcFile=null;  //源文件
	 	private String historyLog=null; //执行历史文件
	 	private Boolean log=false;	//是否输出日志
	 	private Boolean checkHistory=true; //是否检查历史已经执行过
	 	private String flag="-"; //分隔符
	 	private Boolean sort=false; //是否进行排序
	 	private String regFile=null;//规则对应文件，即那些系统对应那些数据库
	 	private Boolean removeRepeat=false;//是否去除重复
	 	
	 	
	 //	private String utility=null; //那些系统的sql
	 	
	 	
	 	
		public void execute() throws BuildException {
	 		try{
	 			if(srcFile==null)  throw new BuildException("srcFile not set");
	 			if(!sort&&!removeRepeat){
	 				if(historyLog==null)  throw new BuildException("historyLog not set");
	 			}


	 			BufferedReader reader = new BufferedReader(
           			 new InputStreamReader(new FileInputStream(srcFile)));
	 			String line="";
	 			String history="";
	 			Boolean find=false;
//	 			Boolean bl=false;
	 			List<String> str =new ArrayList<String>();
	 			List<String> regStr=new ArrayList<String>();
	 				 			
	 			while((line=reader.readLine())!=null){
		 			if(line.length()>0){
		 				if(log)
		 				{
		 					log(line);
		 				}
		 				if(checkHistory&&historyLog!=null){//是否检查历史执行记录
		 					find=false;//循环前先置标志位为false
		 					BufferedReader readerHis = new BufferedReader(
				           			 new InputStreamReader(new FileInputStream(historyLog)));
		 					while((history=readerHis.readLine())!=null)//读取历史记录，并循环
		 					{
		 						
		 						if(history.startsWith("#")) continue;
		 						else if(history.contains(line)){
		 							find=true;
		 							break;//一旦找到结束循环退出
		 						}
		 					}	 					
		 		 			readerHis.close();
		 				}
		 				if(checkHistory&&find){
		 					continue;//存在记录，本次循环结束
		 				}
		 				else str.add(line);
		 			}
	 			}
	 			reader.close(); 
	 			/**
	 			 * list内容去除包含关系
	 			 */
	 			if(removeRepeat&&!sort){
	 				Map<String,String> maplist = new HashMap<String,String>();
	 				for(int i = 0;i < str.size();i++){
	 					if(!maplist.containsKey(str.get(i))){
	 						maplist.put(str.get(i), str.get(i));
	 					}
	 				}
	 				
	 				for(int i = 0;i < str.size();i++){
	 					if(str.get(i).contains(".")){
	 						continue; 							
 						}//只去除目录的包含关系	 				
	 					else {
	 					for(int j=0;j< str.size();j++){
	 						if(log){
	 						log("map清单"+maplist.get((str.get(j))));
	 						log("list清单"+str.get(j));
	 						}
	 						if(maplist.containsKey(str.get(j))&&!maplist.get(str.get(j)).contains(".")){
	 						if(maplist.get(str.get(j)).startsWith(str.get(i))&&!maplist.get(str.get(j)).equals(str.get(i))){
	 							log("当前清单"+str.get(i));
	 							maplist.remove(str.get(j));
	 							}	
	 						}
 						}
	 				}
	 				
	 					str = new ArrayList<String>();
		 				for (Map.Entry<String, String> m : maplist.entrySet()) { 
		 					if(log){
		 		            log("key:"+m.getKey()+" value"+m.getValue()); 
		 					}
		 		            str.add(m.getKey());
		 		        }
	 				}
	 				BufferedWriter writer = new BufferedWriter(
	                        new OutputStreamWriter(new FileOutputStream(srcFile)));
					for(String strTmp:str){
						log("增加清单："+strTmp);
		                writer.write(strTmp);
		                writer.newLine();
					}
					writer.close();
	 			}
	 			if(sort){
	 				if(regFile==null) throw new BuildException("regFile not set");
		 			BufferedReader readReg = new BufferedReader(
		           			 new InputStreamReader(new FileInputStream(regFile)));
		 			while((line=readReg.readLine())!=null){
		 				regStr.add(line);
		 			}
	 				for(int i=0;i<str.size();i++){
	 					if(str.get(i).startsWith("sql")){
	 						str.set(i, str.get(i).substring(str.get(i).indexOf(flag)+1, str.get(i).length()));
	 					}
		 				
		 			}
	 				
//	 				HashSet<String> hs = new HashSet<String>(str); //去除str中重复的项
//	 				str.removeAll(str);   //先清空list
//	 				for (String tmpStr : hs) {  //再将hash中的内容放到list中
//	 				    str.add(tmpStr);
//	 				   }
	 				/**
	 				 * list内容去重复
	 				 */
	 				Map<String,String> map = new HashMap<String,String>();   
	 				for(int i = 0;i < str.size();i++){   //去除完全重复内容
	 					if(!map.containsKey(str.get(i))){
	 						map.put(str.get(i), "");
	 					}
	 				}
	 				str = new ArrayList<String>();
	 				for (Map.Entry<String, String> m : map.entrySet()) { 
	 					if(log){
	 		            log("key:"+m.getKey()+" value"+m.getValue()); 
	 					}
	 		            str.add(m.getKey());
	 		        }  
		 			Collections.sort(str);
		 			for(String strTmp:str){
		 				for(String regTmp:regStr){
		 					if(log){
		 					log("截出系统名称："+strTmp.substring(strTmp.lastIndexOf("/", strTmp.lastIndexOf("/", strTmp.lastIndexOf("/")-1)-1)+1, strTmp.lastIndexOf("/", strTmp.lastIndexOf("/")-1)));
		 					log("reg字符串："+regTmp);
		 					log("sql路径："+strTmp);
		 					}
		 					if(regTmp.contains(strTmp.substring(strTmp.lastIndexOf("/", strTmp.lastIndexOf("/", strTmp.lastIndexOf("/")-1)-1)+1, strTmp.lastIndexOf("/", strTmp.lastIndexOf("/")-1)))){
		 						if(!strTmp.substring(strTmp.lastIndexOf("/")+1, strTmp.length()).contains("productonly")){
		 						BufferedWriter writer = new BufferedWriter(
		 		                        new OutputStreamWriter(new FileOutputStream(regTmp.substring(0, regTmp.indexOf(" ")),true)));
		 		                writer.write(strTmp);
		 		                log(regTmp.substring(0, regTmp.indexOf(" "))+"添加sql："+strTmp.substring(strTmp.lastIndexOf("/")+1, strTmp.length()));
		 		                writer.newLine();
		 		                writer.close();
		 						}
		 						break;
		 					}		 					
		 				}
		 			}
		 			readReg.close();
	 			}
	 			
	 			
	 		
	 			}catch (Exception e) {
	 				e.printStackTrace();
	           throw new BuildException(e.toString());
		   	}
	   }

		public Boolean getRemoveRepeat() {
			return removeRepeat;
		}

		public void setRemoveRepeat(Boolean removeRepeat) {
			this.removeRepeat = removeRepeat;
		}

		public String getRegFile() {
			return regFile;
		}

		public void setRegFile(String regFile) {
			this.regFile = regFile;
		}

		public String getFlag() {
			return flag;
		}

		public void setFlag(String flag) {
			this.flag = flag;
		}

		public Boolean getSort() {
			return sort;
		}

		public void setSort(Boolean sort) {
			this.sort = sort;
		}

		public String getHistoryLog() {
			return historyLog;
		}

		public void setHistoryLog(String historyLog) {
			this.historyLog = historyLog;
		}

		public Boolean getCheckHistory() {
			return checkHistory;
		}

		public void setCheckHistory(Boolean checkHistory) {
			this.checkHistory = checkHistory;
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
