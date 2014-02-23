module metrics

import IO;
import String;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;


public void metricas(){

	myModel = createM3FromEclipseProject(|project://Java|);
	println(myModel);
	println(".................................................");
	println(myModel@containment);
	println(".................................................");
	println(myModel@containment[|java+class:///mundos/HolaMundo|]);
	println(".................................................");
    //s = "\"java+method\"";
	helloWorldMethods = [ e | e <- myModel@containment[|java+class:///mundos/HolaMundo|], e.scheme == "java+method"];
	println(helloWorldMethods);
	
}
