module FlowGraphsAndClassDiagrams
 
/*Example code to compute flow graphs for Java and some basic UML diagramming*/ 
 
import lang::ofg::ast::FlowLanguage;
import lang::ofg::ast::Java2OFG;
import List;
import Relation;
import lang::java::m3::Core;
 
import IO;
import vis::Figure; 
import vis::Render;
 
alias OFG = rel[loc from, loc to];
 
public OFG buildGraph(Program p){ 
	OFG myFlowGraph = 
		{ <as[i], fps[i]> | newAssign(x, cl, c, as) <- p.statemens, constructor(c, fps) <- p.decls, i <- index(as) }
  		+ { <cl + "this", x> | newAssign(x, cl, _, _) <- p.statemens }
  		+ { <x,y> | assign(x, _, y) <- p.statemens }
  		+ { <as[i], fps[i]> | call(x, _, y, m, as) <- p.statemens, method(m, fps) <- p.decls, i <- index(as) }   
		+ { <y, m + "this"> | call(_, _, y, m, _) <- p.statemens }
		+ { <m + "return", x> | call(x, _, _, m, _) <- p.statemens, x != emptyId}
		;
  
  return myFlowGraph;
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

public OFG algorithm(OFG g) {
	OFG aux = {};
	case1 = { <f,c> | <f,c> <- myModel@typeDependency, isMethod(f), c <- classes(myModel)};

		aux += prop(g,{r},toRel([]),false);
	}
	return aux;
}
 
public void drawDiagram(M3 m, OFG g) {
  classFigures = [box(text("<cl.path[1..]>"), id("<cl>")) | cl <- classes(m)]; 
  		  // Generalizations
  edges = [edge("<to>", "<from>", fromArrow(box(size(20)))) | <from,to> <- m@extends, from <- classes(m), to <- classes(m)]
 		  
 		  // Associations/Aggregations
          + [edge("<to>", "<c>", fromArrow(box(size(20)))) | <from,to> <- m@typeDependency, isField(from), to <- classes(m), <c,from> <- m@containment]
          
          // Dependencies
          //+ [ edge("<to>", "<c>") | <from,to> <- m@typeDependency, isMethod(from), to <- classes(m),<c,from> <- m@containment
         
          // Realizations
          + [edge("<to>", "<from>", toArrow(box(size(20)))) | <to,from> <- m@implements, from <- classes(m), to <- classes(m)]
          
          ;
  //edges += [edge("<to>", "<c>", fromArrow(box(size(20)))) | <to,from> <- g, isField(from), to <- classes(m), <c,from> <- m@containment];
  render(graph(classFigures, edges, hint("layered"), std(gap(50)), std(font("Bitstream Vera Sans")), std(fontSize(12))));
}
 
public str dotDiagram(M3 m) {
  return "digraph classes {
         '  fontname = \"Bitstream Vera Sans\"
         '  fontsize = 8
         '  node [ fontname = \"Bitstream Vera Sans\" fontsize = 8 shape = \"record\" ]
         '  edge [ fontname = \"Bitstream Vera Sans\" fontsize = 8 ]
         '
         '  <for (cl <- classes(m)) { /* a for loop in a string template, just like PHP */>
         ' \"N<cl>\" [label=\"{<cl.path[1..] /* a Rascal expression between < > brackets is spliced into the string */>||}\"]
         '  <} /* this is the end of the for loop */>
         '
         '  <for (<from, to> <- m@extends) {>
         '  \"N<to>\" -\> \"N<from>\" [arrowhead=\"empty\"]<}>
         '}";
}
 
public void showDot(M3 m) = showDot(m, |home:///<m.id.authority>.dot|);
 
public void showDot(M3 m, loc out) {
  writeFile(out, dotDiagram(m));
}