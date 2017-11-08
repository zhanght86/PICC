package hayden;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

public class BuildFail  extends Task{
	String msg=null;
	public void execute() throws BuildException{
	throw new BuildException(msg);
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	
}
