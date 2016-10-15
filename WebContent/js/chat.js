$(document).ready(function(){
	var printYesNo = 0;
	var id = -1;
	var userType = ""
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
			userType = $("#userPassword").val().toLowerCase() 
			if(userType== "test" || userType == "student")  {
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
					$("#main").show(0, function(){
							first_msg();
					}); 
					$("#PostQuest").hide();
					$("#PostQuest2").hide();
					$("#commentsFormatUser").hide(); 
			}
				else 
					alert("Incorrect Password. Please enter again.");
			}							
		}
	});		

	var first_msg = function() {
		var time= new Date().toLocaleTimeString().replace(/:\d+ /, ' ');
		console.log("fits");
		$.ajax({
			url: "MyServlet", 
			type:"POST",
			data:{
				msg:null,
				reqtype:"demo",
				pos: $("#Position").val(),
				sex: $("#Gender").val(),
				race: $("#Ethnicity").val(),
				age: $("#Age").val(),
				ex1: $("#Exercise1").val(),
				ex2: $("#Exercise2").val(),
				soc:  $("#SocialNetwork").val(),		
				pre1: $('input:radio[name=taichi1]:checked').val(),
				pre2: $('input:radio[name=taichi2]:checked').val(),
				userType: userType
				},
			success: function(reply){
				var question = reply.split("|")[0]
				id = reply.split("|")[1]
				console.log(question)
				console.log(id)
				if (question=="@END") {
					postchat();
				}
					
				else
					addToChat(time, "Health Guru", question);
			}});		
							
	}; 
	
	
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
			$("#main").show(0, function(){
				first_msg();
		}); 				
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
					data:{reqtype:"chat",msg:msg, userType: userType},
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
		printYesNo = 1;	
		$('body').append('<iframe src="flyer.html?id='+id+'" id="printIFrame" name="printIFrame"></iframe>');
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
						
			$("#welcome").hide();
			$("#QuestFormat").hide();
			$("#ChatFormat").hide();
			$("#PostQuest").hide();
			$("#PostQuest2").hide();
			$("#commentsFormatUser").show();
			$.ajax({
				url: "MyServlet", 
				type:"POST",
				data:{
					reqtype:"postques",
					guruUnder: $('input:radio[name=Q1]:checked').val(),
					userUnder: $('input:radio[name=Q2]:checked').val(),
					excerNeed: $('input:radio[name=Q3]:checked').val(),
					taichiInterest: $('input:radio[name=Q4]:checked').val(),
					taichiPers: $('input:radio[name=Q5]:checked').val(),
					printed: printYesNo,
					userType: userType
					},
				success: function(done){
					//alert(done);
				}});	
		}});	

	/* 
	  *----------------------------------------------------------------------------------------------------------------------------
	  *When the user clicks "Submit" the User Comments Screen, an alert pops up.
	  *----------------------------------------------------------------------------------------------------------------------------
	  */
	
	$("#submitcmmtsUser").click(function(){
		var comments = $('#addCmmtsUser').val();
		console.log("comment"+comments)
		if (comments != "") {
			$.ajax({
				url: "MyServlet", 
				type:"POST",
				data:{
					reqtype:"comments",
					comment: comments,
					userType: userType
					},
				success: function(done){
					window.location = 'thankyou.html';
				}});
		}
		
		$("#commentsFormatUser").hide();
	});
	
	
});//end of document ready function


	