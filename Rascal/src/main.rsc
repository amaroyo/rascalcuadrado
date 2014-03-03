module main

import M3ModelsAndFlowPrograms;
import FlowGraphsAndClassDiagrams;

import IO;

public void main(project){

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

}