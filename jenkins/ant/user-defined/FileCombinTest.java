package hayden;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import static org.junit.Assert.*;

import org.junit.Test;

public class FileCombinTest {
	
	String str=null;
	File filename=null;
	FileCombin fileCombin;

	@Test
	public void test() {
		str="E:/";
		filename=new File("D:/work/����ũ��/05��������/ant�ű�/list.txt");
		fileCombin.setAddString(str);
		fileCombin.setDestFile(filename);
		fileCombin.execute();
		fail("Not yet implemented");
	}

}
