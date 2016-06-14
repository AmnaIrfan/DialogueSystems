package dialogueServlet;
import java.io.IOException;
import java.util.Date;
import java.io.PrintWriter;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dm.dialogue.manager.DM;
import dm.nlp.Message;
import dm.taichi.TaiChiDM;

import queries.DialogueDb;
import java.sql.*;

/**
 * Servlet implementation class MyServlet
 */
@WebServlet("/MyServlet")
public class MyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	private TaiChiDM taichi;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MyServlet() {
        super();
        taichi = new TaiChiDM();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}
 	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		PrintWriter res = response.getWriter();
		HttpSession session = request.getSession();
		String id = session.getId();
		String resp = process(id, request);
		res.write(resp);
		res.flush();
		res.close();
	}
	
	protected String process(String id, HttpServletRequest req){
		DM dialogue = taichi.getDialogueManager();
		String userText = req.getParameter("msg");
		String questionId = "";
		String question = "";
		String emotion = "";
		String time = new Date().toString();
		
		String query = "INSERT INTO Dialogue values(\'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\')";
		DialogueDb db = new DialogueDb("dialogueSystem");
		//first time text is null
		System.out.println("user tst");
		System.out.println(userText);
		if(userText == "") {
			question = dialogue.takeTurn(null);
			questionId = "INTRO";
			this.postDemo(id, req);
			db.executeQuery(String.format(query, id, time, "HG", questionId, emotion, question));
		}
		//second time
		else if (!dialogue.isOver()){
			Message msg = new Message(userText);
			question = dialogue.takeTurn(msg);
			//question = "Many tai chi exercises help build muscle mass. You can do it from the comfort of your own home at a time that's convenient for you. Would you like me to tell you more about it?";
			System.out.println("ques");
			System.out.println(question);
			//question = question.replaceAll("’", "\'");
			System.out.println(question);
			Message response = dialogue.getResponse();
			questionId = response.getProperty("next_question");
			emotion = userText.split("@")[1];
			userText = userText.split("@")[0];
		    if (response.getProperty("next_question").equals("CONCLPRINT")) {
		    	question="@END";
		    }
		    
			db.executeQuery(String.format(query, id, time, "U", questionId, emotion, userText));
			db.executeQuery(String.format(query, id, time, "HG", questionId, emotion, question));
		}
		
		System.out.println("query");
		System.out.println(query);		
		return question;
	}
	
	protected void postDemo(String id, HttpServletRequest req){
		DialogueDb db = new DialogueDb("dialogueSystem");
		String pos = req.getParameter("pos");
		String sex = req.getParameter("sex");
		String race =req.getParameter("race");
		String age = req.getParameter("age");
		String ex1 = req.getParameter("ex1");
		String ex2 = req.getParameter("ex2");
		String soc = req.getParameter("soc");	
		String pre1 = req.getParameter("pre1");
		String pre2 = req.getParameter("pre2");
		String query = "INSERT INTO Demographics values(\'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\')";
		db.executeQuery(String.format(query, id,pos, sex, race, age, ex1, ex2, soc, pre1, pre2));
	
	}

}
