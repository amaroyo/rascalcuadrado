module M3ModelsAndFlowPrograms

import IO;
import List;
import Relation;

//Information extraction
import lang::java::jdt::m3::Core;
import lang::java::m3::Core;

//Architecture reconstruction
import lang::ofg::ast::Java2OFG;
import lang::ofg::ast::FlowLanguage;


//Information extraction
public M3 extractInfo(project) {

	M3 myModel = createM3FromEclipseProject(project);
	
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
	
	associationRelationships = { <f,c> | <f,c> <- myModel@typeDependency, isField(f), c <- classes(myModel)};
	println("Associations/Aggregations");
	println(associationRelationships);
	println("-------------------------------------------");
	
	dependencyRelationships = { <f,c> | <f,c> <- myModel@typeDependency, isMethod(f), c <- classes(myModel)};
	println("Dependencies");
	println(dependencyRelationships);
	println("-------------------------------------------");
	
	generalizationRelationships = { <c1,c2> | <c1,c2> <- myModel@extends, from <- classes(m), to <- classes(m)};
	println("Generalizations");
	println(generalizationRelationships);
	println("-------------------------------------------");
	
	realizationRelationships = { <c1,c2> | <c1,c2> <- myModel@implements, from <- classes(m), to <- classes(m)};
	println("Realizations");
	println(realizationRelationships);
	
	return myModel;
	
}

//Architecture reconstruction
public Program reconstructArquitecture(project) {
	Program myFlowProgram = createOFG(project);
	return myFlowProgram;
}