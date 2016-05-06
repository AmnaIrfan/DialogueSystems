<?
	session_start();

	if(isset($_GET['logout'])){            									
		session_destroy();
		header("Location: index.php"); //Redirect the user }
	}
	if(isset($_GET['admin'])){
		$_SESSION['name'] ='admin';
	}
	else{
		$_SESSION['name'] ='user';
	}
?>

<!DOCTYPE html>
<html>
	<head>
		<title>A Healthy Choice</title>
		<link type="text/css" rel="stylesheet" href="css/style1.css" />		
		<link rel="stylesheet" type="text/css" href="css/jquery.css" />
		<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
		<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>		
		<script>
			$(document).ready(function(){
				
			/* 
			  *--------------------------------------------------------------------------------------------------------------------
			  * Global Variables
			  *--------------------------------------------------------------------------------------------------------------------
			  */
				var user = "";
				var agentName;
				var agentPass;
				var userPass;
				//var ip;
				var refreshIntervalId;
				var refreshIntervalType;
				var refreshintervalFindUser;
				var refreshSwitchid;
				var strat;
				
			/* 
			  *----------------------------------------------------------------------------------------------------------------------------
			  * Login (password) screen for the user (person being tested): All other screens are hidden.
			  * If the password is entered correctly, the welcome screen is displayed.
			  *----------------------------------------------------------------------------------------------------------------------------
			  */					
			 		$("#welcome").hide();
					$("#QuestFormat").hide();
					$("#ChatFormat").hide();
					$("#dialog").hide();
					$("#commentsFormatAdmin").hide();				
					$("#whySwitch").hide();
					$("#whyNoSwitch").hide();
					$("#PostQuest").hide();
					$("#PostQuest3").hide();
					$("#commentsFormatUser").hide();	
					$( "#userDialog" ).dialog({
						modal: true,
						buttons: {
						Login: function() {
							if($("#userPassword").val().toLowerCase() == "chat" || $("#userPassword").val().toLowerCase() == "test" || $("#userPassword").val().toLowerCase() == "pilot" || $("#userPassword").val().toLowerCase() == "face" || $("#userPassword").val().toLowerCase() == "dialogue")  {
								userPass = $("#userPassword").val().toLowerCase();
								$( this ).dialog( "close" ); 
									$("#dialog").hide();
									$("#welcome").show();
									$("#QuestFormat").hide();
									$("#ChatFormat").hide();
									$("#ChatFormatAdmin").hide();
									$("#commentsFormatAdmin").hide();	
									$("#PostQuest").hide();
									$("#PostQuest3").hide();
									$("#commentsFormatUser").hide();     
								}
								else
									alert("Incorrect Password. Please enter again.");
							}							
						}
					});		
					
					/* 
					  *----------------------------------------------------------------------------------------------------------------------------
					  *Animation for the "Continue" button on the User's welcome screen
					  *----------------------------------------------------------------------------------------------------------------------------
					  */
					$("#continue").mouseenter(function(){
						$("#continue").fadeTo("fast", 1.0);
					});
					$("#continue").mouseleave(function(){
						$("#continue").fadeTo("fast", 0.5);
					});
					
					/* 
					  *----------------------------------------------------------------------------------------------------------------------------
					  *When the user clicks "Continue", the welcome screen disappears and the demographics screen is
					  * displayed.
					  *----------------------------------------------------------------------------------------------------------------------------
					  */
					$("#continue").on('click',function(){
						$("#welcome").hide();
						$("#QuestFormat").show();
						$("#ChatFormat").hide();
						$("#PostQuest").hide();
						$("#PostQuest3").hide();
						$("#commentsFormatUser").hide();
					});
					
					/* 
					  *----------------------------------------------------------------------------------------------------------------------------
					  *Animation for the "Begin Chat" button on the User's demographics screen
					  *----------------------------------------------------------------------------------------------------------------------------
					  */
					$("#QuestSubmit").mouseenter(function(){
						$("#QuestSubmit").fadeTo("fast", 1.0);
					});
					$("#QuestSubmit").mouseleave(function(){
						$("#QuestSubmit").fadeTo("fast", 0.5);
					});
					
					/* 
					  *----------------------------------------------------------------------------------------------------------------------------
					  *When the user clicks "Begin Chat", if all fields are filled out, the demographics screen disappears
					  * and the chat screen is displayed. Otherwise, and error message is displayed.
					  *----------------------------------------------------------------------------------------------------------------------------
					  */
					$("#QuestSubmit").click(function(){
						if($("#SocialNetwork").val() == "" || $("#Age").val() == "" || $("#Position").val() == "" || $("#Ethnicity").val() == "" || $("#Gender").val() == "" || $("#Exercise1").val() == "" || $("#Exercise2").val() == "" || ($('input[name=taichi1]:checked').length == 0)  || ($('input[name=taichi2]:checked').length == 0)){
							$("#errorMessage1").html("Please fill out all fields and try again.").show();
						}
						else {
							var pos = $("#Position").val();
							var sex = $("#Gender").val();
							var race = $("#Ethnicity").val();
							var age = $("#Age").val();
							var ex1 = $("#Exercise1").val();
							var ex2 = $("#Exercise2").val();
							var soc = $("#SocialNetwork").val();
							var pre1 = $('input:radio[name=taichi1]:checked').val();
							var pre2 = $('input:radio[name=taichi2]:checked').val();			
															
							/* 
							  *----------------------------------------------------------------------------------------------------------------------------
							  *DATABASE CALL:
							  *The values from the pre-chat questionnaire will be inserted into the database.
							  *----------------------------------------------------------------------------------------------------------------------------
							  */	
							var request0 = $.ajax({ 
								url: "database.php", 
								async: true, 
								type: "POST", 
								data: {pass: userPass, position: pos, gender: sex, ethnicity: race, age: age, exercise1: ex1, exercise2: ex2, socialnetwork: soc, preNeed: pre1, preInterest: pre2, func: 0}, 
								dataType: "html" 
							}).success(function(data) { 
								user = data;
							})//end success
							
							$("#welcome").hide();
							$("#QuestFormat").hide();
							$("#ChatFormat").show();					
							$("#PostQuest").hide();
							$("#PostQuest3").hide();
							$("#commentsFormatUser").hide();
							
							refreshIntervalId = setInterval (loadLog, 1000);	//Reload convo every 1 seconds
							refreshIntervalType = setInterval (displayTyping, 1000);	//Reload typing message every 1 seconds
						}
						return false;
					});	
													
				
			/* 
			  *----------------------------------------------------------------------------------------------------------------------------
			  *DATABASE CALL:
			  * Determine if a new user has filled out a demographics questionnaire and been logged into
			  * the database. If yes, the admin, is assigned to that user. 
			  *----------------------------------------------------------------------------------------------------------------------------
			  */	
			function findUser() {
				if(agentPass == "chat" || agentPass == "test" ||agentPass == "face" || agentPass == "pilot" || agentPass == "dialogue" ) {
					var request1 = $.ajax({
						url: "database.php",
						async: true,
						type: "POST",
						data: {agent: agentName, pass: agentPass, func: 1},
						dataType: "html"
					}).success(function(data) {
						if(data != "notFound") {	
							user = data;		
							$(".notify").hide();
							clearInterval(refreshintervalFindUser);				
							alert("User has logged in. UserID = " + data);				
							refreshIntervalType = setInterval (displayTyping, 1000);	//Reload typing message every 1 seconds			
						}
						else
							user = "notFound";
					})//end success	
				}				
			}
			
				/* 
				  *----------------------------------------------------------------------------------------------------------------------------
				  *The function to determine if the admin or user is in the process of typing a message
				  *----------------------------------------------------------------------------------------------------------------------------
				  */	
				$('#usermsg').add('#otherComments').keydown(checkType); // When key pressed
				$('#strategies').add('#whySwitch').mousedown(checkType); // When mouse is clicked
				
				/* 
				  *----------------------------------------------------------------------------------------------------------------------------
				  *DATABASE CALL:
				  * If either the user or the admin is typing, a boolean is flipped in the Session table.
				  *----------------------------------------------------------------------------------------------------------------------------
				  */	
				function checkType() {
					var timer = null;
					var request8 = $.ajax({  //turn the clicked attribute to true
						url: "database.php", 
						async: true, 
						type: "POST", 
						data: {userNow: user, func: 8}, 
						dataType: "html" 
					}).success(function(data) { 
					})//end success			
				
					if (timer) {
						clearTimeout(timer); // Clear any previous timer
					}
					timer = setTimeout(function() { // Start timer to expire in 1 seconds
						var request9 = $.ajax({  //turn the clicked attribute to false
							url: "database.php", 
							async: true, 
							type: "POST", 
							data: {userNow: user, func: 9}, 
							dataType: "html" 
						}).success(function(data) { 
						})//end success	
					}, 1000);
				};						
				
				/* 
				  *----------------------------------------------------------------------------------------------------------------------------
				  *DATABASE CALL:
				  * If either the user or the admin is typing, a notification is displayed for the other to see.
				  * Otherwise, nothing is shown.
				  *----------------------------------------------------------------------------------------------------------------------------
				  */	
				function displayTyping() {
					var request10 = $.ajax({  //turn the clicked attribute to false
						url: "database.php", 
						async: true, 
						type: "POST", 
						data: {userNow: user, func: 10}, 
						dataType: "html" 
					}).success(function(data) { 
						//alert(data);
						if(data == 1 && user != "notFound") {
														$('.notify').html('Please wait...').fadeIn('slow'); // Show notification
												}
						else if(data == 0 && user != "notFound")
							$('.notify').fadeOut(1000); // Hide notification
					})//end success	
					
				}	
 
				/* 
				  *----------------------------------------------------------------------------------------------------------------------------
				  * When the admin submits their message, it will be stored in the database under a sessionID
				  * along with the rest of the current conversation. If the admin either forgets to write a message,
				  * give a reason for switching, or if applicable, an additional comment with they did/didn't switch
				  * strategies, an error message will be displayed, and the message will not be added to the
				  * database until all necessary information has been entered.
				  *
				  *DATABASE CALL:
				  * All of this information is stored in the database, either under the current conversation
				  * or with the sessionID and the conversation strategies.
				  *----------------------------------------------------------------------------------------------------------------------------
				  */
				$("#submitmsg").click(function(){	
										clientmsg = $("#usermsg").val();
						var request2c = $.ajax({ 
							url: "database.php", 
							async: true, 
							type: "POST", 
							data: {userNow: user, message: clientmsg, func: 3}, 
							dataType: "html" 
						}).success(function(data) { 
							//$("#mainchatbox").html(data); 
							//alert("message =  " + data);
						})//end success			
						$("#usermsg").val("");
									return false;
				});

				/* 
				  *----------------------------------------------------------------------------------------------------------------------------
				  *DATABASE CALL:
				  * Every 1 second, the system loads the conversation to the chat screen.
				  * If the the conversation fills the chatbox, the screen will automatically scroll to the
				  * bottom of the chatbox.
				  *----------------------------------------------------------------------------------------------------------------------------
				  */			
				function loadLog(){		
									var oldscrollHeight = $("#mainchatbox").prop("scrollHeight") - 20;
					var request3 = $.ajax({ 
						url: "database.php", 
						async: true, 
						type: "POST", 
						data: {userNow: user, func: 4}, 
						dataType: "html" 
					}).success(function(data) { 
						if(data != "exit") {
							$("#mainchatbox").html(data); 
							var newscrollHeight = $("#mainchatbox").prop("scrollHeight") - 20;
							if(newscrollHeight > oldscrollHeight){
							$("#mainchatbox").animate({ scrollTop: newscrollHeight }, 'normal'); //Autoscroll to bottom of div
							}
						}
						else {
							//stop refreshing chatbox 							
							clearInterval(refreshIntervalId);
							clearInterval(refreshIntervalType);
								$("#welcome").hide();
								$("#QuestFormat").hide();
								$("#ChatFormat").hide();
								$("#PostQuest").show();
								$("#PostQuest3").hide();
								$("#commentsFormatUser").hide();				
						}
					})
								
				}		

				/* 
				  *----------------------------------------------------------------------------------------------------------------------------
				  *DATABASE CALL:
				  * When the admin clicks exit, the admin is sent to a screen asking for additional comments
				  * regarding switching during the conversation, and the user is sent to a screen prompting
				  * them to print a flyer.
				  * Within the database, a boolean "exitChat" is fliped to "true".
				  *----------------------------------------------------------------------------------------------------------------------------
				  */	
				$("#exit").click(function(){
					var exit = confirm("Are you sure you want to end the session?");
					if(exit==true){
						//stop refreshing chatbox 
						clearInterval(refreshIntervalId);
						clearInterval(refreshIntervalType);
						var request4 = $.ajax({ 
							url: "database.php", 
							async: true, 
							type: "POST", 
							data: {userNow: user, func: 5}, 
							dataType: "html" 
						}).success(function(data) { 
							user = data;
						})//end success
						$("#welcome").hide();
						$("#QuestFormat").hide();
						$("#ChatFormatAdmin").hide();
						$("#commentsFormatAdmin").show();
						$("#PostQuest").hide();
						$("#PostQuest3").hide();
						$("#commentsFormatUser").hide();
					}
				});
				 							
				/* 
				  *----------------------------------------------------------------------------------------------------------------------------
				  *DATABASE CALL:
				  * After the admin submits the additional comments regarding the conversation, those
				  * comments are stored in the database in a table "AdditionalComments".
				  * The current screen is then hidden and a blank screen is displayed until the admin
				  * refreshes the screen and logs in once again to await a new user.
				  *----------------------------------------------------------------------------------------------------------------------------
				  */	
				$("#submitcmmts").click(function(){
					var addcmt = $("#addCmmts").val();
					//alert(user);
					//alert($("#addCmmts").val());
					var request13 = $.ajax({ 
							url: "database.php", 
							async: true, 
							type: "POST", 
							data: {userNow: user, message: addcmt, func: 13}, 
							dataType: "html" 
						}).success(function(data) { 
						})//end success
					$("#welcome").hide();
					$("#QuestFormat").hide();
					$("#ChatFormatAdmin").hide();
					$("#commentsFormatAdmin").hide();
					$("#PostQuest").hide();
					$("#PostQuest3").hide();
					$("#commentsFormatUser").hide();
				});
		
				/* 
				  *----------------------------------------------------------------------------------------------------------------------------
				  *DATABASE CALL:
				  * After the chat is over, the user may select to either print a flyer with more information or
				  * decline. This choice is sent to the database and stored under "PersuasionSuccess".
				  * Additionally, if the user chooses to print, "flyer.php" is printed. The flyer contains a 
				  * user-specific url for our tai chi website. If the user should choose to visit this site, that
				  * success is recorded in our database.
				  *----------------------------------------------------------------------------------------------------------------------------
				  */	
				$("#printing").on('click',function(){
					var printYesNo = 1;			
					$('body').append('<iframe src="flyer.php?userNow='+user+'" id="printIFrame" name="printIFrame"></iframe>');
					$('#printIFrame').bind('load', 
						function() { 
							window.frames['printIFrame'].focus(); 
							window.frames['printIFrame'].print(); 
						}
					);
					var request6 = $.ajax({ 
						url: "database.php", 
						async: true, 
						type: "POST", 
						data: {userNow: user, printFlyer: printYesNo, func: 6}, 
						dataType: "html" 
					}).success(function(data) { 
					})//end success
					$("#welcome").hide();
					$("#QuestFormat").hide();
					$("#ChatFormat").hide();
					$("#PostQuest").hide();		
					$("#PostQuest3").show();
					$("#commentsFormatUser").hide();							
				});
					
				$("#nothank").on('click',function(){
					var printYesNo = 0;
					var request6 = $.ajax({ 
						url: "database.php", 
						async: true, 
						type: "POST", 
						data: {userNow: user, printFlyer: printYesNo, func: 6}, 
						dataType: "html" 
					}).success(function(data) { 
					})//end success
					$("#welcome").hide();
					$("#QuestFormat").hide();
					$("#ChatFormat").hide();
					$("#PostQuest").hide();
					$("#PostQuest3").show();
					$("#commentsFormatUser").hide();					
				});
				
				$("#Thankyouscreen").on('click',function(){
				
					$("#welcome").hide();
					$("#QuestFormat").hide();
					$("#ChatFormat").hide();
					$("#PostQuest").hide();
					$("#PostQuest3").show();	
					$("#commentsFormatUser").hide();				
				});
		
				/* 
				  *----------------------------------------------------------------------------------------------------------------------------
				  *DATABASE CALL:
				  * The user is asked to fill out a post-chat survey asking them to rank their opinion from
				  * 1-5 on a series of questions. When they click submit, the answers are stored in the
				  * database.
				  *----------------------------------------------------------------------------------------------------------------------------
				  */	
				$("#PostQuestsubmit").on('click',function(){
					if(($('input[name=Q1]:checked').length == 0)  || ($('input[name=Q2]:checked').length == 0) || ($('input[name=Q3]:checked').length == 0) || ($('input[name=Q4]:checked').length == 0) || ($('input[name=Q5]:checked').length == 0)){
						$("#errorMessage2").html("Please fill out all fields and try again.").show();
					}
					else {
						var post1 = $('input:radio[name=Q1]:checked').val();
						var post2 = $('input:radio[name=Q2]:checked').val();
						var post3 = $('input:radio[name=Q3]:checked').val();
						var post4 = $('input:radio[name=Q4]:checked').val();
						var post5 = $('input:radio[name=Q5]:checked').val();
						var request7 = $.ajax({ 
							url: "database.php", 
							async: true, 
							type: "POST", 
							data: {userNow: user, chatUnderstoodMe: post1, understoodChat: post2, exerciseNeed: post3, taiChiInterest: post4, taiChiConvinced: post5, func: 7}, 
							dataType: "html" 
						}).success(function(data) { 
							//user = data;
							$("#welcome").hide();
							$("#QuestFormat").hide();
							$("#ChatFormat").hide();
							$("#PostQuest").hide();
							$("#PostQuest3").hide();	
							$("#commentsFormatUser").show();
							
						})//end success
						.error(function() {
							alert("fail");
						})
						return false;	
					}				
				});
				
				/* 
				  *----------------------------------------------------------------------------------------------------------------------------
				  *DATABASE CALL:
				  * Lastly, the user is given an opportunity to submit comments to us regarding their
				  * experience with the experiment (they may choose to decline). These comments will be 
				  * used to improve future conditions. Again, these comments are stored in the database 
				  * within the "Session" table,
				  * 
				  * Upon submitting the comments form (either filled out or blank), the user is finished with
				  * the experiment.
				  *----------------------------------------------------------------------------------------------------------------------------
				  */	
				$("#submitcmmtsUser").on('click',function(){
					var usercmt = $("#addCmmtsUser").val();
					//alert(user);
					//alert($("#addCmmtsUser").val());
					var request11 = $.ajax({ 
						url: "database.php", 
						async: true, 
						type: "POST", 
						data: {userNow: user, message: usercmt, func: 11}, 
						dataType: "html" 
					}).success(function(data) { 
						window.location = 'index.php?logout=true'; 
					})//end success
					.error(function() {
						alert("fail");
					})
				});
			});//end of document.ready(function)	

		</script>		
		
		
							
	</head>

	<body>
		<div id="userDialog" title="User Login">
			<p>Please enter your password: </p>
			<input id="userPassword" type="text">
		</div>
		
		<div id="dialog" title="Admin Login">
			<p>Admin, please enter your name: </p>
			<input id="adminName" type="text">
			<p>Please enter your password: </p>
			<input id="adminPassword" type="text">
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
		BEGINNING OF ADMIN CHAT SCREEN
		-------------------------------------------------------------------------------------------------------------
-->
		
<!--
		-------------------------------------------------------------------------------------------------------------
		BEGINNING OF USER CHAT CHAT SCREEN
		-------------------------------------------------------------------------------------------------------------
-->

<div id="main">
	<div id="top">
	</div>
	<div id="chat-area">
	</div>

	<form name ="chat-input-inner" action="">
			<textArea id="chat-input" name="msg"></textArea>
			<button id="chat-submit" class="submitbutton"type="button" onclick="function()" onkeyup="function()">Send</button>
	</form>

</div>


		<div class="wrapper" id="ChatFormat">
			<div class="top">
				<div class="notify"></div>
			</div>	
			<div class="container" id="mainchatbox">
				
			</div>
		<form name ="chat-input-inner" action="">
			<textArea id="chat-input" name="msg"></textArea>
			<button id="chat-submit" class="submitbutton"type="button" onclick="function()" onkeyup="function()">Send</button>
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
					<input class="submitbutton" id="printing"  type="button" value="Print Flyer" >
					<br><br>
					<input class="submitbutton" id="nothank"  type="button" value="No Thanks" >
				</div>
			</div>				
		</div>
		
<!--
		-------------------------------------------------------------------------------------------------------------
		BEGINNING OF POST QUESTIONS SCREEN
		-------------------------------------------------------------------------------------------------------------
-->		
		<div class="wrapper" id="PostQuest3">
			<div class="top">
				<div style="clear:both"></div>
			</div>	
			<div class="container" id="questbox">
				<h4>Please state whether you agree or disagree with the following statements.</h4>
				<span id="errorMessage2"></span>
				<h5>Strongly Disagree=1 and Strongly Agree=5.</h5>				
				<h4>The chat program understood what I was saying.
					<form id="posttest1">
							<input type="radio" name="Q1" value="1">1&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q1" value="2">2&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q1" value="3">3&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q1" value="4">4&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q1" value="5">5
					</form>		
				</h4>
				<h4>I understood what the chat program was saying to me.
					<form id="posttest2">
							<input type="radio" name="Q2" value="1">1&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q2" value="2">2&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q2" value="3">3&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q2" value="4">4&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q2" value="5">5				
					</form>
				</h4>
				<h4>After this chat,</h4>
				<h4>I feel the need to exercise more often.
					<form id="posttest3">							
							<input type="radio" name="Q3" value="1">1&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q3" value="2">2&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q3" value="3">3&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q3" value="4">4&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q3" value="5">5					
					</form>
				</h4>
				<h4>I am interested in learning Tai chi.
					<form id="posttest4">
							<input type="radio" name="Q4" value="1">1&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q4" value="2">2&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q4" value="3">3&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q4" value="4">4&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q4" value="5">5					
					</form>
				</h4>
				<h4>This chat persuaded me to find out more about Tai Chi.
					<form id="posttest5">
							<input type="radio" name="Q5" value="1">1&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q5" value="2">2&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q5" value="3">3&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q5" value="4">4&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="Q5" value="5">5				
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

