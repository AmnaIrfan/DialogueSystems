package dialogueServlet;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.io.IOException;
import java.util.Date;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.UnknownHostException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTextArea;
import javax.swing.JTextPane;
import javax.swing.text.BadLocationException;
import javax.swing.text.Style;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyledDocument;
import dm.dialogue.manager.DM;
import dm.nlp.Message;
import dm.taichi.TaiChiDM;
import queries.DialogueDb;


@WebServlet("/MyServlet")
public class MyServlet extends HttpServlet {
	
	private JFrame tp;
	private JTabbedPane jtp;
	private final String RESTRICTED_USER = "skip";
	private final String USER_COLOR = "#CD1B4E";
	private final String HG_COLOR = "#6919A8";
	private final String EMO_COLOR = "#00000";
	
	
	public MyServlet() {
		super();
		createChatWindow();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		HttpSession session = request.getSession();
		String id = session.getId();
		String msg = null;
		String reqType = request.getParameter("reqtype");

		if (reqType.equals("postques")) {
			msg = postSurvey(id, request);
		} else if(reqType.equals("comments")){
			msg = postComment(id, request);
		} else {
			if (request.getParameter("msg") == "") {
				msg = startConversation(id, request);
			} else {
				msg = continueConversation(id, request, response);
			}
		}
		
		PrintWriter res = response.getWriter();
		res.write(msg);
		res.flush();
		res.close();
		
	}
	
	protected String getIP(HttpServletRequest req) {
		String ip = req.getRemoteAddr();
		if (ip.equalsIgnoreCase("0:0:0:0:0:0:0:1")) {
		    InetAddress inetAddress = null;
			try {
				inetAddress = InetAddress.getLocalHost();
			} catch (UnknownHostException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    String ipAddress = inetAddress.getHostAddress();
		    ip = ipAddress;
		}
		return ip;
	}
	protected String startConversation(String id, HttpServletRequest req) throws UnknownHostException {
		
		HttpSession session = req.getSession();
		String userType = req.getParameter("userType");
		
		
		TaiChiDM taichi = new TaiChiDM();
		session.setAttribute("taichi", taichi);
		
		DM dialogue = taichi.getDialogueManager();
		String hg = dialogue.takeTurn(null);
		String questionId = "INTRO";
		
		String ip = this.getIP(req);
		addChatTab(req);
		addChatMessage(req, "IP: " + ip, EMO_COLOR);
		addChatMessage(req, "HEALTH GURU: " + hg, HG_COLOR);

		int insertId = -1;
		if (!userType.equals(RESTRICTED_USER)) {
			DialogueDb db = new DialogueDb("dialogueSystem");
			String query = "INSERT INTO Dialogue values(\'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\')";
			String time = new Date().toString();
			insertId = this.postDemo(id, req);
			db.executeQuery(String.format(query, id, time, "HG", questionId, "", hg));
		}
		
		
		return (hg + "|" + insertId + "|" + ip);
		
	}

	protected String continueConversation(String id, HttpServletRequest req, HttpServletResponse res) {
		
		HttpSession session = req.getSession();
		String userType = req.getParameter("userType");
		DialogueDb db = new DialogueDb("dialogueSystem");
		String query = "INSERT INTO Dialogue values(\'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\')";
		
		//show user's msg to wizard
		String userText = req.getParameter("msg");
		addChatMessage(req,"USER: " + userText, USER_COLOR);
		
		
		
		//Block the thread so the next lines execute only when wizard notifies us with an emotion
		TaiChiDM taichi = (TaiChiDM) session.getAttribute("taichi");
		
		synchronized(taichi) {
		    try {
		        taichi.wait();
		    } catch (InterruptedException e) {
		    }
		}
		
		
		//Get emotion and then hg's question
		JTextArea sendArea = (JTextArea) session.getAttribute("sendArea");
		String emotion = sendArea.getText().toUpperCase();
    	userText = userText.replace("@", "") + "@" + emotion;
    	sendArea.setText("");
    	DM dialogue = taichi.getDialogueManager();
    	Message msg = new Message(userText);
    	String hg = dialogue.takeTurn(msg);
    	Message response = dialogue.getResponse();
		String questionId = response.getProperty("next_question");
		
		if (response.getProperty("next_question").equals("CONCLPRINT")) {
			hg = "@END";
		}
    	//show wizard the question and save users ans and question to database
		
		addChatMessage(req,"EMOTION: " + emotion, EMO_COLOR);
		addChatMessage(req,"HEALTH GURU: " + hg, HG_COLOR);
    	
    	if (!userType.equals(RESTRICTED_USER)) {
			db.executeQuery(String.format(query, id, new Date().toString(), "U", questionId, emotion, userText.split("@")[0].replace("'", "‘")));
			db.executeQuery(String.format(query, id, new Date().toString(), "HG", questionId, emotion, hg.replace("'", "‘")));
		}
		
 
		return hg;
		
	}
	
	protected int postDemo(String id, HttpServletRequest req) {
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
		String userType = req.getParameter("userType");
		
	
		String query = "INSERT INTO Demographics (sessionID, position,"
				+ " gender, userType, ethnicity,age_range,excerise_freq, excerise_time,"
				+ "social_networks, excercise_need,taichi_interest"
				+ ") values(\'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\')";
		
		if (!userType.equals(RESTRICTED_USER)) {
			db.executeQuery(String.format(query, id, pos, sex, userType, race, age, ex1, ex2, soc, pre1, pre2));
		}
		
		 query = "SELECT ID from Demographics Where sessionID = \'%s\'";
		 
		 if (!userType.equals(RESTRICTED_USER)) {
			 return db.executeQuery(String.format(query, id));
		 }
		 
		 return -1;
		

	}
	  
	protected String postSurvey(String id, HttpServletRequest req) {
		DialogueDb db = new DialogueDb("dialogueSystem");
		String guruUnder =  req.getParameter("guruUnder");
		String userUnder =  req.getParameter("userUnder");
		String excerNeed =  req.getParameter("excerNeed");
		String taichiInterest= req.getParameter("taichiInterest");
		String taichiPers= req.getParameter("taichiPers");
		String printed =  req.getParameter("printed");
		String userType = req.getParameter("userType");
		
		String query = "INSERT INTO PostQuestions values(\'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\')";
		
		if(!userType.equals(RESTRICTED_USER)) {
			db.executeQuery(String.format(query, id, guruUnder, userUnder, excerNeed, taichiInterest, taichiPers, printed, ""));
		}
		return "completed";

	}
	
	protected String postComment(String id, HttpServletRequest req) {

		DialogueDb db = new DialogueDb("dialogueSystem");
		String comment =  req.getParameter("comment");
		
		String userType = req.getParameter("userType");
		
		String query = "UPDATE PostQuestions SET comment = \'%s\' WHERE sessionID = \'%s\' ";
		if (!userType.equals(RESTRICTED_USER)) {
			db.executeQuery(String.format(query, comment, id));
		}
		return "completed";

	}

	private String wrapText(String text) {
		String formatted_text = "";
		int count = 0;
		for (int i = 0; i<text.length(); i++) {
			count ++;
			if (count >= 186 && text.charAt(i) == ' ') {
				count = 0;
				formatted_text += "\n";
				
			} else {
				formatted_text += text.charAt(i);
			}		
			
		}
		return formatted_text;
	}

	
	//chat GUI

	private void createChatWindow() {
		tp = new JFrame();
		tp.setSize(new Dimension(1280, 800));
		tp.setTitle("Dialogue Chat Room");
		ImageIcon img = new ImageIcon("http://redbluedictionary.org/wp-content/uploads/2016/04/speech_bubbles-512.png");
		tp.setIconImage(img.getImage());
        jtp = new JTabbedPane();
        tp.getContentPane().add(jtp);
        tp.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        tp.setVisible(true);
	}
	
	private void addChatTab(HttpServletRequest req) {
		
		HttpSession session = req.getSession();
		String id = session.getId().substring(session.getId().length() - 2, session.getId().length());;
		
		//tab and chat area
		JPanel tab = new JPanel();
		tab.setLayout(null);
		tab.setBackground(Color.decode("#312E77"));  
        JTextPane chatArea = new JTextPane();
        JScrollPane scrollPane = new JScrollPane(chatArea);
        scrollPane.setBounds(15, 20, 1230, 500);
        chatArea.setEditable(false);
        chatArea.setBorder(BorderFactory.createCompoundBorder(chatArea.getBorder(),BorderFactory.createEmptyBorder(5, 5, 5, 5)));
        scrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        tab.add(scrollPane);
      
        //send area
        JTextArea sendArea = new JTextArea();
        
        sendArea.setBounds(15, 540, 1150, 60);
        sendArea.setLineWrap(true);
        sendArea.setEditable(true);
        sendArea.setBorder(BorderFactory.createCompoundBorder(sendArea.getBorder(), BorderFactory.createEmptyBorder(5, 5, 5, 5)));
        tab.add(sendArea);
        
        //send button
        JButton sendBtn = new JButton("Send");
        sendBtn.addActionListener(new ActionListener()
        {
          public void actionPerformed(ActionEvent e)
          {
        	  TaiChiDM taichi = (TaiChiDM) session.getAttribute("taichi");
        	  synchronized(taichi) {
        		    taichi.notify();
        		}
    		
          }
        });


        sendArea.addKeyListener(new KeyAdapter() {
           public void keyTyped(KeyEvent e) {
              char c = e.getKeyChar();
              String allowed = "isnISN";
              if (allowed.indexOf(c) < 0){
                 e.consume();  // ignore event
              }
           }
        });
        
        sendBtn.setBounds(1175, 555, 60, 30);
        
        tab.add(sendBtn);
        
        JLabel ip = new JLabel("IP: " +this.getIP(req));
        ip.setForeground(Color.white);
        ip.setBounds(15, 620, 300, 30);
        tab.add(ip);
        
        
        jtp.addTab("User " + id, tab);
        session.setAttribute("sendArea", sendArea);
        session.setAttribute("chatArea", chatArea);
        tp.validate();
	}
	
	private void addChatMessage(HttpServletRequest req, String msg, String color) {
		
		HttpSession session = req.getSession();
		
		JTextPane chatArea = (JTextPane)session.getAttribute("chatArea");
		
		StyledDocument doc = chatArea.getStyledDocument();

        Style style = chatArea.addStyle("style", null);
        
        StyleConstants.setForeground(style, Color.decode(color));
        try { doc.insertString(doc.getLength(), wrapText(msg) + "\n",style); }
        catch (BadLocationException e){}
        tp.setVisible(true);

	}
}
