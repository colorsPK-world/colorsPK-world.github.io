<!--#include file="../conn.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="../inc/dv_clsother.asp"-->
<!--#include file="../inc/md5.asp"-->
<!--#include file="../inc/GroupPermission.asp"-->
<!--#include file="../dv_dpo/cls_dvapi.asp"-->
<%
Head()
Dim admin_flag,sqlstr,myrootid
FoundErr=False 
admin_flag=",16,"
CheckAdmin(admin_flag)

Dim tRs,UserInfo,UserTitle
UserMain(1)
Select Case Request("action")
Case "fix"
	Fixuser()
Case "userSearch"
	UserSearch()
Case "touser"
	ToUser()
Case "modify"
	UserModify()
Case "saveuserinfo"
	SaveUserInfo()
Case "UserPermission"
	UserPermission()
Case "UserBoardPermission"
	UserBoardPermission()
Case "saveuserpermission"
	SaveUserPermission()
Case "uniteuser"
	UniteUser()
Case "audituser" '����û�
	audituser()
Case "saveaudit" '�������
	saveaudit()
Case Else
	UserIndex()
End Select

UserMain(0)
Footer()

'�û�����ͨ��ͷ��
Sub UserMain(Str)
	If Str = 1 Then
%>

<table cellpadding="2" cellspacing="1" border="0" width="100%" align=center>
<tr>
<th colspan=8 style="text-align:center;">�û�����</th>
</tr>
<tr>
<td width="20%" class=td2 align="center"><button Style="width:80;height:50;border: 1px outset;" class="button">ע������</button></td>
<td width="80%" class=td2 colspan=7><li>�ٵ�ɾ����ť��ɾ����ѡ�����û����˲����ǲ�����ģ�<li>�������������ƶ��û�����Ӧ���飻<li>�۵��û���������Ӧ�����ϲ�����<li>�ܵ��û�����½IP�ɽ�������IP������<li>�ݵ��û�Email�������û�����Email��<li>�޵��޸����ӽ����޸����û��������������ݲ���������������������ɾID�û������޸���</td>
</tr>
<tr>
<td width=100% class=td2 colspan=8>
���ٲ鿴��<a href="user.asp">�û�������ҳ</a> | <a href="?action=userSearch&userSearch=1"><%If Request("userSearch")="1" Then%><font color=red><%End If%>�����û�<%If Request("userSearch")="1" Then%></font><%End If%></a> | <a href="?action=userSearch&userSearch=2"><%If Request("userSearch")="2" Then%><font color=red><%End If%>����TOP100<%If Request("userSearch")="2" Then%></font><%End If%></a> | <a href="?action=userSearch&userSearch=3"><%If Request("userSearch")="3" Then%><font color=red><%End If%>����END100<%If Request("userSearch")="3" Then%></font><%End If%></a> | <a href="?action=userSearch&userSearch=4"><%If Request("userSearch")="4" Then%><font color=red><%End If%>24H�ڵ�¼<%If Request("userSearch")="4" Then%></font><%End If%></a> | <a href="?action=userSearch&userSearch=5"><%If Request("userSearch")="5" Then%><font color=red><%End If%>24H��ע��<%If Request("userSearch")="5" Then%></font><%End If%></a><BR>
����������<a href="?action=userSearch&userSearch=6"><%If Request("userSearch")="6" Then%><font color=red><%End If%>�ȴ���֤��Ա<%If Request("userSearch")="6" Then%></font><%End If%></a> | <a href="?action=userSearch&userSearch=7"><%If Request("userSearch")="7" Then%><font color=red><%End If%>�ʼ���֤<%If Request("userSearch")="7" Then%></font><%End If%></a> | <a href="?action=userSearch&userSearch=8"><%If Request("userSearch")="8" Then%><font color=red><%End If%>�������Ŷ�<%If Request("userSearch")="8" Then%></font><%End If%></a> | <a href="?action=userSearch&userSearch=11"><%If Request("userSearch")="11" Then%><font color=red><%End If%>���Ρ��û�<%If Request("userSearch")="11" Then%></font><%End If%></a> | <a href="?action=userSearch&userSearch=12"><%If Request("userSearch")="12" Then%><font color=red><%End If%>���� �û�<%If Request("userSearch")="12" Then%></font><%End If%></a> | <a href="?action=userSearch&userSearch=14"><%If Request("userSearch")="13" Then%><font color=red><%End If%>�Զ���Ȩ���û�<%If Request("userSearch")="13" Then%></font><%End If%></a>
 | <a href="?action=userSearch&userSearch=15"><%If Request("userSearch")="15" Then%><font color=red><%End If%>VIP�û�<%If Request("userSearch")="15" Then%></font><%End If%></a>
 | <a href="?action=userSearch&userSearch=16"><%If Request("userSearch")="16" Then%><font color=red><%End If%>��˻�Ա(�����û���)<%If Request("userSearch")="16" Then%></font><%End If%></a>
 | <a href="?action=userSearch&userSearch=17"><%If Request("userSearch")="17" Then%><font color=red><%End If%>�Զ�����˻�Ա<%If Request("userSearch")="17" Then%></font><%End If%></a>
</td>
</tr>
<tr>
<td width=100% class=td2 colspan=8>
����ѡ�<a href="?action=uniteuser">�ϲ��û�</a> | <a href="update_user.asp">�����û�����</a> <!--| <a href="boardmastergrade.asp">�����������</a>-->
</td>
</tr>
<%
	Else
%>
</table>
<p></p>
<%
	End If
End Sub

'�û�������ҳ��������
Sub UserIndex()
%>
<form action="?action=userSearch" method=post>
<tr>
<th colspan=7 style="text-align:center;">�߼���ѯ</th>
</tr>
<tr>
<td width="20%" class=td1>ע������</td>
<td width="80%" class=td1 colspan=5>�ڼ�¼�ܶ���������������Խ���ѯԽ�����뾡�����ٲ�ѯ�����������ʾ��¼��Ҳ����ѡ�����</td>
</tr>
<tr>
<td width="20%" class=td1>�����ʾ��¼��</td>
<td width="80%" class=td1 colspan=5><input size=45 name="searchMax" type=text value=100></td>
</tr>
<tr>
<td width="20%" class=td1>�û���</td>
<td width="80%" class=td1 colspan=5><input size=45 name="username" type=text>&nbsp;<input type=checkbox class=checkbox name="usernamechk" value="yes" checked>�û�������ƥ��</td>
</tr>
<tr>
<td width="20%" class=td1>�û���</td>
<td width="80%" class=td1 colspan=5>
<select size=1 name="usergroups">
<option value=0>����</option>
<%
Dim rs
set rs=Dvbbs.Execute("select usergroupid,UserTitle,ParentGID from dv_usergroups Where Not ParentGID=0 order by ParentGID,usergroupid")
do while not rs.eof
response.write "<option value="&rs(0)&">"&SysGroupName(Rs(2)) & rs(1)&"</option>"
rs.movenext
loop
rs.close
set rs=nothing
%>
</select>
</td>
</tr>
<tr>
<td width="20%" class=td1>Email����</td>
<td width="80%" class=td1 colspan=5><input size=45 name="userEmail" type=text></td>
</tr>
<tr>
<td width="20%" class=td1>�û�IM����</td>
<td width="80%" class=td1 colspan=5><input size=45 name="userim" type=text> ������ҳ��OICQ��UC��ICQ��YAHOO��AIM��MSN</td>
</tr>
<tr>
<td width="20%" class=td1>��¼IP����</td>
<td width="80%" class=td1 colspan=5><input size=45 name="lastip" type=text></td>
</tr>
<tr>
<td width="20%" class=td1>ͷ�ΰ���</td>
<td width="80%" class=td1 colspan=5><input size=45 name="usertitle" type=text></td>
</tr>
<tr>
<td width="20%" class=td1>ǩ������</td>
<td width="80%" class=td1 colspan=5><input size=45 name="sign" type=text></td>
</tr>
<tr>
<td width="20%" class=td1>��ϸ���ϰ���</td>
<td width="80%" class=td1 colspan=5><input size=45 name="userinfo" type=text></td>
</tr>
<!--shinzeal������������-->
<tr>
<th colspan=7 style="text-align:center;">�����ѯ&nbsp;��ע�⣺ <����> �� <����> ��Ĭ�ϰ��� <����>������������ʹ�ô����� ��</th>
</tr>
<tr>
<td class=td1 colspan=7>
<table ID="Table1" width="100%">
<tr>
<td width="50%" class=td2>��¼����:<input type=radio class=radio value=more name="loginR" checked>&nbsp;����&nbsp;<input type=radio class=radio value=less name="loginR">&nbsp;����&nbsp;&nbsp;<input size=5 name="loginT" type=text> ��</td>
<td width="50%" class=td2>��ʧ����:<input type=radio class=radio value=more name="vanishR" checked>&nbsp;����&nbsp;<input type=radio class=radio value=less name="vanishR">&nbsp;����&nbsp;&nbsp;<input size=5 name="vanishT" type=text> ��</td>
</tr>
<tr>
<td>ע������:<input type=radio class=radio value=more name="regR" checked>&nbsp;����&nbsp;<input type=radio class=radio value=less name="regR">&nbsp;����&nbsp;&nbsp;<input size=5 name="regT" type=text> ��</td>
<td>��������:<input type=radio class=radio value=more name="artcleR" checked>&nbsp;����&nbsp;<input type=radio class=radio value=less name="artcleR">&nbsp;����&nbsp;&nbsp;<input size=5 name="artcleT" type=text> ƪ</td>
</tr>

<tr>
<td class=td2>�û���Ǯ:<input type=radio class=radio value=more name="UWealth" checked>&nbsp;����&nbsp;<input type=radio class=radio value=less name="UWealth">&nbsp;����&nbsp;&nbsp;<input size=5 name="UWealth_value" type=text></td>
<td class=td2>�û�����:<input type=radio class=radio value=more name="UEP" checked>&nbsp;����&nbsp;<input type=radio class=radio value=less name="UEP">&nbsp;����&nbsp;&nbsp;<input size=5 name="UEP_value" type=text></td>
</tr>
<tr>
<td>�û�����:<input type=radio class=radio value=more name="UCP" checked>&nbsp;����&nbsp;<input type=radio class=radio value=less name="UCP">&nbsp;����&nbsp;&nbsp;<input size=5 name="UCP_value" type=text></td>
<td>�û�����:<input type=radio class=radio value=more name="UPower" checked>&nbsp;����&nbsp;<input type=radio class=radio value=less name="UPower">&nbsp;����&nbsp;&nbsp;<input size=5 name="UPower_value" type=text></td>
</tr>
<tr>
<td class=td2>�û����:<input type=radio class=radio value=more name="UMoney" checked>&nbsp;����&nbsp;<input type=radio class=radio value=less name="UMoney">&nbsp;����&nbsp;&nbsp;<input size=5 name="UMoney_value" type=text></td>
<td class=td2>�û���ȯ:<input type=radio class=radio value=more name="UTicket" checked>&nbsp;����&nbsp;<input type=radio class=radio value=less name="UTicket">&nbsp;����&nbsp;&nbsp;<input size=5 name="UTicket_value" type=text></td>
</tr>
<tr>
<td class=td1><LI>����������ѡȡ��Ӧ��VIP�û�����в�ѯ</LI></td>
</tr>
<tr>
<td class=td2>Vip�Ǽ�ʱ��:<input type=radio class=radio value=more name="UVipStarTime" checked>&nbsp;����&nbsp;<input type=radio class=radio value=less name="UVipStarTime">&nbsp;����&nbsp;&nbsp;<input size=5 name="UVipStarTime_value" type=text></td>
<td class=td2>Vip��ֹʱ��:<input type=radio class=radio value=more name="UVipEndTime" checked>&nbsp;����&nbsp;<input type=radio class=radio value=less name="UVipEndTime">&nbsp;����&nbsp;&nbsp;<input size=5 name="UVipEndTime_value" type=text></td>
</tr>
</table>
</td></tr>

<!--������������-->
<tr>
<td width="100%" class=td1 align=center colspan=7><input name="submit" type=submit class=button value="   ��  ��   "></td>
</tr>
<input type=hidden value="9" name="userSearch">
</form>
<%
End Sub
'�û��������
Sub audituser()
Dim Groupids
%>
<FORM METHOD=POST ACTION="?action=saveaudit" name="formaudituser">
<tr><th colspan=8 style="text-align:center;">�û������������</th></tr><tr><td width=20% class=td1>ע������</td><td width=80% class=td1 colspan=5>��ÿ���û���ÿ���û��������<font color=red>","</font>���ŷָ�</td></tr>
<tr><td width=20% class=td1>���磺�û�</td><td width=80% class=td1 colspan=5>�û�1,�û�2,...,�û�n</td></tr>
<tr><td width=20% class=td1>���磺�û���</td><td width=80% class=td1 colspan=5>�û���ID1,�û���ID2,...,�û���IDn</td></tr>
<tr><td width=20% class=td1>���磺�Զ����û�</td><td width=80% class=td1 colspan=5>�Զ����û�,�Զ����û�,...,�Զ����û�n</td></tr>
<tr><td width=20% class=td1>���Ȩ������:</td><td width=80% class=td1 colspan=5>�Զ����û�<font color=red>����</font>�û���<font color=red>����</font>�û�</td></tr>
<tr><td width=20% class=td1>&nbsp;</td><td width=80% class=td1 colspan=5>
(1)����Զ����û�Ӧ����ˣ������
(2)����Զ����û���Ӧ����ˣ�������û����Ƿ�Ӧ�����
(3)����û��鲻Ӧ����ˣ�������û��Ƿ�Ӧ�����</td></tr>
<tr><td width=20% class=td1>&nbsp;</td><td width=80% class=td1 colspan=5><input type="radio" id="audittype" name="audittype" value="1" checked>Ӧ�����&nbsp;&nbsp;&nbsp;<input type="radio" id="audittype" name="audittype" value="0">ȡ�����</td></td></tr>
<tr><td width=20% class=td1>�û�</td><td width=80% class=td1 colspan=5><input type="text" id="usernames" name="usernames" size="100"></td></tr>
<tr><td width=20% class=td1>�û���</td><td width=80% class=td1 colspan=5><input type=text name="groupid" value="" size="100"><input type="button" class="button" value="ѡ���û���" onclick="getGroup('Select_Group');"></td></tr>
<tr><td width=20% class=td1>�Զ����û�</td><td width=80% class=td1 colspan=5><input type="text" id="customusernames" name="customusernames" size="100"></td></tr>
<tr><td width=20% class=td1>�����û�</td><td width=80% class=td1 colspan=5><input type="checkbox" id="userall" name="userall" >&nbsp��������û�</td></tr>
<tr><td width=20% class=td1>&nbsp;</td><td width=80% class=td1 colspan=5><INPUT TYPE="submit" value="�ύ">&nbsp;&nbsp;&nbsp;<INPUT TYPE="reset" value="��������"></td></tr>
<%
Call Select_Audit_Group(Replace(Groupids&"","@",","))
End Sub 
Sub saveaudit()
Dim i
Dim audittype,usernames,groupid,customusernames,userall
audittype=Dvbbs.CheckStr(Request("audittype"))
usernames=Dvbbs.CheckStr(request("usernames"))
groupid=Dvbbs.CheckStr(request("groupid"))
customusernames=Dvbbs.CheckStr(request("customusernames"))
If Dvbbs.CheckStr(Request("userall"))="on" Then userall=True 
If Not userall And usernames="" And groupid="" And customusernames="" Then 
			ErrMsg =ErrMsg& "�������û����û�����Զ����û���"
			founderr=true
			Dvbbs_Error()        
Else 
		If userall Then 
			Dvbbs.Execute("Update Dv_User set UserIsAudit_Custom="&audittype&",userisaudit="&audittype&"")
            Dvbbs.Execute("Update Dv_UserGroups set UserGroupIsAudit="&audittype&"")
			Dv_suc("�����û�������˳ɹ���")
		Else 
			If usernames<>"" Then 
			updateaudit usernames,0,audittype
			Dv_suc("�û�������˳ɹ���")
			End If 
			If groupid<>"" Then 
			updateaudit groupid,1,audittype
			Dv_suc("�û���������˳ɹ���")
			End If 
			If customusernames<>"" Then 
			updateaudit customusernames,2,audittype
			Dv_suc("�Զ����û�������˳ɹ���")
			End If 
		End If 
End If 
End Sub 
Function updateaudit(value,type1,audittype) '��1=����ֵ ��2=�û����û�����Զ����û� ��3=��������
Dim usernames,groupid,SQL,Rs,i,ToUserID,ToUserGroupId
Select Case type1
Case "0"
				usernames=Split(value,",")
				If Ubound(usernames)>100 Then
				ErrMsg =ErrMsg& "����һ�β��ܳ���100λĿ���û���"
				founderr=true
				Dvbbs_Error()
				Exit Function 
				End If 
				For i=0 To Ubound(usernames)
					SQL = "Select UserID From [Dv_user] Where UserName = '"&usernames(i)&"' order by userid"
					SET Rs = Dvbbs.Execute(SQL)
					If Not Rs.eof Then
						If i=0 or ToUserID="" Then
							ToUserID = ToUserID & Rs(0)
						Else
							ToUserID = ToUserID &","& Rs(0)
						End If
					Else 
						ErrMsg =ErrMsg&"<font color=red>"&usernames(i)& "</font>�û������ڡ�"
						founderr=true
						Dvbbs_Error()
						Exit Function
					End If
				Next
				Rs.Close : Set Rs = Nothing
				Dvbbs.Execute("Update dv_user set userisaudit="&audittype&" where userid in ("&ToUserID&")")
Case "1"
			groupid=Split(value,",")
			For i=0 To UBound(groupid)
				SQL = "select usergroupid,title from dv_usergroups where usergroupid="&groupid(i)&""
				SET Rs = Dvbbs.Execute(SQL)
				If Rs.eof Then 
							ErrMsg =ErrMsg&"IDΪ<font color=red>"&groupid(i)& "</font>���û��鲻���ڡ�"
							founderr=true
							Dvbbs_Error()
							Exit Function
				End If 
			Next 
			Rs.Close : Set Rs = Nothing
			Dvbbs.Execute("update Dv_UserGroups set UserGroupIsAudit="&audittype&" where UserGroupID in ("&value&")")
Case "2"
				usernames=Split(value,",")
				If Ubound(usernames)>100 Then
				ErrMsg =ErrMsg& "����һ�β��ܳ���100λ�Զ����û���"
				founderr=true
				Dvbbs_Error()
				Exit Function 
				End If 
				For i=0 To Ubound(usernames)
					SQL = "Select UserID From [Dv_user] Where UserName = '"&usernames(i)&"' order by userid"
					SET Rs = Dvbbs.Execute(SQL)
					If Not Rs.eof Then
						If i=0 or ToUserID="" Then
							ToUserID = ToUserID & Rs(0)
						Else
							ToUserID = ToUserID &","& Rs(0)
						End If
					Else 
						ErrMsg =ErrMsg&"<font color=red>"&usernames(i)& "</font>�û������ڡ�"
						founderr=true
						Dvbbs_Error()
						Exit Function
					End If
				Next
				Rs.Close : Set Rs = Nothing
				Dvbbs.Execute("Update dv_user set UserIsAudit_Custom="&audittype&" where userid in ("&ToUserID&")")
End Select 
End Function

%>
</FORM>
<%
Sub UserSearch()
%>
<tr>
<th colspan=8 style="text-align:center;">�������</th>
</tr>
<%
	dim currentpage,page_count,Pcount
	dim totalrec,endpage
	Dim rs,sql
	currentPage=request("page")
	if currentpage="" or not IsNumeric(currentpage) then
		currentpage=1
	else
		currentpage=clng(currentpage)
		if err then
			currentpage=1
			err.clear
		end if
	end if
	Sql = " Userid, Username, Useremail, LastLogin, UserLastIP, UserPost, UserGroupID,Vip_StarTime,Vip_EndTime"
	Set Rs = Dvbbs.iCreateObject("ADODB.Recordset")
	Select Case Request("UserSearch")
	Case 1
		Sql = "SELECT " & Sql & " FROM [Dv_User] ORDER BY UserID DESC"
	Case 2
		Sql = "SELECT TOP 100 " & Sql & " FROM [Dv_User] ORDER BY UserPost DESC"
	case 3
		sql="select top 100 " & Sql & " from [dv_user]  order by UserPost"
	case 4
		If IsSqlDataBase=1 Then
		sql="select " & Sql & " from [dv_user]  where datediff(hour,LastLogin,"&SqlNowString&")<25 order by lastlogin desc"
		else
		sql="select " & Sql & " from [dv_user]  where datediff('h',LastLogin,"&SqlNowString&")<25 order by lastlogin desc"
		end if
	case 5
		If IsSqlDataBase=1 Then
		sql="select " & Sql & " from [dv_user]  where datediff(hour,JoinDate,"&SqlNowString&")<25 order by UserID desc"
		else
		sql="select " & Sql & " from [dv_user]  where datediff('h',JoinDate,"&SqlNowString&")<25 order by UserID desc"
		end if
	case 6
		sql="select " & Sql & " from [dv_user]  where usergroupid=5 order by UserID desc"
	case 7
		sql="select " & Sql & " from [dv_user]  where usergroupid=6 order by UserID desc"
	case 8
		sql="select " & Sql & " from [dv_user]  where usergroupid<4 order by usergroupid"
	case 10
		Sql = "select " & Sql & " from [dv_user]  where usergroupid="&request("usergroupid")&" order by UserID desc"
	case 11
		sql="select " & Sql & " from [dv_user]  where lockuser=2 order by userid desc"
	case 12
		sql="select " & Sql & " from [dv_user]  where lockuser=1 order by userid desc"
	case 13
		sql="select " & Sql & " from [dv_user]  where IsChallenge=1 order by userid desc"
	case 14
		Sql = "SELECT " & Sql & " FROM [Dv_User] WHERE UserID IN (SELECT Uc_UserID FROM Dv_UserAccess) ORDER BY Userid DESC"
	case 15
		Sql = "SELECT " & Sql & " FROM [dv_user]  WHERE UserGroupid IN (SELECT UserGroupID FROM Dv_UserGroups WHERE ParentGID=5) ORDER BY Vip_EndTime desc,UserID desc"
	case 16
        Sql="select u.Userid, u.Username, u.Useremail, u.LastLogin, u.UserLastIP, u.UserPost, u.UserGroupID,u.Vip_StarTime,u.Vip_EndTime from dv_user u inner join Dv_UserGroups g on u.usergroupid=g.Usergroupid where g.UserGroupIsAudit=1 or u.userisaudit=1 order by u.userid desc"
	case 17
        Sql="select u.Userid, u.Username, u.Useremail, u.LastLogin, u.UserLastIP, u.UserPost, u.UserGroupID,u.Vip_StarTime,u.Vip_EndTime from dv_user u where u.UserIsAudit_Custom=1 order by u.userid desc"
	case 9
		sqlstr=""
		if request("username")<>"" then
			if request("usernamechk")="yes" then
			sqlstr=" username='"&request("username")&"'"
			else
			sqlstr=" username like '%"&request("username")&"%'"
			end if
		end if
		if cint(request("usergroups"))>0 then
			if sqlstr="" then
			sqlstr=" usergroupid="&request("usergroups")&""
			else
			sqlstr=sqlstr & " and usergroupid="&CheckNumeric(request("usergroups"))
			end if
		end if
		'if request("userclass")<>"0" then
		'	if sqlstr="" then
		'	sqlstr=" userclass='"&request("userclass")&"'"
		'	else
		'	sqlstr=sqlstr & " and userclass='"&request("userclass")&"'"
		'	end if
		'end if

		'======shinzeal������������=======
		dim Tsqlstr
		if request("loginT")<>"" then
		   	if request("loginR")="more" then
			 Tsqlstr=" userlogins >= "&CheckNumeric(request("loginT"))
			else
			 Tsqlstr=" userlogins <= "&CheckNumeric(request("loginT"))
			end if 	
			if sqlstr="" then 
			  sqlstr=Tsqlstr
			else
			  sqlstr=sqlstr & " and " & Tsqlstr
			end if 
		end if

		if request("vanishT")<>"" then
		   	if request("vanishR")="more" then
				If IsSqlDataBase=1 Then
					Tsqlstr=" datediff(d,lastlogin,"&SqlNowString&") >= "&CheckNumeric(request("vanishT"))
				Else
					Tsqlstr=" datediff('d',lastlogin,"&SqlNowString&") >= "&CheckNumeric(request("vanishT"))
				End If
			else
				If IsSqlDataBase=1 Then
					Tsqlstr=" datediff(d,lastlogin,"&SqlNowString&") <= "&CheckNumeric(request("vanishT"))
				Else
					Tsqlstr=" datediff('d',lastlogin,"&SqlNowString&") <= "&CheckNumeric(request("vanishT"))
				End If
			end if 	
			if sqlstr="" then 
			  sqlstr=Tsqlstr
			else
			  sqlstr=sqlstr & " and " & Tsqlstr
			end if 
		end if

		if request("regT")<>"" then
		   	if request("regR")="more" then
				If IsSqlDataBase=1 Then
					Tsqlstr=" datediff(d,JoinDate,"&SqlNowString&") >= "&CheckNumeric(request("regT"))
				Else
					Tsqlstr=" datediff('d',JoinDate,"&SqlNowString&") >= "&CheckNumeric(request("regT"))
				End If
			else
				If IsSqlDataBase=1 Then
					Tsqlstr=" datediff(d,JoinDate,"&SqlNowString&") <= "&CheckNumeric(request("regT"))
				Else
					Tsqlstr=" datediff('d',JoinDate,"&SqlNowString&") <= "&CheckNumeric(request("regT"))
				End If
			end if 	
			if sqlstr="" then 
			  sqlstr=Tsqlstr
			else
			  sqlstr=sqlstr & " and " & Tsqlstr
			end if 
		end if

		if request("artcleT")<>"" then
		   	if request("artcleR")="more" then
			 Tsqlstr=" UserPost >= "&CheckNumeric(request("artcleT"))
			else
			 Tsqlstr=" UserPost <= "&CheckNumeric(request("artcleT"))
			end if 	
			if sqlstr="" then 
			  sqlstr=Tsqlstr
			else
			  sqlstr=sqlstr & " and " & Tsqlstr
			end if 
		end if

		if request("UWealth_value")<>"" then
			if request("UWealth")="more" then
				Tsqlstr=" userWealth >= "&CheckNumeric(Request("UWealth_value"))
			else
				Tsqlstr=" userWealth <= "&CheckNumeric(Request("UWealth_value"))
			end if 	
			if sqlstr="" then 
			  sqlstr=Tsqlstr
			else
			  sqlstr=sqlstr & " and " & Tsqlstr
			end if
		end if

		if request("UEP_value")<>"" then
			if request("UEP")="more" then
				Tsqlstr=" userEP >= "&CheckNumeric(Request("UEP_value"))
			else
				Tsqlstr=" userEP <= "&CheckNumeric(Request("UEP_value"))
			end if 	
			if sqlstr="" then 
			  sqlstr=Tsqlstr
			else
			  sqlstr=sqlstr & " and " & Tsqlstr
			end if
		end if

		if request("UCP_value")<>"" then
			if request("UCP")="more" then
				Tsqlstr=" userCP >= "&CheckNumeric(Request("UCP_value"))
			else
				Tsqlstr=" userCP <= "&CheckNumeric(Request("UCP_value"))
			end if 	
			if sqlstr="" then 
			  sqlstr=Tsqlstr
			else
			  sqlstr=sqlstr & " and " & Tsqlstr
			end if
		end if

		if request("UPower_value")<>"" then
			if request("UPower")="more" then
				Tsqlstr=" UserPower >= "&CheckNumeric(Request("UPower_value"))
			else
				Tsqlstr=" UserPower <= "&CheckNumeric(Request("UPower_value"))
			end if 	
			if sqlstr="" then 
			  sqlstr=Tsqlstr
			else
			  sqlstr=sqlstr & " and " & Tsqlstr
			end if
		end if

		if request("UMoney_value")<>"" then
			if request("UMoney")="more" then
				Tsqlstr=" UserMoney >= "&CheckNumeric(Request("UMoney_value"))
			else
				Tsqlstr=" UserMoney <= "&CheckNumeric(Request("UMoney_value"))
			end if 	
			if sqlstr="" then 
			  sqlstr=Tsqlstr
			else
			  sqlstr=sqlstr & " and " & Tsqlstr
			end if
		end if

		if request("UTicket_value")<>"" then
			if request("UTicket")="more" then
				Tsqlstr=" UserTicket >= "&CheckNumeric(Request("UTicket_value"))
			else
				Tsqlstr=" UserTicket <= "&CheckNumeric(Request("UTicket_value"))
			end if 	
			if sqlstr="" then 
			  sqlstr=Tsqlstr
			else
			  sqlstr=sqlstr & " and " & Tsqlstr
			end if
		end if

		if request("UVipStarTime_value")<>"" then
		   	if request("UVipStarTime")="more" then
				If IsSqlDataBase=1 Then
					Tsqlstr=" datediff(d,Vip_StarTime,"&SqlNowString&") >= "&CheckNumeric(request("UVipStarTime_value"))
				Else
					Tsqlstr=" datediff('d',Vip_StarTime,"&SqlNowString&") >= "&CheckNumeric(request("UVipStarTime_value"))
				End If
			else
				If IsSqlDataBase=1 Then
					Tsqlstr=" datediff(d,Vip_StarTime,"&SqlNowString&") <= "&CheckNumeric(request("UVipStarTime_value"))
				Else
					Tsqlstr=" datediff('d',Vip_StarTime,"&SqlNowString&") <= "&CheckNumeric(request("UVipStarTime_value"))
				End If
			end if 	
			if sqlstr="" then 
			  sqlstr=Tsqlstr
			else
			  sqlstr=sqlstr & " and " & Tsqlstr
			end if 
		end if
		if request("UVipEndTime_value")<>"" then
		   	if request("UVipEndTime")="more" then
				If IsSqlDataBase=1 Then
					Tsqlstr=" datediff(d,Vip_EndTime,"&SqlNowString&") >= "&CheckNumeric(request("UVipEndTime_value"))
				Else
					Tsqlstr=" datediff('d',Vip_EndTime,"&SqlNowString&") >= "&CheckNumeric(request("UVipEndTime_value"))
				End If
			else
				If IsSqlDataBase=1 Then
					Tsqlstr=" datediff(d,Vip_EndTime,"&SqlNowString&") <= "&CheckNumeric(request("UVipEndTime_value"))
				Else
					Tsqlstr=" datediff('d',Vip_EndTime,"&SqlNowString&") <= "&CheckNumeric(request("UVipEndTime_value"))
				End If
			end if 	
			if sqlstr="" then 
			  sqlstr=Tsqlstr
			else
			  sqlstr=sqlstr & " and " & Tsqlstr
			end if 
		end if

		'======������������======
		if request("useremail")<>"" then
			if sqlstr="" then
			sqlstr=" useremail like '%"&request("useremail")&"%'"
			else
			sqlstr=sqlstr & " and useremail like '%"&request("useremail")&"%'"
			end if
		end if
		if request("userim")<>"" then
			if sqlstr="" then
			sqlstr=" UserIM like '%"&request("userim")&"%'"
			else
			sqlstr=sqlstr & " and UserIM like '%"&request("userim")&"%'"
			end if
		end if
		if request("lastip")<>"" then
			if sqlstr="" then
			sqlstr=" UserLastIP like '%"&request("lastip")&"%'"
			else
			sqlstr=sqlstr & " and UserLastIP like '%"&request("lastip")&"%'"
			end if
		end if
		if request("userinfo")<>"" then
			if sqlstr="" then
			sqlstr=" UserInfo like '%"&request("userinfo")&"%'"
			else
			sqlstr=sqlstr & " and UserInfo like '%"&request("userinfo")&"%'"
			end if
		end if
		'����������ͷ������ 2005-4-9 Dv.Yz
		If Request("usertitle") <> "" Then
			If Sqlstr = "" Then
				Sqlstr = " UserTitle LIKE '%" & Request("usertitle") & "%'"
			Else
				Sqlstr = Sqlstr & " AND UserTitle LIKE '%" & Request("usertitle") & "%'"
			End If
		End If
		if request("sign")<>"" then
			if sqlstr="" then
			sqlstr=" usersign like '%"&request("sign")&"%'"
			else
			sqlstr=sqlstr & " and usersign like '%"&request("sign")&"%'"
			end if
		end if

		If Sqlstr = "" Then
			Response.Write "<tr><td colspan=8 class=td1>��ָ������������</td></tr>"
			Response.End
		End If
		If Request("Searchmax") = "" Or Not Isnumeric(Request("Searchmax")) Then
			Sql = "SELECT TOP 1 "& Sql &" FROM [Dv_User] WHERE " & Sqlstr & " ORDER BY UserID DESC"
		Else
			Sql = "SELECT TOP " & Request("Searchmax") & Sql &" FROM [Dv_User] WHERE " & Sqlstr & " ORDER BY UserID DESC"
		End If
	case else
		Response.Write "<tr><td colspan=8 class=td1>����Ĳ�����</td></tr>"
		Response.End
	End Select
	'Response.Write sql
	rs.open sql,conn,1,1
	if rs.eof and rs.bof then
		response.write "<tr><td colspan=8 class=td1>û���ҵ���ؼ�¼��"
		If Request("userSearch")="15" Then
			Response.Write "����δ����VIP�û��飬��<a href=""group.asp""><font color=red>���������̳�û������</font></a>�������ӡ���"
		End If
		Response.Write "</td></tr>"
	else
%>
<FORM METHOD=POST ACTION="?action=touser">
<tr align=center height=23>
<td class=td2 width="10%"><B>�û���</B></td>
<td class=td2 width="15%"><B>Email</B></td>
<td class=td2 width="8%"><B>Ȩ��</B></td>
<td class=td2 width="8%"><B>�����޸�</B></td>
<td class=td2 width="15%"><B>���IP</B></td>
<td class=td2 width="15%"><B>����¼</B></td>
<td class=td2 width="20%"><B>�Ǽ�/��ֹ����</B></td>
<td class=td2><B>����</B></td>
</tr>
<%
		rs.PageSize = Cint(Dvbbs.Forum_Setting(11))
		rs.AbsolutePage=currentpage
		page_count=0
		totalrec=rs.recordcount
		while (not rs.eof) and (not page_count = Cint(Dvbbs.Forum_Setting(11)))
%>
<tr>
<td class=td1><a href="?action=modify&userid=<%=rs("userid")%>"><%=rs("username")%></a></td>
<td class=td1><a href="mailto:<%=rs("useremail")%>"><%=rs("useremail")%></a></td>
<td class=td1 align=center><a href="?action=UserPermission&userid=<%=rs("userid")%>&username=<%=rs("username")%>">�༭</a></td>
<td class=td1 align=center><a href="?action=fix&userid=<%=rs("userid")%>&username=<%=rs("username")%>">�޸�</a></td>
<td class=td1><a href="lockIP.asp?userip=<%=rs("UserLastIP")%>" title="����������û�IP"><%=rs("userlastip")%></a>&nbsp;</td>
<td class=td1><%if rs("lastlogin")<>"" and isdate(rs("lastlogin")) then%><%=rs("lastlogin")%><%end if%></td>
<td class=td1 align=center>
<%=rs("Vip_StarTime")%>/
<%=rs("Vip_EndTime")%>
</td>
<td class=td1 align=center><input type="checkbox" class=checkbox name="userid" value="<%=rs("userid")%>" <%if rs("userGroupid")=1 then response.write "disabled"%>></td>
</tr>
<%
		page_count = page_count + 1
		rs.movenext
		wend
		Pcount=rs.PageCount
%>
<tr><td colspan=8 class=td1 align=center>��ҳ��
<%
Dim Searchstr,i
'����ͷ�������û��ķ�ҳ����
'��������½IP�����û��ķ�ҳ���� 2005.10.12 By Winder
Searchstr = "?userSearch=" & Request("userSearch") & "&username=" & Request("username") & "&useremail=" & Request("useremail") & "&userim=" & Request("userim") & "&lastip=" & Request("lastip") & "&usertitle=" & Request("usertitle") & "&sign=" & Request("sign") & "&userinfo=" & Request("userinfo") & "&action=" & Request("action") & "&loginR=" & Request("loginR") & "&loginT=" & Request("loginT") & "&vanishR=" & Request("vanishR") & "&vanishT=" & Request("vanishT") & "&regR=" & Request("regR") & "&regT=" & Request("regT") & "&artcleR=" & Request("artcleR") & "&artcleT=" & Request("artcleT") & "&UWealth=" & Request("UWealth") & "&UWealth_value=" & Request("UWealth_value") & "&UEP=" & Request("UEP") & "&UEP_value=" & Request("UEP_value") & "&UCP=" & Request("UCP") & "&UCP_value=" & Request("UCP_value") & "&UPower=" & Request("UPower") & "&UPower_value=" & Request("UPower_value") & "&UMoney=" & Request("UMoney") & "&UMoney_value=" & Request("UMoney_value") & "&UTicket=" & Request("UTicket") & "&UTicket_value=" & Request("UTicket_value") & "&searchmax=" & Request("searchmax") & "&UVipStarTime=" & Request("UVipStarTime") & "&UVipStarTime_value=" & Request("UVipStarTime_value") & "&UVipEndTime=" & Request("UVipEndTime") & "&UVipEndTime_value=" & Request("UVipEndTime_value")&"&usergroups="&Request("usergroups")&"&usergroupid="&Request("usergroupid")

	if currentpage > 4 then
		response.write "<a href="""&Searchstr&"&page=1"">[1]</a> ..."
	end if
	if Pcount>currentpage+3 then
		endpage=currentpage+3
	else
		endpage=Pcount
	end if
	for i=currentpage-3 to endpage
	if not i<1 then
		if i = clng(currentpage) then
        response.write " <font color=red>["&i&"]</font>"
		else
        response.write " <a href="""&Searchstr&"&page="&i&""">["&i&"]</a>"
		end if
	end if
	next
	if currentpage+3 < Pcount then 
		response.write "... <a href="""&Searchstr&"&page="&Pcount&""">["&Pcount&"]</a>"
	end if
%>
</td></tr>
<tr><td colspan=5 class=td1 align=center><B>��ѡ������Ҫ���еĲ���</B>��<input type="radio" class=radio name="useraction" value=1> ɾ��&nbsp;&nbsp;<input type="radio" class=radio name="useraction" value=3> ɾ���û���������&nbsp;&nbsp;<input type="radio" class=radio name="useraction" value=2 checked> �ƶ����û���
<select size=1 name="selusergroup">
<%
set trs=Dvbbs.Execute("select usergroupid,UserTitle,ParentGID from dv_usergroups where not (usergroupid=1 or usergroupid=7) and (Not ParentGID=0) order by ParentGID,usergroupid")
do while not trs.eof
response.write "<option value="&trs(0)&">"&SysGroupName(tRs(2))&trs(1)&"</option>"
trs.movenext
loop
trs.close
set trs=nothing
%>
</select>
</td>
<td class=td1 colspan=8 align=center>ȫ��ѡ��<input type=checkbox class=checkbox value="on" name="chkall" onclick="CheckAll(this.form)">
</td>
</tr>
<tr><td colspan=8 class=td1 align=center>
<input type=submit class=button name=submit value="ִ��ѡ���Ĳ���"  onclick="{if(confirm('ȷ��ִ��ѡ��Ĳ�����?')){return true;}return false;}">
</td></tr>
</FORM>
<%
	end if
	rs.close
	set rs=nothing
End Sub

'�����û���ɾ���û���Ϣ��ز���
Sub ToUser()
	Dim SQL,rs
	response.write "<tr><th colspan=8 style=""text-align:center;"">ִ�н��</th></tr>"
	if request("useraction")="" then
		response.write "<tr><td colspan=8 class=td1>��ָ����ز�����</td></tr>"
		founderr=true
	end if
	if request("userid")="" then
		response.write "<tr><td colspan=8 class=td1>��ѡ������û���</td></tr>"
		founderr=true
	end if
	if not founderr then
		if request("useraction")=1 then
			Dim AllUserName
			AllUserName = ""
			'------------------shinzeal����ɾ���û��Ķ���-------------------------
			dim uid,i
			for i=1 to request("userid").count
				if request("userid").count=1 then
				uID=request("userid")
				else
				uID=replace(request.form("userid")(i),"'","")
				end if
				set rs=Dvbbs.Execute("select username from [dv_User] where userid="&uid&"")
				if not (rs.eof and rs.bof) then
					AllUserName = AllUserName & Rs(0) & ","
					Dvbbs.Execute("update dv_message set delR=1 where incept='"&trim(rs(0))&"' and delR=0")
					Dvbbs.Execute("update dv_message set delS=1 where sender='"&trim(rs(0))&"' and delS=0 and issend=0")
					Dvbbs.Execute("update dv_message set delS=1 where sender='"&trim(rs(0))&"' and delS=0 and issend=1")
					Dvbbs.Execute("delete from dv_message where incept='"&rs(0)&"' and delR=1") 
					Dvbbs.Execute("update dv_message set delS=2 where sender='"&trim(rs(0))&"' and delS=1")
					Dvbbs.Execute("delete from dv_friend where F_username='"&rs(0)&"'") 
					Dvbbs.Execute("delete from dv_bookmark where username='"&rs(0)&"'") 
				end if 
				rs.close
			next
			If Right(AllUserName,1) = "," Then AllUserName = Left(AllUserName,Len(AllUserName)-1)
			'-------------------ɾ���û��Ķ���------------------------
			'ɾ���û������Ӻ;���
			Dvbbs.Execute("delete from dv_topic where PostUserID in ("&replace(request("userid"),"'","")&")")
			for i=0 to ubound(allposttable)
				Dvbbs.Execute("delete from "&allposttable(i)&" where PostUserID in ("&replace(request("userid"),"'","")&")")
			next
			Dvbbs.Execute("delete from dv_besttopic where PostUserID in ("&replace(request("userid"),"'","")&")")
			'ɾ���û��ϴ���
			Dvbbs.Execute("delete from dv_upfile where F_UserID in ("&replace(request("userid"),"'","")&")")
			Dvbbs.Execute("delete from [dv_user] where userid in ("&replace(request("userid"),"'","")&")")
			Response.write "<tr><td colspan=8 class=td1>ɾ���û��� "& AllUserName &" �������ɹ���</td></tr>"

			'-----------------------------------------------------------------
			'ϵͳ����
			'-----------------------------------------------------------------
			Dim DvApi_Obj,DvApi_SaveCookie,SysKey
			If DvApi_Enable Then
				'SysKey = Md5(DvApi_SysKey&AllUserName,16)
				Set DvApi_Obj = New DvApi
					DvApi_Obj.NodeValue "syskey",SysKey,0,False
					DvApi_Obj.NodeValue "action","delete",0,False
					DvApi_Obj.NodeValue "username",AllUserName,1,False
					Md5OLD = 1
					SysKey = Md5(DvApi_Obj.XmlNode("username")&DvApi_SysKey,16)
					Md5OLD = 0
					DvApi_Obj.NodeValue "syskey",SysKey,0,False
					DvApi_Obj.SendHttpData
					'If DvApi_Obj.Status = "1" Then
						'Response.redirect "showerr.asp?ErrCodes="& DvApi_Obj.Message &"&action=OtherErr"
					'End If
				Set DvApi_Obj = Nothing
			End If
			'-----------------------------------------------------------------
		elseif request("useraction")=2 then
			dim userclass,usertitlepic
			set rs=Dvbbs.Execute("select * from dv_usergroups where usergroupid="&request("selusergroup")&" order by minarticle")
			if not (rs.eof and rs.bof) then
				userclass=rs("usertitle")
				usertitlepic=rs("grouppic")
			end if
			Dvbbs.Execute("update [dv_user] set UserGroupID="&replace(request("selusergroup"),"'","")&",userclass='"&userclass&"',titlepic='"&usertitlepic&"' where userid in ("&replace(request("userid"),"'","")&")")
			response.write "<tr><td colspan=8 class=td1>�����ɹ���</td></tr>"
		elseif request("useraction")=3 then
			dim titlenum
			if request("userid")="" then
				response.write "<tr><td colspan=8 class=td1>�����뱻ɾ�������û�����</td></tr>"
			end if
			titlenum=0
			for i=0 to ubound(allposttable)
			set rs=Dvbbs.Execute("Select Count(announceID) from "&allposttable(i)&" where postuserid in ("&replace(request("userid"),"'","")&")") 
   			titlenum=titlenum+rs(0)
			sql="update "&allposttable(i)&" set locktopic=boardid,boardid=444,isbest=0 where postuserid in ("&replace(request("userid"),"'","")&")"
			Dvbbs.Execute(sql)
			next
			Dvbbs.Execute("delete from dv_besttopic where postuserid in ("&replace(request("userid"),"'","")&")")
			set rs=Dvbbs.Execute("select topicid,posttable from dv_topic where postuserid in ("&replace(request("userid"),"'","")&")")
			do while not rs.eof
			Dvbbs.Execute("update "&rs(1)&" set locktopic=boardid,boardid=444,isbest=0 where rootid="&rs(0))
			rs.movenext
			loop
			set rs=nothing
			Dvbbs.Execute("update dv_topic set locktopic=boardid,boardid=444,isbest=0 where postuserid in ("&replace(request("userid"),"'","")&")")
			if isnull(titlenum) then titlenum=0
			sql="update [dv_user] set UserPost=UserPost-"&titlenum&",userWealth=userWealth-"&titlenum*Dvbbs.Forum_user(3)&",userEP=userEP-"&titlenum*Dvbbs.Forum_user(8)&",userCP=userCP-"&titlenum*Dvbbs.Forum_user(13)&" where userid in ("&replace(request("userid"),"'","")&")"
			Dvbbs.Execute(sql)
			response.write "<tr><td colspan=8 class=td1>ɾ���ɹ������Ҫ��ȫɾ�������뵽��̳����վ<BR>��������������̳�����и���һ����̳���ݣ�����<a href=alldel.asp>����</a></td></tr>"
		else
			response.write "<tr><td colspan=8 class=td1>����Ĳ�����</td></tr>"
		end if
	end if
End Sub

'�޸��û����ϱ���
Sub UserModify()
dim realname,character,personal,country,province,city,shengxiao,blood,belief,occupation,marital, education,college,userphone,iaddress
Dim UserIM
Dim rs,sql
	response.write "<tr><th colspan=8 style=""text-align:center;"">�û����ϲ���</th></tr>"
	if not isnumeric(request("userid")) then
		response.write "<tr><td colspan=8 class=td1>������û�������</td></tr>"
		founderr=true
	end if
	if not founderr then
		Set rs= Dvbbs.iCreateObject("ADODB.Recordset")
		sql="select * from [dv_user] where userid="&request("userid")
		rs.open sql,conn,1,1
		if rs.eof and rs.bof then
		response.write "<tr><td colspan=8 class=td1>û���ҵ�����û���</td></tr>"
		founderr=true
		else
if rs("userinfo")<>"" then
	userinfo=split(Server.HtmlEncode(rs("userinfo")),"|||")
	if ubound(userinfo)=14 then
		realname=userinfo(0)
		character=userinfo(1)
		personal=userinfo(2)
		country=userinfo(3)
		province=userinfo(4)
		city=userinfo(5)
		shengxiao=userinfo(6)
		blood=userinfo(7)
		belief=userinfo(8)
		occupation=userinfo(9)
		marital=userinfo(10)
		education=userinfo(11)
		college=userinfo(12)
		userphone=userinfo(13)
		iaddress=userinfo(14)
	else
		realname=""
		character=""
		personal=""
		country=""
		province=""
		city=""
		shengxiao=""
		blood=""
		belief=""
		occupation=""
		marital=""
		education=""
		college=""
		userphone=""
		iaddress=""
	end if
else
	realname=""
	character=""
	personal=""
	country=""
	province=""
	city=""
	shengxiao=""
	blood=""
	belief=""
	occupation=""
	marital=""
	education=""
	college=""
	userphone=""
	iaddress=""
end if
UserIM = Split(Rs("UserIM"),"|||")
%>
<FORM METHOD=POST ACTION="?action=saveuserinfo">
<tr>
<td width=100% class=td1 valign=top colspan=8>�� <%=rs("username")%> �û��������ѡ�<BR><BR>
<a href="mailto:<%=rs("useremail")%>">���ʼ�</a> | <a href="../messanger.asp?action=new&touser=<%=rs("username")%>" target=_blank>������</a> | <a href="../dispuser.asp?id=<%=rs("userid")%>" target=_blank>Ԥ���û�����</a> | <a href="../Query.asp?stype=1&nSearch=3&keyword=<%=rs("username")%>&SearchDate=30" target=_blank>�û�����</a> | <a href="../Query.asp?stype=6&nSearch=0&pSearch=0&keyword=<%=rs("username")%>" target=_blank>�û�����</a> | <a href="../Query.asp?stype=4&nSearch=0&pSearch=0&keyword=<%=rs("username")%>" target=_blank>�û�����</a> | <a href="../show.asp?username=<%=rs("username")%>" target=_blank>�û�չ��</a> | <a href="?action=UserPermission&userid=<%=rs("userid")%>&username=<%=rs("username")%>">�༭Ȩ��</a> | <a href="../TopicOther.asp?action=lookip&ip=<%=Rs("UserLastIP")%>&t=1" target=_blank>�����Դ</a> | <a href="?action=touser&useraction=1&userid=<%=rs("userid")%>" onclick="{if(confirm('ɾ�������ɻָ������ҽ�ɾ�����û�����̳��������Ϣ��ȷ��ɾ����?')){return true;}return false;}">ɾ���û�</a>
</td>
</tr>
<tr><th colspan=6 style="text-align:center;">�û����������޸ģ���<%=rs("username")%></th></tr>
<tr><td class=td1 height=23 align=left colspan=6>
ע�⣺�½�����Ա���鵽����Ա�����н��У����ڴ�����Ϊ����Ա����û����޽���ϵͳ��̨Ȩ��
</td></tr>
<tr>
<td width=20% class=td1>�û���</td>
<td width=80% class=td1 colspan=5>
<select size=1 name="usergroups">
<%
set trs=Dvbbs.Execute("select usergroupid,UserTitle,parentgid from dv_usergroups where Not ParentGID=0 order by ParentGID,usergroupid")
do while not trs.eof
response.write "<option value="&trs(0)
if rs("usergroupid")=trs(0) then response.write " selected "
response.write ">"&SysGroupName(tRs(2)) & trs(1)
'if trs(2)>0 then response.write "(�Զ���ȼ�)"
response.write "</option>"
trs.movenext
loop
trs.close
set trs=nothing

%>
</select>
</td>
</tr>
<input name="userid" type=hidden value="<%=rs("userid")%>">
<tr>
<td width=20% class=td1>�û���</td>
<td width=80% class=td1 colspan=5><input size=45 name="username" type=text value="<%=Server.HtmlEncode(rs("username"))%>" disabled></td>
</tr>
<tr>
<td width=20% class=td1>��  ��</td>
<td width=80% class=td1 colspan=5><input size=45 name="password" type=text>&nbsp;������޸�������</td>
</tr>
<tr>
<td width=20% class=td1>��������</td>
<td width=80% class=td1 colspan=5><input size=45 name="quesion" type=text value="<%If Trim(rs("userquesion"))<>"" Then Response.Write Server.HtmlEncode(rs("userquesion"))%>"></td>
</tr>
<tr>
<td width=20% class=td1>�����</td>
<td width=80% class=td1 colspan=5><input size=45 name="answer" type=text>&nbsp;������޸�������</td>
</tr><tr>
<td width=20% class=td1>�û��Ա�</td>
<td width=80% class=td1 colspan=5>
Ů <input type="radio" class=radio value="0" <%if rs("UserSex")=0 then%>checked<%end if%> name="sex">&nbsp;
�� <input type="radio" class=radio value="1" <%if rs("UserSex")=1 then%>checked<%end if%> name="sex">&nbsp;
</td>
</tr>
<tr>
<td width=20% class=td1>������Ƭ</td>
<td width=80% class=td1 colspan=5><input size=45 name="UserPhoto" type=text value="<%If Trim(rs("UserPhoto"))<>"" Then Response.Write Server.HtmlEncode(rs("UserPhoto"))%>"></td>
</tr>
<tr>
<td width=20% class=td1>Email</td>
<td width=80% class=td1 colspan=5><input size=45 name="userEmail" type=text value="<%If Trim(rs("useremail"))<>"" Then Response.Write Server.HtmlEncode(rs("useremail"))%>"></td>
</tr>
<tr>
<td width=20% class=td1>������ҳ</td>
<td width=80% class=td1 colspan=5><input size=45 name="homepage" type=text value="<%=Server.HtmlEncode(UserIM(0))%>"></td>
</tr>
<tr>
<td width=20% class=td1>ͷ��</td>
<td width=80% class=td1 colspan=5><input size=45 name="face" type=text value="<%If Trim(Rs("UserFace"))<>"" Then Response.Write Server.HtmlEncode(Split(rs("userface"),"|")(Ubound(Split(rs("userface"),"|"))))%>">&nbsp;���ȣ�<input size=3 name="width" type=text value="<%=rs("userwidth")%>">&nbsp;�߶ȣ�<input size=3 name="height" type=text value="<%=rs("userheight")%>"></td>
</tr>
<tr>
<td width=20% class=td1>OICQ</td>
<td width=80% class=td1 colspan=5><input size=45 name="oicq" type=text value="<%=Server.HtmlEncode(UserIM(1))%>"></td>
</tr>
<tr>
<td width=20% class=td1>ICQ</td>
<td width=80% class=td1 colspan=5><input size=45 name="icq" type=text value="<%=Server.HtmlEncode(UserIM(2))%>"></td>
</tr>
<tr>
<td width=20% class=td1>MSN</td>
<td width=80% class=td1 colspan=5><input size=45 name="msn" type=text value="<%=Server.HtmlEncode(UserIM(3))%>"></td>
</tr>
<tr>
<td width=20% class=td1>AIM</td>
<td width=80% class=td1 colspan=5><input size=45 name="aim" type=text value="<%=Server.HtmlEncode(UserIM(4))%>"></td>
</tr>
<tr>
<td width=20% class=td1>YaHoo</td>
<td width=80% class=td1 colspan=5><input size=45 name="yahoo" type=text value="<%=Server.HtmlEncode(UserIM(5))%>"></td>
</tr>
<tr>
<td width=20% class=td1>UC</td>
<td width=80% class=td1 colspan=5><input size=45 name="uc" type=text value="<%=Server.HtmlEncode(UserIM(6))%>"></td>
</tr>
<tr>
<td width=20% class=td1>ͷ��</td>
<td width=80% class=td1 colspan=5><input size=45 name="usertitle" type=text value="<%If Trim(Rs("UserTitle"))<>"" Then Response.Write Server.HtmlEncode(rs("usertitle"))%>"></td>
</tr>
<tr><th colspan=6 style="text-align:center;">�û���ֵ�����޸�</th></tr>
<tr>
<td width=20% class=td1>��������</td>
<td width=80% class=td1 colspan=5><input size=45 name="article" type=text value="<%=rs("UserPost")%>"></td>
</tr>
<tr>
<td width=20% class=td1>��ɾ����</td>
<td width=80% class=td1 colspan=5><input size=45 name="Userdel" type=text value="<%=rs("userdel")%>"></td>
</tr>
<tr>
<td width=20% class=td1>��������</td>
<td width=80% class=td1 colspan=5><input size=45 name="userisbest" type=text value="<%=rs("userisbest")%>"></td>
</tr>
<tr>
<td width=20% class=td1>���</td>
<td width=80% class=td1 colspan=5><input size=45 name="usermoney" type=text value="<%=rs("usermoney")%>"></td>
</tr>
<tr>
<td width=20% class=td1>��ȯ</td>
<td width=80% class=td1 colspan=5><input size=45 name="UserTicket" type=text value="<%=rs("UserTicket")%>"></td>
</tr>
<tr>
<td width=20% class=td1>��Ǯ</td>
<td width=80% class=td1 colspan=5><input size=45 name="userwealth" type=text value="<%=rs("userwealth")%>"></td>
</tr>
<tr>
<td width=20% class=td1>����</td>
<td width=80% class=td1 colspan=5><input size=45 name="userep" type=text value="<%=rs("userep")%>"></td>
</tr>
<tr>
<td width=20% class=td1>����</td>
<td width=80% class=td1 colspan=5><input size=45 name="usercp" type=text value="<%=rs("usercp")%>"></td>
</tr>
<tr>
<td width=20% class=td1>����</td>
<td width=80% class=td1 colspan=5><input size=45 name="userpower" type=text value="<%=rs("userpower")%>"></td>
</tr>
<tr><th colspan=6 style="text-align:center;">�������</th></tr>
<tr>
<td width=20% class=td1>����</td>
<td width=80% class=td1 colspan=5><input size=45 name="birthday" type=text value="<%=rs("userbirthday")%>">&nbsp;��ʽ��2001-2-2</td>
</tr>
<tr>
<td width=20% class=td1>ע��ʱ��</td>
<td width=80% class=td1 colspan=5><input size=45 name="adddate" type=text value="<%=rs("JoinDate")%>"></td>
</tr>
<tr>
<td width=20% class=td1>����¼</td>
<td width=80% class=td1 colspan=5><input size=45 name="lastlogin" type=text value="<%=rs("lastlogin")%>"></td>
</tr>
<tr>
<td width=20% class=td1>ע��IP</td>
<td width=80% class=td1 colspan=5><input size=45 name="regip" type=text value="<%=rs("regip")%>"></td>
</tr>
<tr><th colspan=6 style="text-align:center;">�û���ϸ����</th></tr>
<tr>
<td width=20% class=td1>��ʵ����</td>
<td width=80% class=td1 colspan=5><input size=45 name="realname" type=text value="<%=realname%>"></td>
</tr>
<tr>
<td width=20% class=td1>��������</td>
<td width=80% class=td1 colspan=5><input size=45 name="country" type=text value="<%=country%>"></td>
</tr>
<tr>
<td width=20% class=td1>��ϵ�绰</td>
<td width=80% class=td1 colspan=5><input size=45 name="userphone" type=text value="<%=userphone%>"></td>
</tr><tr>
<td width=20% class=td1>ͨ�ŵ�ַ</td>
<td width=80% class=td1 colspan=5><input size=45 name="address" type=text value="<%=iaddress%>"></td>
</tr>
<tr>
<td width=20% class=td1>ʡ������</td>
<td width=80% class=td1 colspan=5><input size=45 name="province" type=text value="<%=province%>"></td>
</tr>
<tr>
<td width=20% class=td1>�ǡ�����</td>
<td width=80% class=td1 colspan=5><input size=45 name="city" type=text value="<%=city%>"></td>
</tr><tr>
<td width=20% class=td1>������Ф</td>
<td width=80% class=td1 colspan=5>
<select size=1 name=shengxiao>
<option <%if shengxiao="" then%>selected<%end if%>></option>
<option value=�� <%if shengxiao="��" then%>selected<%end if%>>��</option>
<option value=ţ <%if shengxiao="ţ" then%>selected<%end if%>>ţ</option>
<option value=�� <%if shengxiao="��" then%>selected<%end if%>>��</option>
<option value=�� <%if shengxiao="��" then%>selected<%end if%>>��</option>
<option value=�� <%if shengxiao="��" then%>selected<%end if%>>��</option>
<option value=�� <%if shengxiao="��" then%>selected<%end if%>>��</option>
<option value=�� <%if shengxiao="��" then%>selected<%end if%>>��</option>
<option value=�� <%if shengxiao="��" then%>selected<%end if%>>��</option>
<option value=�� <%if shengxiao="��" then%>selected<%end if%>>��</option>
<option value=�� <%if shengxiao="��" then%>selected<%end if%>>��</option>
<option value=�� <%if shengxiao="��" then%>selected<%end if%>>��</option>
<option value=�� <%if shengxiao="��" then%>selected<%end if%>>��</option>
</select>
</td>
</tr>
<tr>
<td width=20% class=td1>Ѫ������</td>
<td width=80% class=td1 colspan=5>
<select size=1 name=blood>
<option <%if blood="" then%>selected<%end if%>></option>
<option value=A <%if blood="A" then%>selected<%end if%>>A</option>
<option value=B <%if blood="B" then%>selected<%end if%>>B</option>
<option value=AB <%if blood="AB" then%>selected<%end if%>>AB</option>
<option value=O <%if blood="O" then%>selected<%end if%>>O</option>
<option value=���� <%if blood="����" then%>selected<%end if%>>����</option>
</select>
</td>
</tr>
<tr>
<td width=20% class=td1>�š�����</td>
<td width=80% class=td1 colspan=5>
<select size=1 name=belief>
<option <%if belief="" then%>selected<%end if%>></option>
<option value=��� <%if belief="���" then%>selected<%end if%>>���</option>
<option value=���� <%if belief="����" then%>selected<%end if%>>����</option>
<option value=������ <%if belief="������" then%>selected<%end if%>>������</option>
<option value=������ <%if belief="������" then%>selected<%end if%>>������</option>
<option value=�ؽ� <%if belief="�ؽ�" then%>selected<%end if%>>�ؽ�</option>
<option value=�������� <%if belief="��������" then%>selected<%end if%>>��������</option>
<option value=���������� <%if belief="����������" then%>selected<%end if%>>����������</option>
<option value=���� <%if belief="����" then%>selected<%end if%>>����</option>
</select>
</td>
</tr><tr>
<td width=20% class=td1>ְ����ҵ</td>
<td width=80% class=td1 colspan=5>
<select name=occupation>
<option <%if occupation="" then%>selected<%end if%>> </option>
<option value="�ƻ�/����" <%if occupation="�ƻ�/����" then%>selected<%end if%>>�ƻ�/����</option>
<option value=����ʦ <%if occupation="����ʦ" then%>selected<%end if%>>����ʦ</option>
<option value=���� <%if occupation="����" then%>selected<%end if%>>����</option>
<option value=����������ҵ <%if occupation="����������ҵ" then%>selected<%end if%>>����������ҵ</option>
<option value=��ͥ���� <%if occupation="��ͥ����" then%>selected<%end if%>>��ͥ����</option>
<option value="����/��ѵ" <%if occupation="����/��ѵ" then%>selected<%end if%>>����/��ѵ</option>
<option value="�ͻ�����/֧��" <%if occupation="�ͻ�����/֧��" then%>selected<%end if%>>�ͻ�����/֧��</option>
<option value="������/�ֹ�����" <%if occupation="������/�ֹ�����" then%>selected<%end if%>>������/�ֹ�����</option>
<option value=���� <%if occupation="����" then%>selected<%end if%>>����</option>
<option value=��ְҵ <%if occupation="��ְҵ" then%>selected<%end if%>>��ְҵ</option>
<option value="����/�г�/���" <%if occupation="����/�г�/���" then%>selected<%end if%>>����/�г�/���</option>
<option value=ѧ�� <%if occupation="ѧ��" then%>selected<%end if%>>ѧ��</option>
<option value=�о��Ϳ��� <%if occupation="�о��Ϳ���" then%>selected<%end if%>>�о��Ϳ���</option>
<option value="һ�����/�ල" <%if occupation="һ�����/�ල" then%>selected<%end if%>>һ�����/�ල</option>
<option value="����/����" <%if occupation="����/����" then%>selected<%end if%>>����/����</option>
<option value="ִ�й�/�߼�����" <%if occupation="ִ�й�/�߼�����" then%>selected<%end if%>>ִ�й�/�߼�����</option>
<option value="����/����/����" <%if occupation="����/����/����" then%>selected<%end if%>>����/����/����</option>
<option value=רҵ��Ա <%if occupation="רҵ��Ա" then%>selected<%end if%>>רҵ��Ա</option>
<option value="�Թ�/ҵ��" <%if occupation="�Թ�/ҵ��" then%>selected<%end if%>>�Թ�/ҵ��</option>
<option value=���� <%if occupation="����" then%>selected<%end if%>>����</option>
</select>
</td>
</tr>
<tr>
<td width=20% class=td1>����״��</td>
<td width=80% class=td1 colspan=5>
<select size=1 name=marital>
<option <%if marital="" then%>selected<%end if%>></option>
<option value=δ�� <%if marital="δ��" then%>selected<%end if%>>δ��</option>
<option value=�ѻ� <%if marital="�ѻ�" then%>selected<%end if%>>�ѻ�</option>
<option value=���� <%if marital="����" then%>selected<%end if%>>����</option>
<option value=ɥż <%if marital="ɥż" then%>selected<%end if%>>ɥż</option>
</select>
</td>
</tr>
<tr>
<td width=20% class=td1>���ѧ��</td>
<td width=80% class=td1 colspan=5>
<select size=1 name=education>
<option <%if education="" then%>selected<%end if%>></option>
<option value=Сѧ <%if education="Сѧ" then%>selected<%end if%>>Сѧ</option>
<option value=���� <%if education="����" then%>selected<%end if%>>����</option>
<option value=���� <%if education="����" then%>selected<%end if%>>����</option>
<option value=��ѧ <%if education="��ѧ" then%>selected<%end if%>>��ѧ</option>
<option value=˶ʿ <%if education="˶ʿ" then%>selected<%end if%>>˶ʿ</option>
<option value=��ʿ <%if education="��ʿ" then%>selected<%end if%>>��ʿ</option>
</select>
</td>
</tr>
<tr>
<td width=20% class=td1>��ҵԺУ</td>
<td width=80% class=td1 colspan=5><input size=45 name="college" type=text value="<%=college%>"></td>
</tr>
<tr>
<td width=20% class=td1>�ԡ���</td>
<td width=80% class=td1 colspan=5>
<textarea name=character rows=4 cols=80><%=character%></textarea>
</td>
</tr><tr>
<td width=20% class=td1>���˼��</td>
<td width=80% class=td1 colspan=5>
<textarea name=personal rows=4 cols=80><%=personal%></textarea>
</td>
</tr><tr>
<td width=20% class=td1>�û�ǩ��</td>
<td width=80% class=td1 colspan=5>
<textarea name="sign" rows=4 cols=80><%If Trim(Rs("UserSign"))<>"" Then Response.Write Server.HtmlEncode(rs("usersign"))%></textarea>
</td>
</tr>
<tr><th colspan=6 style="text-align:center;">�û�����</th></tr>
<tr>
<td width=20% class=td1>�û�״̬</td>
<td width=80% class=td1 colspan=5>
���� <input type="radio" class=radio value="0" <%if rs("lockuser")=0 then%>checked<%end if%> name="lockuser">&nbsp;
���� <input type="radio" class=radio value="1" <%if rs("lockuser")=1 then%>checked<%end if%> name="lockuser">&nbsp;
���� <input type="radio" class=radio value="2" <%if rs("lockuser")=2 then%>checked<%end if%> name="lockuser">
</td>
</tr>
<tr>
<td width=20% class=td1>����¼IP��ѯ</td>
<td width=80% class=td1 colspan=5><%
Dim lastipinfo,k
lastipinfo=Rs("lastipinfo")
If lastipinfo="" Or IsNull(lastipinfo) Then lastipinfo="127.0.0.1"
response.Write Replace(lastipinfo,"|","&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
%></td>
</tr>
<!--
<tr>
<td width=20% class=td1>�����Ա</td>
<td width=80% class=td1 colspan=5>
�ر� <input type="radio" class=radio value="0" <%if rs("IsChallenge")=0 then%>checked<%end if%> name="IsChallenge">&nbsp;
���� <input type="radio" class=radio value="1" <%if rs("IsChallenge")=1 then%>checked<%end if%> name="IsChallenge">&nbsp;
&nbsp;&nbsp;
�ֻ���&nbsp;<input type=text size=15 name="UserMobile" Value="<%=Rs("UserMobile")%>">
</td>
</tr>
-->
<tr>
<td width=20% class=td1>VIP�û��Ǽ�ʱ��</td>
<td width=80% class=td1 colspan=5>
<INPUT TYPE="text" NAME="Vip_StarTime" value="<%=Rs("Vip_StarTime")%>">
</td>
</tr>
<tr>
<td width=20% class=td1>VIP�û�����ʱ��</td>
<td width=80% class=td1 colspan=5>
<INPUT TYPE="text" NAME="Vip_EndTime" value="<%=Rs("Vip_EndTime")%>">
</td>
</tr>
<tr>
<td width=100% class=td1 align=center colspan=6><input name="submit" type=submit class=button value="   ��  ��   "></td>
</tr>
</FORM>
<%
		end if
		rs.close
		set rs=nothing
	end if
End Sub

Sub SaveUserInfo()
	response.write "<tr><th colspan=8 style=""text-align:center;"">�����û�����</th></tr>"
	userinfo=checkreal(request.Form("realname")) & "|||" & checkreal(request.Form("character")) & "|||" & checkreal(request.Form("personal")) & "|||" & checkreal(request.Form("country")) & "|||" & checkreal(request.Form("province")) & "|||" & checkreal(request.Form("city")) & "|||" & request.Form("shengxiao") & "|||" & request.Form("blood") & "|||" & request.Form("belief") & "|||" & request.Form("occupation") & "|||" & request.Form("marital") & "|||" & request.Form("education") & "|||" & checkreal(request.Form("college")) & "|||" & checkreal(request.Form("userphone")) & "|||" & checkreal(request.Form("address"))
	dim myuserim,rs,sql
	myuserim=checkreal(request.Form("homepage")) & "|||" & checkreal(request.Form("oicq")) & "|||" & checkreal(request.Form("icq")) & "|||" & checkreal(request.Form("msn")) & "|||" & checkreal(request.Form("aim")) & "|||" & checkreal(request.Form("yahoo")) & "|||" & request.Form("uc")
	if not isnumeric(request("userid")) then
		response.write "<tr><td colspan=8 class=td1>������û�������</td></tr>"
		founderr=true
	end if
	'�û�ǩ���������� 2004-9-13 Dv.Yz
	If Dvbbs.StrLength(Request.Form("sign")) > 250 Then
		Response.Write "<tr><td colspan=8 class=td1>�û�ǩ�����ܳ��� 250 ���ַ���</td></tr>"
		Founderr = True
	End If
	if not founderr then
	Dim iUserClass,iTitlePic
	Set Rs=Dvbbs.Execute("Select * From Dv_UserGroups Where UserGroupID = " & Request.Form("usergroups"))
	If Rs.Eof And Rs.Bof Then
		Response.Write "<tr><td colspan=8 class=td1>��ѡ�û�����Ϣ�������ڡ�</td></tr>"
		Founderr = True
	Else
		iUserClass = Rs("UserTitle")
		iTitlePic = Rs("GroupPic")
	End If
	Dim UpUserName
	Set rs= Dvbbs.iCreateObject("ADODB.Recordset")
	sql="select * from [dv_user] where userid="&request("userid")
	rs.open sql,conn,1,3
	if rs.eof and rs.bof then
		response.write "<tr><td colspan=8 class=td1>û���ҵ�����û���</td></tr>"
		founderr=true
	Else
		UpUserName = rs("username")
		Rs("UserPhoto")=Request.form("UserPhoto")
		'rs("username")=request.form("username")
		if request.form("password")<>"" then
			rs("userpassword")=md5(request.form("password"),16)
		end if
		rs("usergroupid")=request.form("usergroups")
		rs("userquesion")=request.form("quesion")
		if request.form("answer")<>"" then rs("useranswer")=md5(request.form("answer"),16)
		rs("userclass")=iUserClass
		rs("useremail")=request.form("useremail")
		Rs("UserSex")=request.form("sex")
		rs("userim")=myuserim
		rs("userface")=request.form("face")
		if isnumeric(request.form("width")) then rs("userwidth")=request.form("width")
		if isnumeric(request.form("height")) then rs("userheight")=request.form("height")
		rs("usertitle")=request.form("usertitle")
		rs("titlepic")=iTitlePic
		if isnumeric(request.form("article")) then rs("UserPost")=request.form("article")
		if isnumeric(request.form("userdel")) then rs("userdel")=request.form("userdel")
		if isnumeric(request.form("userisbest")) then rs("userisbest")=request.form("userisbest")
		if isnumeric(request.form("userpower")) then rs("userpower")=request.form("userpower")
		if isnumeric(request.form("userwealth")) then rs("userwealth")=request.form("userwealth")
		if isnumeric(request.form("usermoney")) then rs("usermoney")=request.form("usermoney")
		if isnumeric(request.form("UserTicket")) then rs("UserTicket")=request.form("UserTicket")
		if isnumeric(request.form("userep")) then rs("userep")=request.form("userep")
		if isnumeric(request.form("usercp")) then rs("usercp")=request.form("usercp")
		if isdate(request.form("birthday")) then rs("userbirthday")=request.form("birthday")
		if isdate(request.form("adddate")) then rs("JoinDate")=request.form("adddate")
		if isdate(request.form("lastlogin")) then rs("lastlogin")=request.form("lastlogin")
		if isdate(request.form("Vip_StarTime")) then rs("Vip_StarTime")=request.form("Vip_StarTime")
		if isdate(request.form("Vip_EndTime")) then rs("Vip_EndTime")=request.form("Vip_EndTime")
		if isnumeric(request.form("lockuser")) then rs("lockuser")=request.form("lockuser")
		rs("usersign")=request.form("sign")
		rs("userinfo")=userinfo
		rs("regip")=request.form("regip")
		'If request.form("IsChallenge")="0" Or Request.Form("UserMobile")="" Then
			Rs("IsChallenge")=0
			Rs("UserMobile")=""
		'Else
		'	Rs("IsChallenge")=1
		'	Rs("UserMobile")=Request.Form("UserMobile")
		'End If
		rs.update
	end if
	rs.close
	set rs=nothing
	end if
	if not founderr then
		'-----------------------------------------------------------------
		'ϵͳ����
		'-----------------------------------------------------------------
		Dim DvApi_Obj,DvApi_SaveCookie,SysKey
		If DvApi_Enable Then
			Set DvApi_Obj = New DvApi
				DvApi_Obj.NodeValue "syskey",SysKey,0,False
				DvApi_Obj.NodeValue "action","update",0,False
				DvApi_Obj.NodeValue "username",UpUserName,1,False
				Md5OLD = 1
				SysKey = Md5(DvApi_Obj.XmlNode("username")&DvApi_SysKey,16)
				Md5OLD = 0
				DvApi_Obj.NodeValue "syskey",SysKey,0,False
				DvApi_Obj.NodeValue "password",Request.form("password"),1,False
				DvApi_Obj.NodeValue "answer",Request.Form("useranswer"),1,False
				DvApi_Obj.NodeValue "question",Request.Form("quesion"),1,False
				DvApi_Obj.NodeValue "email",Request.Form("useremail"),1,False
				DvApi_Obj.SendHttpData
				If DvApi_Obj.Status = "1" Then
					response.write "<tr><td colspan=8 class=td1>"&DvApi_Obj.Message&"</td></tr>"
				End If
			Set DvApi_Obj = Nothing
		End If
		'-----------------------------------------------------------------
	End If
	if founderr then
		response.write "<tr><td colspan=8 class=td1>����ʧ�ܡ�</td></tr>"
	else

		response.write "<tr><td colspan=8 class=td1>�����û����ݳɹ���</td></tr>"
	end if
End Sub

Sub UserPermission()
	Response.Write "<tr><th colspan=8 style=""text-align:center;"">�༭" & Request("Username") & "��̳Ȩ�ޣ���ɫ��ʾ���û��ڸð������Զ���Ȩ�ޣ�</th></tr>"
	If Not Isnumeric(Request("Userid")) Then
		Response.Write "<tr><td colspan=8 class=td1>������û�������</td></tr>"
		Founderr = True
	End If
	If Not Founderr Then
		Response.Write "<tr><td colspan=8 class=td1 height=25>�����������ø��û��ڲ�ͬ��̳�ڵ�Ȩ�ޣ���ɫ��ʾΪ���û���ʹ�õ����û��Զ�������<BR>�ڸ�Ȩ�޲��ܼ̳У�������������һ�������¼���̳�İ��棬��ôֻ�������õİ�����Ч��������������̳��Ч<BR>���������������Ч������������ҳ��<B>ѡ���Զ�������</B>��ѡ�����Զ������ú��������õ�Ȩ�޽�<B>����</B>���û������ú���̳Ȩ�����ã������û���Ĭ�ϻ���̳Ȩ�����ø��û��鲻�ܹ������ӣ������������˸��û��ɹ������ӣ���ô���û����������Ϳ��Թ�������</td></tr>"
		Set Trs = Dvbbs.Execute("SELECT Uc_UserId FROM Dv_UserAccess WHERE Uc_Boardid = 0 AND Uc_Userid = " & Request("Userid"))
		If Trs.Eof And Trs.Bof Then
		Response.Write "<tr><td colspan=8 class=td1 height=25><a href=?action=UserBoardPermission&boardid=0&userid=" & Request("Userid") & ">�༭���û���ȫ�ֵ�Ȩ��</a>��ǰ̨���š�ǰ̨�û���Ϣ�����Ӻ�Ȩ�޹����������̨Ȩ�޵ȣ�</td></tr>"
		Else
		Response.Write "<tr><td colspan=8 class=td1 height=25><a href=?action=UserBoardPermission&boardid=0&userid=" & Request("Userid") & "><font color=red>�༭���û���ȫ�ֵ�Ȩ��</font></a>��ǰ̨���š�ǰ̨�û���Ϣ�����Ӻ�Ȩ�޹����������̨Ȩ�޵ȣ�</td></tr>"
		End If
'----------------------boardinfo--------------------
		Response.Write "<tr><td colspan=8 class=td1><B>�����̳���ƽ���༭״̬</B><BR>"
		Rem �����������ѭ����ѯ 2004-5-6 Dvbbs.YangZheng
		Dim Bn,Sql,Rs,i
		Sql = "SELECT Depth, Child, Boardid, Parentid, Boardtype FROM Dv_Board ORDER BY Rootid, Orders"
		Set Rs = Dvbbs.Execute(Sql)
		If Not (Rs.Eof And Rs.Bof) Then
			Sql = Rs.GetRows(-1)
			Rs.Close:Set Rs = Nothing
			For Bn = 0 To Ubound(Sql,2)
				If Sql(0,Bn) > 0 Then
					For i = 1 To Sql(0,Bn)
						Response.Write "&nbsp;"
					Next
				End If
				If Sql(1,Bn) > 0 Then
					Response.Write "<img src=""../skins/default/plus.gif"">"
				Else
					Response.Write "<img src=""../skins/default/nofollow.gif"">"
				End If
%>
<a href="?action=UserBoardPermission&boardid=<%=Sql(2,Bn)%>&userid=<%=Request("Userid")%>">
<%
				Set Trs = Dvbbs.Execute("SELECT Uc_UserId FROM Dv_UserAccess WHERE Uc_Boardid = " & Sql(2,Bn) & " AND Uc_Userid = " & Request("Userid"))
				If Not (Trs.Eof And Trs.Bof) Then
					Response.Write "<font color=red>[�Զ���]"
				End If
				If Sql(3,Bn) = 0 Then Response.Write "<b>"
				Response.Write Sql(4,Bn)
				If Sql(3,Bn) = 0 Then Response.Write "</b>"
				If Sql(1,Bn) > 0 Then Response.Write "(" & Sql(1,Bn) & ")"
				Response.Write "</font></a><BR>"
			Next
		End If
		Response.Write "</td></tr>"
'-------------------end-------------------
	End If
End Sub

Sub UserBoardPermission()
	Dim rs
	if not isnumeric(request("userid")) then
		response.write "<tr><td colspan=8 class=td1>������û�������</td></tr>"
		founderr=true
	end if
	if not isnumeric(request("boardid")) then
		response.write "<tr><td colspan=8 class=td1>����İ��������</td></tr>"
		founderr=true
	end if
	if not founderr then
	set rs=Dvbbs.Execute("select u.UserGroupID,ug.title,u.username from [dv_user] u inner join dv_UserGroups UG on u.userGroupID=ug.userGroupID where u.userid="&request("userid"))
	Dvbbs.UserGroupID=rs(0)
	usertitle=rs(1)
	Dvbbs.membername=rs(2)
	dim boardtype
	set rs=Dvbbs.Execute("select boardtype from dv_board where boardid="&request("boardid"))
	if rs.eof and rs.bof then
	boardtype="��̳����ҳ��"
	else
	boardtype=rs(0)
	end if
	response.write "<tr><th colspan=8 style=""text-align:center;"">�༭ "&Dvbbs.membername&" �� "&boardtype&" Ȩ��</th></tr>"
	response.write "<tr><td colspan=8 height=25 class=td1>ע�⣺���û����� <B>"&usertitle&"</B> �û����У�����������������Զ���Ȩ�ޣ�����û�Ȩ�޽����Զ���Ȩ��Ϊ��</td></tr>"
%>
<tr><td colspan=8 class=td1>
<%
Dim reGroupSetting
Dim FoundGroup,FoundUserPermission,FoundGroupPermission
FoundGroup=false
FoundUserPermission=false
FoundGroupPermission=false

set rs=Dvbbs.Execute("select * from dv_UserAccess where uc_boardid="&request("boardid")&" and uc_userid="&request("userid"))
if not (rs.eof and rs.bof) then
	reGroupSetting=rs("uc_Setting")
	FoundGroup=true
	FoundUserPermission=true
end if

if not foundgroup then
set rs=Dvbbs.Execute("select * from dv_BoardPermission where boardid="&request("boardid")&" and groupid="&DVbbs.UserGroupID)
if not(rs.eof and rs.bof) then
	reGroupSetting=rs("PSetting")
	FoundGroup=true
	FoundGroupPermission=true
end if
end if

if not foundgroup then
set rs=Dvbbs.Execute("select * from dv_usergroups where usergroupid="&DVbbs.UserGroupID)
if rs.eof and rs.bof then
	response.write "δ�ҵ����û��飡"
	response.end
else
	FoundGroup=true
	FoundGroupPermission=true
	reGroupSetting=rs("GroupSetting")
end if
end if
%>
<table width="100%" border="0" cellspacing="1" cellpadding="0" align=center>
<FORM METHOD=POST ACTION="?action=saveuserpermission">
<input type=hidden name="userid" value="<%=request("userid")%>">
<input type=hidden name="BoardID" value="<%=request("boardid")%>">
<input type=hidden name="username" value="<%=Dvbbs.membername%>">
<%If Dvbbs.BoardID <> 0 Then%>
<tr> 
<td width="100%" class=td1 colspan=2 height=25>
<font color=blue>����Ŀ��</font>��<input type=radio class=radio name="savetype" value=0 checked>�ð���&nbsp;<input type=radio class=radio name="savetype" value=1>���а���&nbsp;<input type=radio class=radio name="savetype" value=2>��ͬ���������а��棨���������ࣩ&nbsp;<input type=radio class=radio name="savetype" value=3>��ͬ���������а��棨�������ࣩ&nbsp;<input type=radio class=radio name="savetype" value=4>ͬ����ͬ�������
</td>
</tr>
<tr> 
<td width="100%" class=td1 colspan=2 height=25>
<font color=blue>
����ָ�ķ����ָһ�����࣬�����Ǹð�����ϼ�����</font>��������Ŀǰ���õ���һ���弶���棬ѡ������ͬ���������а��涼���£���ô���ｫ���°����÷����һ�����������������ļ����а��棬��������ĸ��·�Χ̫�󣬿���ѡ�����ͬ����ͬ������档
</td>
</tr>
<%Else%>
<input type=hidden name="savetype" value=0>
<%End If%>
<tr> 
<td height="23" colspan="2" class=td1><input type=radio class=radio name="isdefault" value="1" <%if FoundGroupPermission then%>checked<%end if%>><B>ʹ���û���Ĭ��ֵ</B> (ע��: �⽫ɾ���κ�֮ǰ�������Զ�������)</td>
</tr>
<tr> 
<td height="23" colspan="2"  class=td1><input type=radio class=radio name="isdefault" value="0" <%if FoundUserPermission then%>checked<%end if%>><B>ʹ���Զ�������</B> &nbsp;(<font color=blue>ѡ���Զ������ʹ����������Ч</font>)</td>
</tr>
<%
GroupPermission(reGroupSetting)
%>
<input type=hidden value="yes" name="groupaction">
</FORM>
</table>
</td></tr>
<%
	end if
End Sub

Sub SaveUserPermission()
	Dim i
	response.write "<tr><th colspan=8 style=""text-align:center;"">�༭�û� "&request("username")&" Ȩ��</th></tr>"
	if not isnumeric(request("userid")) then
		response.write "<tr><td colspan=8 class=td1>������û�������</td></tr>"
		founderr=true
	end if
	if not isnumeric(request("boardid")) then
		response.write "<tr><td colspan=8 class=td1>����İ��������</td></tr>"
		founderr=true
	end if
	if not founderr then
	dim myGroupSetting,rs
	Dim IsGroupSetting,MyIsGroupSetting,FoundSetting
	myGroupSetting=GetGroupPermission
	select case request("savetype")
	'��ǰ����
	case "0"
		if request("isdefault")=1 then
			Dvbbs.Execute("delete from dv_UserAccess where uc_boardid="&request("boardid")&" and uc_userid="&request("userid"))
			Set Rs=Dvbbs.Execute("Select Count(*) from dv_UserAccess where uc_boardid="&request("boardid")&" and uc_userid="&request("userid"))
			FoundSetting=Rs(0)
			If IsNull(FoundSetting) Or FoundSetting="" Then FoundSetting=0
			If Dvbbs.BoardID > 0 Then
			Set Rs=Dvbbs.Execute("select IsGroupSetting From Dv_Board Where BoardID="&request("boardid"))
			If Trim(Rs(0))="" Or IsNull(Rs(0)) Then
				MyIsGroupSetting = ""
			Else
				IsGroupSetting = "," & Rs(0) & ","
				If FoundSetting=0 Then IsGroupSetting = Replace(IsGroupSetting,",0_"&request("userid"),"")
				IsGroupSetting=replace(IsGroupSetting,",,",",")
				IsGroupSetting = Split(IsGroupSetting,",")
				For i=1 To Ubound(IsGroupSetting)-1
					If i=1 Then
						MyIsGroupSetting = IsGroupSetting(i)
					Else
						MyIsGroupSetting = MyIsGroupSetting & "," & IsGroupSetting(i)
					End If
				Next
			End If
			Dvbbs.Execute("update dv_Board set IsGroupSetting='"&MyIsGroupSetting&"' Where BoardID="&request("boardid"))
			End If
		else
			set rs=Dvbbs.Execute("select * from dv_UserAccess where uc_boardid="&request("boardid")&" and uc_userid="&request("userid"))
			if rs.eof and rs.bof then
				Dvbbs.Execute("insert into dv_UserAccess (uc_userid,uc_boardid,uc_setting) values ("&request("userid")&","&request("boardid")&",'"&myGroupSetting&"')")
			else
				Dvbbs.Execute("update dv_UserAccess set uc_setting='"&myGroupSetting&"' where uc_boardid="&request("boardid")&" and uc_userid="&request("userid"))
			end if
			If Dvbbs.BoardID > 0 Then
			Set Rs=Dvbbs.Execute("select IsGroupSetting From Dv_Board Where BoardID="&request("boardid"))
			If Trim(Rs(0))="" Or IsNull(Rs(0)) Then
				MyIsGroupSetting = 0
			Else
				IsGroupSetting = "," & Rs(0) & ","
				IsGroupSetting = Replace(IsGroupSetting,",0_"&request("userid"),"")
				IsGroupSetting=replace(IsGroupSetting,",,",",")
				IsGroupSetting = IsGroupSetting & "0_"&request("userid")&","
				IsGroupSetting = Split(IsGroupSetting,",")
				For i=1 To Ubound(IsGroupSetting)-1
					If i=1 Then
						MyIsGroupSetting = IsGroupSetting(i)
					Else
						MyIsGroupSetting = MyIsGroupSetting & "," & IsGroupSetting(i)
					End If
				Next
			End If
			Dvbbs.Execute("update dv_Board set IsGroupSetting='"&MyIsGroupSetting&"' Where BoardID="&request("boardid"))
			Set Rs=Nothing
			End If
		end if
		If Dvbbs.BoardID > 0 Then Dvbbs.ReloadBoardCache request("boardid")
	'���а���
	case "1"
		set trs=Dvbbs.Execute("select * from dv_board")
		do while not trs.eof
		if request("isdefault")=1 then
			Dvbbs.Execute("delete from dv_UserAccess where uc_boardid="&trs("boardid")&" and uc_userid="&request("userid"))
			Set Rs=Dvbbs.Execute("Select Count(*) from dv_UserAccess where uc_boardid="&trs("boardid")&" and uc_userid="&request("userid"))
			FoundSetting=Rs(0)
			If IsNull(FoundSetting) Or FoundSetting="" Then FoundSetting=0
			Set Rs=Dvbbs.Execute("select IsGroupSetting From Dv_Board Where BoardID="&trs("boardid"))
			If Trim(Rs(0))="" Or IsNull(Rs(0)) Then
				MyIsGroupSetting = ""
			Else
				IsGroupSetting = "," & Rs(0) & ","
				If FoundSetting=0 Then IsGroupSetting = Replace(IsGroupSetting,",0_"&request("userid"),"")
				IsGroupSetting=replace(IsGroupSetting,",,",",")
				IsGroupSetting = Split(IsGroupSetting,",")
				For i=1 To Ubound(IsGroupSetting)-1
					If i=1 Then
						MyIsGroupSetting = IsGroupSetting(i)
					Else
						MyIsGroupSetting = MyIsGroupSetting & "," & IsGroupSetting(i)
					End If
				Next
			End If
			FoundSetting=""
			Dvbbs.Execute("update dv_Board set IsGroupSetting='"&MyIsGroupSetting&"' Where BoardID="&trs("boardid"))
		Else
			set rs=Dvbbs.Execute("select * from dv_UserAccess where uc_boardid="&trs("boardid")&" and uc_userid="&request("userid"))
			if rs.eof and rs.bof then
				Dvbbs.Execute("insert into dv_UserAccess (uc_userid,uc_boardid,uc_setting) values ("&request("userid")&","&trs("boardid")&",'"&myGroupSetting&"')")
			else
				Dvbbs.Execute("update dv_UserAccess set uc_setting='"&myGroupSetting&"' where uc_boardid="&trs("boardid")&" and uc_userid="&request("userid"))
			end if
			Set Rs=Dvbbs.Execute("select IsGroupSetting From Dv_Board Where BoardID="&trs("boardid"))
			If Trim(Rs(0))="" Or IsNull(Rs(0)) Then
				MyIsGroupSetting = 0
			Else
				IsGroupSetting = "," & Rs(0) & ","
				IsGroupSetting = Replace(IsGroupSetting,",0_"&request("userid"),"")
				IsGroupSetting=replace(IsGroupSetting,",,",",")
				IsGroupSetting = IsGroupSetting & "0_"&request("userid")&","
				IsGroupSetting = Split(IsGroupSetting,",")
				For i=1 To Ubound(IsGroupSetting)-1
					If i=1 Then
						MyIsGroupSetting = IsGroupSetting(i)
					Else
						MyIsGroupSetting = MyIsGroupSetting & "," & IsGroupSetting(i)
					End If
				Next
			End If
			Dvbbs.Execute("update dv_Board set IsGroupSetting='"&MyIsGroupSetting&"' Where BoardID="&trs("boardid"))
		end if
		Dvbbs.ReloadBoardCache trs("boardid")
		trs.movenext
		loop
		trs.close
		set trs=nothing
		Set Rs=Nothing
	'��ͬ���������а��棨���������ࣩ
	case "2"
		set trs=Dvbbs.Execute("select rootid from dv_board where boardid="&request("boardid"))
		myrootid=trs(0)
		set trs=Dvbbs.Execute("select * from dv_board where (Not ParentID=0) and rootid="&myrootid)
		do while not trs.eof
		if request("isdefault")=1 then
			Dvbbs.Execute("delete from dv_UserAccess where uc_boardid="&trs("boardid")&" and uc_userid="&request("userid"))
			Set Rs=Dvbbs.Execute("Select Count(*) from dv_UserAccess where uc_boardid="&trs("boardid")&" and uc_userid="&request("userid"))
			FoundSetting=Rs(0)
			If IsNull(FoundSetting) Or FoundSetting="" Then FoundSetting=0
			Set Rs=Dvbbs.Execute("select IsGroupSetting From Dv_Board Where BoardID="&trs("boardid"))
			If Trim(Rs(0))="" Or IsNull(Rs(0)) Then
				MyIsGroupSetting = ""
			Else
				IsGroupSetting = "," & Rs(0) & ","
				If FoundSetting=0 Then IsGroupSetting = Replace(IsGroupSetting,",0_"&request("userid"),"")
				IsGroupSetting=replace(IsGroupSetting,",,",",")
				IsGroupSetting = Split(IsGroupSetting,",")
				For i=1 To Ubound(IsGroupSetting)-1
					If i=1 Then
						MyIsGroupSetting = IsGroupSetting(i)
					Else
						MyIsGroupSetting = MyIsGroupSetting & "," & IsGroupSetting(i)
					End If
				Next
			End If
			FoundSetting=""
			Dvbbs.Execute("update dv_Board set IsGroupSetting='"&MyIsGroupSetting&"' Where BoardID="&trs("boardid"))
		else
			set rs=Dvbbs.Execute("select * from dv_UserAccess where uc_boardid="&trs("boardid")&" and uc_userid="&request("userid"))
			if rs.eof and rs.bof then
				Dvbbs.Execute("insert into dv_UserAccess (uc_userid,uc_boardid,uc_setting) values ("&request("userid")&","&trs("boardid")&",'"&myGroupSetting&"')")
			else
				Dvbbs.Execute("update dv_UserAccess set uc_setting='"&myGroupSetting&"' where uc_boardid="&trs("boardid")&" and uc_userid="&request("userid"))
			end if
			Set Rs=Dvbbs.Execute("select IsGroupSetting From Dv_Board Where BoardID="&trs("boardid"))
			If Trim(Rs(0))="" Or IsNull(Rs(0)) Then
				MyIsGroupSetting = 0
			Else
				IsGroupSetting = "," & Rs(0) & ","
				IsGroupSetting = Replace(IsGroupSetting,",0_"&request("userid"),"")
					IsGroupSetting=replace(IsGroupSetting,",,",",")
				IsGroupSetting = IsGroupSetting & "0_"&request("userid")&","
				IsGroupSetting = Split(IsGroupSetting,",")
				For i=1 To Ubound(IsGroupSetting)-1
					If i=1 Then
						MyIsGroupSetting = IsGroupSetting(i)
					Else
						MyIsGroupSetting = MyIsGroupSetting & "," & IsGroupSetting(i)
					End If
				Next
			End If
			Dvbbs.Execute("update dv_Board set IsGroupSetting='"&MyIsGroupSetting&"' Where BoardID="&trs("boardid"))
		end if
		Dvbbs.ReloadBoardCache trs("boardid")
		trs.movenext
		loop
		trs.close
		set trs=nothing
		Set Rs=Nothing
	'��ͬ���������а��棨�������ࣩ
	case "3"
		set trs=Dvbbs.Execute("select rootid from dv_board where boardid="&request("boardid"))
		myrootid=trs(0)
		set trs=Dvbbs.Execute("select * from dv_board where rootid="&myrootid)
		do while not trs.eof
		if request("isdefault")=1 then
			Dvbbs.Execute("delete from dv_UserAccess where uc_boardid="&trs("boardid")&" and uc_userid="&request("userid"))
			Set Rs=Dvbbs.Execute("Select Count(*) from dv_UserAccess where uc_boardid="&trs("boardid")&" and uc_userid="&request("userid"))
			FoundSetting=Rs(0)
			If IsNull(FoundSetting) Or FoundSetting="" Then FoundSetting=0
			Set Rs=Dvbbs.Execute("select IsGroupSetting From Dv_Board Where BoardID="&trs("boardid"))
			If Trim(Rs(0))="" Or IsNull(Rs(0)) Then
				MyIsGroupSetting = ""
			Else
				IsGroupSetting = "," & Rs(0) & ","
				If FoundSetting=0 Then IsGroupSetting = Replace(IsGroupSetting,",0_"&request("userid"),"")
				IsGroupSetting=replace(IsGroupSetting,",,",",")
				IsGroupSetting = Split(IsGroupSetting,",")
				For i=1 To Ubound(IsGroupSetting)-1
					If i=1 Then
						MyIsGroupSetting = IsGroupSetting(i)
					Else
						MyIsGroupSetting = MyIsGroupSetting & "," & IsGroupSetting(i)
					End If
				Next
			End If
			FoundSetting=""
			Dvbbs.Execute("update dv_Board set IsGroupSetting='"&MyIsGroupSetting&"' Where BoardID="&trs("boardid"))
		else
			set rs=Dvbbs.Execute("select * from dv_UserAccess where uc_boardid="&trs("boardid")&" and uc_userid="&request("userid"))
			if rs.eof and rs.bof then
				Dvbbs.Execute("insert into dv_UserAccess (uc_userid,uc_boardid,uc_setting) values ("&request("userid")&","&trs("boardid")&",'"&myGroupSetting&"')")
			else
				Dvbbs.Execute("update dv_UserAccess set uc_setting='"&myGroupSetting&"' where uc_boardid="&trs("boardid")&" and uc_userid="&request("userid"))
			end if
			Set Rs=Dvbbs.Execute("select IsGroupSetting From Dv_Board Where BoardID="&trs("boardid"))
			If Trim(Rs(0))="" Or IsNull(Rs(0)) Then
				MyIsGroupSetting = 0
			Else
				IsGroupSetting = "," & Rs(0) & ","
				IsGroupSetting = Replace(IsGroupSetting,",0_"&request("userid"),"")
				IsGroupSetting=replace(IsGroupSetting,",,",",")
				IsGroupSetting = IsGroupSetting & "0_"&request("userid")&","
				IsGroupSetting = Split(IsGroupSetting,",")
				For i=1 To Ubound(IsGroupSetting)-1
					If i=1 Then
						MyIsGroupSetting = IsGroupSetting(i)
					Else
						MyIsGroupSetting = MyIsGroupSetting & "," & IsGroupSetting(i)
					End If
				Next
			End If
			Dvbbs.Execute("update dv_Board set IsGroupSetting='"&MyIsGroupSetting&"' Where BoardID="&trs("boardid"))
		end if
		Dvbbs.ReloadBoardCache trs("boardid")
		trs.movenext
		loop
		trs.close
		set trs=nothing
		Set Rs=Nothing
	'ͬ����ͬ�������
	case "4"
		dim myparentid,myparentstr
		set trs=Dvbbs.Execute("select rootid,ParentStr,ParentID from dv_board where boardid="&request("boardid"))
		myrootid=trs(0)
		myparentstr=trs(1)
		myparentid=trs(2)
		set trs=Dvbbs.Execute("select * from dv_board where rootid="&myrootid&" and ParentID="&myparentid&" and ParentStr='"&myparentstr&"'")
		do while not trs.eof
		if request("isdefault")=1 then
			Dvbbs.Execute("delete from dv_UserAccess where uc_boardid="&trs("boardid")&" and uc_userid="&request("userid"))
			Set Rs=Dvbbs.Execute("Select Count(*) from dv_UserAccess where uc_boardid="&trs("boardid")&" and uc_userid="&request("userid"))
			FoundSetting=Rs(0)
			If IsNull(FoundSetting) Or FoundSetting="" Then FoundSetting=0
			Set Rs=Dvbbs.Execute("select IsGroupSetting From Dv_Board Where BoardID="&trs("boardid"))
			If Trim(Rs(0))="" Or IsNull(Rs(0)) Then
				MyIsGroupSetting = ""
			Else
				IsGroupSetting = "," & Rs(0) & ","
				If FoundSetting=0 Then IsGroupSetting = Replace(IsGroupSetting,",0_"&request("userid"),"")
				IsGroupSetting=replace(IsGroupSetting,",,",",")
				IsGroupSetting = Split(IsGroupSetting,",")
				For i=1 To Ubound(IsGroupSetting)-1
					If i=1 Then
						MyIsGroupSetting = IsGroupSetting(i)
					Else
						MyIsGroupSetting = MyIsGroupSetting & "," & IsGroupSetting(i)
					End If
				Next
			End If
			FoundSetting=""
			Dvbbs.Execute("update dv_Board set IsGroupSetting='"&MyIsGroupSetting&"' Where BoardID="&trs("boardid"))
		else
			set rs=Dvbbs.Execute("select * from dv_UserAccess where uc_boardid="&trs("boardid")&" and uc_userid="&request("userid"))
			if rs.eof and rs.bof then
				Dvbbs.Execute("insert into dv_UserAccess (uc_userid,uc_boardid,uc_setting) values ("&request("userid")&","&trs("boardid")&",'"&myGroupSetting&"')")
			else
				Dvbbs.Execute("update dv_UserAccess set uc_setting='"&myGroupSetting&"' where uc_boardid="&trs("boardid")&" and uc_userid="&request("userid"))
			end if
			Set Rs=Dvbbs.Execute("select IsGroupSetting From Dv_Board Where BoardID="&trs("boardid"))
			If Trim(Rs(0))="" Or IsNull(Rs(0)) Then
				MyIsGroupSetting = 0
			Else
				IsGroupSetting = "," & Rs(0) & ","
				IsGroupSetting = Replace(IsGroupSetting,",0_"&request("userid"),"")
				IsGroupSetting=replace(IsGroupSetting,",,",",")
				IsGroupSetting = IsGroupSetting & "0_"&request("userid")&","
				IsGroupSetting = Split(IsGroupSetting,",")
				For i=1 To Ubound(IsGroupSetting)-1
					If i=1 Then
						MyIsGroupSetting = IsGroupSetting(i)
					Else
						MyIsGroupSetting = MyIsGroupSetting & "," & IsGroupSetting(i)
					End If
				Next
			End If
			Dvbbs.Execute("update dv_Board set IsGroupSetting='"&MyIsGroupSetting&"' Where BoardID="&trs("boardid"))
		end if
		Dvbbs.ReloadBoardCache trs("boardid")
		trs.movenext
		loop
		trs.close
		set trs=nothing
		Set Rs=Nothing
	end select
	if founderr then
		response.write "<tr><td colspan=8 class=td1>����ʧ�ܡ�</td></tr>"
	else
		response.write "<tr><td colspan=8 class=td1><li>�����û�Ȩ�޳ɹ���"
		If Request.Form("GroupSetting(70)") = "1" Then Response.Write "<li>�������˸��û��ɽ�����̳��̨��Ȩ�ޣ��뵽����Ա������ <a href=""admin.asp?action=add"">����</a> ���û��ĺ�̨�˺ź����ø��ʻ���̨Ȩ�ޡ�"
		Response.Write "</td></tr>"
	end if
	End if
End Sub

Sub UniteUser()
	if request("auser")<>"" and request("buser")<>"" then
		dim auserid,buserid,rs,i
		dim c1,c2,c3,c4,c5,c6,c7,c8,c9
		set rs=dvbbs.execute("select userid,userpost,usertopic,userviews,userwealth,userep,usercp,userpower,userisbest,userdel,usergroupid from dv_user where username='"&replace(request("auser"),"'","''")&"'")
		if rs.eof and rs.bof then
			errmsg = errmsg + "<tr><td colspan=8 class=td1>û���ҵ����ϲ��û�</td></tr>"
			founderr=true
		else
			auserid=rs(0)
			c1=rs(1)
			c2=rs(2)
			c3=rs(3)
			c4=rs(4)
			c5=rs(5)
			c6=rs(6)
			c7=rs(7)
			c8=rs(8)
			c9=rs(9)
			if rs(10) < 4 then
				errmsg = errmsg + "<tr><td colspan=8 class=td1>ֻ������ע���û�����кϲ��û�����</td></tr>"
				founderr=true
			end if
		end if
		set rs=dvbbs.execute("select userid from dv_user where username='"&replace(request("buser"),"'","''")&"'")
		if rs.eof and rs.bof then
			errmsg = errmsg + "<tr><td colspan=8 class=td1>û���ҵ��ϲ���Ŀ���û�</td></tr>"
			founderr=true
		else
			buserid=rs(0)
		end if
		if auserid=buserid then
			errmsg = errmsg + "<tr><td colspan=8 class=td1>��ͬ�û����ܽ��кϲ�</td></tr>"
			founderr=true
		end if
		if founderr then
			Response.Write errmsg
		else
			'�ϲ��û�������
			dvbbs.execute("update dv_user set userpost=userpost+"&c1&",usertopic=usertopic+"&c2&",userviews=userviews+"&c3&",userwealth=userwealth+"&c4&",userep=userep+"&c5&",usercp=usercp+"&c6&",userpower=userpower+"&c7&",userisbest=userisbest+"&c8&",userdel=userdel+"&c9&" where userid="&buserid)
			'������������
			for i=0 to ubound(allposttable)
				dvbbs.execute("update "&allposttable(i)&" set postuserid="&buserid&",username='"&replace(request("buser"),"'","''")&"' where postuserid="&auserid)
			next
			dvbbs.execute("update dv_topic set postuserid="&buserid&",postusername='"&replace(request("buser"),"'","''")&"' where postuserid="&auserid)
			'���¶�������
			Dvbbs.Execute("update dv_message set incept='"&replace(request("buser"),"'","''")&"' where incept='"&replace(request("auser"),"'","''")&"'")
			Dvbbs.Execute("update dv_message set sender='"&replace(request("buser"),"'","''")&"' where sender='"&replace(request("auser"),"'","''")&"'")
			Dvbbs.Execute("update dv_friend set F_username='"&replace(request("buser"),"'","''")&"' where F_username='"&replace(request("auser"),"'","''")&"'") 
			Dvbbs.Execute("update dv_bookmark set username='"&replace(request("buser"),"'","''")&"' where username='"&replace(request("auser"),"'","''")&"'") 

			Dvbbs.Execute("update dv_besttopic set PostUserID="&buserid&",postusername='"&replace(request("buser"),"'","''")&"' where PostUserID="&auserid)
			'�����û��ϴ���
			Dvbbs.Execute("update dv_upfile set F_UserID="&buserid&",F_Username='"&replace(request("buser"),"'","''")&"' where F_UserID="&auserid)
			response.write "<tr><td colspan=8 class=td1>�ϲ��û����ݳɹ���</td></tr>"
		end if
	else
%>
<form action="?action=uniteuser" method=post>
<tr>
<th colspan=7 style="text-align:center;">�ϲ��û�</th>
</tr>
<tr>
<td width=20% class=td1>ע������</td>
<td width=80% class=td1 colspan=5>���ϲ��û�����̳�е��������ӣ����������������š��ϴ����ղص����Ͻ��ϲ�����ָ�����û���</td>
</tr>
<tr>
<td width=20% class=td1>ѡ��</td>
<td width=80% class=td1 colspan=5>���û� <input size=25 name="auser" type=text> ���Ϻϲ��� <input size=25 name="buser" type=text> �û� <input type=submit class=button name=submit value="�ύ"></td>
</tr>
</form>
<%
	end if
End Sub

Sub Fixuser()
	Dim Userid,i
	Userid = Request("Userid")
	If Not IsNumeric(Userid) Then
	Errmsg = ErrMsg + "<BR><li>��������!"
		Dvbbs_Error()
		Exit Sub
	End If
	Userid = CLng(Userid)
	Dim Rs, Username, UserArticle, UserIsBest
	UserArticle = 0
	Set Rs = Dvbbs.Execute("SELECT Username FROM [Dv_User] WHERE Userid = " & Userid & "")
	If Rs.Eof Or Rs.Bof Then
		Errmsg = ErrMsg + "<BR><li>�Ҳ������û�����ɾ�û���Ҫ������ԭ��������ע��ſ����޸�����!"
		Dvbbs_Error()
		Exit Sub
	Else
		Username = Rs(0)
		Rs.Close:Set Rs = Nothing
		'�޸������
		Dvbbs.Execute ("Update Dv_Topic Set PostUserID = " & Userid & " WHERE PostUserName = '" & Username & "'")
		'�޸��������ݱ�
		For i = 0 To Ubound(AllPostTable)
			Dvbbs.Execute ("Update " & AllPostTable(i) & " Set Postuserid = " & Userid & " WHERE UserName = '" & Username & "'")
			'�����û�����
			Set Rs = Dvbbs.Execute("SELECT COUNT(*) FROM " & AllPostTable(i) & " WHERE Postuserid = " & Userid & "")
			UserArticle = UserArticle + Rs(0)
			Rs.Close:Set Rs = Nothing
		Next
		'�޸�����
		Dvbbs.Execute ("UPDATE Dv_BestTopic Set PostUserID = " & Userid & " WHERE PostUserName = '" & Username & "'")
		Set Rs = Dvbbs.Execute("SELECT COUNT(*) FROM Dv_BestTopic WHERE Postuserid = " & Userid &"")
		UserIsBest = Rs(0)
		Rs.Close:Set Rs = Nothing
		'�޸��ϴ��ļ��б�
		Dvbbs.Execute ("UPDATE DV_Upfile SET F_UserID = " & Userid & " WHERE F_Username = '" & Username & "'")
		'���·�����
		Dvbbs.Execute ("UPDATE [Dv_User] SET UserPost = " & UserArticle & ", UserIsBest = " & UserIsBest & " WHERE Userid = " & Userid & "")
	End If
	Set Rs = Nothing
	Dv_Suc("�û�<b>" & Username & "</b>�����޸��ɹ���")
End Sub

Function CheckReal(v)
	Dim w
	If Not IsNull(v) Then
		w=Replace(v,"|||","����")
		CheckReal=w
	End If
End Function

Function CheckNumeric(Byval CHECK_ID)
	If CHECK_ID<>"" and IsNumeric(CHECK_ID) Then _
		CHECK_ID = Int(CHECK_ID) _
	Else _
		CHECK_ID = 0
	CheckNumeric = CHECK_ID
End Function
Sub Select_Audit_Group(SelGroupID)
Dim Rs,Sql,i
SelGroupID = ","&SelGroupID&","
Sql = "Select UserGroupID,Title,UserTitle,ParentGid,IsSetting From Dv_UserGroups where ParentGid>0  Order by ParentGid,UserGroupID"
Set Rs = Dvbbs.Execute(SQL)
If Not Rs.eof Then
	SQL=Rs.GetRows(-1)
	Rs.close:Set Rs = Nothing
Else
	Exit Sub
End If
%>
<div id="Select_Group" style="POSITION:absolute;Z-INDEX: 99;display:none;width:400px">
<select name="SelGroupid" id="SelGroupid" size="28" style="width:100%" multiple>
<%
For i=0 To Ubound(SQL,2)
%>
<option value="<%=SQL(0,i)%>" <%If Instr(SelGroupID,","&SQL(0,i)&",") Then Response.Write "Selected"%>> <%=SysGroupname(SQL(3,i))%> -- <%=SQL(1,i)%>--<%=SQL(2,i)%></option>
<%
Next
%>
</select>
<input type="button" value="ȷ��" class="button" onclick="getGroup('Select_Group')"> �밴 CTRL ����ѡ!
</div>
<%
End Sub
%>