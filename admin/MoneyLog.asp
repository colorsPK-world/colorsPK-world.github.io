<!--#include file =../conn.asp-->
<!--#include file="inc/const.asp"-->
<!--#include file="../inc/dv_clsother.asp"-->
<%
Head()
Dim admin_flag
admin_flag=",42,"
CheckAdmin(admin_flag)
Main_head()
Select Case Request("action")
	Case "del"
		Del()
	Case "alldel"
		AllDel()
	Case Else
		Log_List()
End Select

If founderr then call dvbbs_error()
footer()

'��������
Sub Main_head()
'(0=����,1=ʹ��,2=ת��,3=��ֵ,4=����,5=����)
Dim stype
stype = Request("stype")
If stype="" Then stype=0
%>
<table width="100%" border="0" cellspacing="1" cellpadding="3" align="center">
<tr><th>����������־����</th></tr>
<tr><td class="forumRow" style="line-height : 18px ;">
<B>���</B>��<a href="MoneyLog.asp">������־</a> | <a href="MoneyLog.asp?stype=4"><%If stype=4 Then Response.Write "<font color=red>"%>������־<%If stype=4 Then Response.Write "</font>"%></a> | <a href="MoneyLog.asp?stype=2"><%If stype=2 Then Response.Write "<font color=red>"%>ת����־<%If stype=2 Then Response.Write "</font>"%></a> | <a href="MoneyLog.asp?stype=5"><%If stype=5 Then Response.Write "<font color=red>"%>������־<%If stype=5 Then Response.Write "</font>"%></a> | <a href="MoneyLog.asp?stype=6"><%If stype=6 Then Response.Write "<font color=red>"%>VIP������־<%If stype=6 Then Response.Write "</font>"%></a> | <a href="MoneyLog.asp?stype=1"><%If stype=1 Then Response.Write "<font color=red>"%>ʹ����־<%If stype=1 Then Response.Write "</font>"%></a> | <a href="MoneyLog.asp?stype=-1"><%If stype="-1" Then Response.Write "<font color=red>"%>��̨������־<%If stype="-1" Then Response.Write "</font>"%></a><BR>
</td>
</tr>
<FORM METHOD=POST ACTION="MoneyLog.asp">
<input type=hidden name=stype value="<%=stype%>">
<tr><td class="forumRow">�ؼ��֣�<INPUT TYPE="text" NAME="Keyword" value="<%=Request("Keyword")%>"> <INPUT TYPE="submit" class="button" value="��������"></td></tr>
</FORM>
</table><br>
<%
End Sub

Sub Log_List()
	Dim LogType,Stype,StypeStr,Keyword
	Dim Rs,Sql,i
	Dim Page,MaxRows,Endpage,CountNum,PageSearch,SqlString
	LogType = "����|ʹ��|ת��|��ֵ|����|����|VIP����"
	LogType = Split(LogType,"|")
	PageSearch = ""
	Endpage = 0
	MaxRows = 20
	Page = Request("Page")
	If IsNumeric(Page) = 0 or Page="" Then Page=1
	Page = Clng(Page)
	Stype = Request("Stype")
	If IsNumeric(Stype) = 0 or Stype="" Then Stype=0
	Stype = Clng(Stype)
	Response.Write "<script language=""JavaScript"" src=""../inc/Pagination.js""></script>"
	Keyword = Request("Keyword")
	If Keyword <> "" Then Keyword = Replace(Keyword,"'","''")
	PageSearch = "Keyword="&Keyword&"&Stype="&Stype
%>
<table width="100%" border="0" cellspacing="1" cellpadding="3" align="center">
<FORM METHOD=POST ACTION="?action=alldel">
<tr>
<th width="8%">����</th>
<th width="7%">����</th>
<th width="7%">���</th>
<th width="7%">��ȯ</th>
<th width="*">˵��</th>
<th width="10%">�û�</th>
<th width="10%">IP</th>
<th width="9%">ʱ��</th>
</tr>
<%
	Select Case Stype
	Case 0
		StypeStr = ""
	Case 1
		StypeStr = "Where Log_Type=1"
	Case 2
		StypeStr = "Where Log_Type=2"
	Case 3
		StypeStr = "Where Log_Type=3"
	Case 4
		StypeStr = "Where Log_Type=4"
	Case 5
		StypeStr = "Where Log_Type=5"
	Case 6
		StypeStr = "Where Log_Type=6"
	Case -1
		StypeStr = "Where BoardID=-1"
	Case Else
		StypeStr = ""
	End Select
	If StypeStr<>"" Then
		If Keyword<>"" Then StypeStr = StypeStr & " And (AddUserName Like '%"&keyword&"%' Or Conect Like '%"&keyword&"%')"
	Else
		If Keyword<>"" Then StypeStr = "Where (AddUserName Like '%"&keyword&"%' Or Conect Like '%"&keyword&"%')"
	End If
	'Log_ID=0 ,ToolsID=1 ,CountNum=2 ,Log_Money=3 ,Log_Ticket=4 ,AddUserName=5 ,AddUserID=6 ,Log_IP=7 ,Log_Time=8 ,Log_Type=9 ,BoardID=10 ,Conect=11 ,HMoney=12
	Sql = "Select Log_ID,ToolsID,CountNum,Log_Money,Log_Ticket,AddUserName,AddUserID,Log_IP,Log_Time,Log_Type,BoardID,Conect,HMoney From [Dv_MoneyLog] "&StypeStr&" ORDER BY Log_ID Desc"
	Set Rs = Dvbbs.iCreateObject ("adodb.recordset")
	'Response.Write sql
	If Cint(Dvbbs.Forum_Setting(92))=1 Then
		If Not IsObject(Plus_Conn) Then Plus_ConnectionDatabase
		Rs.Open Sql,Plus_Conn,1,1
	Else
		If Not IsObject(Conn) Then ConnectionDatabase
		Rs.Open Sql,conn,1,1
	End If

	If Not (Rs.Eof And Rs.Bof) Then
		CountNum = Rs.RecordCount
		If CountNum Mod MaxRows=0 Then
			Endpage = CountNum \ MaxRows
		Else
			Endpage = CountNum \ MaxRows+1
		End If
		Rs.MoveFirst
		If Page > Endpage Then Page = Endpage
		If Page < 1 Then Page = 1
		If Page >1 Then 				
			Rs.Move (Page-1) * MaxRows
		End if
		SQL=Rs.GetRows(MaxRows)
	Else
		Response.Write "<tr><td class=""forumRow"" colspan=""8"" align=center>��û����־��¼��</td></tr></table>"
		Exit Sub
	End If
	Rs.close:Set Rs = Nothing

	For i=0 To Ubound(SQL,2)
%>
<tr>
<td class="forumRow" align=center><input type=checkbox class="checkbox" name="logid" value="<%=SQL(0,i)%>"><%=LogType(SQL(9,i))%></td>
<td class="forumRow" align=center><%=SQL(2,i)%></td>
<td class="forumRow" align=center><%=SQL(3,i)%></td>
<td class="forumRow" align=center><%=SQL(4,i)%></td>
<td class="forumRow"><%=Replace(SQL(11,i),"dispbbs.asp?","../dispbbs.asp?skin=1&amp;")%></td>
<td class="forumRow" align=center><a href="../dispuser.asp?id=<%=SQL(6,i)%>" target="_blank" title="�鿴�û����ϣ�ʣ�ࣨ���|��ȯ����<%=SQL(12,i)%>"><%=SQL(5,i)%></a><br><%=SQL(12,i)%></td>
<td class="forumRow" align=center><%=SQL(7,i)%></td>
<td class="forumRow" align=center><%=FormatDateTime(SQL(8,i),2)%></td>
</tr>
<%
	Next
%>
<tr><td class="forumRow" colspan="8" align=left style="line-height : 18px ;">
������<input name=chkall type=checkbox class="checkbox" value=on onclick=CheckAll(this.form)>
ȫѡ
<input type=submit class="button" name=submit value="����ɾ��">
<BR><font color=blue>����ɾ��������ϵͳ���Զ��������10�����־��Ϣ���������ɻָ��������أ�</font><BR>
<B>���</B>��<a href="MoneyLog.asp?action=del" onclick="{if(confirm('ɾ�����������ɻָ���ȷ����?')){return true;}return false;}">������־</a> | <a href="MoneyLog.asp?action=del&dtype=1" onclick="{if(confirm('ɾ�����������ɻָ���ȷ����?')){return true;}return false;}">ʹ����־</a> | <a href="MoneyLog.asp?action=del&dtype=2" onclick="{if(confirm('ɾ�����������ɻָ���ȷ����?')){return true;}return false;}">ת����־</a> | <a href="MoneyLog.asp?action=del&dtype=5" onclick="{if(confirm('ɾ�����������ɻָ���ȷ����?')){return true;}return false;}">������־</a> | <a href="MoneyLog.asp?action=del&dtype=4" onclick="{if(confirm('ɾ�����������ɻָ���ȷ����?')){return true;}return false;}">������־</a> | <a href="MoneyLog.asp?action=del&dtype=3" onclick="{if(confirm('ɾ�����������ɻָ���ȷ����?')){return true;}return false;}">��ֵ��־</a> | <a href="MoneyLog.asp?action=del&dtype=-1" onclick="{if(confirm('ɾ�����������ɻָ���ȷ����?')){return true;}return false;}">��̨������־</a>
</td></tr>
</FORM>
<%

	PageSearch=Replace(Replace(PageSearch,"\","\\"),"""","\""")
	Response.Write "<SCRIPT>PageList("&Page&",3,"&MaxRows&","&CountNum&","""&PageSearch&""",1);</SCRIPT>"
End Sub

Sub Del()
	Dim Stype,SQL
	Dim SqlDate
	Stype = Request("dtype")
	If IsNumeric(Stype) = 0 or Stype="" Then Stype=0
	Stype = Clng(Stype)
	If IsSqlDataBase=1 Then
		SqlDate = "d"
	Else
		SqlDate ="'d'"
	End If
	Select Case Stype
	Case 0
		SQL = "Delete From Dv_MoneyLog Where DateDiff("&SqlDate&",Log_Time,"&SqlNowString&")>10"
	Case 1
		SQL = "Delete From Dv_MoneyLog Where Log_Type=1 And DateDiff("&SqlDate&",Log_Time,"&SqlNowString&")>10"
	Case 2
		SQL = "Delete From Dv_MoneyLog Where Log_Type=2 And DateDiff("&SqlDate&",Log_Time,"&SqlNowString&")>10"
	Case 3
		SQL = "Delete From Dv_MoneyLog Where Log_Type=3 And DateDiff("&SqlDate&",Log_Time,"&SqlNowString&")>10"
	Case 4
		SQL = "Delete From Dv_MoneyLog Where Log_Type=4 And DateDiff("&SqlDate&",Log_Time,"&SqlNowString&")>10"
	Case 5
		SQL = "Delete From Dv_MoneyLog Where Log_Type=5 And DateDiff("&SqlDate&",Log_Time,"&SqlNowString&")>10"
	Case -1
		SQL = "Delete From Dv_MoneyLog Where BoardID=-1 And DateDiff("&SqlDate&",Log_Time,"&SqlNowString&")>10"
	Case Else
		SQL = "Delete From Dv_MoneyLog Where DateDiff("&SqlDate&",Log_Time,"&SqlNowString&")>10"
	End Select
	Dvbbs.Plus_Execute(SQL)
	Dv_Suc("ɾ��ϵͳ������־�ɹ���")
	Footer()
	Response.End
End Sub

Sub AllDel()
	Dim IDStr,IDStr_a
	Dim SqlDate,sql
	IDStr = Request("logid")
	If IDStr="" Then
		Errmsg=ErrMsg + "<BR><li>�Ƿ��Ĳ�����"
		founderr=True
	Else
		IDStr_a = Replace(Replace(IDStr," ",""),",","")
		If Not IsNumeric(IDStr_a) Then
			Errmsg=ErrMsg + "<BR><li>�Ƿ��Ĳ�����"
			founderr=True
		End If
	End If
	If founderr Then Exit Sub
	If IsSqlDataBase=1 Then
		SqlDate = "d"
	Else
		SqlDate ="'d'"
	End If
	SQL = "Delete From Dv_MoneyLog Where Log_ID In ("&IDStr&") And DateDiff("&SqlDate&",Log_Time,"&SqlNowString&")>10"
	Dvbbs.Plus_Execute(SQL)
	Dv_Suc("ɾ��ϵͳ������־�ɹ���")
	Footer()
	Response.End
End Sub
%>