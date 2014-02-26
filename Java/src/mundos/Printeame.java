package mundos;

import java.util.ArrayList;

public class Printeame /*extends ArrayList<String> */ extends HolaMundo{

	String msg;

	
	public Printeame(String msg) {
		this.msg = msg;
	}
	
	public Printeame() {
		msg = "pedoMinion";
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	
}
