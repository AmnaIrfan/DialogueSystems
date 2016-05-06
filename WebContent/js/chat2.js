

$(function() {
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
	    		addToChat(time, "Health Guru", reply)
    		}});
		}
		else{
			$("#chat-input").focus()
		}
	})
		
	var addToChat = function(time, name, msg) {
		$("#chat-area").append("("+time+") ", '<b>' + name +'</b>' + ": " + msg +"<br/>")
		  $('#chat-area').animate({
			  scrollTop: $('#chat-area').get(0).scrollHeight});
		$("#chat-input").focus()

	}
	
	$("#chat-input").keyup(function(event){
		if(event.keyCode == 13) {
			
			if($.trim($("#chat-input").val()) != ""){
				$("#chat-submit").click();}
			else{
				$("#chat-input").val('')
				$("#chat-input").focus()
			}
		}
		

	});
	

});

