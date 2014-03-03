module main

import M3ModelsAndFlowPrograms;
import FlowGraphsAndClassDiagrams;



public void main(project){

	println("******************EXTRACTING INFORMATION*****************************");
	m = extractInfo(project);
	println(m);
	println("******************RECONSTRUCTING ARCHITECTURE************************");
	p = reconstructArchitecture(project);
	println(g);
	println("******************BUILDING GRAPH*************************************");
	g = buildGraph(p);
	println(g);
	println("******************OBJECT FLOW GRAPH**********************************");
	ofg = algorithm(m,g);
	println(ofg);
	drawDiagram(m,ofg);

}