<!--#include file =../conn.asp-->
<!--#include file="inc/const.asp"-->
<!--#include file="../inc/dv_clsother.asp"-->
<!--#include file="../Dv_plus/Tools/plus_MagicFace_const.asp"-->
<%
Head()
Dim Admin_flag
Admin_flag=",43,"
CheckAdmin(admin_flag)
Select Case Request("Action")
	Case "Addnew" : AddNew()
	Case "EditMagic" : EditMagic()
	Case Else
		Main_head()
		MagicFaceList()
End Select
If founderr then dvbbs_error()
Footer()

Sub Main_head()

%>
<table width="100%" border="0" cellspacing="1" cellpadding="3" align="center">
<tr><th style="text-align:center;">ħ�����飨ͷ�����ú͹���</th></tr>
<tr><td class="td2" style="line-height: 130%"><B>ħ�����飨ͷ�����ú͹���</B>��<BR>
	1��ħ�����飨ͷ��Ĭ�ϵ�ͼƬ��FlashЧ��ͼ·���ֱ��ǣ�<B>Dv_Plus/Tools/magicface/gif/</B>��<B>Dv_Plus/Tools/magicface/swf/</B>�������ӻ����ͼƬ��flashЧ����ʱ����ý�����ļ��ϴ�����λ�á�
	<BR>
	2�������Էֱ��趨ʹ��ÿ��ħ����������Ҫ�Ľ�Һ͵�ȯ���������õĽ�Һ͵�ȯ��Ϊ�û�������Ҫ��������ʹ��ÿ��ħ�����飨ͷ����Ҫ�����ӡ���Ǯ�����֡����������������ƣ���Щֻ�����ƴﵽ�˱�׼�Ĳ���ʹ�ã������۳���Ӧ���õ���ֵ��</td></tr>
</table>
<br>
<%

End Sub

Sub MagicFaceList()
Dim Rs,Sql,iMagicFaceType,i,ii,stype
Dim Page,MaxRows,Endpage,CountNum,PageSearch,SqlString
Endpage = 0
MaxRows = 50
Page = Request("Page")
If IsNumeric(Page) = 0 or Page="" Then Page=1
Page = Clng(Page)
stype = Request("stype")
If IsNumeric(stype) = 0 or stype="" Then stype=-1
stype = Clng(stype)
Response.Write "<script language=""JavaScript"" src=""../inc/Pagination.js""></script>"
iMagicFaceType = Split(MagicFaceType,"|")
PageSearch = "stype="&stype
%>
<table width="100%" border="0" cellspacing="1" cellpadding="3" align="center">
<tr>
<td class="td1" colspan=15 style="line-height: 130%">
<li>ͼƬ��Flash���������˵������Ĭ��Ŀ¼��<font color=red>ͼƬ�����������д��ͼƬ��flash�ļ�ֻ������ʾʱ��׺��ͬ���ڴ�Ϊͳһ����</font>�����ͼƬ��Ԥ��Ч��
<li>�޸�ħ�����飨ͷ��������Dv_Plus/Tools/plus_tools_const.asp�ļ��޸�����MagicFaceType����
<li><font color=red>���1�͵�ȯ1�ǹ���ħ������ļ۸񣬽��2�͵�ȯ2�ǹ���ħ��ͷ��ļ۸�</font>
<li><font color=blue>����ħ�����飨ͷ����Ԥ��׼�������ļ���������ӦĿ¼������gifͼƬ�ֱ���С�ʹ�ͼƬ��СͼƬ�����û�����ѡ����ʾ����ͼƬ�����û�����ħ��ͷ��������Ӽ�����������ʾ��һ��swf�ļ���ħ��Ч��</font><BR>
<B>���ٲ鿴����</B>��<a href="?">ȫ��</a> | 
<%
For i = 0 To Ubound(iMagicFaceType)
	If i <> Ubound(iMagicFaceType) Then
		Response.Write "<a href=""?stype="&i&""">"&iMagicFaceType(i)&"</a> | "
	Else
		Response.Write "<a href=""?stype="&i&""">"&iMagicFaceType(i)&"</a>"
	End If
Next
%>
</td>
</tr>
<tr>
<th>ID</th>
<th>Ԥ��</th>
<th>˵��</th>
<th>���</th>
<th>ͼƬ</th>
<th>���1</th>
<th>��ȯ1</th>
<th>���2</th>
<th>��ȯ2</th>
<th>����</th>
<th>��Ǯ</th>
<th>����</th>
<th>����</th>
<th>����</th>
<th>����</th>
</tr>
<FORM METHOD=POST ACTION="?Action=Addnew">
<tr align=center>
<td class="td2"><font color=red>��</font></td>
<td class="td2">&nbsp;</td>
<td class="td2"><input type=text size=13 name="ntitle"></td>
<td class="td2">
<Select Name="ntype" size=1>
<%
For i = 0 To Ubound(iMagicFaceType)
	Response.Write "<option value="""&i&""">"&iMagicFaceType(i)&"</option>"
Next
%>
</Select>
</td>
<td class="td2"><input type=text size=6 name="ngif" value="0"></td>
<td class="td2"><input type=text size=3 name="nmoney" value="1000"></td>
<td class="td2"><input type=text size=3 name="nticket" value="100"></td>
<td class="td2"><input type=text size=3 name="ntmoney" value="100"></td>
<td class="td2"><input type=text size=3 name="ntticket" value="10"></td>
<td class="td2"><input type=text size=3 name="ntopic" value="10"></td>
<td class="td2"><input type=text size=3 name="nwealth" value="100"></td>
<td class="td2"><input type=text size=3 name="nuserep" value="20"></td>
<td class="td2"><input type=text size=3 name="nusercp" value="10"></td>
<td class="td2"><input type=text size=3 name="npower" value="0"></td>
<td class="td2"><input type=submit class="button" name=submit value="����"></td>
</tr>
</FORM>
<%
'[Dv_Plus_Tools_MagicFace]
'ID,Title,MagicFace_s,MagicFace_l,iMoney,iTicket,MagicSetting
Dim MagicSetting
If stype = -1 Then
	Sql="Select ID,Title,MagicFace_s,MagicFace_s As MagicFace_l,MagicType,iMoney,iTicket,MagicSetting,tMoney,tTicket From Dv_Plus_Tools_MagicFace Order By ID Desc"
Else
	Sql="Select ID,Title,MagicFace_s,MagicFace_s As MagicFace_l,MagicType,iMoney,iTicket,MagicSetting,tMoney,tTicket From Dv_Plus_Tools_MagicFace Where MagicType = "&stype&" Order By ID Desc"
End If
Set Rs = Dvbbs.iCreateObject ("adodb.recordset")
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
	For i=0 To Ubound(SQL,2)
		MagicSetting = Split(SQL(7,i),"|")
%>
		<FORM METHOD=POST ACTION="?Action=EditMagic">
		<tr align=center>
		<td class="td2"><%=SQL(0,i)%></td>
		<td class="td2"><a href="../Dv_plus/Tools/magicface/swf/<%=SQL(3,i)%>.swf" target=_blank><img src="../Dv_plus/Tools/magicface/gif/<%=SQL(2,i)%>.gif" border=0></a></td>
		<td class="td2"><input type=text size=13 name="ntitle_<%=SQL(0,i)%>" value="<%=SQL(1,i)%>"></td>
		<td class="td2">
		<Select Name="ntype_<%=SQL(0,i)%>" size=1>
		<%
		For ii = 0 To Ubound(iMagicFaceType)
			Response.Write "<option value="""&ii&""""
			If ii = SQL(4,i) Then Response.Write " Selected "
			Response.Write ">"&iMagicFaceType(ii)&"</option>"
		Next
		%>
		</Select>
		</td>
		<td class="td2"><input type=text size=6 name="ngif_<%=SQL(0,i)%>" value="<%=SQL(2,i)%>"></td>
		<td class="td2"><input type=text size=3 name="nmoney_<%=SQL(0,i)%>" value="<%=SQL(5,i)%>"></td>
		<td class="td2"><input type=text size=3 name="nticket_<%=SQL(0,i)%>" value="<%=SQL(6,i)%>"></td>
		<td class="td2"><input type=text size=3 name="ntmoney_<%=SQL(0,i)%>" value="<%=SQL(8,i)%>"></td>
		<td class="td2"><input type=text size=3 name="ntticket_<%=SQL(0,i)%>" value="<%=SQL(9,i)%>"></td>
		<td class="td2"><input type=text size=3 name="ntopic_<%=SQL(0,i)%>" value="<%=MagicSetting(0)%>"></td>
		<td class="td2"><input type=text size=3 name="nwealth_<%=SQL(0,i)%>" value="<%=MagicSetting(1)%>"></td>
		<td class="td2"><input type=text size=3 name="nuserep_<%=SQL(0,i)%>" value="<%=MagicSetting(2)%>"></td>
		<td class="td2"><input type=text size=3 name="nusercp_<%=SQL(0,i)%>" value="<%=MagicSetting(3)%>"></td>
		<td class="td2"><input type=text size=3 name="npower_<%=SQL(0,i)%>" value="<%=MagicSetting(4)%>"></td>
		<td class="td2"><input type=checkbox class="checkbox" name="ID" value="<%=SQL(0,i)%>"></td>
		</tr>
<%
	Next
End If
Rs.Close
Set Rs=Nothing
%>
<tr>
<td class="td1" colspan=15 align=right height="30">
��ѡ��ָ����ħ����������޸Ļ�ɾ������&nbsp;&nbsp;ȫѡ<input name=chkall type=checkbox class="checkbox" value=on	onclick="CheckAll(this.form)">&nbsp;&nbsp;<input type=submit class="button" name=submit value="�޸�">&nbsp;<input type=submit class="button" name=submit value="ɾ��">
</td>
</tr>
</FORM>
</table>
<%
PageSearch=Replace(Replace(PageSearch,"\","\\"),"""","\""")
Response.Write "<SCRIPT>PageList("&Page&",3,"&MaxRows&","&CountNum&","""&PageSearch&""",1);</SCRIPT>"

End Sub

Sub Addnew()
	Dim ntitle,ntype,ngif,nswf,nmoney,nticket,ntmoney,ntticket,ntopic,nwealth,nuserep,nusercp,npower
	If Request("ntitle")="" Then
		Errmsg=ErrMsg + "<BR><li>������ħ������˵����"
		founderr=True
	End If
	ntitle = Dvbbs.CheckStr(Request("ntitle"))
	If Request("ntype")="" Or Not IsNumeric(Request("ntype")) Then
		Errmsg=ErrMsg + "<BR><li>��ѡ��ħ���������͡�"
		founderr=True
	End If
	ntype = Request("ntype")
	If Request("ngif")="" Then
		Errmsg=ErrMsg + "<BR><li>������ħ������СͼƬ��"
		founderr=True
	End If
	ngif = Dvbbs.CheckStr(Request("ngif"))
	If Request("nmoney")="" Or Not IsNumeric(Request("nmoney")) Then
		Errmsg=ErrMsg + "<BR><li>������ħ��������Ҫ�Ľ������"
		founderr=True
	End If
	nmoney = Request("nmoney")
	If Request("nticket")="" Or Not IsNumeric(Request("nticket")) Then
		Errmsg=ErrMsg + "<BR><li>������ħ��������Ҫ�ĵ�ȯ����"
		founderr=True
	End If
	nticket = Request("nticket")
	If Request("ntmoney")="" Or Not IsNumeric(Request("ntmoney")) Then
		Errmsg=ErrMsg + "<BR><li>������ħ��������Ҫ�Ľ������"
		founderr=True
	End If
	ntmoney = Request("ntmoney")
	If Request("ntticket")="" Or Not IsNumeric(Request("ntticket")) Then
		Errmsg=ErrMsg + "<BR><li>������ħ��������Ҫ�ĵ�ȯ����"
		founderr=True
	End If
	ntticket = Request("ntticket")
	If Request("ntopic")="" Or Not IsNumeric(Request("ntopic")) Then
		Errmsg=ErrMsg + "<BR><li>������ħ��������Ҫ����������"
		founderr=True
	End If
	ntopic = Request("ntopic")
	If Request("nwealth")="" Or Not IsNumeric(Request("nwealth")) Then
		Errmsg=ErrMsg + "<BR><li>������ħ��������Ҫ�Ľ�Ǯ����"
		founderr=True
	End If
	nwealth = Request("nwealth")
	If Request("nuserep")="" Or Not IsNumeric(Request("nuserep")) Then
		Errmsg=ErrMsg + "<BR><li>������ħ��������Ҫ�Ļ�������"
		founderr=True
	End If
	nuserep = Request("nuserep")
	If Request("nusercp")="" Or Not IsNumeric(Request("nusercp")) Then
		Errmsg=ErrMsg + "<BR><li>������ħ��������Ҫ����������"
		founderr=True
	End If
	nusercp = Request("nusercp")
	If Request("npower")="" Or Not IsNumeric(Request("npower")) Then
		Errmsg=ErrMsg + "<BR><li>������ħ��������Ҫ����������"
		founderr=True
	End If
	npower = Request("npower")
	npower = Request("ntopic") & "|" & Request("nwealth") & "|" & Request("nuserep") & "|" & Request("nusercp") & "|" & Request("npower")
	If Founderr Then Exit Sub
	Dvbbs.Plus_Execute("Insert Into Dv_Plus_Tools_MagicFace (Title,MagicFace_s,MagicType,iMoney,iTicket,MagicSetting,tMoney,tTicket) Values ('"&ntitle&"',"&ngif&","&ntype&","&nmoney&","&nticket&",'"&npower&"',"&ntmoney&","&ntticket&")")
	Dv_suc("����ħ������ɹ���")
End Sub

Sub EditMagic()
	Dim ID,FixID,i
	Dim ntype,nmoney,nticket,ntmoney,ntticket,ntopic,nwealth,nuserep,nusercp,npower,ngif
	ID = Replace(Request("ID"),"'","")
	ID = Replace(ID,";","")
	ID = Replace(ID,"--","")
	ID = Replace(ID," ","")
	FixID = Replace(ID,",","")
	FixID = Left(FixID,300)
	If ID = "" Or Not IsNumeric(FixID) Then
		Errmsg=ErrMsg + "<BR><li>��ѡ��ָ����ħ����������޸ĸ��»�ɾ��������"
		founderr=True
	End If
	For I=1 To Request.Form("ID").Count
		ID = Replace(Request.Form("ID")(I),"'","")
		ID = CLng(ID)
		ntype = Request.Form("ntype_"&ID)
		If Not IsNumeric(ntype) Then ntype = 0
		nmoney = Request.Form("nmoney_"&ID)
		If Not IsNumeric(nmoney) Then nmoney = 0
		nticket = Request.Form("nticket_"&ID)
		If Not IsNumeric(nticket) Then nticket = 0
		ntmoney = Request.Form("ntmoney_"&ID)
		If Not IsNumeric(ntmoney) Then ntmoney = 0
		ntticket = Request.Form("ntticket_"&ID)
		If Not IsNumeric(ntticket) Then ntticket = 0
		ntopic = Request.Form("ntopic_"&ID)
		If Not IsNumeric(ntopic) Then ntopic = 0
		nwealth = Request.Form("nwealth_"&ID)
		If Not IsNumeric(nwealth) Then nwealth = 0
		nuserep = Request.Form("nuserep_"&ID)
		If Not IsNumeric(nuserep) Then nuserep = 0
		nusercp = Request.Form("nusercp_"&ID)
		If Not IsNumeric(nusercp) Then nusercp = 0
		npower = Request.Form("npower_"&ID)
		If Not IsNumeric(npower) Then npower = 0
		npower = ntopic & "|" & nwealth & "|" & nuserep & "|" & nusercp & "|" & npower
		ngif = Request.Form("ngif_"&ID)
		If Not IsNumeric(ngif) Then ngif = 0

		If Request("submit")="�޸�" Then
			Dvbbs.Plus_Execute("Update Dv_Plus_Tools_MagicFace Set Title='"&Dvbbs.CheckStr(Request.Form("ntitle_"&ID))&"',MagicFace_s="&ngif&",MagicType="&ntype&",iMoney="&nmoney&",iTicket="&nticket&",tMoney="&ntmoney&",tTicket="&ntticket&",MagicSetting='"&npower&"' Where ID = " & ID)
		Else
			Dvbbs.Plus_Execute("Delete From Dv_Plus_Tools_MagicFace Where ID = " & ID)
		End If
	Next
	Dv_suc("�����޸�ħ������ɹ���")
End Sub
%>