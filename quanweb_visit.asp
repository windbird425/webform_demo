<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
Response.CodePage = 65001 
Response.CharSet = "utf-8"
' 注意!!!此頁面以後可以當作切換作業的首頁，但目前只規劃做關懷訪視--逐次紀錄表
' 因而原先的view 1先改為普通頁面的view
'################################################################################
function get_YN(a_flag)	
	if a_flag = "true" then
		YN_str = "Y"
	elseif a_flag = "false" then
		YN_str = "N"
	end if
	get_YN = YN_str
end function
'################################################################################

userid			= session("user_id")
' set rs_volunteer= get_volunteer(userid)
' volun_name		= rs_volunteer("volun_name")
now_dt			= right("0"&(Year(Now())-1911),3)&right("0"&Month(Now()),2)&right("0"&Day(Now()),2)&right("0"&Hour(Now()),2)&right("0"&Minute(Now()),2)&right("0"&Second(Now()),2)
first_flag		= true

if request("arg01") = "SELECT" then
	scase_id	= request("arg04")
	first_flag	= false
elseif request("arg01") = "Insert" or request("arg01") = "Update" then	' 新增
	' 關懷訪視資料
	scase_id		= request("arg02")
	visit_dt		= request("arg03")
	info_str1		= request("arg04")
	tmp_arr			= split(Cstr(info_str1),"!@!")
	visit_environ	= tmp_arr(0)
	environ_oth		= tmp_arr(1)
	visit_outward	= tmp_arr(2)
	outward_other	= tmp_arr(3)
	visit_attention	= tmp_arr(4)
	attention_other	= tmp_arr(5)
	visit_mood		= tmp_arr(6)
	mood_other		= tmp_arr(7)
	service_chat	= get_YN(tmp_arr(8))
	service_hp		= get_YN(tmp_arr(9))
	service_sbp		= tmp_arr(10)
	service_dbp		= tmp_arr(11)
	service_pulse	= tmp_arr(12)
	service_arrange	= get_YN(tmp_arr(13))
	service_promote	= get_YN(tmp_arr(14))
	service_other	= tmp_arr(15)
	visit_memo		= request("arg05")
	upd_name		= "WEB_"&userid
	' upd_dt			= right("0" & year(now())-1911,3) & right("0" & month(now()),2) & right("0" & day(now()),2) & right("00" & hour(now()),2) & right("00" & minute(now()),2) & right("00" & second(now()),2)
	upd_dt			= now_dt
	
	if request("arg01") = "Insert" then
		' call insert_data(scase_id,visit_dt,visit_environ,environ_oth,visit_outward,outward_other,visit_attention,attention_other,visit_mood,mood_other,service_chat,service_hp,service_sbp,service_dbp,service_pulse,service_arrange,service_promote,service_other,visit_memo,volun_name,upd_name,upd_dt)
		' if err.Number <> 0 then
			' insert_success = false
		' else 
			' insert_success = true
		' end if
		insert_success = true
	elseif request("arg01") = "Update" then
		' call update_data(scase_id,visit_dt,visit_environ,environ_oth,visit_outward,outward_other,visit_attention,attention_other,visit_mood,mood_other,service_chat,service_hp,service_sbp,service_dbp,service_pulse,service_arrange,service_promote,service_other,visit_memo,volun_name,upd_name,upd_dt)
		' if err.Number <> 0 then
			' update_success = false
		' else 
			' update_success = true
		' end if
		update_success = true
	end if
	
	first_flag	= false
end if
%>
<meta name="viewport" content="width=device-width initial-scale=1, maximum-scale=2">  
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<title>XXX長照機構</title>
<script src="script/jquery-1.9.1.min.js"></script>
<script src="script/mScript.js?"></script>
<script src="sweetalert/docs/assets/sweetalert/sweetalert.min.js"></script>
<script type="text/javascript">
$(document).ready(pageIniti);
function pageIniti(){
	$(objArray[0]).css({'width':parseInt($(objArray[0]).css('width')) + defaultArray[0],'height':defaultArray[1]});
}
function ChgEnable(chk_obj,obj_name1,obj_name2,obj_name3){	//判斷文字方塊能否輸入
	if(chk_obj.id == "service_hp"){
		var text_obj1 = document.getElementById(obj_name1);
		var text_obj2 = document.getElementById(obj_name2);
		var text_obj3 = document.getElementById(obj_name3);
		if(chk_obj.checked){
			text_obj1.disabled = false;
			text_obj2.disabled = false;
			text_obj3.disabled = false;
		}else{
			text_obj1.disabled = true;
			text_obj2.disabled = true;
			text_obj3.disabled = true;
		}
	}else{
		var text_obj1 = document.getElementById(obj_name1);
		if(chk_obj.checked){
			text_obj1.disabled = false;
		}else{
			text_obj1.disabled = true;
		}
	}
	//alert(chk_obj.id);
}
function save(way){
	var x			= document.getElementById("form_save");
	var scase_id	= x.scase_id.value
	var visit_dt	= x.visit_dt.value
	var info_str1	= "";	//居家環境、案主外貌、注意力、案主心情、提供服務
	var visit_memo	= x.visit_memo.value.trim();
	
	clean			= x.clean.checked;	//居家環境
	messy			= x.messy.checked;
	dirty			= x.dirty.checked;
	environ_other	= x.environ_other.checked;
	if(!(clean || messy || dirty || environ_other)){
		swal("居家環境","尚未選擇!!");
		return false;
	}
	else{
		visit_environ	= x.visit_environ.value;
		environ_oth		= x.environ_oth.value.trim();
		if(visit_environ == 4 ){
			if(environ_oth == ""){
				swal("居家環境","請填寫其他!!");
				return false;
			}
		}else{environ_oth = "";}
	}
	
	visit_outward1	= x.visit_outward1.checked;	//案主外貌
	visit_outward2	= x.visit_outward2.checked;
	visit_outward3	= x.visit_outward3.checked;
	visit_outward4	= x.visit_outward4.checked;
	if(!(visit_outward1 || visit_outward2 || visit_outward3 || visit_outward4)){
		swal("案主外貌","尚未選擇!!");
		return false;
	}
	else{
		visit_outward	= x.visit_outward.value;
		outward_other	= x.outward_other.value.trim();
		if(visit_outward == 4 ){
			if(outward_other == ""){
				swal("案主外貌","請填寫其他!!");
				return false;
			}
		}else{outward_other = "";}
	}
	
	visit_attention1	= x.visit_attention1.checked;	//注意力
	visit_attention2	= x.visit_attention2.checked;
	visit_attention3	= x.visit_attention3.checked;
	visit_attention4	= x.visit_attention4.checked;
	if(!(visit_attention1 || visit_attention2 || visit_attention3 || visit_attention4)){
		swal("注意力","尚未選擇!!");
		return false;
	}
	else{
		visit_attention	= x.visit_attention.value;
		attention_other	= x.attention_other.value.trim();
		if(visit_attention == 4 ){
			if(attention_other == ""){
				swal("注意力","請填寫其他!!");
				return false;
			}
		}else{attention_other = "";}
	}
	
	visit_mood1	= x.visit_mood1.checked;	//案主心情
	visit_mood2	= x.visit_mood2.checked;
	visit_mood3	= x.visit_mood3.checked;
	visit_mood4	= x.visit_mood4.checked;
	if(!(visit_mood1 || visit_mood2 || visit_mood3 || visit_mood4)){
		swal("案主心情","尚未選擇!!");
		return false;
	}
	else{
		visit_mood	= x.visit_mood.value;
		mood_other	= x.mood_other.value.trim();
		if(visit_mood == 4 ){
			if(mood_other == ""){
				swal("案主心情","請填寫其他!!");
				return false;
			}
		}else{mood_other = "";}
	}
	
	service_chat	= x.service_chat.checked;	//提供服務
	service_hp		= x.service_hp.checked;
	if(service_hp == true){
		service_sbp		= x.service_sbp.value.trim();
		service_dbp		= x.service_dbp.value.trim();
		service_pulse	= x.service_pulse.value.trim();
		if(service_sbp == ""){
			service_sbp = "null";
		}else{
			if(isNaN(service_sbp)){
				swal("提供服務","收縮壓請填寫數字!!");
				return false;
			}
		}
		if(service_dbp == ""){
			service_dbp = "null";
		}else{
			if(isNaN(service_dbp)){
				swal("提供服務","舒張壓請填寫數字!!");
				return false;
			}
		}
		if(service_pulse == ""){
			service_pulse = "null";
		}else{
			if(isNaN(service_pulse)){
				swal("提供服務","脈搏請填寫數字!!");
				return false;
			}
		}
	}else{
		service_sbp		= "null";
		service_dbp		= "null";
		service_pulse	= "null";
	}
	service_arrange	= x.service_arrange.checked;
	service_promote	= x.service_promote.checked;
	service_chk5	= x.service_chk5.checked;	
	service_other	= x.service_other.value.trim();
	if(service_chk5 && service_other == ""){
		swal("提供服務","請填寫其他!!");
		return false;
	}else if(service_chk5 != true){service_other = "";}
	
	info_str1		= visit_environ+"!@!"+environ_oth+"!@!"+visit_outward+"!@!"+outward_other+"!@!"+visit_attention+"!@!"+attention_other+"!@!"+visit_mood+"!@!"+mood_other+"!@!"+service_chat+"!@!"+service_hp+"!@!"+service_sbp+"!@!"+service_dbp+"!@!"+service_pulse+"!@!"+service_arrange+"!@!"+service_promote+"!@!"+service_other
	RetrievePage("quanweb_visit.asp",way,scase_id,visit_dt,info_str1,visit_memo);
}
</script>
<link rel="stylesheet" type="text/css" href="style/mStyle.css" />
<style type=text/css>
.flexbox-left{
	display:flex;
	justify-content:left;
	text-align:left;
	margin-bottom:10px;
}
.flexbox-space-around{
	display:flex;
	justify-content:space-around;
	text-align:center;
}
div.mField div.cont td{
	text-align:left;
}
.other{
	align-self: flex-end;
}
/*baseline*/
.baseline{
	width:90%;
}
</style>
</head>
<body>
    <div class="mStage">
    	<div class="mHeader">
        	<div class="mTitle">關懷訪視</div>
        	<div class="backbutton" style="display:none;"><div class="b2"><div class="b1">&nbsp;</div></div></div>
			
			<!--<div class="homebutton"><div class="b2"><div class="b1"><img src="images/homeIcon.png" /></div></div></div>-->
			
        </div>
        <div class="frame">
		<%
		response.write "<div class='view' >"
		response.write "<div class='mframe' style='display: block; opacity: 1;'>"
			if IsEmpty(session("user_id")) then	'判斷session有無遺失(閒置過久)
				response.write("<div class='contents'><div  class='cont'><center><font color=red style ="&chr(34)&" font-weight:bold; font-size:32px; font-family:'Microsoft JhengHei','PMingLiU';"&chr(34)&">網頁閒置過久，請重新登入。</font></center>")
				response.write("<center><input id='reload' type='button' onclick=top.location.href='login.asp'; value='重新讀取'></center></div></div>")
				response.end
			end if
			' set rs_scase = get_scase()
			if first_flag then
				' scase_id	= rs_scase("scase_id")
			end if
			' 個案下拉式選單
			response.write "<div class='mField'>"
			response.write "<div class='sesSlt'>"
			response.write "<select name='std' id='std' onchange=createRefreshSelect('quanweb_visit.asp','SELECT','','')>"
				' do while not rs_scase.eof
					response.write "<option value='1,0' >001 王OO</option>"
					response.write "<option value='2,0' >002 林OO</option>"
					response.write "<option value='3,0' >003 陳OO</option>"
					' rs_scase.movenext
				' loop
			response.write "</select>"
			response.write "</div>"
			response.write "</div>"
			
			' 關懷訪視紀錄表
			response.write "<div class='mField'>"
			response.write "<div class='contents'>"
				response.write "<div  class='cont'>"
				
				if request("arg01") = "Insert" then
					if insert_success then
						response.write "<script language='javascript'>swal('','新增關懷訪視紀錄成功!!','success');</script>"
					else
						response.write "<script language='javascript'>swal('','新增關懷訪視紀錄失敗，請再重新填寫!!','error');</script>"
					end if
				end if
				if request("arg01") = "Update" then
					if update_success then
						response.write "<script language='javascript'>swal('','更新關懷訪視紀錄成功!!','success');</script>"
					else
						response.write "<script language='javascript'>swal('','更新關懷訪視紀錄失敗!!','error');</script>"
					end if
				end if
				
				' set rs_visit = get_visit(scase_id,left(now_dt,7))
				' if not rs_visit.eof then ' 更新關懷訪視紀錄
					' if not (request("arg01") = "Insert" or request("arg01") = "Update") then
						' response.write "<script language='javascript'>swal('提醒','此個案今日已有紀錄!!','warning');</script>"
					' end if
					' response.write "<form action='' method=post id='form_save' >"
					' response.write "<input type='hidden' id='scase_id' name='scase_id' value='"&scase_id&"'>" ' 案例內碼
					' response.write "<table width='100%'>"
						' response.write "<tr>"
							' response.write "<th style='text-align:center;font-size:40px;' colspan='2'>關懷訪視紀錄表"
							' response.write "<br>"
							' response.write "<div style='text-align:right;font-size:23px;font-weight:normal;'>填寫人："&rs_visit("visit_sign")&"</div>"
							' response.write "<input type='hidden' id='volun_name' name='volun_name' value='"&volun_name&"'>"
							' response.write "</th>"
						' response.write "</tr>"
						
						' visit_dt = rs_visit("visit_dt")
						' visit_dt = Cdate(left(visit_dt,3)&"/"&mid(visit_dt,4,2)&"/"&mid(visit_dt,6,2)&" "&mid(visit_dt,8,2)&":"&mid(visit_dt,10,2)&":"&mid(visit_dt,12,2))
						' visit_dt = left(visit_dt,3)&"/"&mid(visit_dt,4,2)&"/"&mid(visit_dt,6,2)&" "&mid(visit_dt,8,2)&":"&mid(visit_dt,10,2)
						' response.write "<tr>"
							' response.write "<th >訪視<br>時間</th>"
							' response.write "<td>"&visit_dt&"</td>"
							' response.write "<input type='hidden' id='visit_dt' name='visit_dt' value='"&rs_visit("visit_dt")&"' >"
						' response.write "</tr>"
						
						' response.write "<tr>"
							' response.write "<th >居家<br>環境</th>"
							' response.write "<td >"
								' response.write "<div class='flexbox-left' >"
									' if rs_visit("visit_environ") = 1 then
										' check_str	= "checked"
									' else
										' check_str	= ""
									' end if
									' response.write "<div style='width:50%;' ><input type='radio' id='clean'	name='visit_environ' onclick="&chr(34)&"ChgEnable(document.getElementById('environ_other'),'environ_oth');"&chr(34)&" value='1' "&check_str&" >"
									' response.write "<label for='clean'	>整潔乾淨</label></div>"
									' if rs_visit("visit_environ") = 2 then
										' check_str	= "checked"
									' else
										' check_str	= ""
									' end if
									' response.write "<div style='width:50%;' ><input type='radio' id='messy'	name='visit_environ' onclick="&chr(34)&"ChgEnable(document.getElementById('environ_other'),'environ_oth');"&chr(34)&" value='2' "&check_str&" >"
									' response.write "<label for='messy'	>零亂</label></div>"
								' response.write "</div>"
								' response.write "<div class='flexbox-left' style='margin-bottom:0px;' >"
									' if rs_visit("visit_environ") = 4 then
										' check_str	= "checked"
										' disabled_str= ""
									' else
										' check_str	= ""
										' disabled_str= "disabled"
									' end if
									' response.write "<div style='width:50%;' ><input type='radio' id='environ_other'	name='visit_environ' onclick="&chr(34)&"ChgEnable(document.getElementById('environ_other'),'environ_oth');"&chr(34)&" value='4' "&check_str&" >"
									' response.write "<label for='environ_other'	>其他</label></div>"
									' if rs_visit("visit_environ") = 3 then
										' check_str	= "checked"
									' else
										' check_str	= ""
									' end if
									' response.write "<div style='width:50%;' ><input type='radio' id='dirty'	name='visit_environ' onclick="&chr(34)&"ChgEnable(document.getElementById('environ_other'),'environ_oth');"&chr(34)&" value='3' "&check_str&" >"
									' response.write "<label for='dirty'	>骯髒</label></div>"
								' response.write "</div>"
								' response.write "<input type='text' class='baseline' style='margin-bottom:10px;' id='environ_oth' name='environ_oth' value='"&rs_visit("environ_oth")&"' "&disabled_str&" >"
							' response.write "</td>"
						' response.write "</tr>"
						
						' response.write "<tr>"
							' response.write "<th >案主<br>外貌</th>"
							' response.write "<td >"
								
								' if rs_visit("visit_outward") = 1 then
									' check_str	= "checked"
								' else
									' check_str	= ""
								' end if
								' response.write "<div style='margin-bottom:10px;' ><input type='radio' id='visit_outward1' name='visit_outward' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_outward4'),'outward_other');"&chr(34)&" value='1' "&check_str&" >"
								' response.write "<label for='visit_outward1'	>衣著清潔</label></div>"
									
								' if rs_visit("visit_outward") = 2 then
									' check_str	= "checked"
								' else
									' check_str	= ""
								' end if
								' response.write "<div style='margin-bottom:10px;' ><input type='radio' id='visit_outward2' name='visit_outward' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_outward4'),'outward_other');"&chr(34)&" value='2' "&check_str&" >"
								' response.write "<label for='visit_outward2'	>稍微不清潔</label></div>"
								
								' if rs_visit("visit_outward") = 3 then
									' check_str	= "checked"
								' else
									' check_str	= ""
								' end if
								' response.write "<div style='margin-bottom:10px;' ><input type='radio' id='visit_outward3'	name='visit_outward' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_outward4'),'outward_other');"&chr(34)&" value='3' "&check_str&" >"
								' response.write "<label for='visit_outward3'	>可目視到汙垢</label></div>"
									
								' if rs_visit("visit_outward") = 4 then
									' check_str	= "checked"
									' disabled_str= ""
								' else
									' check_str	= ""
									' disabled_str= "disabled"
								' end if
								' response.write "<div class='other' ><input type='radio' id='visit_outward4' name='visit_outward' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_outward4'),'outward_other');"&chr(34)&" value='1' "&check_str&" >"
								' response.write "<label for='visit_outward4'	>其他</label></div>"
								' response.write "<input type='text' class='baseline' style='margin-bottom:10px;' id='outward_other' name='outward_other' value='"&rs_visit("outward_other")&"' "&disabled_str&" >"
							
							' response.write "</td>"
						' response.write "</tr>"
						
						' response.write "<tr>"
							' response.write "<th >注意<br>力</th>"
							' response.write "<td >"
								
								' if rs_visit("visit_attention") = 1 then
									' check_str	= "checked"
								' else
									' check_str	= ""
								' end if
								' response.write "<div style='margin-bottom:10px;' ><input type='radio' id='visit_attention1' name='visit_attention' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_attention4'),'attention_other');"&chr(34)&" value='1' "&check_str&" >"
								' response.write "<label for='visit_attention1'	>大多能集中</label></div>"
								
								' if rs_visit("visit_attention") = 2 then
									' check_str	= "checked"
								' else
									' check_str	= ""
								' end if
								' response.write "<div style='margin-bottom:10px;' ><input type='radio' id='visit_attention2' name='visit_attention' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_attention4'),'attention_other');"&chr(34)&" value='2' "&check_str&" >"
								' response.write "<label for='visit_attention2'	>少部分能集中</label></div>"
								
								' if rs_visit("visit_attention") = 3 then
									' check_str	= "checked"
								' else
									' check_str	= ""
								' end if
								' response.write "<div style='margin-bottom:10px;' ><input type='radio' id='visit_attention3'	name='visit_attention' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_attention4'),'attention_other');"&chr(34)&" value='3' "&check_str&" >"
								' response.write "<label for='visit_attention3'	>一再提醒才能集中</label></div>"
								
								' if rs_visit("visit_attention") = 4 then
									' check_str	= "checked"
									' disabled_str= ""
								' else
									' check_str	= ""
									' disabled_str= "disabled"
								' end if
								' response.write "<div class='other' ><input type='radio' id='visit_attention4' name='visit_attention' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_attention4'),'attention_other');"&chr(34)&" value='1' "&check_str&" >"
								' response.write "<label for='visit_attention4'	>其他</label></div>"
								' response.write "<input type='text' class='baseline' style='margin-bottom:10px;' id='attention_other' name='attention_other' value='"&rs_visit("attention_other")&"' "&disabled_str&" >"
							
							' response.write "</td>"
						' response.write "</tr>"
						
						' response.write "<tr>"
							' response.write "<th >案主<br>心情</th>"
							' response.write "<td >"
								
								' response.write "<div class='flexbox-left' >"
									' if rs_visit("visit_mood") = 1 then
										' check_str	= "checked"
									' else
										' check_str	= ""
									' end if
									' response.write "<div style='width:50%;' ><input type='radio' id='visit_mood1' name='visit_mood' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_mood4'),'mood_other');"&chr(34)&" value='1' "&check_str&" >"
									' response.write "<label for='visit_mood1'	>平穩</label></div>"
									' if rs_visit("visit_mood") = 2 then
										' check_str	= "checked"
									' else
										' check_str	= ""
									' end if
									' response.write "<div style='width:50%;' ><input type='radio' id='visit_mood2' name='visit_mood' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_mood4'),'mood_other');"&chr(34)&" value='2' "&check_str&" >"
									' response.write "<label for='visit_mood2'	>愉悅</label></div>"
								' response.write "</div>"
								
								' response.write "<div class='flexbox-left' style='margin-bottom:0px;' >"
									' if rs_visit("visit_mood") = 4 then
										' check_str	= "checked"
										' disabled_str= ""
									' else
										' check_str	= ""
										' disabled_str= "disabled"
									' end if
									' response.write "<div class='other' style='width:50%;' ><input type='radio' id='visit_mood4' name='visit_mood' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_mood4'),'mood_other');"&chr(34)&" value='1' "&check_str&" >"
									' response.write "<label for='visit_mood4'	>其他</label></div>"
									' if rs_visit("visit_mood") = 3 then
										' check_str	= "checked"
									' else
										' check_str	= ""
									' end if
									' response.write "<div style='width:50%;' ><input type='radio' id='visit_mood3'	name='visit_mood' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_mood4'),'mood_other');"&chr(34)&" value='3' "&check_str&" >"
									' response.write "<label for='visit_mood3'	>沉默</label></div>"
								' response.write "</div>"
								' response.write "<input type='text' class='baseline' style='margin-bottom:10px;' id='mood_other' name='mood_other' value='"&rs_visit("mood_other")&"' "&disabled_str&" >"
							
							' response.write "</td>"
						' response.write "</tr>"
						
						' response.write "<tr>"
							' response.write "<th >提供<br>服務</th>"
							' response.write "<td >"
								' if rs_visit("service_chat") = "Y" then
									' response.write "<div style='margin-bottom:10px;'><input type='checkbox' id='service_chat' name='service_chat' checked >"
								' else
									' response.write "<div style='margin-bottom:10px;'><input type='checkbox' id='service_chat' name='service_chat' >"
								' end if
								' response.write "<label for='service_chat' >陪同聊天</label></div>"
								' if rs_visit("service_hp") = "Y" then
									' response.write "<div style='margin-bottom:10px;'><input type='checkbox' id='service_hp' name='service_hp' onclick="&chr(34)&"ChgEnable(this,'service_sbp','service_dbp','service_pulse');"&chr(34)&" checked >"
									' disabled_str = ""
								' else
									' response.write "<div style='margin-bottom:10px;'><input type='checkbox' id='service_hp' name='service_hp' onclick="&chr(34)&"ChgEnable(this,'service_sbp','service_dbp','service_pulse');"&chr(34)&" >"
									' disabled_str = "disabled"
								' end if
								' response.write "<label for='service_hp' >健康檢測(血壓)</label></div>"
								' response.write "<div class='flexbox-space-around' >"
									' response.write "<div style='width:48%;' >收縮壓</div>"
									' response.write "<div style='width:48%;' >舒張壓</div>"
								' response.write "</div>"
								' response.write "<div class='flexbox-space-around' >"
									' response.write "<div style='width:48%;' ><input type='text' class='baseline' style='width:100%' id='service_sbp' name='service_sbp' value='"&rs_visit("service_sbp")&"' "&disabled_str&" ></div>&nbsp;/&nbsp;"
									' response.write "<div style='width:48%;' ><input type='text' class='baseline' style='width:100%' id='service_dbp' name='service_dbp' value='"&rs_visit("service_dbp")&"' "&disabled_str&" ></div>"
								' response.write "</div>"
								' response.write "<div class='flexbox-space-around' style='margin-bottom:10px;' >"
									' response.write "<div style='width:33%;' >脈搏</div>"
									' response.write "<div style='width:33%;' ><input type='text' class='baseline' style='width:100%' id='service_pulse' name='service_pulse' value='"&rs_visit("service_pulse")&"' "&disabled_str&" ></div>"
									' response.write "<div style='width:33%;' >次/分</div>"
								' response.write "</div>"
								
								' if rs_visit("service_arrange") = "Y" then
									' response.write "<div style='margin-bottom:10px;'><input type='checkbox' id='service_arrange' name='service_arrange' checked >"
								' else
									' response.write "<div style='margin-bottom:10px;'><input type='checkbox' id='service_arrange' name='service_arrange' >"
								' end if
								' response.write "<label for='service_arrange' >簡易居家服務</label></div>"
								' if rs_visit("service_promote") = "Y" then
									' response.write "<div style='margin-bottom:10px;'><input type='checkbox' id='service_promote' name='service_promote' checked >"
								' else
									' response.write "<div style='margin-bottom:10px;'><input type='checkbox' id='service_promote' name='service_promote' >"
								' end if
								' response.write "<label for='service_promote' >宣導參與健康促進活動</label></div>"
								' if VarType(rs_visit("service_other")) = 1 or trim(rs_visit("service_other")) = "" then
									' check_str	= ""
									' disabled_str= "disabled"
								' else
									' check_str	= "checked"
									' disabled_str= ""
								' end if
								' response.write "<div style='margin-bottom:10px;'><input type='checkbox' id='service_chk5' name='service_chk5' onclick="&chr(34)&"ChgEnable(this,'service_other');"&chr(34)&" "&check_str&" >"
								' response.write "<label for='service_chk5' >其他</label><input type='text' class='baseline' id='service_other' name='service_other' value='"&rs_visit("service_other")&"' "&disabled_str&" ></div>"
							' response.write "</td>"
						' response.write "</tr>"
						
						' response.write "<tr>"
							' response.write "<td colspan='2' >"
							' response.write "<div style='font-weight:bold;'>補充陳述：</div>"
							' response.write "<div style='text-align:center;'><textarea style='resize:none;width:90%;border-width:2px;border-style:dotted;border-color:black;font-size:24px;' id='visit_memo' name='visit_memo' rows='3'>"&rs_visit("visit_memo")&"</textarea></div>"
							' response.write "</td>"
						' response.write "</tr>"
						
						' if rs_visit("visit_sign") = volun_name then
							' response.write "<tr>"
								' response.write "<td colspan='2' style='text-align:center;'><input type='button' id='subutton' onclick="&chr(34)&"save('Update');"&chr(34)&" value='更新紀錄'></td>"
							' response.write "</tr>"
						' end if
						
					' response.write "</table>"
					' response.write "</form>"
					
				' else	' 新增關懷訪視紀錄
					response.write "<form action='' method=post id='form_save' >"
					' response.write "<input type='hidden' id='scase_id' name='scase_id' value='"&scase_id&"'>" ' 案例內碼
					response.write "<input type='hidden' id='scase_id' name='scase_id' value='1'>" ' 案例內碼
					response.write "<table width='100%'>"
						response.write "<tr>"
							response.write "<th style='text-align:center;font-size:40px;' colspan='2'>關懷訪視紀錄表"
							response.write "<br>"
							' response.write "<div style='text-align:right;font-size:23px;font-weight:normal;'>填寫人："&volun_name&"</div>"
							' response.write "<input type='hidden' id='volun_name' name='volun_name' value='"&volun_name&"'>"
							response.write "<div style='text-align:right;font-size:23px;font-weight:normal;'>填寫人："&userid&"</div>"
							response.write "<input type='hidden' id='volun_name' name='volun_name' value='"&userid&"'>"
							response.write "</th>"
						response.write "</tr>"
						
						visit_dt = now_dt
						' visit_dt = Cdate(left(visit_dt,3)&"/"&mid(visit_dt,4,2)&"/"&mid(visit_dt,6,2)&" "&mid(visit_dt,8,2)&":"&mid(visit_dt,10,2)&":"&mid(visit_dt,12,2))
						visit_dt = left(visit_dt,3)&"/"&mid(visit_dt,4,2)&"/"&mid(visit_dt,6,2)&" "&mid(visit_dt,8,2)&":"&mid(visit_dt,10,2)
						response.write "<tr>"
							response.write "<th >訪視<br>時間</th>"
							response.write "<td>"&visit_dt&"</td>"
							response.write "<input type='hidden' id='visit_dt' name='visit_dt' value='"&now_dt&"' >"
						response.write "</tr>"
						
						response.write "<tr>"
							response.write "<th >居家<br>環境</th>"
							response.write "<td >"
								response.write "<div class='flexbox-left' >"
									response.write "<div style='width:50%;' ><input type='radio' id='clean'	name='visit_environ' onclick="&chr(34)&"ChgEnable(document.getElementById('environ_other'),'environ_oth');"&chr(34)&" value='1'>"
									response.write "<label for='clean'	>整潔乾淨</label></div>"
									response.write "<div style='width:50%;' ><input type='radio' id='messy'	name='visit_environ' onclick="&chr(34)&"ChgEnable(document.getElementById('environ_other'),'environ_oth');"&chr(34)&" value='2'>"
									response.write "<label for='messy'	>零亂</label></div>"
								response.write "</div>"
								response.write "<div class='flexbox-left' style='margin-bottom:0px;' >"
									response.write "<div class='other' style='width:50%;' ><input type='radio' id='environ_other'	name='visit_environ' onclick="&chr(34)&"ChgEnable(document.getElementById('environ_other'),'environ_oth');"&chr(34)&" value='4'>"
									response.write "<label for='environ_other'	>其他</label></div>"
									response.write "<div style='width:50%;' ><input type='radio' id='dirty'	name='visit_environ' onclick="&chr(34)&"ChgEnable(document.getElementById('environ_other'),'environ_oth');"&chr(34)&" value='3'>"
									response.write "<label for='dirty'	>骯髒</label></div>"
								response.write "</div>"
								response.write "<input type='text' class='baseline' style='margin-bottom:10px;' id='environ_oth' name='environ_oth' disabled >"
							response.write "</td>"
						response.write "</tr>"
						
						response.write "<tr>"
							response.write "<th >案主<br>外貌</th>"
							response.write "<td >"
							
								response.write "<div style='margin-bottom:10px;' ><input type='radio'	id='visit_outward1' name='visit_outward' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_outward4'),'outward_other');"&chr(34)&" value='1'>"
								response.write "<label for='visit_outward1'	>衣著清潔</label></div>"
								
								response.write "<div style='margin-bottom:10px;' ><input type='radio'	id='visit_outward2' name='visit_outward' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_outward4'),'outward_other');"&chr(34)&" value='2'>"
								response.write "<label for='visit_outward2'	>稍微不清潔</label></div>"
								
								response.write "<div style='margin-bottom:10px;' ><input type='radio' id='visit_outward3'	name='visit_outward' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_outward4'),'outward_other');"&chr(34)&" value='3'>"
								response.write "<label for='visit_outward3'	>可目視到汙垢</label></div>"
								
								response.write "<div class='other' ><input type='radio' id='visit_outward4'	name='visit_outward' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_outward4'),'outward_other');"&chr(34)&" value='4'>"
								response.write "<label for='visit_outward4'	>其他</label></div>"
								response.write "<input type='text' class='baseline' style='margin-bottom:10px;' id='outward_other' name='outward_other' disabled >"
							
							response.write "</td>"
						response.write "</tr>"
						
						response.write "<tr>"
							response.write "<th >注意<br>力</th>"
							response.write "<td >"
								
								response.write "<div style='margin-bottom:10px;' ><input type='radio'	id='visit_attention1' name='visit_attention' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_attention4'),'attention_other');"&chr(34)&" value='1'>"
								response.write "<label for='visit_attention1'	>大多能集中</label></div>"
								
								response.write "<div style='margin-bottom:10px;' ><input type='radio'	id='visit_attention2' name='visit_attention' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_attention4'),'attention_other');"&chr(34)&" value='2'>"
								response.write "<label for='visit_attention2'	>少部分能集中</label></div>"
								
								response.write "<div style='margin-bottom:10px;' ><input type='radio' id='visit_attention3'	name='visit_attention' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_attention4'),'attention_other');"&chr(34)&" value='3'>"
								response.write "<label for='visit_attention3'	>一再提醒才能集中</label></div>"
								
								response.write "<div class='other' ><input type='radio' id='visit_attention4'	name='visit_attention' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_attention4'),'attention_other');"&chr(34)&" value='4'>"
								response.write "<label for='visit_attention4'	>其他</label></div>"
								response.write "<input type='text' class='baseline' style='margin-bottom:10px;' id='attention_other' name='attention_other' disabled >"
							
							response.write "</td>"
						response.write "</tr>"
						
						response.write "<tr>"
							response.write "<th >案主<br>心情</th>"
							response.write "<td >"
								response.write "<div class='flexbox-left' >"
									response.write "<div style='width:50%;' ><input type='radio'	id='visit_mood1' name='visit_mood' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_mood4'),'mood_other');"&chr(34)&" value='1'>"
									response.write "<label for='visit_mood1'	>平穩</label></div>"
									response.write "<div style='width:50%;' ><input type='radio'	id='visit_mood2' name='visit_mood' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_mood4'),'mood_other');"&chr(34)&" value='2'>"
									response.write "<label for='visit_mood2'	>愉快</label></div>"
								response.write "</div>"
								response.write "<div class='flexbox-left' style='margin-bottom:0px;' >"
									response.write "<div class='other' style='width:50%;' ><input type='radio' id='visit_mood4'	name='visit_mood' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_mood4'),'mood_other');"&chr(34)&" value='4'>"
									response.write "<label for='visit_mood4'	>其他</label></div>"
									response.write "<div style='width:50%;' ><input type='radio' id='visit_mood3'	name='visit_mood' onclick="&chr(34)&"ChgEnable(document.getElementById('visit_mood4'),'mood_other');"&chr(34)&" value='3'>"
									response.write "<label for='visit_mood3'	>沉默</label></div>"
								response.write "</div>"
								response.write "<input type='text' class='baseline' style='margin-bottom:10px;' id='mood_other' name='mood_other' disabled >"
							response.write "</td>"
						response.write "</tr>"
						
						response.write "<tr>"
							response.write "<th >提供<br>服務</th>"
							response.write "<td >"
								response.write "<div style='margin-bottom:10px;'><input type='checkbox' id='service_chat' name='service_chat' >"
								response.write "<label for='service_chat' >陪同聊天</label></div>"
								response.write "<div ><input type='checkbox' id='service_hp' name='service_hp' onclick="&chr(34)&"ChgEnable(this,'service_sbp','service_dbp','service_pulse');"&chr(34)&" >"
								response.write "<label for='service_hp' >健康檢測(血壓)</label></div>"
								response.write "<div class='flexbox-space-around' >"
									response.write "<div style='width:48%;' >收縮壓</div>"
									response.write "<div style='width:48%;' >舒張壓</div>"
								response.write "</div>"
								response.write "<div class='flexbox-space-around' >"
									response.write "<div style='width:48%;' ><input type='text' class='baseline' style='width:100%' id='service_sbp' name='service_sbp' disabled ></div>&nbsp;/&nbsp;"
									response.write "<div style='width:48%;' ><input type='text' class='baseline' style='width:100%' id='service_dbp' name='service_dbp' disabled ></div>"
								response.write "</div>"
								response.write "<div class='flexbox-space-around' style='margin-bottom:10px;' >"
									response.write "<div style='width:33%;' >脈搏</div>"
									response.write "<div style='width:33%;' ><input type='text' class='baseline' style='width:100%' id='service_pulse' name='service_pulse' disabled ></div>"
									response.write "<div style='width:33%;' >次/分</div>"
								response.write "</div>"
								response.write "<div style='margin-bottom:10px;'><input type='checkbox' id='service_arrange' name='service_arrange' >"
								response.write "<label for='service_arrange' >簡易居家服務</label></div>"
								response.write "<div style='margin-bottom:10px;'><input type='checkbox' id='service_promote' name='service_promote' >"
								response.write "<label for='service_promote' >宣導參與健康促進活動</label></div>"
								response.write "<div style='margin-bottom:10px;'><input type='checkbox' id='service_chk5' name='service_chk5' onclick="&chr(34)&"ChgEnable(this,'service_other');"&chr(34)&" >"
								response.write "<label for='service_chk5' >其他</label><input type='text' class='baseline' id='service_other' name='service_other' disabled ></div>"
							response.write "</td>"
						response.write "</tr>"
						
						response.write "<tr>"
							response.write "<td colspan='2' >"
							response.write "<div style='font-weight:bold;'>補充陳述：</div>"
							response.write "<div style='text-align:center;'><textarea style='resize:none;width:90%;border-width:2px;border-style:dotted;border-color:black;font-size:24px;' id='visit_memo' name='visit_memo' rows='3'></textarea></div>"
							response.write "</td>"
						response.write "</tr>"
						
						response.write "<tr>"
							response.write "<td colspan='2' style='text-align:center;'><input type='button' id='subutton' onclick="&chr(34)&"save('Insert');"&chr(34)&" value='確認存檔'></td>"
						response.write "</tr>"
						
					response.write "</table>"
					response.write "</form>"
				' end if
				
				response.write "</div>"
			response.write "</div>"
			response.write "</div>"
			
			
		response.write "</div>"
		response.write "</div>"
		%>
        </div>
    </div>
</body>
</html>
