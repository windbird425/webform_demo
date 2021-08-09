<%@ CODEPAGE=65001%>
<% 
response.buffer = true
response.expires = -1
response.addheader "pragma","no-cache"
response.Charset = "UTF-8"
if len(request("check")) > 0 then
	uid = trim(request("txtid"))
	pwd = trim(request("txtpwd"))
	'檢查帳號與環境
	
	if true then		' 登入成功
		session("quanweb_online")	= true
		session("user_id")			= uid
		response.write "<form name='frm2' method='post' action='quanweb_visit.asp'></form>"
		response.write "<script language='javascript'>frm2.submit();</script>"
	else
		response.write "<script language='javascript' >alert('帳號密碼錯誤');history.back();</script>"
		response.end
	end if
else
	response.write "<script language='javascript'>alert('請由首頁進入。');top.location.href='login.asp';</script>"
	response.end
end if

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html;charset=UTF-8">
<title></title>
</head>
</html>
