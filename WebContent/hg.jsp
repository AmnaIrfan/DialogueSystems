<html>

<head>
<style>
/* Style the list */
ul#tab {
    list-style-type: none;
    margin: 0;
    padding: 0;
    overflow: hidden;
    border: 1px solid #ccc;
    background-color: #f1f1f1;
}

/* Float the list items side by side */
ul#tab li {float: left;}

/* Style the links inside the list items */
ul#tab li a {
    display: inline-block;
    color: black;
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;
    transition: 0.3s;
    font-size: 17px;
}

/* Change background color of links on hover */
ul#tab li a:hover {background-color: #ddd;}

/* Create an active/current tablink class */
ul#tab li a:focus, .active {background-color: #ccc;}

/* Style the tab content */
.tabcontent {
    display: none;
    padding: 6px 12px;
    border: 1px solid #ccc;
    border-top: none;
    border: 20px solid #312E77;
}
.chatArea {
	min-height: 300px;
	max-height: 300px;
	max-width:  1200px;
	overflow-x: none;
	overflow-y: auto;
	word-wrap: break-word;
	border: 2px solid #FFFFFF;
	padding-bottom: 20px;
}
.sendArea {
	min-height: 80px;
	max-height: 80px;
	width: 680px;
	box-shadow: 0 0 5px 5px #312E77;
}
input {
	border-left: 1px solid #CCC;
	border-right: 1px solid #CCC;
	border-top: 1px solid #CCC;
	width: 55px;
	border-radius: 5px;
	height: 50px;
	padding: 5px;
	margin-left:700px; 
	margin-top:-70px;
}
.notify {
	-webkit-animation: bgcolorchange 1s infinite; /* Chrome, Safari, Opera */ 
  	animation: 1s infinite bgcolorchange;
}

/* Chrome, Safari, Opera */
 @-webkit-keyframes bgcolorchange {
      0%   {background: red;}
      75%  {background: #f1f1f1;}
 }
 
</style>

<script type="text/javascript">
var webSocket = new WebSocket("ws://localhost:8080/DialogueSystem/chat")

webSocket.onopen = function() {
	webSocket.send(JSON.stringify({reqtype:"hg_start"}))
}

webSocket.onmessage = function(event) {
	//scroll to bottom
	console.log(event.data)
	var data = JSON.parse(event.data);
	console.log(data)
	var id = data.id
	if(document.getElementById("user_" + id) == null) {
		addTab(id, data.ip, data.sessionId)
		if (document.getElementsByClassName("tablinks").length == 1) {
			openTab(null, "user_" + id)
		}
	}
	if (data.speaker == "hg") {
		addMsg(id, "HG", data.msg, "#6919A8");
	} else {
		addMsg(id, "USER", data.msg, "#CD1B4E");
		notifyTab(id)
	}
}
	
function openTab(evt, tabName) {
    // Declare all variables
    var i, tabcontent, tablinks;

    // Get all elements with class="tabcontent" and hide them
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }

    // Get all elements with class="tablinks" and remove the class "active"
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }

    // Show the current tab, and add an "active" class to the link that opened the tab
    document.getElementById(tabName).style.display = "block";
    document.getElementById("a_" + tabName).className = document.getElementById("a_" + tabName).className .replace(" notify", "");
    document.getElementById("a_" + tabName).className += " active";
    var chatArea = document.getElementById(tabName.replace("user", "chatarea"));
	chatArea.scrollTop = chatArea.scrollHeight;
	document.getElementById(tabName.replace("user", "sendarea")).focus();
}

function notifyTab(id) {
	var tab = document.getElementById("a_user_" + id)
	
	if (tab.className.indexOf("active") > -1) {
		document.getElementById("sendarea_" + id).focus();
	} else {
		tab.className += " notify";	
	}
	var chatArea = document.getElementById('chatarea_' + id);
	chatArea.scrollTop = chatArea.scrollHeight;
}

function addTab(id, ip, sessionId) {
	var name = "user_" + id
	document.getElementById("tab").innerHTML += 
		'<li><a id="a_' + name + '" href="javascript:void(0)" class="tablinks" onclick="openTab(event, \'' + name + '\')">' + 'USER ' +  sessionId.substring(sessionId.length-4, sessionId.length)  +'</a></li>'
	document.getElementById("body").innerHTML += 
		'<div id="' + name + '" class="tabcontent">' +
  		'<div class="chatArea" id="' + 'chatarea_' + id + '">' +
 		'</div>' +
  		'<div class="sendArea" contenteditable="true" id="' + 'sendarea_' + id + '" onkeypress="sendMsgEnter(event,\'' + id + '\')">'  +
  		'</div>'+
  		'<input type="button" value="SEND" onclick="sendMsg(\'' + id + '\') " ></input>' +
		'<p style="font-size:12px;">' + ip + '</p></div>'
}

function addMsg(id, speaker, msg, color) {
	document.getElementById("chatarea_" + id).innerHTML += '<p style="color:' + color + '">' +'<b>' + speaker +  ': ' + '</b>' + msg + '</p>';
}

function sendMsg(id) {
	var sendArea = document.getElementById("sendarea_" + id)
	var emo = sendArea.innerHTML.toUpperCase();
	var data = {
		id: id,
		emo: emo,
		reqtype:"hg_emo"
	}
	if (emo == "SI" || emo == "NI" || emo== "I") {
		addMsg(id, "EMOTION", emo, "#00000");
		webSocket.send(JSON.stringify(data));
		sendArea.innerHTML = "";
	}
	
}

function sendMsgEnter(event, id){
	if(event.keyCode==13){
	
		sendMsg(id);
	}
	
}

</script>

</head>

<body>

<ul id="tab">

</ul>
<div id="body"></div>
</body>

</html>