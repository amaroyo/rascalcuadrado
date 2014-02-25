module demo

import IO;
import List;
import lang::java::jdt::m3::Core;
import lang::java::m3::Core;

public void extractInfo(project) {
	myModel = createM3FromEclipseProject(project);
	classNames = [ c | <c,l> <- myModel@names, isClass(l)];
	println("Class Names");
	println(classNames);
	println("-------------------------------------------");
	fieldNames = [ f | <f,l> <- myModel@names, isField(l)];
	println("Field Names");
	println(fieldNames);
	println("-------------------------------------------");
	staticFieldNames = [ f | <f,l> <- myModel@names, <l,\static()> <- myModel@modifiers, isField(l)];
	println("Static Field Names");
	println(staticFieldNames);
	println("-------------------------------------------");
	println("Method Signatures");
	methodSignatures = [m | <l,m> <- myModel@types, isMethod(l)];
	println(methodSignatures);
	println("-------------------------------------------");
	println("Associations");
	println("-------------------------------------------");
	println("Generalisations");
	println("-------------------------------------------");
	println("Realisations");
	println("-------------------------------------------");
	println("Dependencies");
}