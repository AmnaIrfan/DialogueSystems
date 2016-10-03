package queries;
import java.sql.*;
import dialogueServlet.Environment;
public class DialogueDb {
	private String dbName;
	
	public DialogueDb(String dbName) {
		this.dbName = dbName;
	}
	public int executeQuery(String query) {
		int id = -1;
		try {
			Class.forName("org.sqlite.JDBC");
		} catch (ClassNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	      Connection connection = null;
	      try
	      {
	         // create a database connection
	         connection = DriverManager.getConnection(Environment.TAICHI_DB);
	       
	         Statement statement = connection.createStatement();
	         statement.setQueryTimeout(30); 
	         if (query.toLowerCase().indexOf("select") > -1) {
	        
	        	 ResultSet rs = statement.executeQuery(query);
	        	  while ( rs.next() ) {
	        	         id = rs.getInt("id");
	        	      }
	        	  rs.close();
	         } else {
	        	 statement.execute(query); 
	         }
	         
	      }
	     catch(SQLException e){  System.err.println(e.getMessage()); }       
	      finally {         
	            try {
	                  if(connection != null)
	                     connection.close();
	                  }
	            catch(SQLException e) {     
	               System.out.println(e); 
	               return 0;
	             }
	      }
	   return id;
	}
	
	 public static void main(String[] args)
     {	
		//creating table
		 DialogueDb db = new DialogueDb("dialogueSystem");
		
     }
}
