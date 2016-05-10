$(document).ready(function(){

	/* 
	  *----------------------------------------------------------------------------------------------------------------------------
	  *The login screen is the initial visible interface.  The rest of the screens are hidden.
	  *----------------------------------------------------------------------------------------------------------------------------
	  */	

	$("#welcome").hide();
	$("#QuestFormat").hide();
	$("#PostQuest").hide();
	$("#PostQuest2").hide();
	$("#commentsFormatUser").hide();  
	$("#main").hide(); 
	$( "#userLogin" ).dialog({
		modal: true,
		buttons: {
		Login: function() {
			if($("#userPassword").val().toLowerCase() == "test")  {
					userPass = $("#userPassword").val().toLowerCase();
					$( this ).dialog( "close" ); 
					$("#welcome").show();
					$("#QuestFormat").hide();
					$("#PostQuest").hide();
					$("#PostQuest2").hide();
					$("#commentsFormatUser").hide();     
				}
			else if($("#userPassword").val().toLowerCase()=="skip") {
					userPass = $("#userPassword").val().toLowerCase();
					$( this ).dialog( "close" ); 
					$("#welcome").hide();
					$("#QuestFormat").hide();
					$("#main").show(); 	
					$("#PostQuest").hide();
					$("#PostQuest2").hide();
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
	$("#continue").click(function(){
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
		if($("#SocialNetwork").val() == "" || $("#Age").val() == "" || $("#Position").val() == "" || 
				$("#Ethnicity").val() == "" || $("#Gender").val() == "" || $("#Exercise1").val() == "" || 
				$("#Exercise2").val() == "" || ($('input[name=taichi1]:checked').length == 0)  || 
				($('input[name=taichi2]:checked').length == 0)){
			$("#errorMessage1").html("Please fill out all fields and try again.").show();
			$('#questbox2').scrollTop(0);
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

											
			$("#welcome").hide();
			$("#QuestFormat").hide();
			$("#main").show();					
			$("#PostQuest").hide();
			$("#PostQuest3").hide();
			$("#commentsFormatUser").hide();
		}});	
	
	/* 
	*----------------------------------------------------------------------------------------------------------------------------
	*onClick event for chat screen
	*----------------------------------------------------------------------------------------------------------------------------
	*/

	$("#chat-submit").click(function(e) {
			
			if ($.trim($("#chat-input").val())) {
		
				var msg = $("#chat-input").val();
				var time= new Date().toLocaleTimeString().replace(/:\d+ /, ' ');
		
				$("#chat-input").val('')
		
				addToChat(time,"You", msg)
				$.ajax({
					url: "MyServlet", 
					type:"POST",
					data:{msg:msg},
					success: function(reply){
						if (reply=="@END")
							postchat();
						else
							addToChat(time, "Health Guru", reply);
					}});
			}
			else{
				$("#chat-input").focus();
			}
		})

			
	/* 
	*----------------------------------------------------------------------------------------------------------------------------
	*adds chat entry history to chat-area, auto-scrolls to display the last entry, 
	*keeps focus on chat-input field
	*----------------------------------------------------------------------------------------------------------------------------
	*/
		
	var addToChat = function(time, name, msg) {
		$("#chat-area").append("("+time+") ", '<b>' + name +'</b>' + ": " + msg +"<br/>")
		  $('#chat-area').animate({
			  scrollTop: $('#chat-area').get(0).scrollHeight});
		$("#chat-input").focus();
	}

	/* 
	*----------------------------------------------------------------------------------------------------------------------------
	*fires chat-submit onclick event when Enter keypress but does nothing when no text entered
	*----------------------------------------------------------------------------------------------------------------------------
	*/

	$("#chat-input").keyup(function(event){
		if(event.keyCode == 13) {
			
			if($.trim($("#chat-input").val()) != ""){
				$("#chat-submit").click();}
			else{
				$("#chat-input").val('');
				$("#chat-input").focus();
			}
		}
	}); //end of keyup event
	
	/* 
	*----------------------------------------------------------------------------------------------------------------------------
	*When chat ends, proceed to post chat questionnaire
	*----------------------------------------------------------------------------------------------------------------------------
	*/
	var postchat = function(){
		$("#welcome").hide();
		$("#QuestFormat").hide();
		$("#ChatFormat").hide();
		$("#main").hide();
		$("#PostQuest").show();
		$("#PostQuest2").hide();
		$("#commentsFormatUser").hide();
	}
	
	/* 
	*----------------------------------------------------------------------------------------------------------------------------
	*When user clicks "Print Flyer", a print dialogue box appears ready to print flyer and 
	*opens the Post Chat Questionnaire. If user clicks "No Thanks", user is navigated to 
	*Post Chat Questionnaire directly without printing flyer.
	*----------------------------------------------------------------------------------------------------------------------------
	*/
	
	$("#printing").click(function(){
		var printYesNo = 1;			
		$('body').append('<iframe src="fleaFlyer.pdf" id="printIFrame" name="printIFrame"></iframe>');
		$('#printIFrame').bind('load', 
			function() { 
				window.frames['printIFrame'].focus(); 
				window.frames['printIFrame'].print(); 
			});
		$('#printIFrame').hide();
		$("#welcome").hide();
		$("#QuestFormat").hide();
		$("#ChatFormat").hide();
		$("#PostQuest").hide();		
		$("#PostQuest2").show();
		$("#commentsFormatUser").hide();							
	});
		
	$("#nothank").click(function(){
		var printYesNo = 0;
		$("#welcome").hide();
		$("#QuestFormat").hide();
		$("#ChatFormat").hide();
		$("#PostQuest").hide();
		$("#PostQuest2").show();
		$("#commentsFormatUser").hide();					
	});
	
	/* 
	  *----------------------------------------------------------------------------------------------------------------------------
	  *When the user clicks "Submit" the Post Chat Questionnaire, user is directed to the comments screen.
	  *----------------------------------------------------------------------------------------------------------------------------
	  */
	$("#PostQuestsubmit").click(function(){
		if($('input[name=Q1]:checked').length == 0 || $('input[name=Q2]:checked').length == 0 ||
				$('input[name=Q3]:checked').length == 0 || $('input[name=Q4]:checked').length == 0 ||
				$('input[name=Q5]:checked').length == 0){
				$("#errorMessage2").html("Please fill out all fields and try again.").show();
				$('#questbox2').scrollTop(0);
		}
		else {
			var q1 = $("#posttest1").val();
			var q2 = $("#posttest2").val();
			var q3 = $("#posttest3").val();
			var q4 = $("#posttest4").val();
			var q5 = $("#posttest5").val();
			$("#welcome").hide();
			$("#QuestFormat").hide();
			$("#ChatFormat").hide();
			$("#PostQuest").hide();
			$("#PostQuest2").hide();
			$("#commentsFormatUser").show();
		}});	

	/* 
	  *----------------------------------------------------------------------------------------------------------------------------
	  *When the user clicks "Submit" the User Comments Screen, an alert pops up.
	  *----------------------------------------------------------------------------------------------------------------------------
	  */
	
	$("#submitcmmtsUser").click(function(){
		$("#commentsFormatUser").hide();
		alert("Thank you and goodbye!");
		
	});
	
	
});//end of document ready function


	