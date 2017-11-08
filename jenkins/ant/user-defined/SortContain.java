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
 * ��txt���ݽ�������
 * ��Ҫ�Ƕ�sqlִ�н�������
 * @author zhanghailiang
 *
 */
public class SortContain extends Task{
	 	private String srcFile=null;  //Դ�ļ�
	 	private String historyLog=null; //ִ����ʷ�ļ�
	 	private Boolean log=false;	//�Ƿ������־
	 	private Boolean checkHistory=true; //�Ƿ�����ʷ�Ѿ�ִ�й�
	 	private String flag="-"; //�ָ���
	 	private Boolean sort=false; //�Ƿ��������
	 	private String regFile=null;//�����Ӧ�ļ�������Щϵͳ��Ӧ��Щ���ݿ�
	 	private Boolean removeRepeat=false;//�Ƿ�ȥ���ظ�
	 	
	 	
	 //	private String utility=null; //��Щϵͳ��sql
	 	
	 	
	 	
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
		 				if(checkHistory&&historyLog!=null){//�Ƿ�����ʷִ�м�¼
		 					find=false;//ѭ��ǰ���ñ�־λΪfalse
		 					BufferedReader readerHis = new BufferedReader(
				           			 new InputStreamReader(new FileInputStream(historyLog)));
		 					while((history=readerHis.readLine())!=null)//��ȡ��ʷ��¼����ѭ��
		 					{
		 						
		 						if(history.startsWith("#")) continue;
		 						else if(history.contains(line)){
		 							find=true;
		 							break;//һ���ҵ�����ѭ���˳�
		 						}
		 					}	 					
		 		 			readerHis.close();
		 				}
		 				if(checkHistory&&find){
		 					continue;//���ڼ�¼������ѭ������
		 				}
		 				else str.add(line);
		 			}
	 			}
	 			reader.close(); 
	 			/**
	 			 * list����ȥ��������ϵ
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
 						}//ֻȥ��Ŀ¼�İ�����ϵ	 				
	 					else {
	 					for(int j=0;j< str.size();j++){
	 						if(log){
	 						log("map�嵥"+maplist.get((str.get(j))));
	 						log("list�嵥"+str.get(j));
	 						}
	 						if(maplist.containsKey(str.get(j))&&!maplist.get(str.get(j)).contains(".")){
	 						if(maplist.get(str.get(j)).startsWith(str.get(i))&&!maplist.get(str.get(j)).equals(str.get(i))){
	 							log("��ǰ�嵥"+str.get(i));
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
						log("�����嵥��"+strTmp);
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
	 				
//	 				HashSet<String> hs = new HashSet<String>(str); //ȥ��str���ظ�����
//	 				str.removeAll(str);   //�����list
//	 				for (String tmpStr : hs) {  //�ٽ�hash�е����ݷŵ�list��
//	 				    str.add(tmpStr);
//	 				   }
	 				/**
	 				 * list����ȥ�ظ�
	 				 */
	 				Map<String,String> map = new HashMap<String,String>();   
	 				for(int i = 0;i < str.size();i++){   //ȥ����ȫ�ظ�����
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
		 					log("�س�ϵͳ���ƣ�"+strTmp.substring(strTmp.lastIndexOf("/", strTmp.lastIndexOf("/", strTmp.lastIndexOf("/")-1)-1)+1, strTmp.lastIndexOf("/", strTmp.lastIndexOf("/")-1)));
		 					log("reg�ַ�����"+regTmp);
		 					log("sql·����"+strTmp);
		 					}
		 					if(regTmp.contains(strTmp.substring(strTmp.lastIndexOf("/", strTmp.lastIndexOf("/", strTmp.lastIndexOf("/")-1)-1)+1, strTmp.lastIndexOf("/", strTmp.lastIndexOf("/")-1)))){
		 						if(!strTmp.substring(strTmp.lastIndexOf("/")+1, strTmp.length()).contains("productonly")){
		 						BufferedWriter writer = new BufferedWriter(
		 		                        new OutputStreamWriter(new FileOutputStream(regTmp.substring(0, regTmp.indexOf(" ")),true)));
		 		                writer.write(strTmp);
		 		                log(regTmp.substring(0, regTmp.indexOf(" "))+"���sql��"+strTmp.substring(strTmp.lastIndexOf("/")+1, strTmp.length()));
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
