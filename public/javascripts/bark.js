var socket = io.connect('http://io.bow.gg/chat');

var chatWindow = $('#chat');
var messageBox = $('#message');
var myName = $('#myName').val();
var myRoom = $('#myRoom').val();


var showMessage = function(msg) {
	//console.log(msg);
	chatWindow.append($('<p>').text(msg));     
	chatWindow.scrollTop(chatWindow.height());
};

socket.on('connect', function() {
			  //소캣 커낵션 이후 실행
			  socket.emit('join', {roomName:myRoom, nickName: myName}); 
		  });

socket.on('joined', function(data) {
			  if(data.isSuccess) {
				  showMessage(data.nickName + '님이 입장하셨습니다.');
			  }
		  });

socket.on('leaved', function(data) {
			  showMessage(data.nickName + '님이 나가셨습니다.');
		  });

socket.on('message', function(data) {
			  showMessage(data.nickName + ' : ' + data.msg); 
		  });

socket.on('preTalked', function(data) {
			  console.log(data.preTalk);

			  $.each(data.preTalk, function(index, value) {
						 console.log(index + ': ' + value);
						 showMessage(value);
					 });
			  //showMessage(data.nickName + ' : ' + data.msg); 
		  });

$('form').submit(function(e) {
					 e.preventDefault();
					 var msg = messageBox.val();
					 if ($.trim(msg) !== '') {
						 showMessage(myName + ' : ' + msg);
						 socket.json.send({nickName:myName, msg:msg});
						 messageBox.val('');
					 }
				 });


window.onbeforeunload = Call;
//window.onunload = Call2;


function Call(){
	return "채팅방을 나가시겠습니까?";
}



$(window).unload( function(){
					  alert("TEST");
} );



/*
$('#joinBtn').click(function(e) {
						//console.log(myRoom);
						socket.emit('join', {roomName:myRoom, nickName:myName});
						//location.href='/';
					});
$('#leaveBtn').click(function(e) {
						 socket.emit('leave', {nickName:myName});
						 //location.href='/';
					 });
$('#saveBtn').click(function(e) {
						myRoom = $('#myRoom').val();
						myName = $('#myName').val();
						console.log(myRoom, myName);
						//location.href='/';
					});
$('#showPretalkBtn').click(function(e) {
							   socket.emit('showPreTalk', {roomName:myRoom, nickName:myName});
							   //location.href='/';
						   });


*/