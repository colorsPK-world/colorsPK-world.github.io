<!--#include file =../conn.asp-->
<!--#include file="inc/const.asp"-->
<!--#include file="../inc/dv_clsother.asp"-->
<%
Head()
Dim admin_flag
admin_flag=",9,"
CheckAdmin(admin_flag)
If Request("action")="readme" Then
	NetPay()
Else
	Main()
End If
If FoundErr Then Call Dvbbs_Error()
Footer()

Sub Main()
	Dim StartTime,EndTime,sType,KeyWord,IsSuc,MoneySize,PayMoney,SqlString
	StartTime = Request("StartTime")
	EndTime = Request("EndTime")
	sType = Request("sType")
	KeyWord = Replace(Request("keyword"),"'","''")
	MoneySize = Request("MoneySize")
	PayMoney = Request("PayMoney")
	IsSuc = Request("IsSuc")

	If IsSuc = "" Or Not IsNumeric(IsSuc) Then IsSuc = 0
	If IsSuc = 1 Then
		If SqlString = "" Then
			SqlString = " Where O_IsSuc = 1"
		Else
			SqlString = SqlString & " And O_IsSuc = 0"
		End If
	ElseIf IsSuc = 2 Then
	End If
	If StartTime <> "" And IsDate(StartTime) Then
		If SqlString = "" Then
			SqlString = " Where O_AddTime >= '"&StartTime&"'"
		Else
			SqlString = SqlString & " And O_AddTime >= '"&StartTime&"'"
		End If
	End If
	If EndTime <> "" And IsDate(EndTime) Then
		If SqlString = "" Then
			SqlString = " Where O_AddTime <= '"&EndTime&"'"
		Else
			SqlString = SqlString & " And O_AddTime <= '"&EndTime&"'"
		End If
	End If
	If sType = "" Or Not IsNumeric(sType) Then sType = 0
	If sType = 1 Then
		If SqlString = "" Then
			SqlString = " Where O_Type = 1"
		Else
			SqlString = SqlString & " And O_Type = 1"
		End If
	ElseIf sType = 2 Then
		If SqlString = "" Then
			SqlString = " Where O_Type = 2"
		Else
			SqlString = SqlString & " And O_Type = 2"
		End If
	End If
	If KeyWord <> "" Then
		If SqlString = "" Then
			SqlString = " Where (O_UserName Like '%"&keyword&"%' Or O_PayCode Like '%"&keyword&"%')"
		Else
			SqlString = SqlString & " And (O_UserName Like '%"&keyword&"%' Or O_PayCode Like '%"&keyword&"%')"
		End If
	End If
	If MoneySize = "" Or Not IsNumeric(MoneySize) Then MoneySize=0
	MoneySize = Cint(MoneySize)
	If PayMoney <> "" And IsNumeric(PayMoney) Then
		If MoneySize = 0 Then
			If SqlString = "" Then
				SqlString = " Where O_PayMoney > "&PayMoney&""
			Else
				SqlString = SqlString & " And O_PayMoney > "&PayMoney&""
			End If
		Else
			If SqlString = "" Then
				SqlString = " Where O_PayMoney < "&PayMoney&""
			Else
				SqlString = SqlString & " And O_PayMoney < "&PayMoney&""
			End If
		End If
	End If

	Dim Page,MaxRows,Endpage,CountNum,PageSearch
	PageSearch = "StartTime="&StartTime&"&EndTime="&EndTime&"&keyword="&KeyWord&"&sType="&sType&"&IsSuc="&IsSuc&"&MoneySize="&MoneySize&"&PayMoney="&PayMoney&""
	Endpage = 0
	MaxRows = 20
	Page = Request("Page")
	If IsNumeric(Page) = 0 or Page="" Then Page=1
	Page = Clng(Page)
	Response.Write "<script language=""JavaScript"" src=""../inc/Pagination.js""></script>"
%>
<table width="100%" border="0" cellspacing="1" cellpadding="3" align="center">
<tr><th style="text-align:center;">��̳������Ϣ����</th></tr>
<tr><td class="td1" style="line-height : 18px ;">
<B>˵��</B>��<BR>
1����������������֧�����ֻ�����ͨ�������û������û���ȯ��<a href="Challenge.asp"><font color=red>ǰ������֧�����ֻ���������</font></a><BR>
2����̳�еĽ�������VIP�û����������ĵȽ��׵Ļ���Ϊ��̳��һ��ȯ<BR>
3����ҿ�ͨ���������������û�����̳������������ȯ��ͨ������֧�����ֻ�����ͨ�����������ص�����<BR>
4����ҳ�湦��Ϊ��ѯ����֧�����ֻ����Ź����ȯ����ϸ�����������̳���������ƻ���δ֪���أ��˴����ݽ����ο��������Ա�ο������ٷ���Ӧ�ĵ�������̳��ȫ����
</td>
</tr>
<FORM METHOD=POST ACTION="ForumPay.asp">
<tr>
<td class="td1" style="line-height : 18px ;">
<B>˵��</B>����ʼ�ͽ���ʱ�䲻��дΪ��ѯ���У������˵���ѡ�ѡ���ѯ������Ϣ���ؼ��ֿ������û�����������
</td>
</tr>
<tr>
<td class="td1" style="line-height : 18px ;">
�ؼ��֣�
<input size=15 name="keyword" type=text value="<%=keyword%>">
��ʼʱ�䣺
<input size=15 name="StartTime" type=text value="<%=StartTime%>">
����ʱ�䣺
<input size=15 name="EndTime" type=text value="<%=EndTime%>">
��ʽ��yyyy-mm-dd
</td>
</tr>
<tr>
<td class="td1" style="line-height : 18px ;">
�ࡡ�ͣ�
<Select Size=1 Name="sType">
<Option value=0>����</Option>
<Option value=1 <%If sType = 1 Then Response.Write "Selected"%>>����֧��</Option>
<Option value=2 <%If sType = 2 Then Response.Write "Selected"%>>�ֻ�����</Option>
</Select>
����״̬��
<Select Size=1 Name="IsSuc">
<Option value=0>����</Option>
<Option value=1 <%If IsSuc = 1 Then Response.Write "Selected"%>>�ɹ�</Option>
<Option value=2 <%If IsSuc = 2 Then Response.Write "Selected"%>>ʧ��</Option>
</Select>
���׽�
����
<input type=radio class="radio" value="0" name="MoneySize" <%If MoneySize = 0 Then Response.Write "Checked"%>>
����
<input type=radio class="radio" value="1" name="MoneySize" <%If MoneySize = 1 Then Response.Write "Checked"%>>
<input type=text size=10 name="PayMoney" value="<%=PayMoney%>">
<input name="submit" value="�ύ��ѯ" type=Submit class="button">
</td>
</tr>
</FORM>
</table><br>
<table width="100%" border="0" cellspacing="1" cellpadding="3" align="center">
<tr>
<th width="150">�û���</th>
<th>������</th>
<th width="35">���</th>
<th width="70">��������</th>
<th width="35">״̬</th>
<th width="100">����ʱ��</th>
</tr>
<%
	'Response.Write SqlString
	Dim PageAmount,AllAmount,Rs,Sql,i
	PageAmount = 0
	AllAmount = 0
	Set Rs = Dvbbs.Execute("Select Sum(O_PayMoney) From Dv_ChanOrders "&SqlString&"")
	AllAmount = Rs(0)
	If IsNull(AllAmount) Then AllAmount = 0
	Set Rs = Dvbbs.iCreateObject ("adodb.recordset")
	Sql = "Select O_PayMoney,O_UserName,O_PayCode,O_Type,O_IsSuc,O_AddTime From Dv_ChanOrders "&SqlString&" Order By O_ID Desc"
	If Not IsObject(Conn) Then ConnectionDatabase
	Rs.Open Sql,conn,1,1
	If Rs.Eof And Rs.Bof Then
		Response.Write "<tr><td class=td1 height=23 colspan=6>δ�ҵ���صĽ�����Ϣ��</td></tr>"
	Else
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
			PageAmount = PageAmount + SQL(0,i)
%>
<tr align=center>
<td class="td1" height=23><a href="../dispuser.asp?name=<%=Server.HtmlEncode(SQL(1,i))%>" target=_blank><%=Server.HtmlEncode(SQL(1,i))%></a></td>
<td class="td1"><%=SQL(2,i)%></td>
<td width="35" class="td1"><%=SQL(0,i)%></td>
<td width="70" class="td1">
<%
Select Case SQL(3,i)
Case 1
	Response.Write "����֧��"
Case 2
	Response.Write "�ֻ�����"
End Select
%>
</td>
<td width="35" class="td1">
<%
Select Case SQL(4,i)
Case 0
	Response.Write "<font color=gray>ʧ��</font>"
Case 1
	Response.Write "�ɹ�"
End Select
%>
</td>
<td><%=FormatDateTime(SQL(5,i),2)%>&nbsp;<%=FormatDateTime(SQL(5,i),4)%></td>
</tr>
<%
		Next
	End If
	Rs.Close
	Set Rs=Nothing
	Response.Write "<tr><td class=td1 height=23 colspan=6><B>��ҳ���׽��</B>��<B>"&PageAmount&"</B> Ԫ����ң�<B>���β�ѯ�����ܽ��</B>��<B>"&AllAmount&"</B> Ԫ�����</td></tr>"
	Response.Write "</table>"
	PageSearch=Replace(Replace(PageSearch,"\","\\"),"""","\""")
	If CountNum > 0 Then Response.Write "<SCRIPT>PageList("&Page&",3,"&MaxRows&","&CountNum&","""&PageSearch&""",1);</SCRIPT>"
End Sub

Sub NetPay()
%>
<table width="100%" border="0" cellspacing="1" cellpadding="3" align="center">
<tr><th style="text-align:center;">����֧���ӿڶ��ο����ĵ�</th></tr>
<tr>
<td class="td1" style="line-height : 18px ;">
<B>��Ҫ˵��</B>��<BR>
1�����в��ô˽ӿ���վ�����Ϊ����������վ��Ա������ʱ���Զ��ύ������Ϣ���ٷ��������Ǽ�<BR>
2�����в��ô�����֧���ӿڹ��ܵĳ�ԱĬ��Ϊ���ܶ������������֧����������������еĽ���Ȩ��������ʱ���⶯���ٷ��Ի������֪ͨ<BR>
3������������֧�����ܲ��迪ͨ�ͷ���ѣ���������ȡһ���������ѣ����Ƚ���Ĭ��Ϊ <B>2%</B>��Ĭ�ϵ��Ƚ�������շѱ�׼Ϊ <B>1</B> Ԫ�����<BR>
4������������ʱ�����������ú͸��ݲ�ͬ��վ��ȡ��ͬ�շѲ��Ե���Ϊ��������ϸ���շѱ�׼���շѲ�������ʱ��ע�����ٷ�վ��<BR>
5��ʹ���߶����е�������վ��ϢΥ������١��¾ɻ���ʵ��ɵ�Ͷ�ߡ��˻������׵ȵ����Σ�����ϸ˵����μ���������֧����������
<p></p>
<B>����֧���ӿں�ʹ�ò���</B>��
<p></p>
<a href="http://www.dvbbs.net/netpay/pay.rar"><font color=red>��ϸ������֧���ӿ�˵���Ϳ���������</font></a>
<p></p>
<B>��һ����Ϊ����������վ��Ա</B><BR>
���ʶ����ٷ�վ�㣬�����Ϊ��������֧��������վ��Ա
<p></p>
<B>�������ύ֧������ҳ��</B><BR>
1�����ɶ����ţ������Ź���Ϊ��02 + ������վID + ʱ��(yyyymmddhhMMss) + 5λ����������һ���е������û���Ϣ�����ɵĶ�������Ϊ020000000012005031513355519597������000000001��������վID��20050315133555���Ƕ������ɵ�ʱ�䣨ʱ���г����������������2λ�����貹0���������03��ʾ3�£���19597�������<BR>
2��������ʽ��������ʽ������������Ϊ�������ţ�����Ϊpaycode���������û���������Ϊusername����Ϊ�գ������ص�ַ������Ϊreturnurl����֧��������Ϊpaymoney��<BR>
3�����ɵĶ�����ϢӦ��¼һ���ڱ������ݿ⣬����Ӧ���������š������û���֧��������ʱ�䡢�Ƿ�ɹ�����Ϣ<BR>
4��������������post��ʽ�ύ����http://server.dvbbs.net/alipay_t1.aspx?action=pay
<p></p>
<B>����������֧�����ҳ��</B><BR>
1��Get��ʽ���صĲ���������״̬������Ϊsuccess���������ţ�����Ϊpaycode������֤�ִ�������Ϊsign��<BR>
2����֤���̣�<BR>
����A. success=1Ϊ�ɹ�������0Ϊʧ�ܶ���<BR>
����B. ���ݶ����Ų�ѯ�������ݿ⣬�綩�����ڣ�������ַ���֤���̣�������Ҫ����һ�ݱ�����֤�ִ�������ΪMD5����32λ���������ַ���������:���صĶ���״̬:�������:������֤�ִ������ǵ�һ���еļ����ַ�key����ע������ÿ����Ŀ�ķָ�ʹ��Ӣ��״̬�µ�ð�ţ�Ȼ�󽫼��ܺ��ַ��ͷ��ص��ַ�(sign)�Ƚϣ���ͬ���ʾ��֤ͨ��<BR>
3����֤ͨ���������Ӧ���û����ݲ���������������Ϊ�ɹ�״̬
<p></p>
<B>���ģ����»�ö���״̬</B><BR>
��Ҫ�����������������Ľ���ʧ��<BR>
��ȡ��Ӧ�����е������Ϣ��������һ�ݶ�����ע��������ݱ�������ԭ������Ϣ�����������ţ�������Ϣ<BR>
�����ɵĶ�����Ϣ��post��ʽ�ύ����http://server.dvbbs.net/alipay_t1.aspx?action=pay_1
</td>
</tr>
</table><P>
<%
End Sub
%>