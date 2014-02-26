module Tool

import IO;
import List;
import lang::java::jdt::m3::Core;
import lang::java::m3::Core;

public void extractInfoFromM3(project) {
	myModel = createM3FromEclipseProject(project);
	
	//classNames = [ c | <c,l> <- myModel@names, isClass(l)];
	classNames = classes(myModel);
	println("Class Names");
	println(classNames);
	println("-------------------------------------------");
	
	//fieldNames = [ f | <f,l> <- myModel@names, isField(l)];
	fieldNames = fields(myModel);
	println("Field Names");
	println(fieldNames);
	println("-------------------------------------------");
	
	
	staticFieldNames = { f | f <- fieldNames, <f,\static()> <- myModel@modifiers, isField(f)};
	println("Static Field Names");
	println(staticFieldNames);
	println("-------------------------------------------");
	
	//methodSignatures = methods(myModel);
	methodSignatures = {m | <l,m> <- myModel@types, isMethod(l)};
	println("Method Signatures");
	println(methodSignatures);
	println("-------------------------------------------");
	
	associationRelationships = { <f,c> | <f,c> <- myModel@typeDependency, isField(f), isClass(c)};
	println("Associations/Aggregation");
	println(associationRelationships);
	println("-------------------------------------------");
	
	dependencyRelationships = { <f,c> | <f,c> <- myModel@typeDependency, isMethod(f), isClass(c)};
	println("Dependencies");
	println(dependencyRelationships);
	println("-------------------------------------------");
	
	generalizationRelationships = { <c1,c2> | <c1,c2> <- myModel@extends, isClass(c1), isClass(c2)};
	println("Generalizations");
	println(generalizationRelationships);
	println("-------------------------------------------");
	
	realizationRelationships = { <c1,c2> | <c1,c2> <- myModel@typeDependency, isClass(c1), isInterface(c2)};
	println("Realization");
	println(realizationRelationships);
	
	println();
	println();
	println();
	println(methods(myModel));
	
}