module FlowGraphsAndClassDiagrams
 
/*Example code to compute flow graphs for Java and some basic UML diagramming*/ 
 
import lang::ofg::ast::FlowLanguage;
import lang::ofg::ast::Java2OFG;
import List;
import Relation;
import lang::java::m3::Core;
import Set;
import String;
 
import IO;
import vis::Figure; 
import vis::Render;
 
alias OFG = rel[loc from, loc to];
public loc emptyLoc = |id:///|;

 
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


rel[loc,loc] generators(Program p) 
  = { <cl + "this", c > | newAssign(_, cl, c, _) <- p.statemens };

rel[loc,loc] generators54(Program p) 
  = { <y, c > | assign(_, c, y) <- p.statemens }
  + { <m + "return", c> |  call(_, c, _, m, _) <- p.statemens}
  ;

   
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

public OFG algorithm(M3 m, OFG g, Program p) {
	OFG propOfg = {};
	gen=generators(p)+generators54(p);
	propOfg = propOfg + prop(g,gen,toRel([]),false);
	propOfg = propOfg + prop(g,gen,toRel([]),true);
	return propOfg;
}
 
public void drawDiagram(M3 m, OFG omg) {
	
  classFigures = [box(text("<cl.path[1..]>"), id("<cl>"),shadow(false), shadowColor("WhiteSmoke")) | cl <- classes(m)]; 
  		  

  edges = // Generalizations
  		  [edge("<to>", "<from>", fromArrow(ellipse(size(20), fillColor("MediumPurple")))) | 
  		  			<from,to> <- m@extends, from <- classes(m), to <- classes(m)]
 		  
 		  // Associations/Aggregations 
          + [edge("<to>", "<c>", fromArrow(box(size(20),fillColor("LightSkyBlue")))) |
          			<from,to> <- m@typeDependency, isField(from), to <- classes(m), <c,from> <- m@containment]
          
          // Dependencies
       //  + [ edge("<to>", "<c>", fromArrow(box(size(20),fillColor("LightSkyBlue"))),lineStyle("dash")) | 
       //  			<from,to> <- m@typeDependency, isMethod(from), to <- classes(m), <c,from> <- m@containment, c != to]
         
          // Realizations
          + [edge("<to>", "<from>", toArrow(ellipse(size(20), fillColor("MediumSeaGreen") )),lineStyle("dash")) | 
          			<to,from> <- m@implements, from <- classes(m), to <- classes(m)]
			
			
		  + [edge("<to>", "<c>", fromArrow(box(size(20),fillColor("LightSkyBlue")))) |
          			<from,to> <- omg, isField(from), to <- classes(m), <c,from> <- m@containment]          
          ;
          
 // figure = graph(classFigures, edges, hint("layered"), std(gap(46)), std(font("Bitstream Vera Sans")), std(fontSize(12)));
 // render(figure);
 // renderSave(figure, |file:///Users/Aleks/Desktop/figuraRascal.png|);
  showDot(m, omg, |file:///Users/Aleks/Desktop/<m.id.authority>.dot|);
  //showDot(m, omg, |home:///<m.id.authority>.dot|);
  
}
 
public str dotDiagram(M3 m, OFG omg) {
ret="ret";
  return "digraph classes {
         '  fontname = \"Bitstream Vera Sans\"
         '  fontsize = 8
         '  node [ fontname = \"Bitstream Vera Sans-bold\" fontsize = 10 shape = \"record\" ]
         '  edge [ fontname = \"Bitstream Vera Sans\" fontsize = 8 ]
         '
         '  <for (c <- classes(m)) {> 
         '		\"N<c>\" [label=\"{<c.path[1..]>|<for(<c,f> <- m@containment, <f,t> <- m@typeDependency, f <- fields(m), !isInterface(t)){>+ <f.file> : <t.file>\\l<}>|
         		'<for(<c,metodo> <- m@containment, metodo <- methods(m)){>+ <replaceAll(metodo.file,"java.lang.","")> : <ret>\\l<}>
         '		}\"]
         '  <} /* this is the end of the for loop */>
         ' 
         '  edge [arrowhead=\"empty\"]
         '  <for (<from, to> <- m@extends, from <- classes(m), to <- classes(m)) {>
         '  \"N<from>\" -\> \"N<to>\" <}>
		 '
         '  
         '  <for (<from,to> <- m@typeDependency + omg, isField(from), to <- classes(m), <c,from> <- m@containment, c != to, <name,from> <- m@names) {>
         '  edge [arrowhead=\"normal\"
         '		  label =\"<name>\"]
         '  \"N<c>\" -\> \"N<to>\" <}>
		 '
         '  edge [arrowhead=\"empty\"
         '		  style=\"dashed\"]
         '  <for (<to,from> <- m@implements, from <- classes(m), to <- classes(m)) {>
         '  \"N<to>\" -\> \"N<from>\" <}>
         '
         ' /* edge [arrowhead=\"normal\"
         '		  style=\"dashed\"]
         '  <for (<from,to> <- m@typeDependency, isMethod(from), to <- classes(m), <c,from> <- m@containment, c != to) {>
         '  \"N<c>\" -\> \"N<to>\" <}> */
       
        
     
         '}";
}
 
public void showDot(M3 m) = showDot(m, |home:///<m.id.authority>.dot|);
 
public void showDot(M3 m, OFG omg, loc out) {
  writeFile(out, dotDiagram(m,omg));
}