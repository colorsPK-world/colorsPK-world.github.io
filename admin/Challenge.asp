<!--#include file =../conn.asp-->
<!--#include file="inc/const.asp"-->
<%	
Head()
Dim admin_flag,rs_c
admin_flag=",1,"
CheckAdmin(admin_flag)
Select Case LCase(Request("action"))
	Case "save1"
		Save1()
	Case "save2"
		Save2()
	Case "save3"
		Save3()
	Case "save4"
		Save4()
	Case Else
		consted()
End Select
If Errmsg <> "" Then Dvbbs_Error()
Footer()

Sub consted()
Dim  sel
%>
<form method="POST" action="Challenge.asp?action=Save1">
<input type="hidden" value="b63uvb8nsvsmbsaxszgvdr6svyus0l4t" name="Forum_ChanSetting(6)"/>
<table width="100%" border="0" cellspacing="1" cellpadding="3" align="center"> 
<th style="text-align:center;" colspan=2 id=tabletitlelink><a name="setting20"></a><b>RSS/WAP/�ֻ�����/����֧��</b>
</tr>

<!--����֧�����ֿ�ʼ-->
<tr>
<td width="50%" class=td1> <U>�Ƿ����������г�ֵ��ȯ</U><br>��ͨ���ͨ������֧���ֶ�����ֵ��̳��ȯ</td>
<td width="50%" class=td1>
<input type=radio class="radio" name="Forum_ChanSetting(3)" value=1 <%if cint(Dvbbs.Forum_ChanSetting(3))=1 then%>checked<%end if%>>��&nbsp;
<input type=radio class="radio" name="Forum_ChanSetting(3)" value=0 <%if cint(Dvbbs.Forum_ChanSetting(3))=0 then%>checked<%end if%>>��&nbsp;
</td>
</tr>
<tr>
<td width="50%" class=td1> <U>֧�����˺�</U><br>�뵽<a href="https://www.alipay.com/" target=_blank><font color=red>֧������վ</font></a>����һ��֧�����˺ţ�Ȼ����д��������</td>
<td width="50%" class=td1>  
<input type=text size=35 value="<%=Dvbbs.Forum_ChanSetting(4)%>" name="Forum_ChanSetting(4)">
&nbsp;&nbsp;&nbsp;<input type="submit" class="button" name="Submit" value="�ύ�޸�">
</td>
</tr>
<tr>
<td width="100%" class=td2 colspan=2 height=25><B>˵��</B>��<BR>
1����������֧�������ɡ�����Ͱ�֧�������ṩ����ͨ�˹����赽<a href="https://www.alipay.com/" target=_blank><font color=red>֧������վ</font></a>����һ��֧�����˺Ų�������������������ȷ���˺Ž���Ӱ�쵽������վ����<BR>
2��<font color=red><B>ͨ�������ܽ�����ȡ1%�������ã�֧�������װ�ȫ����ݣ��û�֧���Ŀ��ֱ��ת����ָ����֧�����ʺţ�</B></font><BR>
</td>
</tr>
</form>
<form method="POST" action="Challenge.asp?action=Save2">
<!--�ֻ����ֿ�ʼ-->
<!--
<tr> 
<td width="50%" class=td1> <U>�Ƿ�����̳�ֻ���ع���</U><BR>�ֻ���ع����ܿ���</td>
<td width="50%" class=td1>  
<input type=radio class="radio" name="Forum_ChanSetting(0)" value=0 <%if cint(Dvbbs.Forum_ChanSetting(0))=0 then%>checked<%end if%>>��&nbsp;
<input type=radio class="radio" name="Forum_ChanSetting(0)" value=1 <%if cint(Dvbbs.Forum_ChanSetting(0))=1 then%>checked<%end if%>>��&nbsp;
</td>
</tr>
<td width="50%" class=td1> <U>�Ƿ�����̳WAP</U><br>������ͨ���ֻ��������̳�ͽ��з����Ȳ���</td>
<td width="50%" class=td1>  
<input type=radio class="radio" name="Forum_ChanSetting(1)" value=0 <%if cint(Dvbbs.Forum_ChanSetting(1))=0 then%>checked<%end if%>>��&nbsp;
<input type=radio class="radio" name="Forum_ChanSetting(1)" value=1 <%if cint(Dvbbs.Forum_ChanSetting(1))=1 then%>checked<%end if%>>��&nbsp;
</td>
</tr>
<tr>
<td width="50%" class=td1> <U>�Ƿ����ֻ����ų�ֵ��ȯ</U><br>�������ͨ���ֻ����Ž�����̳��ȯ��ֵ��</td>
<td width="50%" class=td1>  
<input type=radio class="radio" name="Forum_ChanSetting(13)" value=0 <%if cint(Dvbbs.Forum_ChanSetting(13))=0 then%>checked<%end if%>>��&nbsp;
<input type=radio class="radio" name="Forum_ChanSetting(13)" value=1 <%if cint(Dvbbs.Forum_ChanSetting(13))=1 then%>checked<%end if%>>��&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" class="button" name="Submit" value="�� ��">
</td>
</tr>
<tr>
<td width="100%" class=td2 colspan=2 height=25><B>˵��</B>��<BR>��ص��ֻ����߲�Ʒ�����ɱ���������ſƼ����޹�˾�ṩ����ͨ�˹�����Ĭ�Ͻ�����صķ�������<BR><BR>
<%
dim trs,rs
set trs=Dvbbs.Execute("select * from Dv_ChallengeInfo")
set rs=Dvbbs.Execute("select * from dv_setup")
%>
<%if Dvbbs.Forum_ChanSetting(0)="1" and rs("Forum_isinstall")=1 then%>
���Ѿ���װ����̳���ֻ����߲�Ʒ���񣬾��������뿴���˵��<BR>
����ǰע����ֻ����߲�Ʒ�����ǣ��û�����<%=trs("d_username")%>����վ����<%=trs("d_forumname")%>����̳��ַ��<%if trs("d_forumurl")="" then%><%=Dvbbs.Get_ScriptNameUrl()%><%else%><%=trs("d_forumurl")%><%end if%>�������Щ���Ϻ�����ǰ��ʹ�õ���̳����������̳��ַ���û��������������ܵõ���صĶ������档<BR>
<a href="install.asp?isnew=1"><font color=blue>�����Ե���˴��������ϸ��»�������ע��վ������</font></a>
<%else%>
����û�а�װ��̳���ֻ����߲�Ʒ����ͨ���ֻ����߲�Ʒ�������������ܵ����ֲ�ͬ����վ���棬�����뿴����<a href=""><font color=red>�ֻ����߲�Ʒ�����˵��</font></a>��<a href="install.asp"><font color=blue>����˴�������̳�ֻ����߲�Ʒ����</font></a>
<%end if%>
<%
rs.close
set rs=nothing
trs.close
set trs=nothing
%>
</td>
</tr>
-->
<!--�ֻ����ֽ���-->
</form>
<form method="POST" action="Challenge.asp?action=Save3">
<tr>
<td width="50%" class=td1> <U>��ֵ�ĵ�ȯ�һ���</U><BR><!--�����ֻ����ź�����֧����ʽ--></td>
<td width="50%" class=td1>  
<input type=text size=5 value="<%=Dvbbs.Forum_ChanSetting(14)%>" name="Forum_ChanSetting(14)"> �ŵ�ȯ=1Ԫ�����<!--�����-->
</td>
</tr>
<tr> 
<td width="50%" class=td1> <U>�Ƿ���RSS���Ĺ���</U><BR>�������ͨ��һЩRSS�Ķ���������</td>
<td width="50%" class=td1>  
<input type=radio class="radio" name="Forum_ChanSetting(2)" value=1 <%if (Dvbbs.Forum_ChanSetting(2))="1" then%>checked<%end if%>>��&nbsp;
<input type=radio class="radio" name="Forum_ChanSetting(2)" value=0 <%if (Dvbbs.Forum_ChanSetting(2))="0" then%>checked<%end if%>>��&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" class="button" name="Submit" value="�� ��">
</td>
</tr>
</table>
</form>
<%
end sub

'��������֧�����
Sub Save1()
	'3�Ƿ���/4֧�����˺�/5��������ID/6Forum_AliPayKey
	Dim Forum_ChanSetting,iForum_ChanSetting,mForum_ChanSetting,rs,i,sql
	Set Rs=Dvbbs.Execute("Select Forum_ChanSetting From Dv_Setup")
	Forum_ChanSetting = Rs(0)
	Forum_ChanSetting = Split(Forum_ChanSetting,",")
	Rs.Close
	Set Rs=Nothing

	For i = 0 To Ubound(Forum_ChanSetting)
		If i = 0 Then
			iForum_ChanSetting = Forum_ChanSetting(i)
		Else
			Select Case i
			Case 3
				iForum_ChanSetting = iForum_ChanSetting & "," & Replace(Replace(Request.Form("Forum_ChanSetting(3)"),"'",""),",","")
			Case 4
				iForum_ChanSetting = iForum_ChanSetting & "," & Replace(Replace(Request.Form("Forum_ChanSetting(4)"),"'",""),",","")
			Case 5
				iForum_ChanSetting = iForum_ChanSetting & ",0"
			Case 6
				iForum_ChanSetting = iForum_ChanSetting & "," & Replace(Replace(Request.Form("Forum_ChanSetting(6)"),"'",""),",","")
			Case Else
				iForum_ChanSetting = iForum_ChanSetting & "," & Forum_ChanSetting(i)
			End Select
		End If
	Next
	Sql="Update Dv_Setup Set Forum_ChanSetting='"&iForum_ChanSetting&"'"
	Dvbbs.Execute(Sql)
	Dvbbs.loadSetup()
	Dv_suc("����֧�����óɹ���")
End Sub

'�������������������Ϣ
Sub Save4()
	'3�Ƿ���/4֧�����˺�/5��������ID/6Forum_AliPayKey
	If Request("UserID")="" Or Request("Email")="" Or Request("ForumKey")="" Then
		Errmsg=ErrMsg + "<BR><li>�Ƿ��ķ��ز�����"
		Exit Sub
	End If
	Dim Forum_ChanSetting,iForum_ChanSetting,mForum_ChanSetting
	Set Rs=Dvbbs.Execute("Select Forum_ChanSetting From Dv_Setup")
	Forum_ChanSetting = Rs(0)
	Forum_ChanSetting = Split(Forum_ChanSetting,",")
	mForum_ChanSetting = False
	For i = 0 To Ubound(Forum_ChanSetting)
		If i = 0 Then
			iForum_ChanSetting = Forum_ChanSetting(i)
		Else
			Select Case i
			Case 3
				iForum_ChanSetting = iForum_ChanSetting & ",0"
			Case 4
				iForum_ChanSetting = iForum_ChanSetting & "," & Replace(Replace(Request("Email"),"'",""),",","")
			Case 5
				iForum_ChanSetting = iForum_ChanSetting & "," & Replace(Replace(Request("UserID"),"'",""),",","")
			Case 6
				iForum_ChanSetting = iForum_ChanSetting & "," & Replace(Replace(Request("ForumKey"),"'",""),",","")
			Case Else
				iForum_ChanSetting = iForum_ChanSetting & "," & Forum_ChanSetting(i)
			End Select
		End If
	Next
	Sql="Update Dv_Setup Set Forum_ChanSetting='"&iForum_ChanSetting&"'"
	Dvbbs.Execute(Sql)
	Dvbbs.loadSetup()
	Rs.Close
	Set Rs=Nothing
	Dv_suc("������������֧���������óɹ���" & Request("msg"))
End Sub

'�����ֻ��������
Sub Save2()
	Dim Forum_ChanSetting,iForum_ChanSetting,mForum_ChanSetting,rs,i,sql
	Set Rs=Dvbbs.Execute("Select Forum_ChanSetting,Forum_challengePassWord From Dv_Setup")
	Forum_ChanSetting = Rs(0)
	Forum_ChanSetting = Split(Forum_ChanSetting,",")
	mForum_ChanSetting = False
	For i = 0 To Ubound(Forum_ChanSetting)
		If i = 0 Then
			iForum_ChanSetting = Request.Form("Forum_ChanSetting("&i&")")
			If (Cint(Replace(Request.Form("Forum_ChanSetting("&i&")"),",",""))=1 And Rs(1)="raynetwork") Or (Cint(Replace(Request.Form("Forum_ChanSetting("&i&")"),",",""))=1 And Cint(Forum_ChanSetting(i))=0) Then
				mForum_ChanSetting = True
			End If
		Else
			Select Case i
			Case 1
				iForum_ChanSetting = iForum_ChanSetting & "," & Replace(Request.Form("Forum_ChanSetting("&i&")"),",","")
			Case 13
				iForum_ChanSetting = iForum_ChanSetting & "," & Replace(Request.Form("Forum_ChanSetting("&i&")"),",","")
			Case Else
				iForum_ChanSetting = iForum_ChanSetting & "," & Forum_ChanSetting(i)
			End Select
		End If
	Next
	Sql="Update Dv_Setup Set Forum_ChanSetting='"&iForum_ChanSetting&"'"
	Dvbbs.Execute(Sql)
	Dvbbs.loadSetup()
	Rs.Close
	Set Rs=Nothing
	If mForum_ChanSetting Then Response.Redirect "install.asp?isnew=1"
	Dv_suc("�ֻ��������óɹ���")
End Sub

'��������
Sub Save3()
	Dim Forum_ChanSetting,iForum_ChanSetting,mForum_ChanSetting,rs,sql,i
	Set Rs=Dvbbs.Execute("Select Forum_ChanSetting,Forum_challengePassWord From Dv_Setup")
	Forum_ChanSetting = Rs(0)
	Forum_ChanSetting = Split(Forum_ChanSetting,",")
	mForum_ChanSetting = False
	For i = 0 To Ubound(Forum_ChanSetting)
		If i = 0 Then
			iForum_ChanSetting = Forum_ChanSetting(i)
		Else
			Select Case i
			Case 2
				iForum_ChanSetting = iForum_ChanSetting & "," & Replace(Request.Form("Forum_ChanSetting("&i&")"),",","")
			Case 14
				iForum_ChanSetting = iForum_ChanSetting & "," & Replace(Request.Form("Forum_ChanSetting("&i&")"),",","")
			Case Else
				iForum_ChanSetting = iForum_ChanSetting & "," & Forum_ChanSetting(i)
			End Select
		End If
	Next
	Sql="Update Dv_Setup Set Forum_ChanSetting='"&iForum_ChanSetting&"'"
	Dvbbs.Execute(Sql)
	Rs.Close
	Set Rs=Nothing
	Dv_suc("RSS���óɹ���")
	Dvbbs.loadSetup()
End Sub
%>