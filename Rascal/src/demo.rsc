module demo

import IO;

public int fac(int N){
	if(N==0) return 1;
	return N*fac(N-1);
}

public void squares(int N){
	 println("Table of squares from 0 to <N>");
	 for(int i<-[0..N+1]){
	 println("<i> squared = <i*i>");
	 }
}