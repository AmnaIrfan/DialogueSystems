<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="dialogueServlet.Environment" %>
<%
ResultSet resultset =null; 
String connStr = Environment.TAICHI_DB;
Connection connection = null;
Statement statement = null;
Class.forName("org.sqlite.JDBC");
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>A Healthy Choice</title>
	
	<link rel="stylesheet" type="text/css" href="css/style.css">
	<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
	<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>	
	<script src="js/chat.js"></script>
	
</head>

<body>

<!--
		-------------------------------------------------------------------------------------------------------------
		LOGIN SCREEN
		-------------------------------------------------------------------------------------------------------------
-->	
	<div id="userLogin" title="User Login">
			<p>Please enter your password: </p>
			<input id="userPassword" type="text">
	</div>


<!--
		-------------------------------------------------------------------------------------------------------------
		BEGINNING OF WELCOME SCREEN
		-------------------------------------------------------------------------------------------------------------
-->	

		<div class="wrapper" id="welcome">
			<div class="top">
				<div style="clear:both"></div>
			</div>	
			<div class="container" id="introbox">
			
				<p>
					Hi there! I am your Healthy Choice Guru.<br>
					Together we will try and make a choice that
					is good for you.
				</p>
				<h3>Instructions:</h3>
				
				<p>
					On the next screen there will be a questionnaire. Please select an option for each question.</p>
					<p>Upon completion of the questionnaire, please click "Begin Chat" to start the chat with our agent.<br> 
				</p>
				<h2>Thank you for your participation!</h2>

				<div class = "buttonHolder">
					<input class="submitbutton" id="continue"  type="button" value="Continue">
				</div>		
	
			</div>
		</div>

<!--
		-------------------------------------------------------------------------------------------------------------
		BEGINNING OF PRE-CHAT QUESTIONNAIRE
		-------------------------------------------------------------------------------------------------------------
-->
		<div class="wrapper" id="QuestFormat">
			<div class="top">
			</div>	
			
			
			<div class="container" id="questbox">			
				<h4>Please take a moment to answer a few quick questions. Thank you.</h4>
				<span id="errorMessage1"></span>
				
				<!-- POSITION -->
				<h4>What is your role?
					<% 
					connection = DriverManager.getConnection (connStr); 
					statement = connection.createStatement() ;
					resultset = statement.executeQuery("select * from Position");%>
					<select  id = "Position">
						<option value ="">Select</option>
			        <%  while(resultset.next()){ %>
			            <option value = <%= resultset.getString(1)%> ><%= resultset.getString(2)%></option>
			        <% } %>
					</select>
				</h4>
			
				<!-- GENDER -->
				<h4> What is your gender?
					<% 
					connection = DriverManager.getConnection (connStr); 
					statement = connection.createStatement() ;
					resultset = statement.executeQuery("select * from Gender");%>
					<select id= "Gender">
						<option value ="">Select</option>
			        <%  while(resultset.next()){ %>
			            <option value = <%= resultset.getString(1)%> ><%= resultset.getString(2)%></option>
			        <% } %>
					</select>
				</h4>
						
				<!-- ETHNICITY -->
				<h4>What is your ethnicity?
					<% 
					connection = DriverManager.getConnection (connStr); 
					statement = connection.createStatement() ;
					resultset =statement.executeQuery("select * from Ethnicity");%>
					<select id="Ethnicity">
						<option value ="">Select</option>
			        <%  while(resultset.next()){ %>
			            <option value = <%= resultset.getString(1)%> ><%= resultset.getString(2)%></option>
			        <% } %>
					</select>
				</h4>
			
				<!-- AGE -->
				<h4>What is your age range?
					<%
					connection = DriverManager.getConnection (connStr); 
					statement = connection.createStatement() ;
					resultset =statement.executeQuery("select * from Age");%>
					<select id = "Age">
						<option value ="">Select</option>
			        <%  while(resultset.next()){ %>
			            <option value = <%= resultset.getString(1)%> ><%= resultset.getString(2)%></option>
			        <% } %>
					</select>
				</h4>
				
				<!-- EXCERCISE FREQUENCY -->
				<h4>How often do you exercise per week?
					<%
					connection = DriverManager.getConnection (connStr); 
					statement = connection.createStatement() ;
					resultset =statement.executeQuery("select * from ExcerFreq");%>
					<select id = "Exercise1">
						<option value ="">Select</option>
			        <%  while(resultset.next()){ %>
			            <option value = <%= resultset.getString(1)%> ><%= resultset.getString(2)%></option>
			        <% } %>
					</select>
				</h4>
				
				<!-- EXCERCISE TYPE -->
				<h4>Which type of exercises?
					<% 
					connection = DriverManager.getConnection (connStr); 
					statement = connection.createStatement() ;
					resultset =statement.executeQuery("select * from ExcerType");%>
					<select id = "Exercise2">
						<option value ="">Select</option>
			        <%  while(resultset.next()){ %>
			            <option value = <%= resultset.getString(1)%> ><%= resultset.getString(2)%></option>
			        <% } %>
					</select>
				</h4>
				
				<!-- SOCIAL NETWORK -->
				<h4>What social network sites do you use?
					<%
					connection = DriverManager.getConnection (connStr); 
					statement = connection.createStatement() ;
					resultset =statement.executeQuery("select * from SocialNetworks");%>
					<select id = "SocialNetwork">
						<option value ="">Select</option>
			        <%  while(resultset.next()){ %>
			            <option value = <%= resultset.getString(1)%> ><%= resultset.getString(2)%></option>
			        <% } %>
					</select>
				</h4>
				
				<h4>Please state whether you agree or disagree with the following statements.</h4>
				
				<h5>Strongly Disagree=1 and Strongly Agree=5.</h5>
				
				<h4>I feel the need to exercise more often.</h4>
				
					<form id="pretest1">
						<input type="radio" name="taichi1" value="1"/>1&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="taichi1" value="2"/>2&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="taichi1" value="3"/>3&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="taichi1" value="4"/>4&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="taichi1" value="5"/>5					
					</form>
				
				
				<h4>I am interested in learning Tai Chi.</h4>
					<form id="pretest2">
						<input type="radio" name="taichi2" value="1"/>1&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="taichi2" value="2"/>2&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="taichi2" value="3"/>3&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="taichi2" value="4"/>4&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="taichi2" value="5"/>5					
					</form>
						
			</div>
			
			<div class = "buttonHolder">
				<input class = "submitbutton" id = "QuestSubmit" type = "button" value = "Begin Chat">
			</div>
		</div>		

		
<!--
		-------------------------------------------------------------------------------------------------------------
		BEGINNING OF USER CHAT SCREEN
		-------------------------------------------------------------------------------------------------------------
-->

<div id="main">
	<div id="top"></div>
	<div id="chat-area">

	</div>

	<form name ="chat-input-inner" action="">
			<textArea id="chat-input" name="msg"></textArea>
			<button id="chat-submit" class="submitbutton"type="button">Send</button>
	</form>

</div>

<!--
		-------------------------------------------------------------------------------------------------------------
		BEGINNING OF POST-CHAT QUESTIONNAIRE SCREEN #1
		-------------------------------------------------------------------------------------------------------------
-->		
		<div class="wrapper" id="PostQuest">
			<div class="top">
			</div>	
			<div class="container" id ="end" >		
				<p id="printmsg">Thank you for your participantion.<br>
					Are you interested in receiving more information? </p>
				
				<br><br>
				<div class = "buttonHolder">	
					<input class="submitbutton" id="printing"  type="button" value="Print Flyer"/>
					<br><br>
					<input class="submitbutton" id="nothank"  type="button" value="No Thanks"/>
				</div>
			</div>				
		</div>
		
<!--
		-------------------------------------------------------------------------------------------------------------
		BEGINNING OF POST QUESTIONS SCREEN
		-------------------------------------------------------------------------------------------------------------
-->		
		<div class="wrapper" id="PostQuest2">
			<div class="top">
				<div style="clear:both"></div>
			</div>	
			<div class="container" id="questbox2">
				<h4>Please state whether you agree or disagree with the following statements.</h4>
				<span id="errorMessage2"></span>
				<h5>Strongly Disagree=1 and Strongly Agree=5.</h5>				
				<h4>The chat program understood what I was saying.
					<form id="posttest1">
							<input type="radio" name="Q1" value="1"/>1&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q1" value="2"/>2&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q1" value="3"/>3&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q1" value="4"/>4&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q1" value="5"/>5
					</form>		
				</h4>
				<h4>I understood what the chat program was saying to me.
					<form id="posttest2">
							<input type="radio" name="Q2" value="1"/>1&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q2" value="2"/>2&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q2" value="3"/>3&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q2" value="4"/>4&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q2" value="5"/>5				
					</form>
				</h4>
				<h4>After this chat,</h4>
				<h4>I feel the need to exercise more often.
					<form id="posttest3">							
							<input type="radio" name="Q3" value="1"/>1&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q3" value="2"/>2&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q3" value="3"/>3&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q3" value="4"/>4&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q3" value="5"/>5					
					</form>
				</h4>
				<h4>I am interested in learning Tai chi.
					<form id="posttest4">
							<input type="radio" name="Q4" value="1"/>1&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q4" value="2"/>2&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q4" value="3"/>3&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q4" value="4"/>4&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q4" value="5"/>5					
					</form>
				</h4>
				<h4>This chat persuaded me to find out more about Tai Chi.
					<form id="posttest5">
							<input type="radio" name="Q5" value="1"/>1&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q5" value="2"/>2&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q5" value="3"/>3&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q5" value="4"/>4&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q5" value="5"/>5				
					</form>
				</h4>
			</div>
			<div class = "buttonHolder">
				<input class="submitbutton" id="PostQuestsubmit"  type="button" value="Submit">
			</div>		
		</div>
		
<!--
		-------------------------------------------------------------------------------------------------------------
		BEGINNING OF USER COMMENTS SCREEN
		-------------------------------------------------------------------------------------------------------------
-->		
		<div class="wrapper" id="commentsFormatUser">
			<div class="top">
			</div>	
				<textarea class="container" name="usermsg" id="addCmmtsUser" placeholder="If you have any comments or suggestions about your chat that may be used to help us improve the experience for future users, please write them here. Thank you. (Leave blank if not applicable):"></textarea>
				<div class = "buttonHolder">
					<input class = "submitbutton" type="button"  id="submitcmmtsUser" value="Send" />
				</div>				
		</div>
		

</body>
</html>