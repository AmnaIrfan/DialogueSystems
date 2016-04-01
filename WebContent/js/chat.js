$(function() {
	$("#chat-submit").click(function(e) {
		var msg = $("#chat-input").val();
		$("#chat-input").val('')
		addToChat("Amna", msg)
	    $.ajax({
	    	url: "MyServlet", 
	    	type:"POST",
	    	data:{msg:msg},
	    	success: function(reply){
	    		addToChat("Server", reply)
    		}});
	})
	var addToChat = function(name, msg) {
		$("#chat-area").append('<b>' + name +'</b>' + ": " + msg +"<br/>")
	}
});