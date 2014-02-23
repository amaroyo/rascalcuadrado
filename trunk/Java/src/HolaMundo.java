/**
 * 
 */

/**
 * @author pecas
 *
 */
public class HolaMundo {

	/**
	 * 
	 */
	public HolaMundo() {
		// TODO Auto-generated constructor stub
		System.out.println("Hola mundo:");
		metodoAdios(HolaMundoEnum.value1.toString());
	}
	
	public void metodoAdios(String s) {
		System.out.println(s);
		System.out.println("Adiós.");
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		HolaMundo mundo = new HolaMundo();
		mundo.metodoAdios(HolaMundoEnum.value2.toString());

	}

}
