module main

import M3ModelsAndFlowPrograms;
import FlowGraphsAndClassDiagrams;



public void main(project){

	m = extractInfo(project);
	p = reconstructArchitecture(project);
	g = buildGraph(p);
	ofg = algorithm(m,g);
	drawDiagram(m,ofg);

}