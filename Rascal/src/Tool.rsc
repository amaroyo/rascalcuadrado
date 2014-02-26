module Tool

import IO;
import List;
import Relation;

//Information extraction
import lang::java::jdt::m3::Core;
import lang::java::m3::Core;

//Architecture reconstruction
import lang::ofg::ast::Java2OFG;
import lang::ofg::ast::FlowLanguage;

alias OFG = rel[loc from, loc to];

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
	
	return myModel;
	
}

//Architecture reconstruction
public Program reconstructArquitecture(project) {
	Program myFlowProgram = createOFG(project);
	return myFlowProgram;
}

//
public OFG buildGraph(Program p) {
	OFG myObjectFlowGraph =
	{ <as[i], fps[i]> | newAssign(x, cl, c, as) <- p.statements, constructor(c, fps) <- p.decls, i <- index(as) }
	+ { <cl + "this", x> | newAssign(x, cl, _, _) <- p.statements } + { <Y , x> | assign(x, _, Y) <- p.statements};
	
	println(myObjectFlowGraph);
	
	return myObjectFlowGraph;
}

OFG prop(OFG g, rel[loc,loc] gen, rel[loc,loc] kill, bool back) {
  OFG IN = { };
  OFG OUT = gen + (IN - kill);
  gi = g<to,from>;
  set[loc] pred(loc n) = gi[n];
  set[loc] succ(loc n) = g[n];
  
  solve (IN, OUT) {
    IN = { <n,\o> | n <- carrier(g), p <- (back ? pred(n) : succ(n)), \o <- OUT[p] };
    OUT = gen + (IN - kill);
  }
  
  return OUT;
}