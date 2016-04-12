<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Dialogue Chat System</title>
	
	<link rel="stylesheet" type="text/css" href="css/style.css">
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
	<script src="js/chat.js"></script>
</head>

<body>
<div id="main">
	<div id="top"></div>
	<div id="chat-area">

	</div>

	<form name ="chat-input-inner" action="">
			<textArea id="chat-input" name="msg"></textArea>
			<button id="chat-submit" class="submitbutton"type="button" onclick="function()" onkeyup="function()">Send</button>
	</form>

</div>
</body>
</html>