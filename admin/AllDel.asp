<!--#include file="../conn.asp"-->
<!-- #include file="inc/const.asp" -->
<%
Head()
Server.ScriptTimeout=9999999
dim iboardid(2000),idepth(2000),iboardname(2000)
dim k,n,i
dim admin_flag
admin_flag="24"
CheckAdmin(admin_flag)
Dim body
Call main()
Footer()

Erase iboardid
Erase idepth
Erase iboardname

sub main()
Dim rs
i=0
set rs=Dvbbs.Execute("select boardid,depth,boardtype from dv_board order by rootid,orders")
if rs.eof and rs.bof then
	iboardid(0)=0
	idepth(0)=0
	iboardname(0)="û����̳"
else
	do while not rs.eof
		iboardid(i)=rs(0)
		idepth(i)=rs(1)
		iboardname(i)=rs(2)
		i=i+1
		rs.movenext
	loop
end if
set rs=nothing
select case request("action")
case "alldel"
	call alldel()
case "userdel"
	call del()
case "alldelTopic"
	call alldelTopic()
case "delUser"
	call deluser()
case "moveinfo"
	call moveinfo()
case "MoveUserTopic"
	call moveusertopic()
case "MoveDateTopic"
	call movedatetopic()
case else
%>
<table cellpadding=3 cellspacing=1 border=0 width=100% align="center">
	<tr>
    <td width="100%" valign=top class=td1>
<B>ע��</B>�����������������ɾ����̳���ӣ�<font color=red>�������в������ɻָ���</font>�����ȷ��������������ϸ������������Ϣ��
</td>
</tr>
</table><BR>
<table width="100%" border="0" cellspacing="1" cellpadding="3" align="center">
<form action="alldel.asp?action=alldel" method="post">
	<th valign=middle colspan=2>ɾ��ָ������������</b>(�����ܲ��۳��û��������ͻ���)</th>
	<tr>
	<td valign=middle width=40% class=td1>ɾ��������ǰ������(��д����)</td><td class=td1><input name="TimeLimited" value=100 size=30>&nbsp;<input type=submit class="button" name="submit" value="�� ��"></td></tr>
	<tr>
	<td valign=middle width=40%  class=td1>��̳����</td>
	<td class=td1>
		<select name="delboardid" size=1>
		<%
		for k=0 to i-1
			if iboardid(k)=0 then
				response.write "<option value=0>û����̳</option>"
			elseif k=0 then
				response.write "<option value=all>ȫ����̳</option>"
			end if
			response.write "<option value="&iboardid(k)&">"
			if idepth(k)>0 then
			for n=1 to idepth(k)
			response.write "��"
			next
			end if
			response.write iboardname(k)&"</option>"
		next
		%>
		</select>
	</td></tr>
</form>
<form action="alldel.asp?action=alldelTopic" method="post">
	<th valign=middle colspan=2>ɾ��ָ��������û�лظ�������(�����ܲ��۳��û��������ͻ���)</th>
	<tr>
	<td valign=middle width=40% class=td1>ɾ��������ǰ������(��д����)</td><td class=td1><input name="TimeLimited" value=100 size=30>&nbsp;<input type=submit class="button" name="submit" value="�� ��"></td></tr>
	<tr>
	<td valign=middle width=40% class=td1>��̳����</td>
	<td class=td1>
		<select name="delboardid" size=1>
		<%
		for k=0 to i-1
			if iboardid(k)=0 then
				response.write "<option value=0>û����̳</option>"
			elseif k=0 then
				response.write "<option value=all>ȫ����̳</option>"
			end if
			response.write "<option value="&iboardid(k)&">"
			if idepth(k)>0 then
			for n=1 to idepth(k)
			response.write "��"
			next
			end if
			response.write iboardname(k)&"</option>"
		next
		%>
		</select>
	</td></tr>
</form>
<form action="alldel.asp?action=userdel" method="post">
	<th valign=middle colspan=2>ɾ��ĳ�û�����������</th>
	<tr>
	<td valign=middle width=40% class=td1>�������û���</td><td class=td1><input type=text name="username" size=30>&nbsp;<input type=submit class="button" name="submit" value="�� ��"></td></tr>
	<tr>
	<td valign=middle width=40%  class=td1>��̳����</td><td class=td1>
		<select name="delboardid" size=1>
		<%
		for k=0 to i-1
			if iboardid(k)=0 then
				response.write "<option value=0>û����̳</option>"
			elseif k=0 then
				response.write "<option value=all>ȫ����̳</option>"
			end if
			response.write "<option value="&iboardid(k)&">"
			if idepth(k)>0 then
			for n=1 to idepth(k)
			response.write "��"
			next
			end if
			response.write iboardname(k)&"</option>"
		next
		%>
		</select>
	</td></tr>
</form>

<form action="alldel.asp?action=delUser" method="post">
	<th valign=middle colspan=2>ɾ��ָ��������û�е�¼���û�</th>
	<tr>
	<td class=td1 valign=middle>ָ������</td>
	<td class=td1 valign=middle>
		<select name=TimeLimited size=1> 
		<option value=1>ɾ��һ��ǰ��
		<option value=2>ɾ������ǰ��
		<option value=7>ɾ��һ����ǰ��
		<option value=15>ɾ�������ǰ��
		<option value=30>ɾ��һ����ǰ��
		<option value=60>ɾ��������ǰ��
		<option value=180>ɾ������ǰ��
		</select>
		<input type=submit class="button" name="submit" value="�� ��">
	</td></tr>
</form>

</table>
<%end select%>
<%if founderr then Call dvbbs_error()%>
<%
end sub

Sub Moveinfo()
%>
<table cellpadding=3 cellspacing=1 border=0 width=100% align=center>
	<tr>
    <td width="100%" valign=top>
<B>ע��</B>������ֻ���ƶ����ӣ������ǿ�������ɾ����
            <br>���������ɾ��ԭ��̳���ӣ����ƶ�����ָ������̳�С������ȷ��������������ϸ������������Ϣ��<BR>�����Խ�һ����̳������̳�������ƶ����ϼ���̳��Ҳ���Խ��ϼ���̳�������ƶ����¼���̳������Ϊ�������̳������̳���úܿ��ܲ��ܷ������ӣ�ֻ�������
</td>
</tr>
</table>
<table width="100%" border="0" cellspacing="1" cellpadding="3" align="center">
<form action="alldel.asp?action=MoveDateTopic" method="post">
	<th valign=middle colspan=2>�������ƶ�</th>
	<tr>
	<td valign=middle width=40% class=td1>�ƶ�������ǰ������(��д����)<li>��дΪ0�����ְ��������ӡ�</td><td class=td1><input name="TimeLimited" value=0 size=30>��&nbsp;<input type=submit class="button" name="submit" value="�� ��"></td></tr>
	<tr>
	<td valign=middle width=40% class=td1>ԭ��̳</td><td class=td1>
		<select name="outboardid" size=1>
		<%
		for k=0 to i-1
			if iboardid(k)=0 then
				response.write "<option value=0>û����̳</option>"
			end if
			response.write "<option value="&iboardid(k)&">"
			if idepth(k)>0 then
			for n=1 to idepth(k)
			response.write "��"
			next
			end if
			response.write iboardname(k)&"</option>"
		next
		%>
		</select>
	</td></tr>
	<tr>
	<td valign=middle width=40% class=td1>Ŀ����̳</td><td class=td1>
		<select name="inboardid" size=1>
		<%
		for k=0 to i-1
			if iboardid(k)=0 then
				response.write "<option value=0>û����̳</option>"
			end if
			response.write "<option value="&iboardid(k)&">"
			if idepth(k)>0 then
			for n=1 to idepth(k)
			response.write "��"
			next
			end if
			response.write iboardname(k)&"</option>"
		next
		%>
		</select>
	</td></tr>
</form>
<form action="alldel.asp?action=MoveUserTopic" method="post">
	<th valign=middle colspan=2>���û��ƶ�</th>
	<tr>
	<td valign=middle width=40% class=td1>����д�û���</td><td class=td1><input name="username" size=30>&nbsp;<input type=submit class="button" name="submit" value="�� ��"></td></tr>
	<tr>
	<td valign=middle width=40% class=td1>ԭ��̳</td><td class=td1>
		<select name="outboardid" size=1>
		<%
		for k=0 to i-1
			if iboardid(k)=0 then
				response.write "<option value=0>û����̳</option>"
			end if
			response.write "<option value="&iboardid(k)&">"
			if idepth(k)>0 then
			for n=1 to idepth(k)
			response.write "��"
			next
			end if
			response.write iboardname(k)&"</option>"
		next
		%>
		</select>
	</td></tr>
	<tr>
	<td valign=middle width=40% class=td1>Ŀ����̳</td><td class=td1>
		<select name="inboardid" size=1>
		<%
		for k=0 to i-1
			if iboardid(k)=0 then
				response.write "<option value=0>û����̳</option>"
			end if
			response.write "<option value="&iboardid(k)&">"
			if idepth(k)>0 then
			for n=1 to idepth(k)
			response.write "��"
			next
			end if
			response.write iboardname(k)&"</option>"
		next
		%>
		</select>
	</td></tr>
</form>
</table>
<%
	end sub

'ɾ��ĳ�û�����������
Sub Del()
	dim titlenum,delboardid,PostUserID,delboardida,rs,sql,i
	Dim Dnum 'ɾ�������� 2005-10-30 Dv.Yz
	If request("delboardid")="0" then
		founderr=true
		Errmsg=ErrMsg + "<BR><li>�Ƿ��İ��������"
		exit sub
	Elseif request("delboardid")="all" then
		delboardid=""
		delboardida=""
	Else
		delboardid=" boardid="&Dvbbs.CheckNumeric(request("delboardid"))&" and "
		delboardida=" F_boardid="&Dvbbs.CheckNumeric(request("delboardid"))&" and "
	End if
	If Request("username")="" then
		founderr=true
		Errmsg=ErrMsg + "<BR><li>�����뱻����ɾ���û�����"
		exit sub
	End If
	Set Rs=Dvbbs.Execute("Select UserID,UserGroupID From Dv_User Where UserName='"&replace(request("username"),"'","")&"'")
	If Rs.Eof And Rs.Bof Then
		founderr=true
		Errmsg=ErrMsg + "<BR><li>Ŀ���û������ڣ����������롣"
		exit sub
	End If
	If Rs(1)=1 Or Rs(1)=2 Or Rs(1)=3 Then
		founderr=true
		Errmsg=ErrMsg + "<BR><li>�Թ���Ա���������������������Ӳ��ܽ�������ɾ��������"
		exit sub
	End If
		PostUserID=Rs(0)
		Set Rs=Nothing
		titlenum=0
		for i=0 to ubound(allposttable)
		set rs=Dvbbs.Execute("Select Count(*) from "&allposttable(i)&" where "&delboardid&" PostUserID="&PostUserID) 
   		titlenum=titlenum+rs(0)

		sql="Delete From "&allposttable(i)&" where "&delboardid&" PostUserID="&PostUserID
		Dvbbs.Execute(sql)
		next
		Set Rs=Nothing
		'����
		Dvbbs.Execute("delete from dv_besttopic where "&delboardid&" PostUserID="&PostUserID)
		'�ϴ�
		Dvbbs.Execute("delete from Dv_UpFile where "&delboardida&" F_UserID="&PostUserID)
		'���û����������⡢��������һ��ɾ��
		set rs=Dvbbs.Execute("select topicid,posttable from dv_topic where "&delboardid&" PostUserID="&PostUserID)
		do while not rs.eof
			Dvbbs.Execute("Delete From "&rs(1)&" where rootid="&rs(0))
		rs.movenext
		loop
		Set Rs = Dvbbs.Execute("SELECT COUNT(TopicID) FROM Dv_Topic WHERE " & Delboardid & " PostUserID = " & PostUserID)
		Dnum = Rs(0)
		Set Rs=Nothing
		Dvbbs.Execute("Delete From dv_topic where "&delboardid&" PostUserID="&PostUserID)
		if isnull(titlenum) then titlenum=0
		sql="update [dv_user] set userpost=userpost-"&titlenum&",userWealth=userWealth-"&titlenum*Dvbbs.Forum_user(3)&",userEP=userEP-"&titlenum*Dvbbs.Forum_user(8)&",userCP=userCP-"&titlenum*Dvbbs.Forum_user(13)&" where UserID="&PostUserID
		Dvbbs.Execute(sql)
		Response.write "���û���" & Dnum & "�����⼰����ɾ���ɹ���<BR>��������������̳�����и���һ����̳���ݣ�����<a href=alldel.asp>����</a>"
	Response.Flush
End Sub

'ɾ��ָ������������
Sub Alldel()
	Dim TimeLimited,Delboardid,DelSql,rs,i
	Dim Dnum 'ɾ�������� 2005-10-30 Dv.Yz
	If Request("delboardid")="0" Then
		'founderr=true
		Errmsg=ErrMsg + "<BR><li>�Ƿ��İ��������"
		Exit Sub
	Elseif Request("delboardid")="all" Then
		Delboardid=""
	Else
		'Delboardid="And boardid="&Clng(Request("delboardid"))
		Delboardid=" boardid="&Clng(Request("delboardid"))&" and "
	End If
	TimeLimited=Request.Form("TimeLimited")
	If Not Isnumeric(TimeLimited) Then
		'founderr=true
		Errmsg=ErrMsg + "<BR><li>�Ƿ��Ĳ�����"
		Exit Sub
	Else
		For i=0 to Ubound(allposttable)
			If IsSqlDataBase=1 Then
				Set Rs = Dvbbs.Execute("SELECT COUNT(AnnounceID) FROM " & Allposttable(i) & " WHERE " & Delboardid & " Datediff(d, DateAndTime, " & SqlNowString & ") > " & TimeLimited)
				Dnum = Rs(0)
				Dvbbs.Execute("DELETE FROM "&Allposttable(i)&" WHERE "&Delboardid&" Datediff(d,DateAndTime,"&SqlNowString&")>"&TimeLimited)
			Else
				Set Rs = Dvbbs.Execute("SELECT COUNT(AnnounceID) FROM " & Allposttable(i) & " WHERE " & Delboardid & " Datediff('d', DateAndTime, " & SqlNowString & ") > " & TimeLimited)
				Dnum = Rs(0)
				Dvbbs.Execute("DELETE FROM "&Allposttable(i)&" WHERE "&Delboardid&" Datediff('d',DateAndTime,"&SqlNowString&")>"&TimeLimited)
			End if
			Response.Write Allposttable(i)&"��" & Dnum & "������ɾ����ɣ�<BR>"
			Response.Flush
		Next
		If IsSqlDataBase=1 Then
			Set Rs = Dvbbs.Execute("SELECT COUNT(TopicID) FROM Dv_topic WHERE " & Delboardid & " Datediff(d, DateAndTime, " & SqlNowString & ") > " & TimeLimited)
			Dnum = Rs(0)
			Dvbbs.Execute("DELETE FROM Dv_topic WHERE "&Delboardid&" Datediff(d,DateAndTime,"&SqlNowString&")>"&TimeLimited)
			Dvbbs.Execute("delete from dv_besttopic where "&Delboardid&" datediff(d,DateAndTime,"&SqlNowString&")>"&TimeLimited)
		Else
			Set Rs = Dvbbs.Execute("SELECT COUNT(TopicID) FROM Dv_topic WHERE " & Delboardid & " Datediff('d', DateAndTime, " & SqlNowString & ") > " & TimeLimited)
			Dnum = Rs(0)
			Dvbbs.Execute("DELETE FROM Dv_topic WHERE "&Delboardid&" Datediff('d',DateAndTime,"&SqlNowString&")>"&TimeLimited)
			Dvbbs.Execute("DELETE FROM Dv_besttopic WHERE "&Delboardid&" Datediff('d',DateAndTime,"&SqlNowString&") > "&TimeLimited)
		End If
			Response.Write "Dv_Topic��" & Dnum & "������ɾ����ɣ�<BR>"
			Response.Flush
	End if
	Response.Write "ɾ���ɹ���<BR>��������������̳�����и���һ����̳���ݣ�����<a href=alldel.asp>����</a>"
	Response.Flush
End sub

sub alldelTopic()
	Dim TimeLimited,delboardid,rs
	Dim Dnum 'ɾ�������� 2005-10-30 Dv.Yz
	if request("delboardid")="0" then
		'founderr=true
		Errmsg=ErrMsg + "<BR><li>�Ƿ��İ��������"
		exit sub
	elseif request("delboardid")="all" then
		delboardid=""
	else
		delboardid=" boardid="&Dvbbs.CheckNumeric(request("delboardid"))&" and "
	end if
	TimeLimited=request.form("TimeLimited")
	if not isnumeric(TimeLimited) then
		'founderr=true
		Errmsg=ErrMsg + "<BR><li>�Ƿ��Ĳ�����"
		exit sub
	else
	if IsSqlDataBase=1 then
		set rs=Dvbbs.Execute("select Topicid,PostTable from dv_topic where "&delboardid&"   datediff(d,DateAndTime,"&SqlNowString&")>"&TimeLimited&" and Child=0")
	else
		set rs=Dvbbs.Execute("select Topicid,PostTable from dv_topic where "&delboardid&"   datediff('d',DateAndTime,"&SqlNowString&")>"&TimeLimited&" and Child=0")
	end if
	do while not rs.eof
		Dvbbs.Execute("Delete From "&rs(1)&" where rootid="&rs(0))
		Dvbbs.Execute("delete from dv_besttopic where rootid="&rs(0))
	rs.movenext
	loop
	if IsSqlDataBase=1 then
		Set Rs = Dvbbs.Execute("SELECT COUNT(TopicID) FROM Dv_Topic WHERE " & Delboardid & " DATEDIFF(d, DateAndTime, " & SqlNowString & ") > " & TimeLimited & " AND Child = 0")
		Dnum = Rs(0)
		Dvbbs.Execute("Delete From dv_topic where "&delboardid&"   datediff(d,DateAndTime,"&SqlNowString&")>"&TimeLimited&" and Child=0")
	else
		Set Rs = Dvbbs.Execute("SELECT COUNT(TopicID) FROM Dv_Topic WHERE " & Delboardid & " DATEDIFF('d', DateAndTime, " & SqlNowString & ") > " & TimeLimited & " AND Child = 0")
		Dnum = Rs(0)
		Dvbbs.Execute("Delete From dv_topic where "&delboardid&"   datediff('d',DateAndTime,"&SqlNowString&")>"&TimeLimited&" and Child=0")
	end if
	set rs=nothing
	end if
	response.write "Dv_Topic��" & Dnum & "������ɾ���ɹ���<BR>��������������̳�����и���һ����̳���ݣ�����<a href=alldel.asp>����</a>"
	end sub

Sub DelUser()
	Dim TimeLimited,rs,sql,i
	Dim Dnum 'ɾ���û��� 2005-10-30 Dv.Yz
	TimeLimited=Replace(request.form("TimeLimited"),"'","")
	if TimeLimited="all" then
	response.Write "���˰ɣ��뿪��ɣ���������������Ա��ɾ���ģ�"
	else
	if IsSqlDataBase=1 then
	set rs=Dvbbs.Execute("select userid,username,usergroupid from [dv_user] where datediff(d,LastLogin,"&SqlNowString&")>"&Dvbbs.CheckNumeric(TimeLimited)&"")
	else
	set rs=Dvbbs.Execute("select userid,username,usergroupid from [dv_user] where datediff('d',LastLogin,"&SqlNowString&")>"&Dvbbs.CheckNumeric(TimeLimited)&"")
	end if
	'shinzeal����ɾ���û���ͬʱ�Զ�ɾ�������ӣ��������������Ĺ���
	do while not rs.eof
		If rs(2)>3 then
		for i=0 to ubound(allposttable)
		sql="Delete From "&allposttable(i)&" where postuserid="&rs(0)
		Dvbbs.Execute(sql)
		next
		Dvbbs.Execute("delete from dv_besttopic where postuserid="&rs(0))
		Dvbbs.Execute("Delete From Dv_UpFile Where F_UserID="&rs(0))
		Dvbbs.Execute("Delete From Dv_Message Where Sender='"&Replace(Rs(1),"'","''")&"'")
		Dvbbs.Execute("Delete From Dv_Friend Where F_UserID="&rs(0))
		Dvbbs.Execute("Delete From Dv_BookMark Where UserName='"&Replace(Rs(1),"'","''")&"'")
		dim rrs
		set rrs=Dvbbs.Execute("select topicid,posttable from dv_topic where postuserid="&rs(0))
		do while not rrs.eof
		Dvbbs.Execute("Delete From "&rrs(1)&" where rootid="&rrs(0))
		rrs.movenext
		loop
		set rrs=nothing
		Dvbbs.Execute("Delete From dv_topic where postuserid="&rs(0))
		end if
	rs.movenext
	loop
	set rs=nothing
	if IsSqlDataBase=1 then
		Set Rs = Dvbbs.Execute("SELECT COUNT(UserID) FROM Dv_User WHERE Datediff(d, LastLogin, " & SqlNowString & ") > " & TimeLimited & "")
		Dnum = Rs(0)
		Dvbbs.Execute("delete from [dv_user] where datediff(d,LastLogin,"&SqlNowString&")>"&TimeLimited&"")
	else
		Set Rs = Dvbbs.Execute("SELECT COUNT(UserID) FROM Dv_User WHERE Datediff('d', LastLogin, " & SqlNowString & ") > " & TimeLimited & "")
		Dnum = Rs(0)
		Dvbbs.Execute("delete from [dv_user] where datediff('d',LastLogin,"&SqlNowString&")>"&TimeLimited&"")
	end if
	end if
	response.write "ɾ��" & Dnum & "���û��ɹ���<BR>��������������̳�����и���һ����̳���ݣ�����<a href=alldel.asp>����</a>"
	Response.Flush
End Sub

Sub MoveUserTopic()
	Dim PostUserID,Sql,rs,i
	If Not Isnumeric(Request("Inboardid")) Then
		Response.Write "����İ��������"
		Exit Sub
	End If
	If Not Isnumeric(Request("Outboardid")) Then
		Response.Write "����İ��������"
		Exit Sub
	End If
	If Request("Username") = "" Then
		Response.Write "����д�û�����"
		Exit Sub
	End If
	If Cint(Request("Outboardid")) = Cint(Request("Inboardid")) Then
		Response.Write "��������ͬ��������ƶ�������"
		Exit Sub
	End If
	Set Rs = Dvbbs.Execute("Select UserID From Dv_User Where UserName = '" & Replace(Request("Username"), "'", "''") & "'")
	If Rs.Eof And Rs.Bof Then
		Response.Write "Ŀ���û����������ڣ����������룡"
		Exit Sub
	End If
	PostUserID = Rs(0)
	For i = 0 To Ubound(Allposttable)
		Dvbbs.Execute("UPDATE " & Allposttable(i) & " SET Boardid = " & Request("Inboardid") & " WHERE Boardid = " & Request("Outboardid") & " AND PostUserID = " & PostUserID)
	Next
	Rs.Close:Set Rs = Nothing
	REM �޸������ƶ���ʽ 2004-4-25 Dvbbs.YangZheng
	SET Rs = Dvbbs.Execute("SELECT Topicid, Posttable, Istop FROM Dv_Topic WHERE Boardid = " & Request("Outboardid") & " AND PostUserID = " & PostUserID)
	Rem Topicid:0, Posttable:1, Istop:2
	If Not(Rs.Eof And Rs.Bof) Then
		Sql = Rs.GetRows(-1)
		Rs.Close:Set Rs = Nothing
		Dim Yrs, TopstrinfoN, TopstrinfoO
		For i = 0 To Ubound(Sql,2)
			Dvbbs.Execute("UPDATE " & Sql(1,i) & " SET Boardid = " & Request("Inboardid") & " WHERE Rootid = " & Sql(0,i))
			Dvbbs.Execute("UPDATE Dv_Topic SET Boardid = " & Request("Inboardid") & " WHERE Boardid = " & Request("Outboardid") & " AND Topicid = " & Sql(0,i))
			If Sql(2,0) > 0 Then
				'��ȡ�¾ɰ���Ĺ̶���Ϣ
				Set Yrs = Dvbbs.Execute("SELECT BoardTopStr From Dv_Board Where Boardid = " & Request("Outboardid"))
				TopstrinfoO = Yrs(0)
				Set Yrs = Dvbbs.Execute("SELECT BoardTopStr From Dv_Board Where Boardid = " & Request("Inboardid"))
				TopstrinfoN = Yrs(0)
				Yrs.Close:Set Yrs = Nothing
				'ɾ��ԭ�̶�����ID
				TopstrinfoO = Replace(TopstrinfoO, Cstr(Sql(0,i))&",", "")
				TopstrinfoO = Replace(TopstrinfoO, ","&Cstr(Sql(0,i)), "")
				TopstrinfoO = Replace(TopstrinfoO, Cstr(Sql(0,i)), "")
				If TopstrinfoN = "" Or Isnull(TopstrinfoN) Then
					TopstrinfoN = Cstr(Sql(0,i))
				ElseIf TopstrinfoN = Cstr(Sql(0,i)) Then
					TopstrinfoN = TopstrinfoN
				ElseIf Instr(TopstrinfoN, ","&Cstr(Sql(0,i))) > 0 Then
					TopstrinfoN = TopstrinfoN
				Else
					TopstrinfoN = TopstrinfoN & "," & Cstr(Sql(0,i))
				End If
				'���µ�ǰ����̶���Ϣ������
				Dvbbs.Execute("UPDATE Dv_Board SET BoardTopStr = '" & TopstrinfoO & "' WHERE BoardID = " & Request("Outboardid"))
				'�����°���̶���Ϣ������
				Dvbbs.Execute("UPDATE Dv_Board SET BoardTopStr = '" & TopstrinfoN & "' WHERE Boardid = " & Request("Inboardid"))
			End If
		Next
		Dvbbs.ReloadBoardInfo(Request("Outboardid")&","&Request("Inboardid"))
	End If
	Dvbbs.Execute("UPDATE Dv_Besttopic SET Boardid = " & Request("Inboardid") & " WHERE Boardid = " & Request("Outboardid") & " AND PostUserID = " & PostUserID)
	'shinzeal�����ƶ��ϴ��ļ�����
	Dvbbs.Execute("UPDATE Dv_Upfile SET F_Boardid = " & Request("Inboardid") & " WHERE F_Boardid = " & Request("Outboardid") & " AND F_UserID = " & PostUserID)
	Response.Write "�ƶ��ɹ���<br>�ڡ��ؼ���̳���ݺ��޸����С�������̳���ݡ���"
End Sub

Sub MoveDateTopic()
	Dim TimeLimited,rs,sql,i
	TimeLimited = Request.Form("TimeLimited")
	If Not Isnumeric(TimeLimited) Then
		Response.Write "��������ڲ�����"
		Exit Sub
	Else
		TimeLimited = Clng(TimeLimited)
	End If
	If Not Isnumeric(Request("Inboardid")) Then
		Response.Write "����İ��������"
		Exit Sub
	End If
	If Not Isnumeric(Request("Outboardid")) Then
		Response.Write "����İ��������"
		Exit Sub
	End If
	If Cint(Request("Outboardid")) = Cint(Request("Inboardid")) Then
		Response.Write "��������ͬ��������ƶ�������"
		Exit Sub
	End If
	Rem �޸��ƶ���ʽ 2004-4-25 Dvbbs.YangZheng
	Sql = "SELECT PostTable,Isbest,IsTop,TopicID FROM Dv_Topic WHERE Boardid = " & Request("Outboardid")
	If TimeLimited > 0 Then
		If IsSqlDataBase = 1 Then
			Sql = Sql & " AND DATEDIFF(d, DateAndTime, " & SqlNowString & ") >= " & TimeLimited
		Else
			Sql = Sql & " AND DATEDIFF('d', DateAndTime, " & SqlNowString & ") >= " & TimeLimited
		End If
	End If
	Rem PostTable:0, Isbest:1, IsTop:2, TopicID:3
	Set Rs = Dvbbs.Execute(Sql)
	Dim Sqlstr
	Dim Yrs, TopstrinfoN, TopstrinfoO
	If Not(Rs.Eof And Rs.Bof) Then
		Sql = Rs.Getrows(-1)
		Rs.Close:Set Rs = Nothing
		For i = 0 To Ubound(Sql,2)
			Sqlstr = "UPDATE " & Sql(0,i) & " SET BoardID = " & Request("Inboardid") & " WHERE BoardID = " & Request("Outboardid") & " AND RootID = " & Clng(Sql(3,i))
			Dvbbs.Execute(Sqlstr)
			Dvbbs.Execute("UPDATE Dv_Topic SET BoardID = " & Request("Inboardid") & " WHERE BoardID = " & Request("Outboardid") & " AND TopicID = " & Sql(3,i))
			If Sql(1,i) = 1 Then
				Dvbbs.Execute("UPDATE Dv_Besttopic Set BoardID = " & Request("Inboardid") & " WHERE BoardID = " & Request("Outboardid") & " AND RootID = " & Sql(3,i))
			End If
			If Sql(2,i) > 0 Then
				
				'��ȡ�¾ɰ���Ĺ̶���Ϣ
				Set Yrs = Dvbbs.Execute("SELECT BoardTopStr From Dv_Board Where Boardid = " & Request("Outboardid"))
				TopstrinfoO = Yrs(0)
				Set Yrs = Dvbbs.Execute("SELECT BoardTopStr From Dv_Board Where Boardid = " & Request("Inboardid"))
				TopstrinfoN = Yrs(0)
				Yrs.Close:Set Yrs = Nothing
				'ɾ��ԭ�̶�����ID
				TopstrinfoO = Replace(TopstrinfoO, Cstr(Sql(3,i))&",", "")
				TopstrinfoO = Replace(TopstrinfoO, ","&Cstr(Sql(3,i)), "")
				TopstrinfoO = Replace(TopstrinfoO, Cstr(Sql(3,i)), "")
				If TopstrinfoN = "" Or Isnull(TopstrinfoN) Then
					TopstrinfoN = Cstr(Sql(3,i))
				ElseIf TopstrinfoN = Cstr(Sql(3,i)) Then
					TopstrinfoN = TopstrinfoN
				ElseIf Instr(TopstrinfoN, ","&Cstr(Sql(3,i))) > 0 Then
					TopstrinfoN = TopstrinfoN
				Else
					TopstrinfoN = TopstrinfoN & "," & Cstr(Sql(3,i))
				End If
				'����ԭ����̶���Ϣ������
				Sqlstr = "UPDATE Dv_Board SET BoardTopStr = '" & TopstrinfoO & "' WHERE BoardID = " & Request("Outboardid")
				Dvbbs.Execute(Sqlstr)
				
				'�����°���̶���Ϣ������
				Sqlstr = "UPDATE Dv_Board SET BoardTopStr = '" & TopstrinfoN & "' WHERE Boardid = " & Request("Inboardid")
				Dvbbs.Execute(Sqlstr)
			End If
			Dvbbs.Execute("UPDATE Dv_Upfile SET F_Boardid = " & Request("Inboardid") & " WHERE F_Boardid = " & Request("Outboardid") &" And F_AnnounceID Like '"&Sql(3,i)&"|%'") 
		Next
		Dvbbs.ReloadBoardInfo(Request("Outboardid")&","&Request("Inboardid"))
	End If
	Response.Write "�ƶ��ɹ���<br>�ڡ��ؼ���̳���ݺ��޸����С�������̳���ݡ���"
End Sub
%>