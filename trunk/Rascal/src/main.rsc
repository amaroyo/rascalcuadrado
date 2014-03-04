module main

import M3ModelsAndFlowPrograms;
import FlowGraphsAndClassDiagrams;
import IO;

//Information extraction
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

public M3 main(project){

	println("******************EXTRACTING INFORMATION*****************************");
	m = extractInfo(project);
	println(m);
	println("******************RECONSTRUCTING ARCHITECTURE************************");
	p = reconstructArchitecture(project);
	println(p);
	println("******************BUILDING GRAPH*************************************");
	g = buildGraph(p);
	println(g);
	println("******************OBJECT FLOW GRAPH**********************************");
	ofg = algorithm(m,g,p);
	println(ofg);
	drawDiagram(m,ofg);
	return m;

}