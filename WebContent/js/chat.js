$(function() {
	$("#chat-submit").click(function(e) {
		if ($("#chat-input").val()) {
			
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
	})
		
	var addToChat = function(time, name, msg) {
		$("#chat-area").append("("+time+") ", '<b>' + name +'</b>' + ": " + msg +"<br/>")
		  $('#chat-area').animate({
			  scrollTop: $('#chat-area').get(0).scrollHeight});
		$("#chat-input").focus()

	}
	
	$("#chat-input").keyup(function(event){
		if(event.keyCode == 13){
				$("#chat-submit").click();
		}
	});
	

});

