<!--#include file="../conn.asp"-->
<!--#include file="inc/const.asp"-->
<!--#include file="../inc/dv_clsother.asp"-->
<!--#include file="../inc/GroupPermission.asp"-->
<!--#include file=../inc/md5.asp-->
<%
Head()
Server.ScriptTimeout=999999
dim Str
dim admin_flag
admin_flag=Split("11,12",",")
founderr=False 
CheckAdmin(admin_flag(0))
CheckAdmin(admin_flag(1))
call main()
footer()

Sub main()
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr> 
<th width="100%" colspan=2 style="text-align:center;">论坛管理
</th>
</tr>
<tr>
<td class="td2" colspan=2>
<p><B>注意</B>：<BR>①删除论坛同时将删除该论坛下所有帖子！删除分类同时删除下属论坛和其中帖子！ 操作时请完整填写表单信息；<BR>②如果选择<B>复位所有版面</B>，则所有版面都将作为一级论坛（分类），这时您需要重新对各个版面进行归属的基本设置，<B>不要轻易使用该功能</B>，仅在做出了错误的设置而无法复原版面之间的关系和排序的时候使用，在这里您也可以只针对某个分类进行复位操作(见分类的更多操作下拉菜单)，具体请看操作说明。<BR><font color=blue>每个版面的更多操作请见下拉菜单，操作前请仔细阅读说明，分类下拉菜单中比别的版面增加了分类排序和分类复位功能</font><BR>
<font color=red>如果您希望某个版面需要会员付出一定代价（货币）才能进入，可以在版面高级设置中设置相应版面进入所需的金币或点券数以及能访问的时间是多少</font>
</td>
</tr>
<tr>
<td class="td2" height=25>
<B>论坛操作选项</B></td>
<td class="td2"><a href="board.asp">论坛管理首页</a> | <a href="board.asp?action=add">新建论坛版面</a> | <a href="?action=settemplates">模板风格批量设置</a> | <a href="?action=orders">一级分类排序</a> | <a href="?action=boardorders">N级分类排序</a> | <a href="?action=RestoreBoard" onclick="{if(confirm('复位所有版面将把所有版面恢复成为一级大分类，复位后要对所有版面重新进行归属的基本设置，请慎重操作，确定复位吗?')){return true;}return false;}">复位所有版面</a> | <a href="?action=RestoreBoardCache" onclick="{if(confirm('有时候您对论坛版面的修改在前台看不出修改效果，这很可能是相应版面的缓存没有生效所致，在这里将重建所有版面的缓存，如果您的版面很多，这将消耗您一定的时间，确定吗?')){return true;}return false;}">重建版面缓存</a>
</td>
</tr>
</table>
<p></p>
<%
select case Request("action")
	case "add"
		call add()
	case "edit"
		call edit()
	case "savenew"'新增论坛
		call savenew()
	Case "savedit"
		call savedit()
	Case "del"
		call del()
	Case "orders"
		call orders()
	case "updatorders"
		call updateorders()
	Case "boardorders"
		call boardorders()
	case "updatboardorders"
		call updateboardorders()
	Case "mode"
		call mode()
	case "savemod"
		call savemod()
	Case "permission"
		call boardpermission()
	case "editpermission"
		call editpermission()
	case "RestoreBoard"
		call RestoreBoard()
	Case "RestoreBoardCache"
		Call RestoreBoardCache()
	Case "clearDate"
		Call clearDate
	Case "delDate"
		Call delDate
	Case "RestoreClass"
		Call RestoreClass
	Case "handorders"
		Call handorders
	Case "savehandorders"
		Call savehandorders
	Case "savesid"
		Call savesid
	Case "upallsid"
		Call upallsid
	Case "settemplates"
		Call Settemplates
	Case Else
		Call boardinfo()
end select
end Sub
Sub upallsid()
	Dim Sid,cid,board
	SID= Request("Sid")
'	cid=Request("CID")
	If SID="" Then SID=1
'	If CID="" Then CID=1
	SID=CLng(SID)
'	CID=CLng(CID)
	Dvbbs.Execute("Update Dv_Setup Set Forum_Sid="& SID )
	Dvbbs.Execute("Update Dv_Board Set Sid="& SID )
	Dvbbs.loadSetup()
	For Each board in Application(Dvbbs.CacheName&"_boardlist").documentElement.selectNodes("board/@boardid")
	Dvbbs.LoadBoardData(board.text)
	Next
	Dv_suc("论坛版面风格样式统一设置成功!")
End Sub
Sub savesid
	Dim i,boardid,TempStr
	Dim Templateslist,sid,j,bid,cid
	sid=""
	For Each TempStr in Request.form("upboardid")
		If Bid="" Then
			Bid=TempStr
		Else
			Bid=Bid&","&TempStr
		End If 
	Next
	Bid=split(Bid,",")
	For i=0 to UBound(bid)
		If sid="" Then
			sid=Request("sid"&bid(i))
		Else
			sid=sid&","&Request("sid"&bid(i))
		End If
'		If cid="" Then
'			cid=Request("cid"&bid(i))
'		Else
'			cid=cid&","&Request("cid"&bid(i))
'		End If
	Next
	sid=split(sid,",")
	For i=0 to UBound(bid)	
		Dvbbs.Execute("Update Dv_board set sid="&CLng(sid(i))&" Where BoardId="&Clng(bid(i))&" ")
		Dvbbs.LoadBoardData(Clng(bid(i)))
	Next 
	Dv_suc("论坛模板批量设置成功!")
End Sub

Sub Settemplates
'Application(Dvbbs.CacheName &"_style")
Dim reBoard_Setting,MoreMenu,i
Dim Templateslist,rs,SQL

%>

<form action ="board.asp?action=upallsid" method=post name="dv">
<table cellspacing="0" cellpadding="0" align="center" width="100%">
<tr> 
<th colspan="2" style="text-align:center;">模 板 统 一 设 置
</th>
</tr>
<tr>
<td width="70%" align=Left class="td2"><B>所有论坛版面风格模板设置为：</b>&nbsp; 
<%
	Dim forum_sid,iCssName,iCssID,iStyleName
	Dim Forum_cid
	set rs=dvbbs.execute("select forum_sid,Forum_CID from dv_setup")
	Forum_sid=rs(0)
'	Forum_CID=Rs(1)
	Rs.close:Set Rs=Nothing
%>
<Select Size=1 Name="sid">
<%
If Not TypeName(Application(Dvbbs.CacheName & "_style"))="DOMDocument" Then Dvbbs.Loadstyle()
For Each Templateslist in Application(Dvbbs.CacheName &"_style").documentElement.selectNodes("style")
	Response.write Templateslist.getAttribute("id")&"--"&Templateslist.getAttribute("type")
	Response.Write "<Option value="""& Templateslist.selectSingleNode("@id").text &""""
	If Forum_sid = CLng(Templateslist.selectSingleNode("@id").text) Then Response.Write " selected "
	Response.Write ">"& Templateslist.selectSingleNode("@type").text &" </Option>"
Next
%>
</Select>
</td>
<td width="30%" align=Left  class="td2" >
<Input type="submit" name="Submit" value="设 定" class="button"></td>
</tr>
</table><BR>
</form>
<form action ="board.asp?action=savesid" method=post name="dv1">
<table cellspacing="0" cellpadding="0" align="center" width="100%">
<tr> 
<th width="70%">&nbsp;论坛版面
</th>
<th width="30%">采用风格样式
</th>
</tr>
<%
dim classrow
sql="select * from dv_board order by rootid,orders"
set rs=server.createobject("adodb.recordset")
rs.open sql,conn,1,1
do while not rs.eof
reBoard_Setting=split(rs("Board_setting"),",")
if classrow="td2" then
	classrow="td1"
else
	classrow="td2"
end if
%>
<tr> 
<td height="25"  class="<%=classrow%>">
<%if rs("depth")>0 then%>
<%for i=1 to rs("depth")%>
&nbsp;
<%next%>
<%end if%>
<%if rs("child")>0 then%><img src="../skins/default/plus.gif"><%else%><img src="../skins/default/nofollow.gif"><%end if%>
<%if rs("parentid")=0 then%><b><%end if%><%=rs("boardtype")%><%if rs("child")>0 then%>(<%=rs("child")%>)<%end if%>
<%if rs("parentid")=0 then%></b><%end if%>
</td>
<td align=Left  class="<%=classrow%>">
<Select Size=1 Name="sid<%=Rs("BoardID")%>">
<%
For Each Templateslist in Application(Dvbbs.CacheName &"_style").documentElement.selectNodes("style")
	Response.Write "<Option value="""& Templateslist.selectSingleNode("@id").text &""""
	If Rs("SID") = CLng(Templateslist.selectSingleNode("@id").text) Then Response.Write " selected "
	Response.Write ">"& Templateslist.selectSingleNode("@type").text &" </Option>"
Next
%>
</Select>
<Input type="hidden" name="upboardid" value="<%=rs("boardid")%>">
</td></tr>
<%
Rs.movenext
loop
set rs=nothing
%>
<tr>
<td width=300 align=Left class="td2" >&nbsp;</td>
<td width=300 align=Left class="td2" ><input type="submit" name="Submit" value="设 定" class="button"></td>
</tr>
</table><BR><BR>
</form>
<%
End Sub 

sub boardinfo()
Dim reBoard_Setting,MoreMenu
Dim Rs,classrow,iii,SQL,i
%>
<div class=menuskin id=popmenu onmouseover="clearhidemenu();" onmouseout="dynamichide(event)" style="Z-index:100"></div>
<table width="100%" cellspacing="0" cellpadding="0" align="center">
<tr> 
<th width="35%">论坛版面
</th>
<th width="35%">操作
</th>
</tr>
<%
SQL="select boardid,boardtype,parentid,depth,child,Board_setting from dv_board order by rootid,orders"
SET Rs = Conn.Execute(SQL)
If Rs.eof Then
	Rs.close:Set Rs = Nothing
Else
SQL=Rs.GetRows(-1)
Rs.close:Set Rs = Nothing
For iii=0 To Ubound(SQL,2)
	reBoard_Setting=split(SQL(5,iii),",")
	if classrow="td2" then
		classrow="td1"
	else
		classrow="td2"
	end if
	Response.Write "<tr>"
	Response.Write "<td height=""25"" width=""55%"" class="
	Response.Write classrow 
	Response.Write ">"
	if SQL(3,iii)>0 then
		for i=1 to SQL(3,iii)
			Response.Write "&nbsp;&nbsp;"
		next
	end if
	if SQL(4,iii)>0 then
		Response.Write "<img src=""../skins/default/plus.gif"">"
	else
		Response.Write "<img src=""../skins/default/nofollow.gif"">"
	end if
	if SQL(2,iii)=0 then
		Response.Write "<b>"
	end if
	Response.Write SQL(1,iii)
	if SQL(4,iii)>0 then
		Response.Write "("
		Response.Write SQL(4,iii)
		Response.Write ")"
	end if
%>
</td>
<td width="45%" class="<%=classrow%>">
<a href="board.asp?action=add&editid=<%=SQL(0,iii)%>"><font color="<%=Dvbbs.mainsetting(3)%>"><U>添加版面</U></font></a> | <a href="board.asp?action=edit&editid=<%=SQL(0,iii)%>"><font color="<%=Dvbbs.mainsetting(3)%>"><U>基本设置</U></font></a> | <a href="BoardSetting.asp?editid=<%=SQL(0,iii)%>"><font color="<%=Dvbbs.mainsetting(3)%>"><U>高级设置</U></font></a>
<%

MoreMenu=MoreMenu & "<div class=menuitems><a href=update.asp?action=updat&submit=更新论坛数据&boardid="&SQL(0,iii)&" title=更新最后回复、帖子数、回复数><font color="&Dvbbs.mainsetting(3)&"><U>更新数据</U></font></a></div><div class=menuitems><a href=# onclick=alertreadme(\'清空将包括该论坛所有帖子置于回收站，确定清空吗?\',\'update.asp?action=delboard&boardid="&SQL(0,iii)&"\')><font color="&Dvbbs.mainsetting(3)&"><U>清空版面数据</U></font></a></div>"

if SQL(4,iii)=0 then
MoreMenu=MoreMenu & "<div class=menuitems><a href=# onclick=alertreadme(\'删除将包括该论坛的所有帖子，确定删除吗?\',\'board.asp?action=del&editid="&SQL(0,iii)&"\')><font color="&Dvbbs.mainsetting(3)&"><U>删除版面</U></font></a></div>"
else
MoreMenu=MoreMenu & "<div class=menuitems><a href=# onclick=alertreadme(\'该论坛含有下属论坛，必须先删除其下属论坛方能删除本论坛！\',\'#\')><font color="&Dvbbs.mainsetting(3)&"><U>删除版面</U></font></a></div>"
end if
MoreMenu=MoreMenu & "<div class=menuitems><a href=Board.asp?action=clearDate&boardid="&SQL(0,iii)&"><font color="&Dvbbs.mainsetting(3)&"><u>清理数据</u></font></a></div>"
If SQL(2,iii)=0 Then
	MoreMenu=MoreMenu & "<div class=menuitems><a href=# onclick=alertreadme(\'复位该分类将会把该分类下的所有版面都复位成二级版面，包括原来的多级分类都将复位成二级版面，请慎重操作，确定复位吗?\',\'?action=RestoreClass&classid="&SQL(0,iii)&"\')><font color="&Dvbbs.mainsetting(3)&"><u>复位该分类</u></font></a></div><div class=menuitems><a href=?action=handorders&classid="&SQL(0,iii)&"><font color="&Dvbbs.mainsetting(3)&"><u>分类排序(手动)</u></font></a></div>"
End If
%>
 | <a href="#" onMouseOver="showmenu(event,'<%=MoreMenu%>')" style="CURSOR:hand"><font color=<%=Dvbbs.mainsetting(3)%>><u>更多操作</u></font></a>
<%
if reBoard_Setting(2)=1 then
	Response.Write "<a href=board.asp?action=mode&boardid="&SQL(0,iii)&"><font color="&Dvbbs.mainsetting(3)&"><U>认证用户</U></font></a>"
end if
%>
</td></tr>
<%
MoreMenu=""
Next
End If
%>
</table><BR><BR>
<SCRIPT LANGUAGE="JavaScript">
<!--
function alertreadme(str,url){
{if(confirm(str)){
location.href=url;
return true;
}return false;}
}
//-->
</SCRIPT>
<%
end sub

sub add()
dim rs_c,sql,Rs
Dim forum_sid,forum_cid,Style_Option,TempOption
Dim iCssName,iCssID,iStyleName
set rs_c= server.CreateObject ("adodb.recordset")
sql = "select * from dv_board order by rootid,orders"
rs_c.open sql,conn,1,1
	dim boardnum,i
	set rs = server.CreateObject ("Adodb.recordset")
	sql="select Max(boardid) from dv_board"
	rs.open sql,conn,1,1
	if rs.eof and rs.bof then
	boardnum=1
	else
	boardnum=rs(0)+1
	end if
	if isnull(boardnum) then boardnum=1
	if boardnum=444 then boardnum=445
	if boardnum=777 then boardnum=778
	rs.close
%>
<form action ="board.asp?action=savenew" method=post name=theform>
<input type="hidden" name="newboardid" value=<%=boardnum%>>
<table width="100%" border="0" cellspacing="1" cellpadding="0" align="center">
<tr> 
<th colspan=2 style="text-align:center;"><B>添加新论坛</th>
</tr>
<tr> 
<td width="100%" height=30 class="td2" colspan=2>
说明：<BR>1、添加论坛版面后，相关的设置均为默认设置，请返回论坛版面管理首页版面列表的高级设置中设置该论坛的相应属性，如果您想对该论坛做更具体的权限设置，请到<A HREF="board.asp?action=permission"><font color=blue>论坛权限管理</font></A>中设置相应用户组在该版面的权限。<BR>
2、<font color=blue>如果您添加的是论坛分类</font>，只需要在所属分类中选择作为论坛分类即可；<font color=blue>如果您添加的是论坛版面</font>，则要在所属分类中确定并选择该论坛版面的上级版面。
</td>
</tr>
<tr> 
<td width="40%" height=30 class="td1">论坛名称</td>
<td width="60%" class="td1"> 
<input type="text" name="boardtype" size="35">
</td>
</tr>
<tr> 
<td width="40%" height=24 class="td1">版面说明<BR>可以使用HTML代码</td>
<td width="60%" class="td1"> 
<textarea name="Readme" cols="50" rows="5"></textarea>
</td>
</tr>
<tr> 
<td width="40%" height=24 class="td1">版面规则<BR>可以使用HTML代码</td>
<td width="60%" class="td1"> 
<textarea name="Rules" cols="50" rows="5"></textarea>
</td>
</tr>
<tr> 
<td width="40%" height=30 class="td1"><U>所属类别</U></td>
<td width="60%" class="td1"> 
<select name="class" id="Boardid"></select>
<SCRIPT LANGUAGE="JavaScript">
<!--
BoardJumpListSelect('<%=Dvbbs.CheckNumeric(Request("editid"))%>','Boardid','做为论坛分类','0','0');
//-->
</SCRIPT>
</td>
</tr>
<tr> 
<td width="40%" height=30 class="td1"><U>使用样式风格</U><BR>相关样式风格中包含论坛颜色、图片<BR>等信息</td>
<td width="60%" class="td1">
<%
	set rs_c=dvbbs.execute("select forum_sid,forum_cid from dv_setup")
	Forum_sid=rs_c(0)
'	Forum_cid=rs_c(1)
	rs_c.close:Set rs_c=Nothing
%>
<Select Size=1 Name="sid">
<%
Dim Templateslist
For Each Templateslist in Application(Dvbbs.CacheName &"_style").documentElement.selectNodes("style")
	Response.Write "<Option value="""& Templateslist.selectSingleNode("@id").text &""""
	If Forum_sid = CLng(Templateslist.selectSingleNode("@id").text) Then Response.Write " selected "
	Response.Write ">"& Templateslist.selectSingleNode("@type").text &" </Option>"
Next
%>
</td>
</tr>
<tr> 
<td width="40%" height=30 class="td1"><U>论坛版主</U><BR>多版主添加请用|分隔，如：沙滩小子|wodeail</td>
<td width="60%" class="td1"> 
<input type="text" name="boardmaster" size="35">
</td>
</tr>
<tr> 
<td width="40%" height=30 class="td1"><U>首页显示论坛图片</U><BR>出现在首页论坛版面介绍左边<BR>请直接填写图片URL</td>
<td width="60%" class="td1">
<input type="text" name="indexIMG" size="35">
</td>
</tr>
<tr> 
<td width="40%" height=24 class="td1">&nbsp;</td>
<td width="60%" class="td1"> 
<input type="submit" name="Submit" value="添加论坛" class="button">
</td>
</tr>
</table>
</form>
<%
set rs_c=nothing
set rs=nothing
end sub

sub edit()
dim rs_c,reBoard_Setting,rs,sql
Dim forum_sid,forum_cid,Style_Option,TempOption
Dim iCssName,iCssID,iStyleName,i
sql = "select * from dv_board order by rootid,orders"
set rs_c=Dvbbs.Execute(sql)
sql = "select * from dv_board where boardid="&Dvbbs.CheckNumeric(request("editid"))
set rs=Dvbbs.Execute(sql)
reBoard_Setting=split(rs("Board_setting"),",")

forum_sid=rs("sid")
'forum_cid=rs("cid")
%>
<form action ="board.asp?action=savedit" method=post name=theform>
<input type="hidden" name=editid value="<%=Request("editid")%>">
<table width="100%" border="0" cellspacing="1" cellpadding="0" align="center">
<tr> 
<th colspan=2 style="text-align:center;">编辑论坛：<%=rs("boardtype")%></th>
</tr>
<tr> 
<td width="100%" height=30 class="td2" colspan=2>
说明：<BR>1、添加论坛版面后，相关的设置均为默认设置，请返回论坛版面管理首页版面列表的高级设置中设置该论坛的相应属性，如果您想对该论坛做更具体的权限设置，请到<A HREF="board.asp?action=permission"><font color=blue>论坛权限管理</font></A>中设置相应用户组在该版面的权限。<BR>
2、<font color=blue>如果您添加的是论坛分类</font>，只需要在所属分类中选择作为论坛分类即可；<font color=blue>如果您添加的是论坛版面</font>，则要在所属分类中确定并选择该论坛版面的上级版面
</td>
</tr>
<tr> 
<td width="40%" height=30 class="td1">论坛名称</td>
<td width="60%" class="td1"> 
<input type="text" name="boardtype" size="35" value="<%=Server.htmlencode(rs("boardtype"))%>" >
</td>
</tr>
<tr> 
<td width="40%" height=24 class="td1">版面说明<BR>可以使用HTML代码</td>
<td width="60%" class="td1"> 
<textarea name="Readme" cols="50" rows="5"><%=server.HTMLEncode(Rs("readme")&"")%></textarea>
</td>
</tr>
<tr> 
<td width="40%" height=24 class="td1">版面规则<BR>可以使用HTML代码</td>
<td width="60%" class="td1"> 
<textarea name="Rules" cols="50" rows="5"><%=server.HTMLEncode(Rs("Rules")&"")%></textarea>
</td>
</tr>
<tr> 
<td width="40%" height=30 class="td1"><U>所属类别</U><BR>所属论坛不能指定为当前版面<BR>所属论坛不能指定为当前版面的下属论坛</td>
<td width="60%" class="td1"> 
<select name=class>
<option value="0">做为论坛分类</option>
<% do while not rs_c.EOF%>
<option value="<%=rs_c("boardid")%>" <% if cint(rs("parentid")) = rs_c("boardid") then%> selected <%end if%>>
<%if rs_c("depth")>0 then%>
<%for i=1 to rs_c("depth")%>&nbsp;&nbsp;|<%next%>
<%end if%>&nbsp;├&nbsp;<%=rs_c("boardtype")%></option>
<%
rs_c.MoveNext 
loop
rs_c.Close 
%>
</select>
</td>
</tr>
<tr> 
<td width="40%" height=30 class="td1"><U>使用样式风格</U><BR>相关样式风格中包含论坛颜色、图片<BR>等信息</td>
<td width="60%" class="td1">
<%
	set rs_c=dvbbs.execute("select forum_sid,forum_cid from dv_setup")
	Forum_sid=rs_c(0)
	Forum_cid=rs_c(1)
	rs_c.close:Set rs_c=Nothing
%>
<Select Size=1 Name="sid">
<%
Dim Templateslist
For Each Templateslist in Application(Dvbbs.CacheName &"_style").documentElement.selectNodes("style")
	Response.Write "<Option value="""& Templateslist.selectSingleNode("@id").text &""""
	If rs("sid") = CLng(Templateslist.selectSingleNode("@id").text) Then Response.Write " selected "
	Response.Write ">"& Templateslist.selectSingleNode("@type").text &" </Option>"
Next
%>
</td>
</tr>
<tr> 
<td width="40%" height=30 class="td1"><U>论坛版主</U><BR>多斑竹添加请用|分隔，如：沙滩小子|wodeail</td>
<td width="60%" class="td1"> 
<input type="text" name="boardmaster" size="35" value='<%=rs("boardmaster")%>'>
<input type="hidden" name="oldboardmaster" value='<%=rs("boardmaster")%>'>
</td>
</tr>
<tr> 
<td width="40%" height=30 class="td1"><U>首页显示论坛图片</U><BR>出现在首页论坛版面介绍左边<BR>请直接填写图片URL</td>
<td width="60%" class="td1">
<input type="text" name="indexIMG" size="35" value="<%=rs("indexIMG")%>">
</td>
</tr>
<tr> 
<td width="40%" height=24 class="td1">&nbsp;</td>
<td width="60%" class="td1"> 
<input type="submit" name="Submit" value="提交修改" class="button">
</td>
</tr>
<tr> 
<td width="100%" height=30 class="td2" colspan=2 align=right>
<a href="board.asp?action=add&editid=<%=Request("editid")%>"><font color="<%=Dvbbs.mainsetting(3)%>"><U>添加版面</U></font></a> | <a href="board.asp?action=edit&editid=<%=Request("editid")%>"><font color="<%=Dvbbs.mainsetting(3)%>"><U>基本设置</U></font></a> | <a href="BoardSetting.asp?editid=<%=Request("editid")%>"><font color="<%=Dvbbs.mainsetting(3)%>"><U>高级设置</U></font></a>
<%if reBoard_Setting(2)=1 then%>
| <a href="board.asp?action=mode&boardid=<%=Request("editid")%>"><font color="<%=Dvbbs.mainsetting(3)%>"><U>认证用户</U></font></a>
<%end if%>
| <a href="update.asp?action=updat&submit=更新论坛数据&boardid=<%=Request("editid")%>" title="更新最后回复、帖子数、回复数"><font color="<%=Dvbbs.mainsetting(3)%>"><U>更新数据</U></font></a> | <a href="update.asp?action=delboard&boardid=<%=Request("editid")%>" onclick="{if(confirm('清空将包括该论坛所有帖子置于回收站，确定清空吗?')){return true;}return false;}"><font color="<%=Dvbbs.mainsetting(3)%>"><U>清空</U></font></a> | <%if rs("child")=0 then%><a href="board.asp?action=del&editid=<%=Request("editid")%>" onclick="{if(confirm('删除将包括该论坛的所有帖子，确定删除吗?')){return true;}return false;}"><font color="<%=Dvbbs.mainsetting(3)%>"><U>删除</U></a><%else%><a href="#" onclick="{if(confirm('该论坛含有下属论坛，必须先删除其下属论坛方能删除本论坛！')){return true;}return false;}"><font color="<%=Dvbbs.mainsetting(3)%>"><U>删除</U></a><%end if%>
| <a href="Board.asp?action=clearDate&boardid=<%=Request("editid")%>"> <font color="<%=Dvbbs.mainsetting(3)%>"><u>清理数据</u></a>
</td>
</tr>
</table>
</form>
<%
rs.close
set rs=nothing
set rs_c=nothing
end sub

Sub Mode()
	Dim Boarduser
	Dim BoarduserNum
	Dim Rs,Sql
%>
<form action ="board.asp?action=savemod" method=post>
<table width="100%" cellspacing="1" cellpadding="1" align="center">
<tr> 
<th width="52%">说明：</th>
<th width="48%">操作：</th>
</tr>
<tr> 
<td width="52%" height=22 class=td1><B>论坛名称</B></td>
<td width="48%" class=td1> 
<%
Sql = "SELECT Boardid, Boardtype, Boarduser FROM Dv_Board WHERE Boardid = " & Dvbbs.CheckNumeric(Request("boardid"))
Set Rs = Dvbbs.Execute(Sql)
If Rs.Eof And Rs.Bof Then
	Response.Write "该版面并不存在或者该版面不是加密版面。"
Else
	Response.Write Rs(1)
	Response.Write "<input type=hidden value=" & Rs(0) & " name=boardid>"
	Boarduser = Rs(2)
End If
Set Rs = Nothing
%>
</td>
</tr>
<tr> 
<td width="52%" class=td1 valign=top><B>认证用户</B>：
<%
	If Not Isnull(Boarduser) Or Boarduser <> "" Then
		BoarduserNum = Split(Boarduser,",")
		Response.Write "（本版共有<font color=red>" & Ubound(BoarduserNum)+1 & "</font>位认证用户）"
	Else
		Response.Write "（本版暂时没有认证用户）"
	End If
%>
<br>
只有设定为认证论坛的论坛需要填写能够进入该版面的用户，每输入一个用户请确认用户名在论坛中存在，每个用户名用<B>回车</B>分开</font>
<%
If Clng(Dvbbs.Board_Setting(62))>0 Or Clng(Dvbbs.Board_Setting(63))>0 Then Response.Write "<BR><font color=blue>此版面设置了支付金币或点券方能进入，有效期为<font color=red>" & Clng(Dvbbs.Board_Setting(64)) & "</font>个月，请在每个用户名后面加上：=当前时间，每行效果如：admin="&Now&"</font>"
%>
</td>
<td width="48%" class=td1> 
<textarea cols="50" rows="3" name="vipuser" id="vipuser">
<%if not isnull(boarduser) or boarduser<>"" then
	response.write Replace(boarduser,",",Chr(10))
end if%></textarea>
<br><a href="javascript:admin_Size(-3,'vipuser')"><img src="skins/images/minus.gif" unselectable="on" border='0'></a> <a href="javascript:admin_Size(3,'vipuser')"><img src="skins/images/plus.gif" unselectable="on" border='0'></a>
</td>
</tr>
<tr> 
<td width="52%" height=22 class=td1>&nbsp;</td>
<td width="48%" class=td1> 
<input type="submit" name="Submit" value="设 定" class="button">
</td>
</tr>
</table>
</form>
<%
End Sub 

'保存编辑论坛认证用户信息
'入口：用户列表字符串
sub savemod()
	dim boarduser
	dim boarduser_1
	dim userlen
	dim updateinfo,i
	'清理付费论坛过期的认证用户 2005-3-10 Dv.Yz
	Dim Get_BoardUser_Money, BoardUser_Money
	Get_BoardUser_Money = False
	If Clng(Dvbbs.Board_Setting(62))>0 Or Clng(Dvbbs.Board_Setting(63))>0 Then Get_BoardUser_Money = True
	
	If trim(request("vipuser"))<>"" then
		boarduser=Replace(request("vipuser"),"'","")
		boarduser=split(boarduser,chr(13)&chr(10))
		For i = 0 To Ubound(Boarduser)
			If Not (Boarduser(i) = "" Or Boarduser(i) = " ") Then
				If Get_BoardUser_Money Then
					BoardUser_Money = Split(Boarduser(i),"=")
					If Not DateDiff("d",BoardUser_Money(1),Now()) > Cint(Dvbbs.Board_Setting(64))*30 Then
						Boarduser_1 = "" & Boarduser_1 & "" & Boarduser(i) & ","
					End If
				Else
					Boarduser_1 = "" & Boarduser_1 & "" & Boarduser(i) & ","
				End If
			End If
		Next
		userlen=len(boarduser_1)
		if boarduser_1<>"" then
			boarduser=left(boarduser_1,userlen-1)
			updateinfo=" boarduser='"&boarduser&"' "
			Dvbbs.Execute("update dv_board set "&updateinfo&" where boardid="&Dvbbs.CheckNumeric(request("boardid")))
			Dv_suc("论坛设置成功!<LI>成功添加认证用户："&boarduser&"<LI><a href=""?action=RestoreBoardCache"" >请执行重建版面缓存才能生效</a><br>")
			RestoreBoardCache()
		else
			Errmsg = errmsg + "你没有添加认证用户！"'response.write "你没有添加认证用户！"
			Dvbbs_Error()
			Exit Sub
		end if
	Else
		Errmsg = errmsg + "你没有添加认证用户！"'response.write "<p><font color=red>你没有添加认证用户</font><br><br>"
		Dvbbs_Error()
	End If
	
End Sub

'保存添加论坛信息
Sub savenew()
	If request("boardtype")="" Then
		Errmsg=Errmsg+"<br>"+"<li>请输入论坛名称。"
		founderr=true
	End If
	If request("class")="" Then
		Errmsg=Errmsg+"<br>"+"<li>请选择论坛分类。"
		founderr=true
	End If
	If request("readme")="" Then
		Errmsg=Errmsg+"<br>"+"<li>请输入论坛说明。"
		founderr=true
	End If
	If founderr=true Then
		dvbbs_error()
		exit sub
	End If
	Dim boardid,rootid,parentid,depth,orders,Fboardmaster,maxrootid,parentstr,rs,SQL
	If request("class")<>"0" Then
		Set rs=Dvbbs.Execute("select rootid,boardid,depth,orders,boardmaster,ParentStr from dv_board where boardid="&Dvbbs.CheckNumeric(request("class")))
		rootid=rs(0)
		parentid=rs(1)
		depth=rs(2)
		orders=rs(3)
		If depth+1>20 Then
			Errmsg="本论坛限制最多只能有20级分类"
		  dvbbs_error()
		  Exit Sub
		 End If 
		parentstr=rs(5)
	Else
		Set rs=Dvbbs.Execute("select max(rootid) from dv_board")
	  maxrootid=rs(0)+1
		If IsNull(MaxRootID) Then MaxRootID=1
	End If
	sql="select boardid from dv_board where boardid="&Dvbbs.CheckNumeric(request("newboardid"))
	Set rs=Dvbbs.Execute(sql)
	If not (rs.eof and rs.bof) then
		Errmsg="您不能指定和别的论坛一样的序号。"
		dvbbs_error()
		exit sub
	Else
		boardid=request("newboardid")
	End If
	Dim trs,forumuser,setting
	Set trs=Dvbbs.Execute("select * from dv_setup")
	Setting=Split(trs("Forum_Setting"),"|||")
	forumuser=Setting(2)
	set rs = server.CreateObject ("adodb.recordset")
	sql = "select * from dv_board"
	rs.Open sql,conn,1,3
	rs.AddNew
	If request("class")<>"0" Then
		rs("depth")=depth+1
		rs("rootid")=rootid
		rs("orders") = Request.form("newboardid")
		rs("parentid") = Request.Form("class")
		if ParentStr="0" then
		rs("ParentStr")=Request.Form("class")
	Else
	 rs("ParentStr")=ParentStr & "," & Request.Form("class")
	End If
	Else
		rs("depth")=0
		rs("rootid")=maxrootid
		rs("orders")=0
		rs("parentid")=0
		rs("parentstr")=0
		end if
		rs("boardid") = Request.form("newboardid")
		rs("boardtype") = request.form("boardtype")
		rs("readme") = Request.form("readme")
		rs("Rules") = Request.form("Rules")
		rs("TopicNum") = 0
		rs("PostNum") = 0
		rs("todaynum") = 0
		rs("child")=0
		rs("LastPost")="$0$"&Now()&"$$$$$"
		rs("Board_Setting")="0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,16240,3,0,gif|jpg|jpeg|bmp|png|rar|txt|zip|mid,0,0,1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1,0,1,100,20,10,9,normal,1,10,10,0,0,0,0,1,0,0,1,4,0,0,0,200,0,0,,$$,0,0,0,1,0|0|0|0|0|0|0|0|0,0|0|0|0|0|0|0|0|0,0,0,0,0,0,0,0,0,0,灌水|广告|奖励|惩罚|好文章|内容不符|重复发帖,0,1,0,24,0,0"
		rs("sid")=Dvbbs.CheckNumeric(request.form("sid"))
'		rs("cid")=Dvbbs.CheckNumeric(request.form("cid"))
		rs("board_ads")=trs("forum_ads")
		rs("board_user")=forumuser
		If Request("boardmaster")<>"" Then 
			rs("boardmaster") = Request.form("boardmaster")
		End If
	If request.form("indexIMG")<>"" Then
		rs("indexIMG")=request.form("indexIMG")
	End If
	rs.Update 
	rs.Close
	If Request("boardmaster")<>"" Then Call addmaster(Request("boardmaster"),"none",0)
	dv_suc("论坛添加成功！<br>该论坛目前高级设置为默认选项，建议您返回论坛管理中心重新设置该论坛的高级选项，<A HREF=BoardSetting.asp?editid="&Request.form("newboardid")&">点击此处进入该版面高级设置</A><br>" & str)
	set rs=nothing
	trs.close
	set trs=nothing
	CheckAndFixBoard 0,1
	RestoreBoardCache()
End Sub

'保存编辑论坛信息
Sub savedit()
	if clng(request("editid"))=clng(request("class")) then
		Errmsg="所属论坛不能指定自己"
		dvbbs_error()
		exit sub
	end if
	dim newboardid,maxrootid,readme,Rules
	dim parentid,boardmaster,depth,child,ParentStr,rootid,iparentid,iParentStr
	dim trs,brs,mrs
	Dim iii,rs,sql
	set rs = server.CreateObject ("adodb.recordset")
	sql = "select * from dv_board where boardid="&request("editid")
	rs.Open sql,conn,1,3
	newboardid=rs("boardid")
	parentid=rs("parentid")
	iparentid=rs("parentid")
	boardmaster=rs("boardmaster")
	ParentStr=rs("ParentStr")
	depth=rs("depth")
	child=rs("child")
	rootid=rs("rootid")
	'判断所指定的论坛是否其下属论坛
	if ParentID=0 then
		if clng(request("class"))<>0 then
		set trs=Dvbbs.Execute("select rootid from dv_board where boardid="&request("class"))
		if rootid=trs(0) then
			errmsg="您不能指定该版面的下属论坛作为所属论坛1"
			dvbbs_error()
			exit sub
		end if
		end if
	else
		set trs=Dvbbs.Execute("select boardid from dv_board where ParentStr like '%"&ParentStr&","&newboardid&"%' and boardid="&request("class"))
		if not (trs.eof and trs.bof) then
			errmsg="您不能指定该版面的下属论坛作为所属论坛2"
			dvbbs_error()
			exit sub
		end if
	end if

	If parentid=0 then
		parentid=rs("boardid")
		iparentid=0
	Else
		Set mrs=Dvbbs.Execute("select max(rootid) from dv_board")
			Maxrootid=mrs(0)+1
		mrs.close:Set mrs=Nothing
		rs("rootid")=Maxrootid
	End if
	rs("boardtype") = Request.Form("boardtype")	'取消JS过滤。
	rs("parentid") = Request.Form("class")
	rs("boardmaster") = Request("boardmaster")
	rs("readme") = Request("readme")
	rs("Rules") = Request.form("Rules")
	rs("indexIMG")=request.form("indexIMG")
	rs("sid")=Cint(request.form("sid"))
'	rs("cid")=Cint(request.form("cid"))
	rs.Update 
	rs.Close:set rs=nothing
	if request("oldboardmaster")<>Request("boardmaster") then call addmaster(Request("boardmaster"),request("oldboardmaster"),1)
	
	dv_suc("论坛修改成功！<br>" & str)
	CheckAndFixBoard 0,1
	Boardchild()
	RestoreBoardCache()
End sub

'删除版面，删除版面帖子，入口：版面ID
Sub Del()
	Dim Trs,EditId
	EditId = Dvbbs.CheckNumeric(Request("editid"))
	'更新其上级版面论坛数，如果该论坛含有下级论坛则不允许删除
	Set tRs = Dvbbs.Execute("SELECT RootID FROM Dv_Board WHERE BoardID = " & EditId)
	Dim UpdateRootID,Rs,sql,i
	UpdateRootID = tRs(0)
	Set Rs = Dvbbs.Execute("SELECT ParentStr, Child, Depth FROM Dv_Board WHERE BoardID = " &  EditId)
	If Not (Rs.Eof And Rs.Bof) Then
		If Rs(1) > 0 Then
			Response.Write "该论坛含有下属论坛，请删除其下属论坛后再进行删除本论坛的操作"
			Exit Sub
		End If
		'如果有上级版面，则更新数据
		If Rs(2) > 0 Then
			Dvbbs.Execute("UPDATE Dv_Board SET Child = Child - 1 WHERE BoardID IN (" & Rs(0) & ")")
		End If
		Sql = "DELETE FROM Dv_Board WHERE Boardid = " & EditId
		Dvbbs.Execute(Sql)
		For i = 0 To Ubound(AllPostTable)
			Sql = "DELETE FROM " & AllPostTable(i) & " WHERE BoardID = " & EditId
			Dvbbs.Execute(Sql)
		Next
		Dvbbs.Execute("DELETE FROM Dv_Topic WHERE BoardID = " & EditId)
		Dvbbs.Execute("DELETE FROM Dv_BestTopic WHERE BoardID = " & EditId)
		Dvbbs.Execute("DELETE FROM Dv_Upfile WHERE F_BoardID = " & EditId)
		Dvbbs.Execute("DELETE FROM Dv_Appraise WHERE BoardID = " & EditId)
		'删除被删除论坛的自定义用户权限 2004-11-15 Dv.Yz
		Dvbbs.Execute("DELETE FROM Dv_UserAccess WHERE NOT Uc_BoardID IN (SELECT BoardID FROM Dv_Board)")
	End If
	Set Rs = Nothing
	CheckAndFixBoard 0,1
	RestoreBoardCache()
	Dv_suc("论坛删除成功！")
End Sub

sub orders()
	Dim rs,SQL
%>
<table width="100%" border="0" cellspacing="1" cellpadding="3" align="center">
	<tr> 
	<th style="text-align:center;">论坛一级分类重新排序修改(请在相应论坛分类的排序表单内输入相应的排列序号)
	</th>
	</tr>
	<tr>
	<td class="td1"><table width="50%">
<%
	set rs = server.CreateObject ("Adodb.recordset")
	sql="select * from dv_Board where ParentID=0 order by RootID"
	rs.open sql,conn,1,1
	if rs.eof and rs.bof then
		response.write "还没有相应的论坛分类。"
	else
		do while not rs.eof
		response.write "<form action=board.asp?action=updatorders method=post><tr><td width=""50%"">"&rs("boardtype")&"</td>"
		response.write "<td width=""50%""><input type=text name=""OrderID"" size=4 value="""&rs("rootid")&"""><input type=hidden name=""cID"" value="""&rs("rootid")&""">&nbsp;&nbsp;<input type=submit name=Submit value=修改 class=button></td></tr></form>"
		rs.movenext
		loop
%>
</table>
<BR>&nbsp;<font color=red>请注意，这里系统会<B>自动修复</B>不正确的序号！</font>
<%
	end if
	rs.close
	set rs=nothing
%>
	</td>
	</tr>
</table>
<%
end sub

sub updateorders()
	dim cID,OrderID,ClassName,rs
	cID=Dvbbs.CheckNumeric(request.form("cID"))
	OrderID=Dvbbs.CheckNumeric(request.form("OrderID"))
	set rs=Dvbbs.Execute("select boardid from dv_board where rootid="&orderid)
	If rs.eof and rs.bof Then
		Dvbbs.Execute("update dv_board set rootid="&OrderID&" where rootid="&cID)
		Dv_suc("设置成功")
	Else
		Errmsg = errmsg + "请不要和其他论坛设置相同的序号"'response.write "请不要和其他论坛设置相同的序号"
		Dvbbs_Error()
	end if
	CheckAndFixBoard 0,1
	RestoreBoardCache()
end sub

Sub Boardorders()
%>
<table width="100%" border="0" cellspacing="1" cellpadding="3" align="center">
	<tr> 
	<th style="text-align:center;">论坛N级分类重新排序修改(请在相应论坛分类的排序表单内输入相应的排列序号)
	</th>
	</tr>
	<tr>
	<td class="td1"><table width="90%">
<%
	Dim Trs,Uporders,Doorders,Rs,SQL,i
	Set Rs = Server.CreateObject ("Adodb.recordset")
	Sql = "SELECT Depth, Child, Parentid, Boardtype, Orders, BoardId FROM Dv_Board ORDER BY RootID, Orders"
	Set Rs = Dvbbs.Execute(Sql)
	If Rs.Eof And Rs.Bof Then
		Response.Write "还没有相应的论坛分类。"
	Else
		Sql = Rs.GetRows(-1)
		Dim Bn
		Rs.Close:Set Rs = Nothing
		For Bn = 0 To Ubound(Sql,2)
			Response.Write "<form action=board.asp?action=updatboardorders method=post><tr><td width=""50%"">"
			If Sql(0,Bn) > 0 Then
				For i = 1 To Sql(0,Bn)
					Response.Write "&nbsp;"
				Next
			End If
			If Sql(1,Bn) > 0 Then
				Response.Write "<img src=../skins/default/plus.gif>"
			Else
				Response.Write "<img src=../skins/default/nofollow.gif>"
			End If
			If Sql(2,Bn) = 0 Then
				Response.Write "<b>"
			End If
			Response.Write Sql(3,Bn)
			If Sql(1,Bn) > 0 Then
				Response.Write "(" & Sql(1,Bn) & ")"
			End If
			Response.Write "</td><td width=""50%"">"
			If Sql(2,Bn) > 0 Then
				'算出相同深度的版面数目，得到该版面在相同深度的版面中所处位置（之上或者之下的版面数）
				'所能提升最大幅度应为For i=1 to 该版之上的版面数
				Set Trs = Dvbbs.Execute("SELECT COUNT(*) FROM Dv_Board WHERE ParentID = " & Sql(2,Bn) & " AND ORDERS < " & Sql(4,Bn) &"")
				Uporders = Trs(0)
				If Isnull(Uporders) Then Uporders = 0
				'所能降低最大幅度应为For i=1 to 该版之下的版面数
				Set Trs = Dvbbs.Execute("SELECT COUNT(*) FROM Dv_Board WHERE ParentID = " & Sql(2,Bn) &" AND ORDERS > " & Sql(4,Bn) &"")
				Doorders = Trs(0)
				If Isnull(doorders) Then Doorders = 0
				If Uporders > 0 Then
					Response.Write "<select name=uporders size=1><option value=0>向上移动</option>"
					For i = 1 To Uporders
						Response.Write "<option value=" & i & ">" & i & "</option>"
					Next
					Response.Write "</select>"
				End If
				If Doorders > 0 Then
					If uporders > 0 Then Response.Write "&nbsp;"
					Response.Write "<select name=doorders size=1><option value=0>向下移动</option>"
					For i = 1 To Doorders
						Response.Write "<option value=" & i & ">" & i & "</option>"
					Next
					Response.Write "</select>"
				End If
				If Doorders > 0 Or Uporders > 0 Then
					Response.Write "<input type=hidden name=""editID"" value=""" & Sql(5,Bn) & """>&nbsp;<input type=submit name=Submit value=修改 class=button>"
				End If
			End If
			Response.Write "</td></tr></form>"
			Uporders = 0
			Doorders = 0
		Next
		Response.Write "</table>"
	End If
%>
	</td>
	</tr>
</table>
<%
End Sub

'N级分类移动 2004-10-18 Dv.Yz
Sub Updateboardorders()
	Dim Orders, tRs, Parentid
	Dim Uporders, Doorders
	Dim Frontorders, Nextorders, Lastorders
	Dim Rootid, Depth, Child, Parentstr, Rs, SQL
	If Not Isnumeric(Request("EditID")) Then
		Response.Write "非法的参数！"
		Exit Sub
	End If
	If Request("Uporders") <> "" And Not Cint(Request("Uporders")) = 0 Then
		If Not Isnumeric(Request("Uporders")) Then
			Response.Write "非法的参数！"
			Exit Sub
		Elseif Cint(Request("Uporders")) = 0 Then
			Response.Write "请选择要提升的数字！"
			Exit Sub
		End If
		Uporders = Cint(Request("Uporders"))
		'向上移动
		Set Rs = Dvbbs.Execute("SELECT Orders, Rootid, Depth, ParentID, Child, ParentStr FROM Dv_Board WHERE Boardid = " & Request("EditID"))
		Orders = Rs(0)
		Rootid = Rs(1)
		Depth = Rs(2)
		Parentid = Rs(3)
		Child = Rs(4)
		ParentStr = Rs(5) & "," & Request("EditID")
		Set Rs = Nothing

		'取Lastorders值
		Sql = "SELECT Top 1 Orders FROM Dv_Board WHERE Rootid = " & Rootid & " ORDER BY Orders DESC"
		Set Rs = Dvbbs.Execute(Sql)
		Lastorders = Rs(0)
		Set Rs = Nothing

		'取取移动结属ORDERS值
		If Child > 0 Then
			Sql = "SELECT COUNT(*) FROM Dv_Board WHERE ParentStr LIKE '%" & ParentStr & "%' AND Rootid = " & Rootid
			Set Rs = Dvbbs.Execute(Sql)
			Nextorders = Orders + Rs(0)
		Else
			Nextorders = Orders
		End If
		Doorders = Nextorders
		Set Rs = Nothing

		'取同级版面往上的版面ORDERS值
		Sql = "SELECT Top " & Uporders & " Orders FROM Dv_Board WHERE Rootid = " & Rootid & " AND Depth = " & Depth & " AND ParentID = " & Parentid & " AND Orders < " & Orders & " ORDER BY Orders Desc"
		Set Rs = Dvbbs.Execute(Sql)
		If Rs.Eof And Rs.Bof Then
			Frontorders = 0
		Else
			Sql = Rs.GetRows(-1)
			Frontorders = Sql(0,Ubound(Sql,2))
		End If

		'一次更新Orders
		Sql = "UPDATE Dv_Board SET Orders = Orders + " & Doorders & " WHERE Rootid = " & Rootid & " AND (Orders >= " & Frontorders & " AND Orders < " & Orders & " OR Orders > " & Nextorders & ")"
'		Response.Write Sql
		Dvbbs.Execute(Sql)

	Elseif Request("Doorders") <> "" Then
		If Not Isnumeric(Request("Doorders")) Then
			Response.Write "非法的参数！"
			Exit Sub
		Elseif Cint(Request("doorders")) = 0 Then
			Response.Write "请选择要下降的数字！"
			Exit Sub
		End If
		Uporders = Cint(Request("doorders"))
		'向下移动
		Set Rs = Dvbbs.Execute("SELECT Orders, Rootid, Depth, ParentID, Child, ParentStr FROM Dv_Board WHERE Boardid = " & Request("EditID"))
		Orders = Rs(0)
		Rootid = Rs(1)
		Depth = Rs(2)
		Parentid = Rs(3)
		Child = Rs(4)
		ParentStr = Rs(5) & "," & Request("EditID")
		Set Rs = Nothing

		'取Lastorders值
		Sql = "SELECT Top 1 Orders FROM Dv_Board WHERE Rootid = " & Rootid & " ORDER BY Orders DESC"
		Set Rs = Dvbbs.Execute(Sql)
		Lastorders = Rs(0)
		Set Rs = Nothing

		'取取移动结属ORDERS值
		If Child > 0 Then
			Sql = "SELECT COUNT(*) FROM Dv_Board WHERE ParentStr LIKE '%" & ParentStr & "%' AND Rootid = " & Rootid
			Set Rs = Dvbbs.Execute(Sql)
			Nextorders = Orders + Rs(0)
		Else
			Nextorders = Orders
		End If
		Set Rs = Nothing

		'取同级版面移下后上一个版面ORDERS值
		Sql = "SELECT Top " & Uporders + 1 & " Orders, Child, ParentStr, BoardID FROM Dv_Board WHERE Rootid = " & Rootid & " AND Depth = " & Depth & " AND ParentID = " & Parentid & " AND Orders > " & Orders & " ORDER BY Orders"
		Set Rs = Dvbbs.Execute(Sql)
		If Rs.Eof And Rs.Bof Then
			Frontorders = Lastorders
		Else
			Sql = Rs.GetRows(-1)
			Frontorders = Sql(0,Ubound(Sql,2)) - 1
			If Not Ubound(Sql,2) = Uporders Then
				If Sql(1,Ubound(Sql,2)) > 0 Then
					ParentStr = Sql(2,Ubound(Sql,2)) & "," & Sql(3,Ubound(Sql,2))
					Set Rs = Dvbbs.Execute("SELECT COUNT(*) FROM Dv_Board WHERE ParentStr LIKE '%" & ParentStr & "%' AND Rootid = " & Rootid)
					Frontorders = Sql(0,Ubound(Sql,2)) + Rs(0)
				Else
					Frontorders = Sql(0,Ubound(Sql,2))
				End If
			End If
		End If
		Doorders = Frontorders

		'一次更新Orders
		Sql = "UPDATE Dv_Board SET Orders = Orders + " & Doorders & " WHERE Rootid = " & Rootid & " AND Orders >= " & Orders & " AND Orders <= " & Nextorders & " OR Orders > " & Frontorders
'		Response.Write Sql
		Dvbbs.Execute(Sql)

	End If
	CheckAndFixBoard 0,1
	RestoreBoardCache()
	Response.Redirect "board.asp?action=boardorders"
End Sub

Sub Addmaster(s,o,n)
	Dim Arr, Pw, Oarr
	Dim Classname, Titlepic, Rs, Sql, i
	Set Rs = Dvbbs.Execute("SELECT Usertitle, GroupPic FROM Dv_UserGroups WHERE Usergroupid = 3")
	If Not (Rs.Eof And Rs.Bof) Then
		Classname = Rs(0)
		Titlepic = Rs(1)
	End If
	Randomize
	Pw = CInt(Rnd * 9000) + CInt(Rnd * 9000) + 100000
	Arr = Split(s,"|")
	Oarr = Split(o,"|")
	Set Rs = Server.Createobject("Adodb.Recordset")
	For i = 0 To Ubound(Arr)
		Sql = "SELECT * FROM [Dv_User] WHERE Username = '" & Arr(i) & "'"
		Rs.Open Sql,Conn,1,3
		If Rs.Eof And Rs.Bof Then
			Rs.Addnew
			Rs("Username") = Arr(i)
			Rs("Userpassword") = Md5(Pw,16)
			Rs("Userclass") = Classname
			Rs("UserGroupID") = 3
			Rs("Titlepic") = Titlepic
			Rs("UserWealth") = 100
			Rs("Userep") = 30
			Rs("Usercp") = 30
			Rs("Userisbest") = 0
			Rs("Userdel") = 0
			Rs("Userpower") = 0
			Rs("Lockuser") = 0
			'加入更详细资料使登录与显示资料不会出错。
			Rs("UserSex") = 1
			Rs("UserEmail") = Arr(i) & "@aspsky.net"
			Rs("UserFace") = "Images/userface/image1.gif"
			Rs("UserWidth") = 32
			Rs("UserHeight") = 32
			Rs("UserIM") = "||||||||||||||||||"
			Rs("UserFav") = "陌生人,我的好友,黑名单"
			Rs("LastLogin") = Now()
			Rs("JoinDate") = Now()
			Rs("Userpost") = 0
			Rs("Usertopic") = 0
			Rs.Update
			Str = Str & "你添加了以下用户：<b>" & Arr(i) & "</b> 密码：<b>" & Pw & "</b><br><br>"
			Dvbbs.Execute("UPDATE Dv_Setup SET Forum_Usernum = Forum_Usernum + 1, Forum_Lastuser = '" & Arr(i) & "'")
		Else
			'修正添加版主不改变等级的错误 2005-3-7 Dv.Yz
			If Rs("UserGroupID") > 3 Then
				Rs("Userclass") = Classname
				Rs("UserGroupID") = 3
				Rs("Titlepic") = Titlepic
				Rs.Update
			End If
		End If
		Rs.Close
	Next
	'判断原版主在其他版面是否还担任版主，如没有担任则撤换该用户职位。
	If n = 1 Then
		Dim Iboardmaster
		Dim UserGrade, Article
		Iboardmaster = False
		For i = 0 To Ubound(Oarr)
			Set Rs = Dvbbs.Execute("SELECT Boardmaster FROM Dv_Board")
			Do While Not Rs.Eof
				If Instr("|" & Trim(Rs("Boardmaster")) & "|","|" & Trim(Oarr(i)) & "|") > 0 Then
					Iboardmaster = True
					Exit Do
				End If
				Rs.Movenext
			Loop
			If Not Iboardmaster Then
				Set Rs = Dvbbs.Execute("SELECT Userid, UserGroupID, UserPost FROM [Dv_User] WHERE Username = '" & Trim(Oarr(i)) & "'")
				If Not (Rs.Eof And Rs.Bof) Then
					If Rs(1) > 2 Then
						If Not Isnumeric(Rs(2)) Or Rs(2) = "" Then
							Article = 0
						Else
							Article = Cstr(Rs(2))
						End If
						'取对应注册会员的等级
						Set UserGrade = Dvbbs.Execute("SELECT TOP 1 Usertitle, Grouppic,UserGroupID FROM Dv_Usergroups WHERE Minarticle <= " & Article & " AND NOT MinArticle = -1 AND ParentGID = 4 ORDER BY MinArticle DESC")
						If Not (UserGrade.Eof And UserGrade.Bof) Then
							Dvbbs.Execute("UPDATE [Dv_User] SET UserGroupID = 10, Titlepic = '" & UserGrade(1) & "', Userclass = '" & UserGrade(0) & "' WHERE Userid = " & Rs(0))
						End If
						UserGrade.Close:Set UserGrade = Nothing
					End If
				End If
			End If
			Iboardmaster = False
		Next
	End If
	Set Rs = Nothing
End Sub

Rem 分版面用户权限设置 重写2004-5-2 Dvbbs.YangZheng
Sub BoardPerMission()
	Dim iUserGroupID(100), UserTitle(100),iParentID(100)
	Dim Trs, Ars, k, ii
	Dim Bn,Sql
	Set Trs = Dvbbs.Execute("SELECT Usertitle,Usergroupid,ParentGID FROM Dv_UserGroups WHERE Not ParentGID=0 ORDER BY ParentGID,UserGroupId")
	If Not (Trs.Eof And Trs.Bof) Then
		Sql = Trs.GetRows(-1)
		Trs.Close:Set Trs = Nothing
		For ii = 0 To Ubound(Sql,2)
			UserTitle(ii) = Sql(0,ii)
			iUserGroupID(ii) = Sql(1,ii)
			iParentID(ii) = Sql(2,ii)
		Next
	End If
%>
<table width="100%" border="0" cellspacing="1" cellpadding="3" align="center">
	<tr>
	<th style="text-align:center;">编辑论坛权限</th>
	</tr>
	<tr>
	<td class=td1>
	①您可以设置不同用户组在不同论坛内的权限，红色表示为该论坛该用户组使用的是用户定义属性<BR>
	②该权限不能继承，比如您设置了一个包含下级论坛的版面，那么只对您设置的版面生效而不对其下属论坛生效<BR>
	③如果您想设置生效，必须在设置页面<B>选择自定义设置</B>，选择了自定义设置后，这里设置的权限将<B>优先</B>于用户组设置，比如用户组默认不能管理帖子，而这里设置了该用户组可管理帖子，那么该用户组在这个版面就可以管理帖子
	</td>
	</tr>
</table><BR>
<table width="100%" cellspacing="1" cellpadding="1" align="center">
<tr> 
<th width="35%">论坛版面
</th>
<th width="35%">设置用户组权限
</th>
</tr>
<%
	Dim Percount,Rs,i
	Dim hasc
	Sql = "SELECT Depth, Child, Parentid, BoardType, Boardid,IsGroupSetting FROM Dv_Board ORDER BY Rootid, Orders"
	Set Rs = Dvbbs.Execute(Sql)
	If Not (Rs.Eof And Rs.Bof) Then
		Sql = Rs.GetRows(-1)
		Set Rs = Nothing
		For Bn = 0 To Ubound(Sql,2)
			Response.Write "<tr><td height=25 width=40% class=td1>"
			If Sql(0,Bn) > 0 Then
				For i = 1 To Sql(0,Bn)
					Response.Write "&nbsp;"
				Next
			End If
			If Sql(1,Bn) > 0 Then
				Response.Write "<img src=../skins/default/plus.gif>"
			Else
				Response.Write "<img src=../skins/default/nofollow.gif>"
			End If
			If Sql(2,Bn) = 0 Then
				Response.Write "<b>"
			End If
			Response.Write Sql(3,Bn)
			If Sql(1,Bn) > 0 Then
				Response.Write "(" & Sql(1,Bn) & ")"
			End If
			'Percount = Dvbbs.Execute("SELECT COUNT(*) FROM Dv_BoardPermission WHERE Boardid = " & Sql(4,Bn))(0)
%>
</td>
<FORM METHOD=POST ACTION="?action=editpermission">
<td width=60% class="td1">&nbsp;
<select name="groupid" size=1>
<%
			hasc = 0
			For k = 0 To ii-1
				Response.Write "<option value=""" & iUserGroupID(k) & """>" & SysGroupName(iParentID(k)) & UserTitle(k)
				If Sql(5,Bn)<>"" Then
					Set Ars = Dvbbs.Execute("SELECT Pid FROM Dv_BoardPerMission WHERE BoardID = " & Sql(4,Bn) & " AND GroupID = " & iUserGroupID(k))
					If Not Ars.Eof Then
						Response.Write "(自定义)"
						hasc=1
					End If
				End If
				Response.Write "</option>"
			Next
			Response.Write "</select><input type=hidden value="
			Response.Write Sql(4,Bn)
			Response.Write " name=reboardid><input type=submit name=submit value=设置 class=button>"
			If hasc=1 Then
				Response.Write "(有自定义版面)"
			End If
			Response.Write "</td></FORM></tr>"
		Next
	End If
	Response.Write "</table><BR><BR>"
	Set Ars = Nothing
	Set Trs = Nothing
End Sub

Sub editpermission()
	if not isnumeric(request("groupid")) Or request("groupid")="" Or request("reBoardID")="" Or not isnumeric(request("reBoardID")) then
	response.write "错误的参数，请返回分版面权限设置首页选择正确的设置！"
	exit sub
	end if
	if request("groupaction")="yes" then
		dim GroupSetting,rspid,SaveGroupid,NewGroupid
		Dim IsGroupSetting,MyIsGroupSetting
		Dim Sql,i,k
		Dim UpdateStr,OldStr,NewStr
		GroupSetting=GetGroupPermission
		If Not IsNumeric(Replace(Request.Form("GroupID"),",","")) or Request.Form("GroupID")="" Then
			Errmsg = ErrMsg + "<BR><li>请选择对应的用户组。"
			Dvbbs_Error()
			Exit Sub
		End If
		SaveGroupid = Request.Form("groupid")
		Set rs= Server.CreateObject("ADODB.Recordset")
		if Request("isdefault")=1 then
			'清理ID
			Dvbbs.Execute("Delete from dv_BoardPermission where BoardID="&request.Form("reBoardID")&" and GroupID in ("&SaveGroupid&")")
		Else
			'使用自定义
			sql="Select Pid,GroupID,PSetting from dv_BoardPermission where BoardID="&request("reBoardID")&" And GroupID in ("&SaveGroupid&") "
			NewGroupid = ","&SaveGroupid&","
			Set Rs=Dvbbs.Execute(sql)
			If Not Rs.eof And Not Rs.bof Then
				If Instr(SaveGroupid,",")=0 Then
					sql="update dv_BoardPermission set PSetting='"&GroupSetting&"' where pid="&Rs(0)
					Dvbbs.Execute(Sql)
					NewGroupid = ""
				Else
					Do while Not Rs.Eof
						NewStr = Split(GroupSetting,",")
						OldStr = Split(Rs(2),",")
						UpdateStr = ""
						For K = 0 To 90
							If Request.Form("CheckGroupSetting("&K&")")="on" Then
								UpdateStr = UpdateStr & NewStr(k)
							Else
								UpdateStr = UpdateStr & OldStr(k)
							End If
							If K<90 Then
								UpdateStr = UpdateStr & ","
							End If
						Next
						sql="update dv_BoardPermission set PSetting='"&UpdateStr&"' where pid="&Rs(0)
						Dvbbs.Execute(Sql)
						NewGroupid = Replace(NewGroupid,","&Rs(1)&",",",")
					Rs.MoveNext
					Loop
				End If
			Else
				Dim iSaveGroupID
				iSaveGroupID = Split(SaveGroupid,",")
				For i = 0 To Ubound(iSaveGroupID)
					sql="insert into dv_BoardPermission (BoardID,GroupID,PSetting) values ("&request("reBoardID")&","&iSaveGroupID(i)&",'"&GroupSetting&"')"
					Dvbbs.Execute(Sql)
				Next
				NewGroupid = ""
			End If
			Set Rs=Nothing


			If Replace(NewGroupid,",","")<>"" Then
				'有新组添加
				NewGroupid = Split(NewGroupid,",")
				For i=1 to Ubound(NewGroupid)-1
					Sql = Dvbbs.Execute("select GroupSetting From Dv_UserGroups where UserGroupID="&NewGroupid(i))(0)
					If Sql<>"" Then
						NewStr = Split(GroupSetting,",")
						OldStr = Split(Sql,",")
						UpdateStr = ""
						For K = 0 To 90
							If Request.Form("CheckGroupSetting("&K&")")="on" Then
								UpdateStr = UpdateStr & NewStr(k)
							Else
								UpdateStr = UpdateStr & OldStr(k)
							End If
							If K<90 Then
								UpdateStr = UpdateStr & ","
							End If
						Next
						sql="insert into dv_BoardPermission (BoardID,GroupID,PSetting) values ("&request("reBoardID")&","&NewGroupid(i)&",'"&UpdateStr&"')"
						Dvbbs.Execute(Sql)
					End If
				Next
			End If
		End If

		'重新提取有自定义的ID
		Dim IsGroupSetting1
		IsGroupSetting=Get_board_AccUserList(CLng(request("reBoardID")))
		IsGroupSetting1=Get_Board_GroupSetting(CLng(request("reBoardID")))
		If IsGroupSetting="" Then
			IsGroupSetting=IsGroupSetting1
		ElseIf IsGroupSetting1<>"" Then
			IsGroupSetting=IsGroupSetting&","& IsGroupSetting1
		End If
		Dvbbs.Execute("update dv_Board set IsGroupSetting='"&IsGroupSetting&"' Where BoardID="&CLng(request("reBoardID")))
		RestoreBoardCache()
		Set Rs=Nothing
		Dv_suc("修改成功！")
Else
	Dim reGroupSetting,reBoardID,groupid
	Dim Groupname,Boardname,founduserper,rs
	founduserper=false
	if request("GroupID")<>"" then
	set rs=Dvbbs.Execute("select * from dv_BoardPermission where boardid="&request("reBoardID")&" and GroupID="&request("GroupID"))
	if rs.eof and rs.bof then
		founduserper=false
	else
	groupid=rs("groupid")
	reGroupSetting=rs("PSetting")
	reBoardID=rs("boardid")
	set rs=Dvbbs.Execute("select usertitle from dv_UserGroups where usergroupid="&groupid)
	groupname=rs("usertitle")
	founduserper=true
	end if
	if not founduserper then
	set rs=Dvbbs.Execute("select * from dv_usergroups where usergroupid="&request("groupid"))
	if rs.eof and rs.bof then
	response.write "未找到该用户组！"
	exit sub
	end if
	groupid=request("groupid")
	reGroupSetting=rs("GroupSetting")
	reBoardID=request("reBoardID")
	Groupname=rs("usertitle")
	end if
	end if
	set rs=Dvbbs.Execute("select boardtype from dv_board where boardid="&reBoardID)
	Boardname=rs("boardtype")
%>
<table width="100%" border="0" cellspacing="1" cellpadding="3" align="center">
<FORM METHOD=POST ACTION="?action=editpermission">
<input type=hidden name="groupid" value="<%=groupid%>">
<input type=hidden name="reBoardID" value="<%=reBoardID%>">
<input type=hidden name="pID" value="<%=request("pid")%>">
<tr> 
<th colspan="4" style="text-align:center;">编辑论坛用户组权限&nbsp;>> <%=boardname%>&nbsp;>> <%=groupname%></th>
</tr>
<tr> 
<td height="23" colspan="4" class=td1><input type=radio class="radio" name="isdefault" value="1" <%if not founduserper then%>checked<%end if%>><B>使用用户组默认值</B> (注意: 这将删除任何之前所做的自定义设置)</td>
</tr>
<tr> 
<td height="23" colspan="4" class=td1><input type=radio class="radio" name="isdefault" value="0" <%if founduserper then%>checked<%end if%>><B>使用自定义设置</B>&nbsp;(选择自定义才能使以下设置生效) </td>
</tr>
<tr> 
<td height="23" colspan="4" class=td1>
①<font color="red">在更新多个用户组设置时，请选取最左边的复选表单，只有选取的设置项目才会更新；</font>
<BR>②不执行多用户组更新时，不需要选取左边的复选表单；
<br><b>批量更新用户组设置</b>：<input type="button" value="选择用户组" class="button" onclick="getGroup('Select_Group');">
 <INPUT TYPE="checkbox" NAME="chkall" onclick="CheckAll(this.form);" class="checkbox">[全选]
</td>
</tr>
<%
GroupPermission(reGroupSetting)
%>
<input type=hidden value="yes" name="groupaction">
</FORM>
</table>
<%
Call Select_Group(Request("groupid"))
end if
end sub

sub RestoreBoard()
	'按照目前的排序循环i数值更新rootid
	'还原所有版面的depth,orders,parentid,parentstr,child为0
	Dim i,rs
	i=0
	set rs=Dvbbs.Execute("select boardid from dv_board order by rootid,orders")
	do while not rs.eof
	i=i+1
	Dvbbs.Execute("update dv_board set rootid="&i&",depth=0,orders=0,ParentID=0,ParentStr='0',child=0 where boardid="&rs(0))
	rs.movenext
	loop
	Set Rs=Nothing
	Dv_suc("请返回做论坛归属设置。复位")
	RestoreBoardCache()
End sub

Sub clearDate
	If Dvbbs.Boardid=0 Then
		errmsg=errmsg+"<br><li>请选择论坛版面"
		dvbbs_error()
		Exit Sub
	End If
	Dim Rs,str1,str2,str3,str4,i
	Set Rs=Dvbbs.Execute("Select Count(*) from dv_topic where Boardid="& Dvbbs.boardid &"")
	str1=Rs(0)
	str3=0
	str4=0
	For i= 0 to UBound(AllPostTable)
		Set Rs=Dvbbs.Execute("Select Count(*) from "&AllPostTable(i)&" where Boardid="& Dvbbs.boardid &"")
		str2=str2&"其中在"&AllPostTable(i)&"有"&Rs(0)&"篇文章，"
		str3=str3+Rs(0)
		Set Rs=Dvbbs.Execute("Select Count(*) from "&AllPostTable(i)&" where Boardid="& Dvbbs.boardid &" and isbest=1")
		str4=str4+Rs(0)
	Next
	Response.Write"<br>"
	Response.Write"<table cellpadding=0 cellspacing=0 align=center width=""100%"">"
	Response.Write"<tr align=center>"
	Response.Write"<th width=""100%"" colspan=2 style=""text-align:center;"">"
	Response.Write Dvbbs.BoardType
	Response.Write "-贴子信息"
	Response.Write"</td>"
	Response.Write"</tr>"
	Response.Write"<tr>"
	Response.Write"<td width=""100%"" class=""td2"" colspan=2>"
	Response.Write "<li>主题总数:<b>"
	Response.Write str1
	Response.Write "</b><li>文章总数:<b>"
	Response.Write str3
	Response.Write "</b><li>"
	Response.Write str2
	Response.Write "<li>有<B>"&str4&"</B>篇精华文章"
	Response.Write"</td></tr>"
	Response.Write "<form action =""?action=delDate&boardid="&Dvbbs.boardid&""" method=post>"
	Response.Write"<tr>"
	Response.Write"<td class=""td2"" valign=middle colspan=2 align=left><li>  清除<b>"
	Response.Write Dvbbs.BoardType
	Response.Write "</b>在 "
	Response.Write "<select name=""tablelist""><option value=""all"">所有数据表</option>"
	For i= 0 to UBound(AllPostTable)
		Response.Write "<option value="""&AllPostTable(i)&""">"
		Response.Write 	AllPostTableName(i)
		Response.Write "</option>"
	Next 
	Response.Write "</select>"
	Response.Write " 中 <input type=text name=dd value=365 size=5 > 天前的贴子"
	Response.Write " <input type=""submit"" name=""Submit"" value=""执 行"" class=""button""> <b>注意:此操作不可恢复！</b>其中精华贴不会被删除。<BR><BR>如果您的论坛数据众多，执行此操作将消耗大量的服务器资源，执行过程请耐心等候，最好选择夜间在线人少的时候更新。"
	Response.Write "</td></tr>"
	Response.Write "</form>"
	Response.Write"</table>"
End Sub
Sub delDate
	Dim i,rs,sql
	If Dvbbs.Boardid=0 Then
		errmsg=errmsg+"<br><li>请选择论坛版面"
		dvbbs_error()
		Exit Sub
	End If
	Dim tablelist
	If request.form("tablelist")<>"all" Then
		tablelist=Dvbbs.checkstr(request.form("tablelist"))
	Else
		For i= 0 to UBound(AllPostTable)
		If i=0 Then
			tablelist=AllPostTable(i)
		Else
			tablelist=tablelist&","&AllPostTable(i)
		End If
		Next
	End If
	tablelist=split(tablelist,",")
	Dim SqlTopic
	Dim k
	k=0
	For i= 0 to UBound(tablelist)
		'删除数据表记录
		If IsSqlDataBase=1 Then
			SqlTopic="Select TopicID,isvote,PollID from dv_Topic where Boardid="&Dvbbs.boardid&" and isbest=0 and PostTable='"&tablelist(i)&"' and Datediff(d,LastPostTime,"&SqlNowString&") > "& CLng(request.form("dd"))&" "
		Else
			SqlTopic="Select TopicID,isvote,PollID from dv_Topic where Boardid="&Dvbbs.boardid&" and isbest=0 and PostTable='"&tablelist(i)&"' and Datediff('d',LastPostTime,"&SqlNowString&") > "& CLng(request.form("dd"))&" "
		End If
		Set rs=Dvbbs.Execute(SqlTopic)
		Do While Not Rs.Eof
			Sql="Delete from "&tablelist(i)&" where Boardid="&Dvbbs.boardid&" and rootid="&RS(0)&""
			Dvbbs.Execute(Sql)
			If Rs(1)=1 And Not IsNull(Rs(2)) Then
				Sql="Delete from dv_vote where voteid="&RS(2)&""
				Dvbbs.Execute(Sql)
			End If 
			Dvbbs.Execute("Delete from Dv_Appraise where Boardid="&Dvbbs.boardid&" and Topicid="&RS(0)&"")
			Rs.movenext
			k=k+1
		Loop 
		'删除主题表记录
		If IsSqlDataBase=1 Then
		SqlTopic="Delete from dv_Topic where Boardid="&Dvbbs.boardid&" and isbest=0 and PostTable='"&tablelist(i)&"' and Datediff(d,LastPostTime,"&SqlNowString&") > "& CLng(request.form("dd"))&" "
		Else
		SqlTopic="Delete from dv_Topic where Boardid="&Dvbbs.boardid&" and isbest=0 and PostTable='"&tablelist(i)&"' and Datediff('d',LastPostTime,"&SqlNowString&") > "& CLng(request.form("dd"))&" "
		End If
		Dvbbs.Execute(SqlTopic) 
		Set rs=Nothing 	
	Next
	Response.Write "删除了"&k&"个主题。"
End Sub

Sub RestoreClass()
	Dim ClassID,RootID,RootIDNum,ParentID,Rs,i
	ClassID=Request("ClassID")
	If Not IsNumeric(ClassID) Or ClassID="" Then
		Response.Write "错误的版面参数！"
		Exit Sub
	Else
		ClassID=Clng(ClassID)
	End If
	Set Rs=Dvbbs.Execute("Select RootID,BoardID From Dv_Board Where BoardID="&ClassID)
	If Rs.Eof And Rs.Bof Then
		Response.Write "错误的版面参数！"
		Exit Sub
	Else
		RootID=Rs(0)
		ParentID=Rs(1)
	End If
	i=0
	Set Rs=Dvbbs.Execute("Select BoardID,ParentID From Dv_Board Where RootID="&RootID&" Order By ParentID,Orders,Depth")
	Do While Not Rs.Eof
		If Rs(1)=0 Then
			Dvbbs.Execute("UpDate Dv_Board Set Orders="&i&" Where BoardID="&Rs(0))
		Else
			Dvbbs.Execute("UpDate Dv_Board Set Orders="&i&",ParentID="&ParentID&",ParentStr='"&ParentID&"',Depth=1,child=0 Where BoardID="&Rs(0))
		End If
		i=i+1
	Rs.MoveNext
	Loop
	Set Rs=Dvbbs.Execute("Select Count(*) From Dv_Board Where RootID="&RootID)
	RootIDNum=Rs(0)
	If IsNull(RootIDNum) Or RootIDNum="" Then
		RootIDNum=0
	Else
		RootIDNum=RootIDNum-1
	End If
	Dvbbs.Execute("UpDate Dv_Board Set Child="&RootIDNum&" Where BoardID="&ClassID)
	dv_suc("复位分类成功！")
	RestoreBoardCache()
	Set Rs=Nothing
End Sub

Sub handorders()
%>
<table width="100%" border="0" cellspacing="1" cellpadding="3" align="center">
	<tr> 
	<th>论坛分类重新排序修改(请在相应论坛分类的排序表单内输入相应的排列序号)
	</th>
	</tr>
	<tr>
	<td class="td1">
	<B>注意</B>：<BR>
1、由于本论坛排序算法不是递归，所以请正确输入排序的序号，否则将引起论坛显示不正常，<font color=red>如果您未正确了解说明，请不要随意更改</font><BR>
2、一级分类排序序号为0，请正确输入，<font color=blue>所有输入框请输入数字</font><BR>
3、排序规则为数字最大的排在后面，<font color=blue>在这里不能用排序来指定某个版面的所属分类或版面</font>，如下为正确的排序输入方式：<BR>
<B>分类</B> 0<BR>
--二级版面A 1<BR>
--二级版面B 2<BR>
----三级版面A 3<BR>
----三级版面B 4<BR>
----三级版面C 5<BR>
--二级版面C 6<BR>
A.<font color=blue>要把三级版面C提到三级版面A上面</font>，则依次输入：分类(0)-二级A(1)-二级B(2)-三级A(<font color=red>4</font>)-三级B(<font color=red>5</font>)-三级C(<font color=red>3</font>)-二级C(6)<BR>
B.<font color=blue>要把二级版面C提到二级版面B上面</font>，则依次输入：分类(0)-二级A(1)-二级B(<font color=red>3</font>)-三级A(<font color=red>4</font>)-三级B(<font color=red>5</font>)-三级C(<font color=red>6</font>)-二级C(<font color=red>2</font>)<BR>
B.<font color=blue>要把二级版面B提到二级版面A上面</font>，则依次输入：分类(0)-二级A(<font color=red>5</font>)-二级B(<font color=red>1</font>)-三级A(<font color=red>2</font>)-三级B(<font color=red>3</font>)-三级C(<font color=red>4</font>)-二级C(6)
	</td></tr>
<form action="board.asp?action=savehandorders" method=post>
	<tr>
	<td class="td1"><table width="100%">
<%
dim trs,uporders,doorders,RootID,Rs,sql,i
Set Rs=Dvbbs.Execute("Select RootID From Dv_Board Where BoardID="&Dvbbs.CheckNumeric(Request("classid")))
If Rs.eof And Rs.bof Then
	response.write "还没有相应的论坛分类。"
	exit sub
Else
	RootID=Rs(0)
End If
set rs = server.CreateObject ("Adodb.recordset")
sql="select * from dv_Board Where RootID="&RootID&" order by RootID,orders"
rs.open sql,conn,1,1
if rs.eof and rs.bof then
	response.write "还没有相应的论坛分类。"
else
	do while not rs.eof
	response.write "<tr><td width=""50%"">"
	if rs("depth")>0 then
	for i=1 to rs("depth")
		response.write "&nbsp;"
	next
	end if
	if rs("child")>0 then
		response.write "<img src=../skins/default/plus.gif>"
	else
		response.write "<img src=../skins/default/nofollow.gif>"
	end if
	if rs("parentid")=0 then
		response.write "<b>"
	end if
	response.write rs("boardtype")
	if rs("child")>0 then
		response.write "("&rs("child")&")"
	end if
	response.write "</td><td width=""50%"">"
	Response.Write "<input type=hidden value="""&rs("boardid")&""" name=getboard>"
	Response.Write "<input type=text size=5 value="""&rs("orders")&""" name=orders>"
	response.write "</td></tr>"
	uporders=0
	doorders=0
	rs.movenext
	loop
	Response.Write "<tr><td class=td1><input type=submit name=submit value=提交 class=button></td></tr>"
	response.write "</table>"
end if
rs.close
set rs=nothing
%>
	</td>
	</tr></form>
</table>
<%
End Sub

Sub savehandorders()
	dim cID,OrderID,ClassName,i
	cID=replace(request.form("getboard"),"'","")
	OrderID=replace(request.form("Orders"),"'","")
	For i=1 to request.form("getboard").count
		cID=Dvbbs.CheckNumeric(request.form("getboard")(i))
		OrderID=Dvbbs.CheckNumeric(request.form("Orders")(i))
		Dvbbs.Execute("Update Dv_Board Set Orders="&OrderID&" Where BoardID="&cID)
	next
	Dv_suc("更改分类排序成功！")
	CheckAndFixBoard 0,1
	RestoreBoardCache()
End Sub

Sub RestoreBoardCache()	
	Dvbbs.Name="jsonboardlist0"
	Dvbbs.RemoveCache
	Dvbbs.Name="jsonboardlist1"
	Dvbbs.RemoveCache
	Dim Board
	Dvbbs.Name="0"
	Dvbbs.RemoveCache
	Dvbbs.LoadBoardList()

	For Each board in Application(Dvbbs.CacheName&"_boardlist").documentElement.selectNodes("board/@boardid")
		Dvbbs.LoadBoardData board.text
		Dvbbs.LoadBoardinformation board.text
	Next
	If Request("action")="RestoreBoardCache" Then dv_suc("重建所有版面缓存成功！")
End Sub
Sub CheckAndFixBoard(ParentID,orders)
	Dim Rs,SQL,Child,ParentStr,i
	If ParentID=0 Then
		Dvbbs.Execute("update dv_board set Depth=0,ParentStr='0' where ParentID=0")
	End If
	Set Rs=Dvbbs.Execute("Select BoardID,rootid,ParentStr,Depth From Dv_Board where ParentID="&ParentID&" order by Rootid,orders")
	If Not Rs.Eof Then
		SQL = Rs.GetRows(-1)
		Rs.Close:Set Rs=Nothing
		For i=0 To Ubound(SQL,2)
			If SQL(2,i)<>"0" Then
				ParentStr=SQL(2,i)&","&SQL(0,i)
			Else
				ParentStr=SQL(0,i)
			End If
			Conn.Execute "update dv_board set Depth="&SQL(3,i)+1&",ParentStr='"&ParentStr&"',rootid="&SQL(1,i)&" where ParentID="&SQL(0,i)&"",Child
			Dvbbs.Execute("update dv_board set Child="&Child&",orders="&orders&" Where BoardID="&SQL(0,i)&"")
			orders=orders+1
			CheckAndFixBoard SQL(0,i),orders
		Next
	End If
End Sub
Function Get_board_AccUserList(bid)
	Dim Rs,tmp
	Set Rs=Dvbbs.Execute("Select uc_userid from dv_UserAccess where uc_boardid="&bid&"")
	tmp=""
	If Not Rs.EOF Then
		Do while Not Rs.EOF
			If tmp="" Then
				tmp="0_"&rs(0)
			Else
				tmp=tmp&",0_"&rs(0)
			End If
		Rs.MoveNext
		Loop
		Get_board_AccUserList=tmp
	Else
		Get_board_AccUserList=""
	End If
	Set Rs=Nothing
End Function
Function Get_Board_GroupSetting(bid)
	Dim Rs,tmp
	Set Rs=Dvbbs.Execute("select GroupID From Dv_BoardPermission Where BoardID="&bid)
	tmp=""
	If Not Rs.EOF Then
		Do while Not Rs.EOF
			If tmp="" Then
				tmp=rs(0)
			Else
				tmp=tmp&","&rs(0)
			End If
		Rs.MoveNext
		Loop
		Get_Board_GroupSetting=tmp
	Else
		Get_Board_GroupSetting=""
	End If
	Set Rs=Nothing
End Function
Rem 统计下属论坛函数 2004-5-3 Dvbbs.YangZheng
Sub Boardchild()
	Dim cBoardNum, cBoardid
	Dim Trs,rs,Sql
	Dim Bn,i
	Dvbbs.Execute("UPDATE Dv_Board SET Child = 0")
	Set Rs = Dvbbs.Execute("SELECT Boardid, Rootid, ParentID, Depth, Child, ParentStr FROM Dv_Board ORDER BY Boardid DESC")
	If Not (Rs.Eof And Rs.Bof) Then
		Sql = Rs.GetRows(-1)
		Rs.Close:Set Rs = Nothing
		For Bn = 0 To Ubound(Sql,2)
			If Isnull(Sql(4,Bn)) And Cint(Sql(3,Bn)) > 0 Then
				Dvbbs.Execute("UPDATE Dv_Board SET Child = 0 WHERE Boardid = " & Sql(0,Bn))
			End If
			If Cint(Sql(2,Bn)) = 0 And Cint(Sql(3,Bn)) = 0 Then
				Set Trs = Dvbbs.Execute("SELECT COUNT(*) FROM Dv_Board WHERE RootID = " & Sql(1,Bn))
				Cboardnum = Trs(0) - 1
				Trs.Close:Set Trs = Nothing
				If Isnull(Cboardnum) Or Cboardnum < 0 Then Cboardnum = 0
				Dvbbs.Execute("UPDATE Dv_Board SET Child = " & Cboardnum & " WHERE Boardid = " & Sql(0,Bn))
			Elseif Cint(Sql(3,Bn)) > 1 Then
				cBoardid = Split(Sql(5,Bn),",")
				For i = 1 To Ubound(cBoardid)
					Dvbbs.Execute("UPDATE Dv_Board SET Child = Child + 1 WHERE Boardid = " & cBoardid(i))
				Next
			End If
		Next
	End If
End Sub
%>