package dialogueServlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dm.dialogue.manager.DM;
import dm.nlp.Message;
import dm.taichi.TaiChiDM;


/**
 * Servlet implementation class MyServlet
 */
@WebServlet("/MyServlet")
public class MyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	private TaiChiDM taichi;
	private boolean first=true;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MyServlet() {
        super();
        // TODO Auto-generated constructor stub
        taichi = new TaiChiDM();
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
		String msg = request.getParameter("msg");
		String resp = process(msg);
		res.write(resp);
		res.flush();
		res.close();
	}
	
	protected String process(String userText){
		DM dialogue = taichi.getDialogueManager();
		String text = "";
		System.out.println("first?"+first);
		if(first)
			text = dialogue.takeTurn(null);
		else if (!dialogue.isOver()){
			Message msg = new Message(userText);
			text = dialogue.takeTurn(msg);
			Message response = dialogue.getResponse();
			if(response.getProperty("next_question").equals("CONCLPRINT"))
				text="@END";
		}
		first = false;
		return text;
	}

}
