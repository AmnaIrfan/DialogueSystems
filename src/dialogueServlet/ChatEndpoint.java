package dialogueServlet;

import java.security.SecureRandom;
import java.math.BigInteger;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import org.json.*;
import dm.dialogue.manager.DM;
import dm.taichi.TaiChiDM;
import queries.DialogueDb;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import dm.nlp.Message;





@ServerEndpoint("/chat")
public class ChatEndpoint {

	private static ArrayList<User> users = new ArrayList<User>();
	private static User healthguru;
	private final String RESTRICTED_USER = "skip";
	private static SecureRandom random = new SecureRandom();
	
	public ChatEndpoint() {
		super();
	}
	
	@OnOpen
	public void onOpen(Session session) {
		String sessionId = this.generateSessionId();
		User u = new User(session, session.getId(), sessionId);
		System.out.println("Session: " + sessionId.substring(sessionId.length()-4, sessionId.length()) + " connected.");
		users.add(u);
	}
	
	@OnMessage
	public void onMessage(Session req, String message) {
		
	
		JSONObject data = new JSONObject(message);		
		String reqType = data.getString("reqtype");
		
		User user = this.getUser(req.getId());	
		
		System.out.println("Recieved message from " + user.sessionId.substring(user.sessionId.length()-4));
		System.out.println(message);
		
		if(reqType.equals("hg_start")) {
			healthguru = user;
		} else if(reqType.equals("hg_emo")){
			recievedEmotion(data);
		} else if (reqType.equals("demo")) {
			this.startConversation(data, user);
		} else if(reqType.equals("chat")) {
			this.receivedResponse(data, user);
		} else if(reqType.equals("postques")) {
			this.postSurvey(user, data);
		} else {
			this.postComment(user, data);
		}
		
	}

	public void receivedResponse(JSONObject data, User user) {
		String msg = data.getString("msg");
		user.setMsg(msg);
		this.sendMessage(healthguru, "{\"msg\":\"" + msg + "\",\"speaker\":\"user\", \"id\":\"" + user.id + "\"}");
	}
	
	public void recievedEmotion(JSONObject data) {
		String id = data.getString("id");
		User u = this.getUser(id);
		String emotion = data.getString("emo");
    	String userText = u.msg.replace("@", "") + "@" + emotion;
    	DM dialogue = u.taichi.getDialogueManager();
	    Message msg = new Message(userText);
	    String hg = dialogue.takeTurn(msg);
	      
	    Message response = dialogue.getResponse();
	    String questionId = response.getProperty("next_question");

	    if (response.getProperty("next_question").equals("CONCLPRINT")) {
			hg = "@END";
	    }
	    DialogueDb db = new DialogueDb("dialogueSystem");
	    String query = "INSERT INTO Dialogue values(\'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\')";
	    if (u.isAllowed) {
			db.executeQuery(String.format(query, u.sessionId, new Date().toString(), "U", questionId, emotion, userText.split("@")[0].replace("'", "‘")));
			db.executeQuery(String.format(query, u.sessionId, new Date().toString(), "HG", questionId, emotion, hg.replace("'", "‘")));
		}
	    this.sendMessage(healthguru, "{\"msg\":\"" + hg + "\",\"speaker\":\"hg\", \"id\":" + id + "}");
		this.sendMessage(u, hg);
	}
	
	public void startConversation(JSONObject data, User u) {
		
		String userType = data.getString("usertype");
		u.setIsAllowed(!userType.equals(RESTRICTED_USER));
		String ip = data.getString("ip");
		
		TaiChiDM taichi = new TaiChiDM();
		u.setTaichi(taichi);
		
		DM dialogue = taichi.getDialogueManager();
		String hg = dialogue.takeTurn(null);
		String questionId = "INTRO";
	
		 
		int insertId = -1;
		if (u.isAllowed) {
			DialogueDb db = new DialogueDb("dialogueSystem");
			String query = "INSERT INTO Dialogue values(\'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\')";
			String time = new Date().toString();
			insertId = this.postDemo(data, u, userType);
			db.executeQuery(String.format(query, u.sessionId, time, "HG", questionId, "", hg));
		}
		
		this.sendMessage(healthguru, "{\"msg\":\"" + hg + "\",\"speaker\":\"hg\", \"id\":\"" + u.id + "\", \"ip\":\"" + ip +"\", \"sessionId\":\"" + u.sessionId + "\"}");
		this.sendMessage(u, hg + "|" + insertId);
		
		 
	}
	
	private void sendMessage(User u, String msg) {
		try {
			 u.getSession().getBasicRemote().sendText(msg);
      	  } catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				System.out.print("unable to send msg to: " + u.sessionId.substring(u.sessionId.length()-4));
      	  }
	}
	
	protected int postDemo(JSONObject data, User u, String userType) {

		DialogueDb db = new DialogueDb("dialogueSystem");
		String pos = data.getString("pos");
		String sex = data.getString("sex");
		String race = data.getString("race");
		String age = data.getString("age");
		String ex1 = data.getString("ex1");
		String ex2 = data.getString("ex2");
		String soc = data.getString("soc");
		String pre1 = data.getString("pre1");
		String pre2 = data.getString("pre2");
		
	
		String query = "INSERT INTO Demographics (sessionID, position,"
				+ " gender, userType, ethnicity,age_range,excerise_freq, excerise_time,"
				+ "social_networks, excercise_need,taichi_interest"
				+ ") values(\'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\')";
		
		if (u.isAllowed) {
			db.executeQuery(String.format(query,u.sessionId, pos, sex, userType, race, age, ex1, ex2, soc, pre1, pre2));
		}
		
		 query = "SELECT ID from Demographics Where sessionID = \'%s\'";
		 
		 if (u.isAllowed) {
			 return db.executeQuery(String.format(query, u.sessionId));
		 }
		 
		 return -1;
		

	}
	 
	protected String postSurvey(User u, JSONObject data) {
		DialogueDb db = new DialogueDb("dialogueSystem");
		String guruUnder =  data.getString("guruUnder");
		String userUnder =  data.getString("userUnder");
		String excerNeed =  data.getString("excerNeed");
		String taichiInterest= data.getString("taichiInterest");
		String taichiPers= data.getString("taichiPers");
		int  printed =  data.getInt("printed");
		
		String query = "INSERT INTO PostQuestions values(\'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\')";
		
		if(u.isAllowed) {
			db.executeQuery(String.format(query, u.sessionId, guruUnder, userUnder, excerNeed, taichiInterest, taichiPers, printed, ""));
		}
		return "completed";

	}
	
	protected String postComment(User u, JSONObject data) {
		DialogueDb db = new DialogueDb("dialogueSystem");
		String comment =   data.getString("comment");
		
		
		String query = "UPDATE PostQuestions SET comment = \'%s\' WHERE sessionID = \'%s\' ";
		if (u.isAllowed) {
			db.executeQuery(String.format(query, comment.replace("'", "‘"), u.sessionId));
		}
		return "completed";

	}

	public String generateSessionId() {
		return new BigInteger(130, random).toString(32);
	}
	
	public User getUser(String id) {
		for (int i = 0; i <users.size(); i++ ) {
			if (users.get(i).id.equals(id)) {
				return users.get(i);
			}
		}
		return null;
	}
	
	public class User {
		
		private Session session;
		private TaiChiDM taichi;
		private String sessionId;
		private String msg;
		private String id;
		private boolean isAllowed;
   
		public User(Session session,String id, String sessionId) {
			this.session = session;
			this.sessionId = sessionId;
			this.id = id;
		}
		
		public String getId() {
			return this.id;
		}
		
		public String getSessionId() {
			return this.sessionId;
		}
		
		public Session getSession() {
			return this.session;
		}
		
		public TaiChiDM getTaichi() {
			return this.taichi;
		}
		public void setTaichi(TaiChiDM taichi) {
			this.taichi = taichi;
		}
	
		public String getMsg() {
			return this.msg;
		}
		public void setMsg(String msg) {
			this.msg = msg;
		}
		public boolean getIsAllowed() {
			return this.isAllowed;
		}
		public void setIsAllowed(boolean allowed) {
			this.isAllowed = allowed;
		}
		
	}
	
}
