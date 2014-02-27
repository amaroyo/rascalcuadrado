package mundos;



public class HolaMundo implements Comparable {

	/**
	 * 
	 */
	private static int caca;
	private Boolean b;
	private Printeame p3;
	
	public class Hola2 {
		
		
	}
	
	String mycosa = "hola world";
	
	public HolaMundo() {
		// TODO Auto-generated constructor stub
		System.out.println("Hola mundo:");
		System.out.println(mycosa);
		metodoAdios(HolaMundoEnum.rascalmeGatita.toString());
		Printeame p = new Printeame();
		//GenericsType<Printeame> g = new GenericsType<>();
		
	}

	public void f(Printeame p) {p.getMsg(); }
	public void f2() {Printeame p2 = new Printeame("pis"); p2.getMsg();}
	
	public void metodoAdios(String s) {
		System.out.println(s);
		System.out.println("Adios.");
	}

	public boolean sacamela(String s, HolaMundo i, String s1) {
		if(s != null)
			return true;
		else
			return false;
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public int compareTo(Object o) {
		// TODO Auto-generated method stub
		return 0;
	}

}
