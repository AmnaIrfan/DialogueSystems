<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>A Healthy Choice</title>
	
	<link rel="stylesheet" type="text/css" href="css/style.css">
	<link rel="stylesheet" type="text/css" href="css/jquery.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
	<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>	
	<script src="js/chat.js"></script>
</head>

<body>


<div id="userDialog" title="User Login">
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
				<h4>What is your role?
					<select  id = "Position" required>
						<option value = "Select" selected>-Select-</option>
						<option value = "UndergraduateStudent">Undergraduate Student</option>
						<option value = "graduateStudent">Graduate Student</option>
						<option value = "Faculty">Faculty</option>
						<option value = "Staff">Staff</option>
					</select>
				</h4>
				<h4>What is your gender?
					<select id = "Gender" required>
						<option value selected>-Select-</option>
						<option value = "Male">Male</option>
						<option value = "Female">Female</option>
					</select>
				</h4>
				
				<h4>What is your ethnicity?
					<select id = "Ethnicity" required>
						<option value selected>-Select-</option>
						<option value = "Caucasian">Caucasian</option>
						<option value = "Hispanic/Latino">Hispanic / Latino</option>
						<option value = "MiddleEastern">Middle Eastern</option>
						<option value = "AsianPacificIslander">Asian/Pacific Islander</option>
						<option value = "Black/AfricanAmerican">Black/African American</option>
						<option value = "Other">Other</option>
					</select>
				</h4>
				<h4>What is your age range?
					<select id = "Age" required>
						<option value selected>-Select-</option>
						<option value = "EighteenToTwentyOne">18 -21</option>
						<option value = "TwentyTwoToTwentyFive">22 - 25</option>
						<option value = "TwentySixToThirty">26 - 30</option>
						<option value = "ThirtyOneToForty">31 - 40</option>
						<option value = "FortyOneToFifty">41 - 50</option>
						<option value = "FiftyOneToSixty">51 - 60</option>
						<option value = "SixtyOneAndOlder">61 and Older</option>
					</select>
				</h4>
				
				<h4>How often do you exercise per week?
					<select id = "Exercise1" required>
						<option value selected>-Select-</option>
						<option value = "0-1times">0-1 times</option>
						<option value = "2-3times">2-3 times</option>
						<option value = "4+">4+ times</option>
					</select>
				</h4>
			
				<h4>Which type of exercises?
					<select id = "Exercise2" width = "20">
						<option value selected>-Select-</option>
						<option value = "Aerobicexercise">Aerobic exercise(walking, running, cycling)</option>
						<option value = "Anaerobicexercise">Anaerobic exercise(weight lifting)</option>
						<option value = "Flexibility">Flexibility(yoga)</option>
						<option value = "None">None</option>
					</select>
				</h4>
			
				<h4>What social network sites do you use?
					<select id = "SocialNetwork" required>
						<option value selected>-Select-</option>
						<option value = "Facebook" >Facebook</option>
						<option value = "Twitter">Twitter</option>
						<option value = "Both">Both</option>
					</select>			
				</h4>
				<h4>Please state whether you agree or disagree with the following statements.</h4>
				
				<h5>Strongly Disagree=1 and Strongly Agree=5.</h5>
				
				<h4>I feel the need to exercise more often.
					<form id="pretest1">
						<input type="radio" name="taichi1" value="1">1&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="taichi1" value="2">2&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="taichi1" value="3">3&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="taichi1" value="4">4&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="taichi1" value="5">5					
					</form>
				</h4>
				
				<h4>I am interested in learning Tai Chi.
					<form id="pretest2">
						<input type="radio" name="taichi2" value="1">1&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="taichi2" value="2">2&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="taichi2" value="3">3&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="taichi2" value="4">4&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="taichi2" value="5">5					
					</form>
				</h4>		
			</div>
			<div class = "buttonHolder">
				<input class = "submitbutton" id = "QuestSubmit" type = "button" value = "Begin Chat">
			</div>
		</div>		
		
<!--
		-------------------------------------------------------------------------------------------------------------
		BEGINNING OF USER CHAT CHAT SCREEN
		-------------------------------------------------------------------------------------------------------------
-->
<div id="main">
	<div id="top"></div>
	<div id="chat-area">

	</div>

	<div name ="chat-input-inner" action="">
			<textArea id="chat-input" name="msg"></textArea>
			<button id="chat-submit" class="submitbutton1" type="button" onclick="function()" onkeyup="function()">Send</button>
	</div>

</div>
</body>
</html>