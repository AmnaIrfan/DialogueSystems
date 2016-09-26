package dialogueServlet;

import java.util.Scanner;

import java.io.IOException;
import java.util.Arrays;
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

/**
 * Servlet implementation class MyServlet
 */
@WebServlet("/MyServlet")
public class MyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private int temp;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public MyServlet() {
		super();
		temp = 0;
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		PrintWriter res = response.getWriter();
		HttpSession session = request.getSession();
		String id = session.getId();
		String resp = null;
		String reqType = request.getParameter("reqtype");
		if (reqType.equals("postques")) {
			resp = postSurvey(id, request);
		} else if(reqType.equals("comments")){
			resp = postComment(id, request);
		} else {
			resp = process(id, request);
		}
		res.write(resp);
		res.flush();
		res.close();
	}

	protected String process(String id, HttpServletRequest req) {

		HttpSession session = req.getSession();
		
		String userText = req.getParameter("msg");
		
		TaiChiDM taichi = (TaiChiDM) session.getAttribute("taichi");
		if (taichi == null) {
			System.out.println("***NEW SESSION :" + session.getId()+ " ***");	
			taichi = new TaiChiDM();
			session.setAttribute("taichi", taichi);
		} else {
			userText = userText.replaceAll("'","’").replaceAll("[^A-Za-z0-9 .?!,’]","");
			String [] emoptions = {"NI","I", "SI"};
			Scanner kbd = new Scanner(System.in);
			String emotion;
			String guru = session.getAttribute("prevQuestion").toString();
			do {
				System.out.println("########################################\nGURU: " + guru + "\nUSER: " + userText + "\n########################################\nEnter emotion:");
				emotion = kbd.nextLine();
			} while(!Arrays.asList(emoptions).contains(emotion.toUpperCase()));
			userText = userText + "@" + emotion.toUpperCase();
		}

		DM dialogue = taichi.getDialogueManager();
		//String userText = req.getParameter("msg");
		String questionId = "";
		String question = "";
		String emotion = "";
		String time = new Date().toString();

		String query = "INSERT INTO Dialogue values(\'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\')";
		DialogueDb db = new DialogueDb("dialogueSystem");
		// first time text is null
		if (userText == "") {
			question = dialogue.takeTurn(null);
			questionId = "INTRO";
			this.postDemo(id, req);
			db.executeQuery(String.format(query, id, time, "HG", questionId, emotion, question));
		}
		// second time
		else if (!dialogue.isOver()) {
			Message msg = new Message(userText);
			question = dialogue.takeTurn(msg);
			
			Message response = dialogue.getResponse();
			questionId = response.getProperty("next_question");
			emotion = userText.split("@")[1];
			userText = userText.split("@")[0];
			if (response.getProperty("next_question").equals("CONCLPRINT")) {
				question = "@END";
			}
			//clean question and answer before saving to database
			db.executeQuery(String.format(query, id, time, "U", questionId, emotion, userText));
			db.executeQuery(String.format(query, id, time, "HG", questionId, emotion, question.replaceAll("'","’").replaceAll("[^A-Za-z0-9 .?!,’]","")));
		}

		session.setAttribute("prevQuestion", question);
		return question;
	}

	protected void postDemo(String id, HttpServletRequest req) {
		DialogueDb db = new DialogueDb("dialogueSystem");
		String pos = req.getParameter("pos");
		String sex = req.getParameter("sex");
		String race = req.getParameter("race");
		String age = req.getParameter("age");
		String ex1 = req.getParameter("ex1");
		String ex2 = req.getParameter("ex2");
		String soc = req.getParameter("soc");
		String pre1 = req.getParameter("pre1");
		String pre2 = req.getParameter("pre2");
		
		String query = "INSERT INTO Demographics values(\'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\')";
		db.executeQuery(String.format(query, id, pos, sex, race, age, ex1, ex2, soc, pre1, pre2));

	}
	
	
	protected String postSurvey(String id, HttpServletRequest req) {
		DialogueDb db = new DialogueDb("dialogueSystem");
		String guruUnder =  req.getParameter("guruUnder");
		String userUnder =  req.getParameter("userUnder");
		String excerNeed =  req.getParameter("excerNeed");
		String taichiInterest= req.getParameter("taichiInterest");
		String taichiPers= req.getParameter("taichiPers");
		String printed =  req.getParameter("printed");
		
		String query = "INSERT INTO PostQuestions values(\'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\')";
		db.executeQuery(String.format(query, id, guruUnder, userUnder, excerNeed, taichiInterest, taichiPers, printed, ""));
		return "completed";

	}
	
	protected String postComment(String id, HttpServletRequest req) {
		DialogueDb db = new DialogueDb("dialogueSystem");
		String comment =  req.getParameter("comment");
		
		String query = "UPDATE PostQuestions SET comment = \'%s\' WHERE id = \'%s\' ";
		db.executeQuery(String.format(query, comment, id));
		
		return "completed";

	}

	


	

}
