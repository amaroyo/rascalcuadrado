package mundos;



public class HolaMundo {

	/**
	 * 
	 */
	String mycosa = "hola world";
	
	public HolaMundo() {
		// TODO Auto-generated constructor stub
		System.out.println("Hola mundo:");
		System.out.println(mycosa);
		metodoAdios(HolaMundoEnum.rascalmeGatita.toString());
	}

	public void metodoAdios(String s) {
		System.out.println(s);
		System.out.println("Adios.");
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		HolaMundo mundo = new HolaMundo();
		mundo.metodoAdios(HolaMundoEnum.rascalmePerrita.toString());

	}

}
