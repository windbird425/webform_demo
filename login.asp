<%
Response.CodePage = 65001 
Response.CharSet = "utf-8"
response.buffer = true
response.expires = -1
response.addheader "pragma","no-cache"

%>

<html>
<head>
<meta name="viewport" content="width=device-width initial-scale=1, maximum-scale=2">  
<meta name="format-detection" content="telephone=no">
<meta name="description" content="">
<meta name="keywords" content="">
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<link rel="apple-touch-icon" href="images/tj.png"/>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="content-type" content="text/html;charset=UTF-8">
<link href="style.css" rel="stylesheet">
<title></title>
<style type="text/css">


</style>  
</head>
<body style="margin-top:0;margin-left:0;" class='bodybgcolor' >
<script language="vbscript" src="control.vbs"></script>

<form id=frmlogin name="frmlogin" method="post" action="quanweb_loginchk.asp">
<div class='text_middle title_h2' >XXX長照機構</div>
<div  >
	<div class='text_middle' >
		帳號：<input type=text class='textone' id='txtid' name='txtid' size=20 maxlength=20 style="background-color:white;" onfocus='this.select();' onblur="txtid_onblur();" >
	</div>
	<div class='text_middle' >
		密碼：<input type=password class='textone' id='txtpwd' name='txtpwd' size=20 maxlength=30 style="background-color:white;"  onfocus='this.select();' onkeydown="checkenter(event)" >
	</div>
	<input type=hidden name=check value="confirm">
	</form>
	<div class='text_middle' >
		<input type="button" id='chk' name='chk' value='確定送出' onclick="cmblogin_onclick();" >
		<input type="hidden" id="ls_chochk" name="ls_chochk" value="">
	</div>
</div>
<script language="javascript" >

//document.oncontextmenu = function() {return false;}

function txtid_onblur(){
	document.getElementById("txtpwd").value = "";
}
function cmblogin_onclick(){
	if(frmlogin.txtid.value == "" ) {
		alert('帳號不能為空!!');
		return false;
	}
	if(frmlogin.txtpwd.value == "" ){
		alert('密碼不能為空!!');
		return false;
	}
	if(frmlogin.txtpwd.value.indexOf(" ") >= 0 ){
		alert('密碼有誤，請重新輸入!!');
		return false;
	}
	frmlogin.submit();
}

function checkenter(evt){
	evt = (evt) ? evt : ((window.event) ? window.event : "");
	var key = evt.keyCode?evt.keyCode:evt.which;
	if (key == 13){ 
		if(frmlogin.txtid.value == "" ){
			alert('帳號不能為空!!');
			return false;
		}
		if(frmlogin.txtpwd.value == "" ){
			alert('密碼不能為空!!');
			return false;
		}
		frmlogin.submit();
	}
}

</script> 
</body>
</html>