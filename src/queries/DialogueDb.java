package queries;
import java.sql.*;

public class DialogueDb {
	private String dbName;
	
	public DialogueDb(String dbName) {
		this.dbName = dbName;
	}
	public boolean executeQuery(String query) {
		try {
			Class.forName("org.sqlite.JDBC");
		} catch (ClassNotFoundException e1) {
			// TODO Auto-generated catch block
			System.out.println("np");
			e1.printStackTrace();
		}
	      Connection connection = null;
	      try
	      {
	    	  
	         // create a database connection
	         connection = DriverManager.getConnection("jdbc:sqlite:/Users/amnairfan/Documents/eclipse_workspace/DialogueSystems/"+ dbName +".db");

	         Statement statement = connection.createStatement();
	         statement.setQueryTimeout(30); 
	         statement.execute(query);
	      }
	     catch(SQLException e){  System.err.println(e.getMessage()); }       
	      finally {         
	            try {
	                  if(connection != null)
	                     connection.close();
	                  }
	            catch(SQLException e) {     
	               System.out.println(e); 
	               return false;
	             }
	      }
	   return true;
	}
	
	 public static void main(String[] args)
     {	
		//creating table
		 DialogueDb db = new DialogueDb("dialogueSystem");
		 //db.executeQuery("INSERT INTO Dialogue values('B6965B478DB2EA118DDF2C74D0C707DA', '90', 'HG', 'INTRO', '', 'Hi, I am the health guru. How are you?')");
		
     }
}
