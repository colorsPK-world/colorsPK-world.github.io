<!--#include file =../conn.asp-->
<!-- #include file="inc/const.asp" -->
<%	
Head()
Dim admin_flag,rs_c
admin_flag=",1,"
CheckAdmin(admin_flag)
If request("action")="save" Then
	Call saveconst()
ElseIf request("action")="restore" Then
	Call restore()
Else
	Call consted()
end if
Footer()

Sub consted()
Dim  sel
%>
<iframe width="260" height="165" id="colourPalette" src="../images/post/nc_selcolor.htm" style="visibility:hidden; position: absolute; left: 0px; top: 0px;border:1px gray solid" frameborder="0" scrolling="no" ></iframe>
<table border="0" cellspacing="1" cellpadding="3"  align="center" width="100%">
<form method="POST" action="setting.asp?action=save" name="theform" onsubmit="return checkForm(this)">
<tr> 
<th width="100%" colspan="3" style="text-align:center;">论坛基本设置（目前只提供一种设置)
</th></tr>
<tr> 
<td width="100%" colspan=3>
<a href="#setting3">[基本信息]</a>&nbsp;<a href="#setting21">[论坛系统数据设置]</a>&nbsp;<a href="#setting6">[悄悄话选项]</a>&nbsp;<a href="#setting7">[论坛首页选项]</a>&nbsp;<a href="#setting8">[用户与注册选项]</a>&nbsp;<a href="#setting10">[系统设置]</a>&nbsp;<a href="#setting12">[在线和用户来源]</a>&nbsp;<a href="#setting_seo">[搜索引擎优化设置(SEO)]</a>
</td>
</tr>
<tr> 
<td width="100%" colspan="3">
<a href="#setting13">[邮件选项]</a>&nbsp;<a href="#setting14">[上传设置]</a>&nbsp;<a href="#setting15">[用户选项(签名、头衔、排行等)]</a>&nbsp;<a href="#setting16">[帖子选项]</a>&nbsp;<a href="#setting17">[防刷新机制]</a>&nbsp;<a href="#setting18">[论坛分页设置]</a>
</td>
</tr>
<tr> 
<td width="100%" colspan="3">
<a href="#setting20">[搜索选项]</a>&nbsp;<a href="#settingxu">[<font color=blue>官方插件设置</font>]</a>&nbsp;<a href="#admin">[<font color=red>安全设置</font>]</a>&nbsp;<a href="challenge.asp">[<font color=blue>RSS/手机短信/在线支付</font>]</a>
<a href="#SettingVIP">[VIP用户组设置]</a>
</td>
</tr>
<tr> 
<td width="93%" colspan="2">
如果您的论坛的设置搞乱了，可以使用<a href="?action=restore"><B>还原论坛默认设置</B></a>
</td>
<input type="hidden" id="forum_return" value="<b>还原论坛默认设置:</b><br><li>如果您把论坛设置搞乱了，可以点击还原论坛默认设置进行还原操作。<br><li>使用此操作将使您原来的设置无效而还原到论坛的默认设置，请确认您做了论坛备份或者记得还原后该做哪些针对您论坛所需要的设置">
<td><a href=# onclick="helpscript(forum_return);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td width="50%">
<U>论坛默认使用风格</U></td>
<td width="43%">
<%
	Dim forum_sid,iforum_setting,stopreadme,forum_pack,iCssName,iCssID,iStyleName
	Dim rs,Style_Option,css_Option,Forum_cid,TempOption,i
	set rs=dvbbs.execute("select forum_sid,forum_setting,forum_pack,forum_cid from dv_setup")
	Forum_sid=rs(0)
	Forum_pack=Split(rs(2),"|||")
	Iforum_setting=split(rs(1),"|||")
	Forum_cid=rs(3)
	Rs.close:Set Rs=Nothing
	stopreadme=iforum_setting(5)
%>
<Select Size=1 Name="sid">
<%
Dim Templateslist
For Each Templateslist in Application(Dvbbs.CacheName &"_style").documentElement.selectNodes("style")
	Response.Write "<option value="""& Templateslist.selectSingleNode("@id").text &""""
	If Forum_sid = CLng(Templateslist.selectSingleNode("@id").text) Then Response.Write " selected "
	Response.Write ">"& Templateslist.selectSingleNode("@type").text &" </option>"
Next
%>
</select> 
</td>
<input type="hidden" id="forum_skin" value="<b>论坛默认使用风格:</b><br><li>在这里您可以选择您论坛的默认使用风格。<br><li>如果想改变论坛风格请到论坛风格模板管理中进行相关设置">
<td><a href=# onclick="helpscript(forum_skin);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td class="td2"><U>论坛当前状态</U><BR>维护期间可设置关闭论坛</td>
<td class="td2"> 
<input type=radio name="forum_setting(21)" value=0 <%if Dvbbs.forum_setting(21)="0" then%>checked<%end if%> class="radio">打开&nbsp;
<input type=radio name="forum_setting(21)" value=1 <%if Dvbbs.forum_setting(21)="1" then%>checked<%end if%> class="radio">关闭&nbsp;
</td>
<input type="hidden" id="forum_open" value="<b>论坛当前状态:</b><br><li>如果您需要做更改程序、更新数据或者转移站点等需要暂时关闭论坛的操作，可在此处选择关闭论坛。<br><li>关闭论坛后，可直接使用论坛地址＋login.asp登录论坛，然后使用论坛地址＋admin_login.asp登录后台管理进行打开论坛的操作">
<td class="td2"><a href=# onclick="helpscript(forum_open);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td><U>维护说明</U><BR>在论坛关闭情况下显示，支持html语法</td>
<td> 
<textarea name="StopReadme" cols="50" rows="3" ID="TDStopReadme"><%=Stopreadme%></textarea><br><a href="javascript:admin_Size(-3,'TDStopReadme')"><img src="skins/images/minus.gif" unselectable="on" border='0'></a> <a href="javascript:admin_Size(3,'TDStopReadme')"><img src="skins/images/plus.gif" unselectable="on" border='0'></a>
</td>
<input type="hidden" id="forum_opens" value="<b>论坛维护说明:</b><br><li>如果您在论坛当前状态中关闭了论坛，请在此输入维护说明，他将显示在论坛的前台给会员浏览，告知论坛关闭的原因，在这里可以使用HTML语法。">
<td><a href=# onclick="helpscript(forum_opens);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td class="td2">
<U>论坛定时设置</U></td>
<td class="td2"> 
<input type=radio name="forum_setting(69)" value="0" <%If Dvbbs.forum_setting(69)="0" Then %>checked <%End If%> class="radio">关 闭</option>
<input type=radio name="forum_setting(69)" value="1" <%If Dvbbs.forum_setting(69)="1" Then %>checked <%End If%> class="radio">定时关闭
<input type=radio name="forum_setting(69)" value="2" <%If Dvbbs.forum_setting(69)="2" Then %>checked <%End If%> class="radio">定时只读
</td>
<input type="hidden" id="forum_isopentime" value="<b>定时设置选择:</b><br><li>在这里您可以设置是否起用定时的各种功能，如果开启了本功能，请设置好下面选项中的论坛设置时间。<br><li>如果在非开放时间内需要更改本设置，可直接使用论坛地址＋login.asp登录论坛，然后使用论坛地址＋admin_login.asp登录后台管理进行打开论坛的操作">
<td class="td2"><a href=# onclick="helpscript(forum_isopentime);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td>
<U>定时设置</U><BR>请根据需要选择开或关</td>
<td> 
<%
Dvbbs.forum_setting(70)=split(Dvbbs.forum_setting(70),"|")
If UBound(Dvbbs.forum_setting(70))<2 Then 
	Dvbbs.forum_setting(70)="1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"
	Dvbbs.forum_setting(70)=split(Dvbbs.forum_setting(70),"|")
End If
For i= 0 to UBound(Dvbbs.forum_setting(70))
If i<10 Then Response.Write "&nbsp;"
%>
  <%=i%>点：<input type="checkbox" name="forum_setting(70)<%=i%>" value="1" <%If Dvbbs.forum_setting(70)(i)="1" Then %>checked<%End If%> class="checkbox">开
 <%
 If (i+1) mod 4 = 0 Then Response.Write "<br>"
 Next
 %>
</td>
<input type="hidden" id="forum_opentime" value="<b>论坛开放时间:</b><br><li>设置本选项请确认您打开了定时开放论坛功能。<br><li>本设置以小时为单位，请务必按规定正确填写<br><li>如果在非开放时间内需要更改本设置，可直接使用论坛地址＋login.asp登录论坛，然后使用论坛地址＋admin_login.asp登录后台管理进行打开论坛的操作">
<td><a href=# onclick="helpscript(forum_opentime);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
</table><a name="admin"></a><BR>
<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th width="100%" colspan="3" align="Left" id="tabletitlelink"><b>安全设置</b>[<a href="#top">顶部</a>]
</th></tr>
<tr> 
<td class="td1" width="50%">
<U>后台管理目录的设定</U><br>缺省目录为admin为安全起见，不让其他人知道目录，请修改</td>
<td class="td1" width="43%"> 
<input title="值不能为空 $!" type="text" name="Forum_AdminFolder" size="35" value="<%=Dvbbs.CacheData(33,0)%>"><br><BR><b>注意：</b>目录名称后面要有"/"，如"admin/"
<input type="hidden" id="AdminFolder" value="<b>后台管理目录的设定:</b><br><li>在FTP上修改您的论坛的管理,目录名称。(缺省目录为admin)<br><li>然后重新修改管理目录,管理员登录后台后就可以自动被引导到您设定的目录.<br><li>除管理员外,其他人无法知道管理的地址.">
</td>
<td class="td1"><a href=# onclick="helpscript(AdminFolder);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td class="td2" width="50%">
<U>是否禁止代理服务器访问</U><BR>禁止代理服务器访问能避免恶意的CC攻击，但开放后影响站点排名，建议在受到明显的攻击的时候开启</td>
<td class="td2" width="43%"> 
<input type="radio" name="forum_setting(100)" value="0" <%if Dvbbs.forum_setting(100)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type="radio" name="forum_setting(100)" value="1" <%if Dvbbs.forum_setting(100)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
<input type="hidden" id="killcc" value="<b>是否禁止代理服务器访问:</b><br><li>禁止代理服务器访问能避免恶意的CC攻击，但开放后影响站点排名，建议在受到明显的攻击的时候开启，平时则关闭。">
<td class="td2"><a href=# onclick="helpscript(killcc);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td class="td1" width="50%">
<U>限制同一IP连接数为</U><BR>限制同一IP连接数，可以减少恶意的CC攻击的影响，但会造成用户访问不便，建议设置为0关闭此功能，在受到攻击的时候才开放</td>
<td class="td1" width="43%"> 
<% Dim IP_MAX_value
If UBound(Dvbbs.forum_setting) > 101 Then
	IP_MAX_value=Dvbbs.forum_setting(101)
Else
	IP_MAX_value=0
End If
%>
<input title="请输入整数 $!cint" type="text" name="forum_setting(101)" size="5" value="<%=IP_MAX_value%>">
</td>
<input type="hidden" id="IP_MAX" value="<b>限制同一IP连接数:</b><br><li>限制同一IP连接数，可以减少恶意的CC攻击的影响，但会造成用户访问不便，建议设置为0关闭此功能，在受到攻击的时候才开放，平时则关闭。">
<td class="td1"><a href=# onclick="helpscript(IP_MAX);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
</table><BR>
<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th width="100%" colspan="3">动网官方自动通讯设置
</th></tr>
<tr> 
<td class="td1" width="50%">
<U>是否起用动网官方自动通讯系统</U><BR>开启后可在论坛后台收到动网官方最新通知以及直接参与官方讨论区讨论和发贴</td>
<td class="td1" width="43%"> 
<input type=radio name="forum_pack(0)" value=0 <%if cint(forum_pack(0))=0 then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_pack(0)" value=1 <%if cint(forum_pack(0))=1 then%>checked<%end if%> class="radio">是&nbsp;
</td>
<input type="hidden" id="forum_pack1" value="<b>是否起用动网自动更新通知系统:</b><br><li>开启后管理后台顶部会提示动网的最新程序、补丁、通知等。">
<td class="td1"><a href=# onclick="helpscript(forum_pack1);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td class="td2">
<U>开启通讯系统用户名与密码</U><BR>用户名与密码用符号“|||”分开<BR>用户名和密码请到 <a href="http://bbs.dvbbs.net/Union_GetUserInfo.asp" target=_blank><font color=blue>动网官方</font></a> 获取</td>
<td class="td2">
<%
If UBound(forum_pack)<2 Then ReDim forum_pack(3)
%>
<input type=text size=21 name="forum_pack(1)" value="<%=forum_pack(1)%>|||<%=forum_pack(2)%>">
</td>
<input type="hidden" id="forum_pack2" value="<b>开启通知系统用户名与密码:</b><br><li>如要开启通知系统，请您先到动网官方论坛注册一个用户名并在动网官方通知系统里取得密码，并填写于此栏即可开启。">
<td class="td2"><a href=# onclick="helpscript(forum_pack2);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
</table><BR>
<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=2 align=left id=tabletitlelink><a name="setting3"></a><b>论坛基本信息</b>[<a href="#top">顶部</a>]</th>
</tr>
<tr> 
<td width="50%" class="td1"> <U>论坛名称</U></td>
<td width="50%" class="td1">  
<input title="值不能为空 $!" name="Forum_info(0)" size="35" value="<%=Dvbbs.Forum_info(0)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>论坛的访问地址</U></td>
<td width="50%" class="td2">  
<input title="值不能为空 $!" name="Forum_info(1)" size="35" value="<%=Dvbbs.Forum_info(1)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>论坛的创建日期（格式：YYYY-M-D）</U></td>
<td width="50%" class="td2">  
<input type="text" name="forum_setting(74)" size="35" value="<%=Dvbbs.forum_setting(74)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>论坛首页文件名</U></td>
<td width="50%" class="td1">  
<input title="值不能为空 $!" name="Forum_info(11)" size="35" value="<%=Dvbbs.Forum_info(11)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>网站主页名称</U></td>
<td width="50%" class="td2">  
<input title="值不能为空 $!" name="Forum_info(2)" size="35" value="<%=Dvbbs.Forum_info(2)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>网站主页访问地址</U></td>
<td width="50%" class="td1">  
<input title="值不能为空 $!" name="Forum_info(3)" size="35" value="<%=Dvbbs.Forum_info(3)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>论坛管理员Email</U></td>
<td width="50%" class="td2">  
<input  name="Forum_info(5)" size="35" value="<%=Dvbbs.Forum_info(5)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>联系我们的链接（不填写为Mailto管理员）</U></td>
<td width="50%" class="td1">  
<input type="text" name="Forum_info(7)" size="35" value="<%=Dvbbs.Forum_info(7)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>论坛首页Logo图片地址</U><BR>显示在论坛顶部左上角，可用相对路径或者绝对路径</td>
<td width="50%" class="td2">  
<input title="值不能为空 $!" type="text" name="Forum_info(6)" size="35" value="<%=Dvbbs.Forum_info(6)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>论坛版权信息</U></td>
<td width="50%" class="td1" valign=top>  
<textarea name="Copyright" cols="50" rows="5" id=TdCopyright><%=Dvbbs.Forum_Copyright%></textarea>
<a href="javascript:admin_Size(-5,'TdCopyright')"><img src="skins/images/minus.gif" unselectable="on" border='0'></a> <a href="javascript:admin_Size(5,'TdCopyright')"><img src="skins/images/plus.gif" unselectable="on" border='0'></a>
</td>
</tr>
</table><BR>
<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=2 align=left id=tabletitlelink><a name="setting21"></a><b>论坛系统数据设置</b>[<a href="#top">顶部</a>]--(以下信息不建议用户修改)</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>论坛会员总数</U></td>
<td width="50%" class="td1">  
<input title="请输入整数 $!cint" type="text" name="Forum_UserNum" size="25" value="<%=Dvbbs.CacheData(10,0)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>论坛主题总数</U></td>
<td width="50%" class="td2">  
<input title="请输入整数 $!cint" type="text" name="Forum_TopicNum" size="25" value="<%=Dvbbs.CacheData(7,0)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>论坛帖子总数</U></td>
<td width="50%" class="td1">  
<input title="请输入整数 $!cint" type="text" name="Forum_PostNum" size="25" value="<%=Dvbbs.CacheData(8,0)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>论坛最高日发贴</U></td>
<td width="50%" class="td2">  
<input title="请输入整数 $!cint" type="text" name="Forum_MaxPostNum" size="25" value="<%=Dvbbs.CacheData(12,0)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>论坛最高日发贴发生时间</U></td>
<td width="50%" class="td1">  
<input type="text" name="Forum_MaxPostDate" size="25" value="<%=Dvbbs.CacheData(13,0)%>">(格式：YYYY-M-D H:M:S)
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>历史最高同时在线纪录人数</U></td>
<td width="50%" class="td2">  
<input title="请输入整数 $!cint" type="text" name="Forum_Maxonline" size="25" value="<%=Dvbbs.Maxonline%>">
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>历史最高同时在线纪录发生时间</U></td>
<td width="50%" class="td1">  
<input type="text" name="Forum_MaxonlineDate" size="25" value="<%=Dvbbs.CacheData(6,0)%>">(格式：YYYY-M-D H:M:S)
</td>
</tr>
</table><BR>

<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=2 align=left id=tabletitlelink><a name="setting6"></a><b>悄悄话选项</b>[<a href="#top">顶部</a>]</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>新短消息弹出窗口</U></td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(10)" value=0 <%if Dvbbs.forum_setting(10)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(10)" value=1 <%if Dvbbs.forum_setting(10)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>发论坛短消息是否采用验证码</U><BR>开启此项可以防止恶意短消息</td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(80)" value=0 <%if Dvbbs.forum_setting(80)="0" Then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(80)" value=1 <%if Dvbbs.forum_setting(80)="1" Then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>多久检查一次是否有群发短信</U><BR></td>
<td width="50%" class="td1">  
<input type=text name="forum_setting(115)" size=8 value='<%=Dvbbs.forum_setting(115)%>'> 分钟（建议不要设置太小）
</td>
</tr>
</table><BR>

<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=3 align=left id=tabletitlelink><a name="setting7"></a><b>论坛首页选项</b>[<a href="#top">顶部</a>]</td>
</tr>
<tr>
<td width="50%" class="td1">
<U>首页显示论坛深度</U>
<input type="hidden" id="forum_depth" value="<b>首页显示论坛深度帮助:</b><br><li>0代表一级，1代表2级，以此类推；<li>设置过大的论坛深度将影响论坛整体性能，请根据自己论坛情况做设置，建议设置为1。">
</td>
<td width="43%" class="td1"> 
<input title="请输入整数 $!cint" type="text" size=10 name="forum_setting(5)" value="<%=Dvbbs.forum_setting(5)%>"> 级
</td>
<td class="td1"><a href=# onclick="helpscript(forum_depth);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td class="td2"> <U>是否显示过生日会员</U>
<input type="hidden" id="forum_userbirthday" value="<b>首页显示过生日会员帮助:</b><br><li>凡当天有会员过生日则显示于论坛首页；<li>开启本功能较消耗资源。">
</td>
<td class="td2">  
<input type=radio name="forum_setting(29)" value=0 <%if Dvbbs.forum_setting(29)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(29)" value=1 <%if Dvbbs.forum_setting(29)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
<td class="td2"><a href=# onclick="helpscript(forum_userbirthday);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr>
<td width="50%" class="td1"><U>首页四格显示</U></td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(113)" value=0 <%if Dvbbs.forum_setting(113)="0" then%>checked<%end if%> class="radio">是&nbsp;
<input type=radio name="forum_setting(113)" value=1 <%if Dvbbs.forum_setting(113)="1" then%>checked<%end if%> class="radio">否&nbsp;
</td>
<td class="td2"><a href=# class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr>
<td width="50%" class="td1"><U>首页右侧信息显示</U></td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(114)" value=0 <%if Dvbbs.forum_setting(114)="0" then%>checked<%end if%> class="radio">是&nbsp;
<input type=radio name="forum_setting(114)" value=1 <%if Dvbbs.forum_setting(114)="1" then%>checked<%end if%> class="radio">否&nbsp;
</td>
<td class="td2"><a href=# class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
</table><BR>

<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=2 align=left id=tabletitlelink><a name="setting8"></a><b>用户与注册选项</b>[<a href="#top">顶部</a>]</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>是否允许新用户注册</U><BR>关闭后论坛将不能注册</td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(37)" value=0 <%if Dvbbs.forum_setting(37)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(37)" value=1 <%if Dvbbs.forum_setting(37)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>

<tr> 
<td width="50%" class="td2"> <U>注册是否采用验证码</U><BR>开启此项可以防止恶意注册</td>
<td width="50%" class="td2">  
<input type=radio name="forum_setting(78)" value=0 <%if Dvbbs.forum_setting(78)="0" Then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(78)" value=1 <%if Dvbbs.forum_setting(78)="1" Then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>注册是否采用问题验证</U><BR>开启此项可以防止恶意注册<br />注意问题答案不要太BT哦，还想不想人注册？</td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(107)" value=0 <%if Dvbbs.forum_setting(107)="0" Then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(107)" value=1 <%if Dvbbs.forum_setting(107)="1" Then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>注册验证问题：</U><BR>可以设置多个验证问题，防止恶意注册<br />每个问题使用!(英文感叹号)分隔.<br /><b><font color="red">如：1+2=? ! 3*3=? ! 爱的英文单词是____ ?</font></b></td>
<td width="50%" class="td2"><textarea name="forum_setting(105)" rows="5" cols="60"><%=Dvbbs.forum_setting(105)%></textarea></td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>注册验证答案：</U><BR>设置回答上述问题的答案，防止恶意注册<br />每个答案使用!(英文感叹号)分隔，和上面的问题顺序对应! <br /><b><font color="red">如：3!9!love</font></b></td>
<td width="50%" class="td2"><textarea name="forum_setting(106)" rows="5" cols="60"><%=Dvbbs.forum_setting(106)%></textarea></td>
</tr>

<tr> 
<td width="50%" class="td1"> <U>登录是否采用验证码</U><BR>开启此项可以防止恶意登录猜解密码</td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(79)" value=0 <%if Dvbbs.forum_setting(79)="0" Then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(79)" value=1 <%if Dvbbs.forum_setting(79)="1" Then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>会员取回密码是否采用验证码</U><BR>开启此项可以防止恶意登录猜解密码</td>
<td width="50%" class="td2">  
<input type=radio name="forum_setting(81)" value=0 <%if Dvbbs.forum_setting(81)="0" Then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(81)" value=1 <%if Dvbbs.forum_setting(81)="1" Then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>会员取回密码次数限制</U><BR>0则表示无限制，若取回问答错误超过此限制，则停止至24小时后才能再次使用取回密码功能。</td>
<td width="50%" class="td1">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(84)" size="3" value="<%=Dvbbs.forum_setting(84)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>最短用户名长度</U><BR>填写数字，不能小于1大于50</td>
<td width="50%" class="td2">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(40)" size="3" value="<%=Dvbbs.forum_setting(40)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>最长用户名长度</U><BR>填写数字，不能小于1大于50</td>
<td width="50%" class="td1">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(41)" size="3" value="<%=Dvbbs.forum_setting(41)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>同一IP注册间隔时间</U><BR>如不想限制可填写0</td>
<td width="50%" class="td2">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(22)" size="3" value="<%=Dvbbs.forum_setting(22)%>">&nbsp;秒
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>Email通知密码</U><BR>确认您的站点支持发送mail，所包含密码为系统随机生成</td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(23)" value=0 <%if Dvbbs.forum_setting(23)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(23)" value=1 <%if Dvbbs.forum_setting(23)="1" then%>checked<%end if%> class="radio">打开&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>一个Email只能注册一个帐号</U></td>
<td width="50%" class="td2">  
<input type=radio name="forum_setting(24)" value=0 <%if Dvbbs.forum_setting(24)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(24)" value=1 <%if Dvbbs.forum_setting(24)="1" then%>checked<%end if%> class="radio">打开&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>注册需要管理员认证</U></td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(25)" value=0 <%if Dvbbs.forum_setting(25)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(25)" value=1 <%if Dvbbs.forum_setting(25)="1" then%>checked<%end if%> class="radio">打开&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>发送注册信息邮件</U><BR>请确认您打开了邮件功能</td>
<td width="50%" class="td2">  
<input type=radio name="forum_setting(47)" value=0 <%if Dvbbs.forum_setting(47)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(47)" value=1 <%if Dvbbs.forum_setting(47)="1" then%>checked<%end if%> class="radio">打开&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>开启短信欢迎新注册用户</U></td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(46)" value=0 <%if Dvbbs.forum_setting(46)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(46)" value=1 <%if Dvbbs.forum_setting(46)="1" then%>checked<%end if%> class="radio">打开&nbsp;
</td>
</tr>

</table><BR>
<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=2 align=left id=tabletitlelink><a name="setting10"></a><b>系统设置</b>[<a href="#top">顶部</a>]</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>论坛所在时区</U></td>
<td width="50%" class="td1">  
<input title="值不能为空 $!" type="text" name="Forum_info(9)" size="35" value="<%=Dvbbs.Forum_info(9)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>服务器时差</U></td>
<td width="50%" class="td2">
<select name="forum_setting(0)">
<%for i=-23 to 23%>
<option value="<%=i%>" <%if i=CInt(Dvbbs.forum_setting(0)) then%>selected<%end if%>><%=i%></option>
<%next%>
</select>
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>脚本超时时间</U><BR>默认为300，一般不做更改</td>
<td width="50%" class="td1">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(1)" size="3" value="<%=Dvbbs.forum_setting(1)%>">&nbsp;秒
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>是否显示页面执行时间</U></td>
<td width="50%" class="td2">  
<input type=radio name="forum_setting(30)" value=0 <%If Dvbbs.forum_setting(30)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(30)" value=1 <%if Dvbbs.forum_setting(30)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td1"><U>禁止的邮件地址</U><BR>在下面指定的邮件地址将被禁止注册，每个邮件地址用“|”符号分隔<BR>本功能支持模糊搜索，如设置了eway禁止，将禁止eway@aspsky.net或者eway@dvbbs.net类似这样的注册</td>
<td width="50%" class="td1"> 
<input title="值不能为空 $!" type="text" name="forum_setting(52)" size="50" value="<%=Dvbbs.forum_setting(52)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td2"><U>论坛脚本过滤扩展设置</U><BR>此设置为开启HTML解释的时候对脚本代码的识别设置，<br>您可以根据需要添加自定的过滤<br>格式是：过滤字| 如：abc|efg| 这样就添加了abc和efg的过滤</td>
<td width="50%" class="td2"> 
<Input title="值不能为空 $!" type="text" name="forum_setting(77)" size="50" value="<%=Dvbbs.forum_setting(77)%>"><br> 没有添加可以填0,如果添加了最后一个字符必须是"|"
</td>
</tr>
</table><BR>
<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=2 align=left id=tabletitlelink><a name="setting12"></a><b>在线和用户来源</b>[<a href="#top">顶部</a>]</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>在线显示用户IP</U><BR>关闭后如果所属用户组、论坛权限、用户权限中设置了用户可浏览则可见</td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(28)" value=0 <%if Dvbbs.forum_setting(28)="0" then%>checked<%end if%> class="radio">保密&nbsp;
<input type=radio name="forum_setting(28)" value=1 <%if Dvbbs.forum_setting(28)="1" then%>checked<%end if%> class="radio">公开&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>在线显示用户来源</U><BR>关闭后如果所属用户组、论坛权限、用户权限中设置了用户可浏览则可见<BR>开启本功能较消耗资源</td>
<td width="50%" class="td2">  
<input type=radio name="forum_setting(36)" value=0 <%if Dvbbs.forum_setting(36)="0" then%>checked<%end if%> class="radio">保密&nbsp;
<input type=radio name="forum_setting(36)" value=1 <%if Dvbbs.forum_setting(36)="1" then%>checked<%end if%> class="radio">公开&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>在线资料列表显示用户当前位置</U></td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(33)" value=0 <%if Dvbbs.forum_setting(33)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(33)" value=1 <%if Dvbbs.forum_setting(33)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>在线资料列表显示用户登录和活动时间</U></td>
<td width="50%" class="td2">  
<input type=radio name="forum_setting(34)" value=0 <%if Dvbbs.forum_setting(34)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(34)" value=1 <%if Dvbbs.forum_setting(34)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>在线资料列表显示用户浏览器和操作系统</U></td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(35)" value=0 <%If Dvbbs.forum_setting(35)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(35)" value=1 <%if Dvbbs.forum_setting(35)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>在线名单显示客人在线</U><BR>为节省资源建议关闭</td>
<td width="50%" class="td2">  
<input type=radio name="forum_setting(15)" value=0 <%if Dvbbs.forum_setting(15)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(15)" value=1 <%if Dvbbs.forum_setting(15)="1" then%>checked<%end if%> class="radio">打开&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>在线名单显示用户在线</U><BR>为节省资源建议关闭</td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(14)" value=0 <%if Dvbbs.forum_setting(14)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(14)" value=1 <%if Dvbbs.forum_setting(14)="1" then%>checked<%end if%> class="radio">打开&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>删除不活动用户时间</U><BR>可设置删除多少分钟内不活动用户<BR>单位：分钟，请输入数字</td>
<td width="50%" class="td2">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(8)" size="3" value="<%=Dvbbs.forum_setting(8)%>">&nbsp;分钟
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>总论坛允许同时在线数</U><BR>如不想限制，可设置为0</td>
<td width="50%" class="td1">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(26)" size="6" value="<%=Dvbbs.forum_setting(26)%>">&nbsp;人
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>展开用户在线列表每页显示用户数</U></td>
<td width="50%" class="td2">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(58)" size="6" value="<%=Dvbbs.forum_setting(58)%>">&nbsp;人
</td>
</tr>
</table><BR>
<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=3 align=left id=tabletitlelink><a name="setting13"></a><b>邮件选项</b>[<a href="#top">顶部</a>]</td>
</tr>
<tr> 
	<td width="50%" class="td1"> <U>发送邮件组件</U>
	<input type="hidden" id="forum_emailplus" value="<b>发送邮件组件帮助:</b><br><li>选择组件时请确认服务器是否支持。">
	<BR>如果您的服务器不支持下列组件，请选择不支持</td>
	<td width="43%" class="td1">  
	<select name="forum_setting(2)" id="forum_setting(2)" onChange="chkselect(options[selectedIndex].value,'know1');">
	<option value="0">不支持 
	<option value="1">JMAIL 
	<option value="2">CDONTS 
	<option value="3">ASPEMAIL 
	</select><div id=know1></div></td>
	<td class="td1"><a href=# onclick="helpscript(forum_emailplus);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
	<td class="td2"> <U>SMTP Server地址</U>
	<input type="hidden" id="forum_smtp" value="<b>SMTP Server地址帮助:</b><br><li>当选择了邮件组件时此项建议填写，例如：smtp.21cn.com；<li>此邮件服务器地址的填写是根据管理员邮箱而定，例如管理员邮箱为abc@163.net，则此栏可填：smtp.163.net。">
	<BR>只有在论坛使用设置中打开了发送邮件功能，该填写内容方有效</td>
	<td class="td2">  
	<input type="text" name="Forum_info(4)" size="35" value="<%=Dvbbs.Forum_info(4)%>">
	</td>
	<td class="td2"><a href=# onclick="helpscript(forum_smtp);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr>
	<td class="td1"> <U>邮件登录用户名</U><BR>只有在论坛使用设置中打开了发送邮件功能，该填写内容方有效</td>
	<td colspan=2 class="td1">
	<input type="text" name="Forum_info(12)" size="35" value="<%=Dvbbs.Forum_info(12)%>">
	</td>
</tr>
<tr> 
	<td class="td2"> <U>邮件登录密码</U></td>
	<td colspan=2 class="td2">  
	<input type="password" name="Forum_info(13)" size="35" value="<%=Dvbbs.Forum_info(13)%>">
	</td>
</tr>
</table>
<a name="setting14"></a>
<BR>
<%
Dim UploadSetting
UploadSetting = Split(Dvbbs.forum_setting(7),"|")
If Ubound(UploadSetting)<>20 Then
	Redim UploadSetting(20)
	For i=0 to 20
		If i=2 or i=3 Then
			UploadSetting(i)=999
		Else
			UploadSetting(i)=0
		End If
	Next
End If
%>
<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=3 align=left id=tabletitlelink><b>上传设置</b>[<a href="#top">顶部</a>]</td>
</tr>
<tr> 
	<td width="50%" class="td1"> <U>头像上传</U></td>
	<td width="43%" class="td1">
	<SELECT name="UploadSetting(0)" id="UploadSetting(0)">
	<OPTION value=0 <%if UploadSetting(0)=0 then%>selected<%end if%>>完全关闭&nbsp;
	<OPTION value=1 <%if UploadSetting(0)=1 then%>selected<%end if%>>完全打开&nbsp;
	<OPTION value=2 <%if UploadSetting(0)=2 then%>selected<%end if%>>只允许会员上传&nbsp;
	</SELECT>
	</td>
	<input type="hidden" id="Forum_FaceUpload" value="<b>头像上传帮助:</b><br><li>当开启此功能，用户可以把图像文件上传到服务器作为头像。<li>在上传管理中有对上传头像进行管理。<LI>完全关闭：即注册和修改资料都不允许上传头像。<LI>完全打开：即注册和修改资料都允许上传头像。<LI>只允许会员上传：即会员修改个人资料时允许上传头像。">
	<td class="td1"><a href=# onclick="helpscript(Forum_FaceUpload);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
	<td class="td2"><U>允许的最大头像文件大小</U></td>
	<td class="td2"> 
	<input title="请输入整数 $!cint" type="text" name="UploadSetting(1)" size="6" value="<%=UploadSetting(1)%>">&nbsp;K
	</td>
	<input type="hidden" id="Forum_FaceUploadSize" value="<b>头像文件大小帮助:</b><br><li>限制上传头像文件的大小。<li>用户头像除上传限制外，请查看“用户选项”相关设置。">
	<td class="td2"><a href=# onclick="helpscript(Forum_FaceUploadSize);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr>
	<td class="td1" ><U>选取上传组件</U></td>
	<td class="td1" >
	<select name="UploadSetting(2)" id="UploadSetting(2)" onChange="chkselect(options[selectedIndex].value,'know2');">
	<option value="999">关闭
	<option value="0">无组件上传类
	<option value="1">Aspupload3.0组件 
	<option value="2">SA-FileUp 4.0组件
	<option value="3">DvFile-Up V1.0组件
	</option></select><div id="know2"></div>
	</td>
	<td class="td1" >
	<input type="hidden" id="forum_upload" value="<b>选取上传组件帮助:</b><br><li>当选取时，论坛系统会自动为您检测服务器是否支持该组件；<li>若提示不支持，请选择关闭。">
	<a href=# onclick="helpscript(forum_upload);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
	<td class="td2"><U>选取生成预览图片组件</U></td>
	<td class="td2"> 
	<select name="UploadSetting(3)" id="UploadSetting(3)" onChange="chkselect(options[selectedIndex].value,'know3');">
	<option value="999">关闭
	<option value="0">CreatePreviewImage组件
	<option value="1">AspJpeg组件
	<option value="2">SA-ImgWriter组件
	</select><div id="know3"></div>
	</td>
	<td class="td2">
	<input type="hidden" id="forum_CreatImg" value="<b>选取生成预览图片组件帮助:</b><br><li>当选取时，论坛系统会自动为您检测服务器是否支持该组件；<li>若提示不支持，请选择关闭。">
	<a href=# onclick="helpscript(forum_CreatImg);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
	<td class="td1"><U>生成预览图片大小设置（宽度|高度）</U></td>
	<td class="td1">
		宽度：<INPUT title="请输入整数 $!cint" type="text" NAME="UploadSetting(14)" size=10 value="<%=UploadSetting(14)%>"> 象素
		高度：<INPUT title="请输入整数 $!cint" type="text" NAME="UploadSetting(15)" size=10 value="<%=UploadSetting(15)%>"> 象素
	</td>
	<td class="td1">
	<input type="hidden" id="forum_CreatImgSize" value="<b>生成预览图片大小设置帮助:</b><br><li>当选取了生成预览图片组件，并且服务器上装有相应组件，此功能才能生效；">
	<a href=# onclick="helpscript(forum_CreatImgSize);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
	<td class="td2"><U>生成预览图片大小规则选项</U></td>
	<td class="td2"> 
		<SELECT name="UploadSetting(16)" id="UploadSetting(16)">
		<OPTION value=0>固定</OPTION>
		<OPTION value=1>等比例缩小</OPTION>
		</SELECT>
	</td>
	<td class="td2">&nbsp;</td>
</tr>
<tr> 
	<td class="td1"><U>图片水印设置开关</U></td>
	<td class="td1"> 
		<SELECT name="UploadSetting(17)" id="UploadSetting(17)">
		<OPTION value="0">关闭水印效果</OPTION>
		<OPTION value="1">水印文字效果</OPTION>
		<OPTION value="2">水印图片效果</OPTION>
		</SELECT>
	</td>
	<td class="td1">&nbsp;</td>
</tr>
<tr> 
	<td class="td2"><U>上传图片添加水印文字信息（可为空或0）</U></td>
	<td class="td2"> 
	<INPUT TYPE="text" NAME="UploadSetting(4)" size=40 value="<%=UploadSetting(4)%>">
	</td>
	<td class="td2">
	<input type="hidden" id="forum_CreatText" value="<b>上传图片添加水印文字帮助:</b><br><li>若不需要水印文字效果，请设置为空；<li>水印文字字数不宜超过15个字符,不支持任何WEB编码标记；<li>目前支持的相关图片组件有：AspJpeg组件，SA-ImgWriter V1.21组件.">
	<a href=# onclick="helpscript(forum_CreatText);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
	<td class="td1"><U>上传添加水印字体大小</U></td>
	<td class="td1"> 
	<INPUT title="请输入整数 $!cint" type="text" NAME="UploadSetting(5)" size=10 value="<%=UploadSetting(5)%>"> <b>px</b>
	</td>
	<td class="td1">&nbsp;</td>
</tr>
<tr> 
	<td class="td2"><U>上传添加水印字体颜色</U></td>
	<td class="td2">
	<input type="hidden" name="UploadSetting(6)" id="UploadSetting(6)" value="<%=UploadSetting(6)%>">
	<img border=0 src="../images/post/rect.gif" style="cursor:pointer;background-Color:<%=UploadSetting(6)%>;" onclick="Getcolor(this,'UploadSetting(6)');" title="选取颜色!">
	</td>
	<td class="td2">&nbsp;</td>
</tr>
<tr> 
	<td class="td1"><U>上传添加水印字体名称</U></td>
	<td class="td1">
	<SELECT name="UploadSetting(7)" id="UploadSetting(7)">
	<option value="宋体">宋体</option>
	<option value="楷体_GB2312">楷体</option>
	<option value="新宋体">新宋体</option>
	<option value="黑体">黑体</option>
	<option value="隶书">隶书</option>
	<OPTION value="Andale Mono" selected>Andale Mono</OPTION> 
	<OPTION value=Arial>Arial</OPTION> 
	<OPTION value="Arial Black">Arial Black</OPTION> 
	<OPTION value="Book Antiqua">Book Antiqua</OPTION>
	<OPTION value="Century Gothic">Century Gothic</OPTION> 
	<OPTION value="Comic Sans MS">Comic Sans MS</OPTION>
	<OPTION value="Courier New">Courier New</OPTION>
	<OPTION value=Georgia>Georgia</OPTION>
	<OPTION value=Impact>Impact</OPTION>
	<OPTION value=Tahoma>Tahoma</OPTION>
	<OPTION value="Times New Roman" >Times New Roman</OPTION>
	<OPTION value="Trebuchet MS">Trebuchet MS</OPTION>
	<OPTION value="Script MT Bold">Script MT Bold</OPTION>
	<OPTION value=Stencil>Stencil</OPTION>
	<OPTION value=Verdana>Verdana</OPTION>
	<OPTION value="Lucida Console">Lucida Console</OPTION>
	</SELECT>
	</td>
	<td class="td1">&nbsp;</td>
</tr>
<tr> 
	<td class="td2"><U>上传水印字体是否粗体</U></td>
	<td class="td2"> 
		<SELECT name="UploadSetting(8)" id="UploadSetting(8)">
		<OPTION value=0>否</OPTION>
		<OPTION value=1>是</OPTION>
		</SELECT>
	</td>
	<td class="td2">&nbsp;</td>
</tr>
<!-- 上传图片添加水印LOGO图片定义 -->
<tr> 
	<td class="td1"><U>上传图片添加水印LOGO图片信息（可为空或0）</U><br>填写LOGO的图片相对路径</td>
	<td class="td1"> 
	<INPUT TYPE="text" NAME="UploadSetting(9)" size=40 value="<%=UploadSetting(9)%>">
	</td>
	<td class="td1">&nbsp;</td>
</tr>
<tr> 
	<td class="td2"><U>上传图片添加水印透明度</U></td>
	<td class="td2"> 
	<INPUT TYPE="text" NAME="UploadSetting(10)" size=10 value="<%=UploadSetting(10)%>"> 如60%请填写0.6
	</td>
	<td class="td2">&nbsp;</td>
</tr>
<tr> 
	<td class="td2"><U>水印图片去除底色</U><br>保留为空则水印图片不去除底色</td>
	<td class="td2"> 
	<INPUT TYPE="text" NAME="UploadSetting(18)" ID="UploadSetting(18)" size=10 value="<%=UploadSetting(18)%>"> 
	<img border=0 src="../images/post/rect.gif" style="cursor:pointer;background-Color:<%=UploadSetting(18)%>;" onclick="Getcolor(this,'UploadSetting(18)');" title="选取颜色!">
	</td>
	<td class="td2">&nbsp;</td>
</tr>
<tr> 
	<td class="td1"><U>水印文字或图片的长宽区域定义</U><br>如水印图片的宽度和高度</td>
	<td class="td1"> 
	宽度：<INPUT title="请输入整数 $!cint" type="text" NAME="UploadSetting(11)" size=10 value="<%=UploadSetting(11)%>"> 象素
	高度：<INPUT title="请输入整数 $!cint" type="text" NAME="UploadSetting(12)" size=10 value="<%=UploadSetting(12)%>"> 象素
	</td>
	<td class="td1">&nbsp;</td>
</tr>
<tr> 
	<td class="td2"><U>上传图片添加水印LOGO位置坐标</U></td>
	<td class="td2">
	<SELECT NAME="UploadSetting(13)" id="UploadSetting(13)">
		<option value="0">左上</option>
		<option value="1">左下</option>
		<option value="2">居中</option>
		<option value="3">右上</option>
		<option value="4">右下</option>
	</SELECT>
	</td>
	<td class="td2">&nbsp;</td>
</tr>
<!-- 上传图片添加水印LOGO图片定义 -->
<%
If IsObjInstalled("Scripting.FileSystemObject") Then 
%>
<tr> 
<td class="td1"><U>是否采用文件、图片防盗链</U></td>
<td class="td1">
<input type="radio" name="Forum_Setting(75)" value=0 <%if Dvbbs.Forum_Setting(75)=0 Then %>checked<%end if%> class="radio">关闭&nbsp;
<input type="radio" name="Forum_Setting(75)" value=1 <%if Dvbbs.Forum_Setting(75)=1 Then %>checked<%end if%> class="radio">打开&nbsp;
</td>
<td class="td1">&nbsp;</td>
</tr>
<tr> 
<td class="td2"><U>上传目录设定</U></td>
<td class="td2">
<%
If Dvbbs.Forum_Setting(76)="" Or Dvbbs.Forum_Setting(76)="0" Then Dvbbs.Forum_Setting(76)="UploadFile/"
%>
<input type=text name="Forum_Setting(76)" value=<%=Dvbbs.Forum_Setting(76)%>>如果修改了此项，请用FTP手工创建目录和移动原有上传文件。
</td>
<td class="td2">&nbsp;</td>
</tr>
<%
End If 
%>
</table>
<BR>
<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=2 align=left id=tabletitlelink><a name="setting15"></a><b>用户选项</b>[<a href="#top">顶部</a>]</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>允许个人签名</U></td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(42)" value=0 <%if Dvbbs.forum_setting(42)=0 then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(42)" value=1 <%if Dvbbs.forum_setting(42)=1 then%>checked<%end if%> class="radio">打开&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>允许用户使用头像</U></td>
<td width="50%" class="td2">  
<input type=radio name="forum_setting(53)" value=0 <%if Dvbbs.forum_setting(53)=0 then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(53)" value=1 <%if Dvbbs.forum_setting(53)=1 then%>checked<%end if%> class="radio">打开&nbsp;
</td>
</tr>
<tr> 
<td class="td1" width="50%"><U>最大头像尺寸</U><BR>定义内容为头像的最大高度和宽度</td>
<td class="td1" width="50%"> 
<input title="请输入整数 $!cint" type="text" name="forum_setting(57)" size="6" value="<%=Dvbbs.forum_setting(57)%>">&nbsp;象素
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>默认头像宽度</U><BR>定义内容为论坛头像的默认宽度</td>
<td width="50%" class="td2">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(38)" size="6" value="<%=Dvbbs.forum_setting(38)%>">&nbsp;象素
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>默认头像高度</U><BR>定义内容为论坛头像的默认宽度</td>
<td width="50%" class="td1">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(39)" size="6" value="<%=Dvbbs.forum_setting(39)%>">&nbsp;象素
</td>
</tr>
<tr> 
<td class="td2" width="50%"><U>使用自定义头像的最少发帖数</U></td>
<td class="td2" width="50%"> 
<input title="请输入整数 $!cint" type="text" name="forum_setting(54)" size="6" value="<%=Dvbbs.forum_setting(54)%>">&nbsp;篇
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>允许从其他站点链接头像</U><BR>就是是否可以直接使用http..这样的url来直接显示头像</td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(55)" value=0 <%if Dvbbs.forum_setting(55)=0 then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(55)" value=1 <%if Dvbbs.forum_setting(55)=1 then%>checked<%end if%> class="radio">打开&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>用户签名是否开启UBB代码</U></td>
<td width="50%" class="td2">  
<input type=radio name="forum_setting(65)" value=0 <%if Dvbbs.forum_setting(65)=0 then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(65)" value=1 <%if Dvbbs.forum_setting(65)=1 then%>checked<%end if%> class="radio">打开&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>用户签名是否开启HTML代码</U></td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(66)" value=0 <%if Dvbbs.forum_setting(66)=0 then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(66)" value=1 <%if Dvbbs.forum_setting(66)=1 then%>checked<%end if%> class="radio">打开&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>用户是否开启贴图标签</U></td>
<td width="50%" class="td2">  
<input type=radio name="forum_setting(67)" value=0 <%if Dvbbs.forum_setting(67)=0 then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(67)" value=1 <%if Dvbbs.forum_setting(67)=1 then%>checked<%end if%> class="radio">打开&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>用户是否开启Flash标签</U></td>
<td width="50%" class="td1">  
<input type=radio name="forum_setting(71)" value=0 <%if Dvbbs.forum_setting(71)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(71)" value=1 <%if Dvbbs.forum_setting(71)="1" then%>checked<%end if%> class="radio">打开&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>用户头衔</U><BR>是否允许用户自定义头衔</td>
<td width="50%" class="td2">  
<input type=radio name="forum_setting(6)" value=0 <%if Dvbbs.forum_setting(6)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(6)" value=1 <%if Dvbbs.forum_setting(6)="1" then%>checked<%end if%> class="radio">打开&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>用户头衔最大长度</U></td>
<td width="50%" class="td1">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(59)" size="6" value="<%=Dvbbs.forum_setting(59)%>">&nbsp;byte
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>自定义头衔最少发帖数量限制</U><BR>不做限制请设置为0</td>
<td width="50%" class="td2">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(60)" size="6" value="<%=Dvbbs.forum_setting(60)%>">&nbsp;篇
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>自定义头衔注册天数限制</U><BR>不做限制请设置为0</td>
<td width="50%" class="td1">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(61)" size="6" value="<%=Dvbbs.forum_setting(61)%>">&nbsp;天
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>自定义头衔上面两个条件加在一起限制</U></td>
<td width="50%" class="td2">  
<input type=radio name="forum_setting(62)" value=0 <%if Dvbbs.forum_setting(62)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(62)" value=1 <%if Dvbbs.forum_setting(62)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>自定义头衔中要屏蔽的词语</U><BR>每个限制字符用“|”符号隔开</td>
<td width="50%" class="td1">  
<input title="值不能为空 $!" type="text" name="forum_setting(63)" size="50" value="<%=Dvbbs.forum_setting(63)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>帖子显示页面是否显示支付宝和该用户交易图标</U></td>
<td width="50%" class="td2">  
<input type=radio name="forum_setting(89)" value=0 <%if Dvbbs.forum_setting(89)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(89)" value=1 <%if Dvbbs.forum_setting(89)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
</table><BR>
<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=2 align=left id=tabletitlelink><a name="setting17"></a><b>防刷新机制</b>[<a href="#top">顶部</a>]</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>防刷新机制</U><BR>如选择打开请填写下面的限制刷新时间<BR>对版主和管理员无效</td>
<td width="50%" class="td2">  
<input type=radio name="forum_setting(19)" value=0 <%if Dvbbs.forum_setting(19)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(19)" value=1 <%if Dvbbs.forum_setting(19)="1" then%>checked<%end if%> class="radio">打开&nbsp;
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>浏览刷新时间间隔</U><BR>填写该项目请确认您打开了防刷新机制<BR>仅对帖子列表和显示帖子页面起作用</td>
<td width="50%" class="td1">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(20)" size="3" value="<%=Dvbbs.forum_setting(20)%>">&nbsp;秒
</td>
</tr>
<tr> 
<td width="50%" class="td2"><U>防刷新功能有效的页面</U><BR>请确认您打开了防刷新功能<BR>您指定的页面将有防刷新作用，用户在限定的时间内不能重复打开该页面，具有一定减少资源消耗的作用<BR>每个页面名请用“|”符号隔开</td>
<td width="50%" class="td2"> 
<input title="值不能为空 $!" type="text" name="forum_setting(64)" size="50" value="<%=Dvbbs.forum_setting(64)%>">
</td>
</tr>
</table><BR>
<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=3 align=left id=tabletitlelink><a name="setting20"></a><b>搜索选项</b>[<a href="#top">顶部</a>]</td>
</tr>
<tr> 
<td class="td1" width="50%"><U>每次搜索时间间隔</U></td>
<td class="td1" width="43%"> 
<input title="请输入整数 $!cint" type="text" name="Forum_Setting(3)" size="6" value="<%=Dvbbs.Forum_Setting(3)%>">&nbsp;秒
</td>
<input type="hidden" id="s_1" value="<b>每次搜索时间间隔</b><br><li>设置合理的每次搜索时间间隔，可以避免用户反复进行相同搜索而消耗大量论坛资源">
<td class="td1"><a href=# onclick="helpscript(s_1);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td class="td2"><U>搜索字串最小和最大长度</U><BR>最小和最大字符请用符号“|”分隔，单位为字节<BR>最小字符不宜设置过小，最大字符不宜设置过大，建议用默认值</td>
<td class="td2" > 
<input title="值不能为空 $!" type="text" name="Forum_Setting(4)" size="8" value="<%=Dvbbs.Forum_Setting(4)%>">
</td>
<input type="hidden" id="s_2" value="<b>搜索字串最小和最大长度</b><br><li>最小和最大字符请用符号“|”分隔，单位为字节<br><li>最小字符不宜设置过小，最大字符不宜设置过大，设置过小或者过大都将消耗大量论坛资源">
<td class="td2"><a href=# onclick="helpscript(s_2);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td class="td1" ><U>搜索可以不受字串长度限制的词</U><BR>每个字符请用符号“|”分隔</td>
<td class="td1"> 
<input title="值不能为空 $!" type="text" name="Forum_Setting(9)" size="50" value="<%=Dvbbs.Forum_Setting(9)%>">&nbsp;
</td>
<input type="hidden" id="s_3" value="<b>搜索可以不受字串长度限制的词</b><br><li>每个字符请用符号“|”分隔<br><li>合理的填写不受字串长度限制的词，可以使一些常用且简单的单词搜索到结果，但您同时必须考虑搜索字串长度的长短是和消耗的资源成正比的">
<td class="td1"><a href=# onclick="helpscript(s_3);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td class="td2"><U>搜索返回最多的结果数</U><BR>建议不要设置过大</td>
<td class="td2"> 
<input title="请输入整数 $!cint" type="text" name="Forum_Setting(12)" size="6" value="<%=Dvbbs.Forum_Setting(12)%>">&nbsp;个
</td>
<input type="hidden" id="s_4" value="<b>搜索返回最多的结果数</b><br><li>单位为数字<br><li>返回搜索的结果数和消耗的资源成正比，请合理设置">
<td class="td2"><a href=# onclick="helpscript(s_4);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td class="td1">
<U>搜索热门帖子条件中对应的搜索天数和浏览次数标准</U><BR>搜索天数和浏览次数请用符号“|”分隔，单位为数字<BR>搜索天数不宜设置过大，建议用默认值</td>
<td class="td1"> 
<input title="值不能为空 $!" type="text" name="Forum_Setting(13)" size="8" value="<%=Dvbbs.Forum_Setting(13)%>">
</td>
<input type="hidden" id="s_5" value="<b>搜索热门帖子条件中对应的搜索天数和浏览次数标准</b><br><li>搜索天数和浏览次数请用符号“|”分隔，单位为数字<br><li>作为热门主题的搜索天数和浏览次数标准和论坛资源消耗成正比，请合理设置">
<td class="td1"><a href=# onclick="helpscript(s_5);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td class="td2"> <U>是否开启全文搜索</U><BR>ACCESS数据库不建议开启<BR>SQL数据库做了全文索引可以开启</td>
<td class="td2">  
<input type=radio name="Forum_Setting(16)" value=0 <%If Dvbbs.Forum_Setting(16)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="Forum_Setting(16)" value=1 <%If Dvbbs.Forum_Setting(16)="1" then%>checked<%end if%> class="radio">打开&nbsp;
</td>
<input type="hidden" id="s_6" value="<b>是否开启全文搜索</b><br><li>ACCESS数据库在数据容量较大情况下开启搜索将消耗大量资源，SQL数据库开启数据库全文搜索后可使用本选项<br><li>设置SQL数据库的全文搜索请看微软相关帮助文档">
<td class="td2"><a href=# onclick="helpscript(s_6);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td class="td1"> <U>用户列表允许用户名搜索</U></td>
<td class="td1">  
<input type=radio name="Forum_Setting(17)" value=0 <%if Dvbbs.Forum_Setting(17)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="Forum_Setting(17)" value=1 <%if Dvbbs.Forum_Setting(17)="1" then%>checked<%end if%> class="radio">打开&nbsp;
</td>
<input type="hidden" id="s_7" value="<b>用户列表允许用户名搜索</b><br><li>开启本项目，在用户列表中可以对用户名做简单搜索<br><li>出于用户数据安全上的考虑，您也可以关闭该选项">
<td class="td1"><a href=# onclick="helpscript(s_7);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td class="td2"> <U>用户列表允许列出管理团队</U></td>
<td class="td2">  
<input type=radio name="Forum_Setting(18)" value=0 <%if Dvbbs.Forum_Setting(18)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="Forum_Setting(18)" value=1 <%if Dvbbs.Forum_Setting(18)="1" then%>checked<%end if%> class="radio">打开&nbsp;
</td>
<input type="hidden" id="s_8" value="<b>用户列表允许列出管理团队</b><br><li>开启本项目，在用户列表中可以列出论坛中的管理团队资料，即版主或其以上等级的用户<br><li>出于用户数据安全上的考虑，您也可以关闭该选项">
<td class="td2"><a href=# onclick="helpscript(s_8);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td class="td1"> <U>用户列表允许列出所有用户</U></td>
<td class="td1">  
<input type=radio name="Forum_Setting(27)" value=0 <%if Dvbbs.Forum_Setting(27)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="Forum_Setting(27)" value=1 <%if Dvbbs.Forum_Setting(27)="1" then%>checked<%end if%> class="radio">打开&nbsp;
</td>
<input type="hidden" id="s_9" value="<b>用户列表允许列出所有用户</b><br><li>开启本项目，在用户列表中可以列出论坛中的所有的用户资料<br><li>出于用户数据安全上的考虑，您也可以关闭该选项">
<td class="td1"><a href=# onclick="helpscript(s_9);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td class="td2"> <U>用户列表允许列出TOP排行用户</U></td>
<td class="td2">  
<input type=radio name="Forum_Setting(31)" value=0 <%if Dvbbs.Forum_Setting(31)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="Forum_Setting(31)" value=1 <%if Dvbbs.Forum_Setting(31)="1" then%>checked<%end if%> class="radio">打开&nbsp;
</td>
<input type="hidden" id="s_10" value="<b>用户列表允许列出TOP排行用户</b><br><li>开启本项目，在用户列表中可以列出论坛按照发贴和积分数等用户排行<br><li>出于用户数据安全上的考虑，您也可以关闭该选项">
<td class="td2"><a href=# onclick="helpscript(s_10);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
<tr> 
<td class="td1"><U>用户列表TOP个数</U></td>
<td class="td1"> 
<input title="请输入整数 $!cint" type="text" name="forum_setting(68)" size="6" value="<%=Dvbbs.forum_setting(68)%>">&nbsp;个
</td>
<input type="hidden" id="s_11" value="<b>用户列表TOP个数</b><br><li>在开启了TOP排行的情况下，将根据这里所设置的数字读取所规定数目的用户数据<br><li>出于用户数据安全上的考虑和出于论坛资源消耗方面的考虑，您也可以减少该选项的设置数目">
<td class="td1"><a href=# onclick="helpscript(s_11);return false;" class="helplink"><img src="skins/images/help.gif" border=0 title="点击查阅管理帮助！"></a></td>
</tr>
</table><BR>

<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=2 align=left id=tabletitlelink><a name="setting18"></a><b>论坛分页设置</b>[<a href="#top">顶部</a>]</th>
</tr>
<tr> 
<td class="td1"  width="50%"> <U>每页显示最多纪录</U><BR>用于论坛所有和分页有关的项目（帖子列表和浏览帖子除外）</td>
<td class="td1"  width="50%">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(11)" size="3" value="<%=Dvbbs.forum_setting(11)%>">&nbsp;条
</td>
</tr>
</table><BR>

<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr>
<th height=25 colspan=2 align=left id=tabletitlelink><a name="setting_seo"></a><b>搜索引擎优化设置(SEO)</b>[<a href="#top">顶部</a>]</th>
</tr>
<tr> 
<td class="td1"  width="50%"> <U>Title 描述：</U><BR>为所有页面输入站点的标题(title)描述，让搜索引擎更容易找到您的论坛。</td>
<td class="td1"  width="50%">  
<input title="值不能为空 $!" type="text" name="forum_setting(111)" size="35" value="<%=Dvbbs.forum_setting(111)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td1"> <U>Meta 关键词：</U><BR>为所有页面输入 Meta 关键词，让搜索引擎更容易找到您的论坛。</td>
<td width="50%" class="td1">  
<input title="值不能为空 $!" type="text" name="Forum_info(8)" size="35" value="<%=Dvbbs.Forum_info(8)%>">
</td>
</tr>
<tr> 
<td width="50%" class="td2"> <U>Meta 描述：</U><BR>为所有页面输入 Meta 描述，以便能够在搜索引擎中正确搜索到您的论坛。<BR><font color=red>介绍中请不要带英文的逗号</font></td>
<td width="50%" class="td2">  
<input title="值不能为空 $!" type="text" name="Forum_info(10)" size="35" value="<%=Dvbbs.Forum_info(10)%>">
</td>
</tr>
</table><BR>

<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=2 align=left id=tabletitlelink><a name="setting16"></a><b>帖子选项</b>[<a href="#top">顶部</a>]</td>
</tr>
<tr>
<td class="td1"  width="50%"> <U>作为热门话题的最低人气值</U><BR>标准为主题回复数</td>
<td class="td1"  width="50%">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(44)" size="3" value="<%=Dvbbs.forum_setting(44)%>">&nbsp;条
</td>
</tr>
<tr> 
<td class="td2"> <U>编辑过的帖子显示“由xxx于yyy编辑”的信息</U></td>
<td class="td2">  
<input type=radio name="forum_setting(48)" value=0 <%if Dvbbs.forum_setting(48)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(48)" value=1 <%if Dvbbs.forum_setting(48)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
<tr> 
<td class="td1"> <U>管理员编辑后显示“由XXX编辑”的信息</U></td>
<td class="td1">  
<input type=radio name="forum_setting(49)" value=0 <%if Dvbbs.forum_setting(49)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(49)" value=1 <%if Dvbbs.forum_setting(49)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
<tr> 
<td class="td2"> <U>等待“由XXX编辑”信息显示的时间</U><BR>允许用户编辑自己的帖子而不在帖子底部显示“由XXX编辑”信息的时限（以分钟为单位）</td>
<td class="td2">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(50)" size="3" value="<%=Dvbbs.forum_setting(50)%>">&nbsp;分钟
</td>
</tr>
<tr> 
<td class="td1"> <U>编辑帖子时限</U><BR>编辑处理帖子的时间限制（以分钟为单位，1天是1440分钟）超过这个时间限制，只有管理员和版主才能编辑和删除帖子。如果不想使用这项功能，请设置为0</td>
<td class="td1">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(51)" size="3" value="<%=Dvbbs.forum_setting(51)%>">&nbsp;分钟
</td>
</tr>
</table>
<BR>
<!--
<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=2 align=left id=tabletitlelink><a name="setting19"></a><b>门派设置</b>[<a href="#top">顶部</a>]
</tr>
<tr> 
<td class="td2"  width="50%"> <U>是否开启论坛门派</U></td>
<td class="td2">  
<input type=radio name="forum_setting(32)" value=0 checked class="radio">否&nbsp;
<input type=radio name="forum_setting(32)" value=1 class="radio">是&nbsp;
</td>
</tr>
</table>
<BR>
-->
<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=2 align=left id=tabletitlelink><a name="setting19"></a><b>VIP用户组功能开启设置</b>[<a href="#top">顶部</a>]
</tr>
<tr> 
<td class="td2"  width="50%"><a name="SettingVIP"></a>
<U>是否VIP用户组功能</U>
<br>若开启VIP用户组功能，请确认论坛用户组（等级）管理里是否添加了VIP用户组</td>
<td class="td2">  
<input type=radio name="forum_setting(43)" value=0 <%if Dvbbs.forum_setting(43)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(43)" value=1 <%if Dvbbs.forum_setting(43)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
</table>
<BR>
<table border="0" cellspacing="1" cellpadding="3" align="center" width="100%">
<tr> 
<th height=25 colspan=2 align=left id=tabletitlelink><a name="settingxu"></a><b>动网官方插件选项</b>[<a href="#top">顶部</a>]
</tr>
<tr> 
<td class="td1" width="50%"> <U>道具功能总开关</U></td>
<td class="td1" width="43%">  
<input type=radio name="forum_setting(90)" value=0 <%if Dvbbs.forum_setting(90)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(90)" value=1 <%if Dvbbs.forum_setting(90)="1" then%>checked<%end if%> class="radio">开启&nbsp;
</td>
</tr>
<tr> 
<td class="td2"> <U>道具中心买卖交易</U></td>
<td class="td2">  
<input type=radio name="forum_setting(91)" value=0 <%if Dvbbs.forum_setting(91)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(91)" value=1 <%if Dvbbs.forum_setting(91)="1" then%>checked<%end if%> class="radio">开启&nbsp;
</td>
</tr>
<tr> 
<td class="td1"> <U>道具中心采用独立数据库</U><BR>若设为独立，请自行修改CONN.ASP文件，设置独立数据库路径</td>
<td class="td1">  
<input type=radio name="forum_setting(92)" value=0 <%if Dvbbs.forum_setting(92)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(92)" value=1 <%if Dvbbs.forum_setting(92)="1" then%>checked<%end if%> class="radio">开启&nbsp;
</td>
</tr>
<tr> 
<td class="td2" width="50%"> <U>魔法表情（头像）总开关</U><BR>该功能数据库采用道具中心数据库，功能可独立于道具中心之外开关</td>
<td class="td2" width="43%">  
<input type=radio name="forum_setting(98)" value=0 <%if Dvbbs.forum_setting(98)="0" then%>checked<%end if%> class="radio">关闭&nbsp;
<input type=radio name="forum_setting(98)" value=1 <%if Dvbbs.forum_setting(98)="1" then%>checked<%end if%> class="radio">开启&nbsp;
</td>
</tr>
<tr> 
<td class="td1"  width="50%"> <U>是否启用博客功能</U><BR>开启后请打开boke/config.asp文件做好相关设置</td>
<td class="td1">  
<input type=radio name="forum_setting(99)" value=0 <%if Dvbbs.forum_setting(99)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(99)" value=1 <%if Dvbbs.forum_setting(99)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>

<!--如果要开启勋章插件请去掉这行代码-->
<tr> 
<td class="td1"  width="50%"> <U>是否启用勋章功能</U></td>
<td class="td1">  
<input type=radio name="forum_setting(104)" value=0 <%if Dvbbs.forum_setting(104)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(104)" value=1 <%if Dvbbs.forum_setting(104)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>


<!--如果要开启在线时长统计功能请去掉这行代码
<tr> 
<td class="td1"  width="50%"> <U>是否启用在线时长统计功能</U></td>
<td class="td1">  
<input type=radio name="forum_setting(102)" value=0 <%if Dvbbs.forum_setting(102)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(102)" value=1 <%if Dvbbs.forum_setting(102)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
-->

<!--如果要启用版主评价功能请去掉这行代码
<tr> 
<td class="td1"  width="50%"> <U>是否启用版主评价功能</U></td>
<td class="td1">  
<input type=radio name="forum_setting(110)" value=0 <%if Dvbbs.forum_setting(110)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(110)" value=1 <%if Dvbbs.forum_setting(110)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
-->
<tr> 
<td class="td1"  width="50%"> <U>是否显示分栏</U></td>
<td class="td1">  
<input type=radio name="forum_setting(103)" value=0 <%if Dvbbs.forum_setting(103)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(103)" value=1 <%if Dvbbs.forum_setting(103)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
<tr> 
<th height=25 colspan=3 align=left id=tabletitlelink><a name="setting23"></a><b>论坛金币汇率设置</b></th>
</tr>
<tr> 
<td class="td2" width="50%"> <U>金钱与金币汇率</U></td>
<td class="td2">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(93)" size="6" value="<%=Dvbbs.forum_setting(93)%>">&nbsp;金钱=1金币
</td>
</tr>
<tr> 
<td class="td1" width="50%"> <U>积分与金币汇率</U></td>
<td class="td1">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(94)" size="6" value="<%=Dvbbs.forum_setting(94)%>">&nbsp;积分=1金币
</td>
</tr>
<tr> 
<td class="td2" width="50%"> <U>魅力与金币汇率</U></td>
<td class="td2">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(95)" size="6" value="<%=Dvbbs.forum_setting(95)%>">&nbsp;魅力=1金币
</td>
</tr>
<tr>
<td class="td1" width="50%"> <U>点券与金币汇率</U></td>
<td class="td1">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(96)" size="6" value="<%=Dvbbs.forum_setting(96)%>">&nbsp;点券=1金币
</td>
</tr>
<tr> 
<th height=25 colspan=3 align=left id=tabletitlelink><a name="setting23"></a><b>其它设置</b></th>
</tr>
<tr>
<td class="td2" width="50%"> <U>版主每日可奖励金币个数</U></td>
<td class="td2">  
<input title="请输入整数 $!cint" type="text" name="forum_setting(97)" size="6" value="<%=Dvbbs.forum_setting(97)%>">&nbsp;个金币
</td>
</tr>
<tr> 
<th height=25 colspan=3 align=left id=tabletitlelink><a name="setting23"></a><b>全站审核设置</b></th>
</tr>
<tr>
<td class="td2" width="50%"> <U>是否开启除管理员，版主，超版以外的其它所有用户组发帖需要审核</U></td>
<td class="td2">  
<input type=radio name="forum_setting(108)" value=0 <%if Dvbbs.forum_setting(108)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(108)" value=1 <%if Dvbbs.forum_setting(108)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
<tr>
<td class="td2" width="50%"> <U>是否开启含有非法关键词不允许发功能</U>&nbsp;&nbsp;&nbsp;<a href="Badlanguage.asp">点击这里设置关键词</a></td>
<td class="td2">  
<input type=radio name="forum_setting(109)" value=0 <%if Dvbbs.forum_setting(109)="0" then%>checked<%end if%> class="radio">否&nbsp;
<input type=radio name="forum_setting(109)" value=1 <%if Dvbbs.forum_setting(109)="1" then%>checked<%end if%> class="radio">是&nbsp;
</td>
</tr>
<tr>
<td class="td2" width="50%"> <U>网站导航设置</U>&nbsp;&nbsp;&nbsp;</td>
<td class="td2">  
<input type=radio name="forum_setting(112)" value=0 <%if Dvbbs.forum_setting(112)="0" then%>checked<%end if%> class="radio">开启&nbsp;
<input type=radio name="forum_setting(112)" value=1 <%if Dvbbs.forum_setting(112)="1" then%>checked<%end if%> class="radio">关闭&nbsp;建议在版块多时关闭此功能
</td>
</tr>
<tr> 
<td width="50%" class="td1"> &nbsp;</td>
<td width="50%" class="td1">
<input type="submit" name="Submit" value="提 交" class="button">
</td>
</tr>
</table>
</form>
<SCRIPT LANGUAGE="JavaScript">
CheckSel('forum_setting(2)','<%=Dvbbs.forum_setting(2)%>');
CheckSel('UploadSetting(0)','<%=UploadSetting(0)%>');
CheckSel('UploadSetting(2)','<%=UploadSetting(2)%>');
CheckSel('UploadSetting(3)','<%=UploadSetting(3)%>');
CheckSel('UploadSetting(7)','<%=UploadSetting(7)%>');
CheckSel('UploadSetting(8)','<%=UploadSetting(8)%>');
CheckSel('UploadSetting(13)','<%=UploadSetting(13)%>');
CheckSel('UploadSetting(16)','<%=UploadSetting(16)%>');
CheckSel('UploadSetting(17)','<%=UploadSetting(17)%>');
</script>
<div id="Issubport0" style="display:none">请选择EMAIL组件！</div>
<div id="Issubport999" style="display:none"></div>
<%
Dim InstalledObjects(12)
InstalledObjects(1) = "JMail.Message"				'JMail 4.3
InstalledObjects(2) = "CDONTS.NewMail"				'CDONTS
InstalledObjects(3) = "Persits.MailSender"			'ASPEMAIL
'-----------------------
InstalledObjects(4) = "Adodb.Stream"				'Adodb.Stream
InstalledObjects(5) = "Persits.Upload"				'Aspupload3.0
InstalledObjects(6) = "SoftArtisans.FileUp"			'SA-FileUp 4.0
InstalledObjects(7) = "DvFile.Upload"				'DvFile-Up V1.0
'-----------------------
InstalledObjects(9) = "CreatePreviewImage.cGvbox"	'CreatePreviewImage
InstalledObjects(10) = "Persits.Jpeg"				'AspJpeg
InstalledObjects(11) = "SoftArtisans.ImageGen"		'SoftArtisans ImgWriter V1.21
InstalledObjects(12) = "sjCatSoft.Thumbnail"		'sjCatSoft.Thumbnail V2.6

For i=1 to 12
	Response.Write "<div id=""Issubport"&i&""" style=""display:none"">"
	If IsObjInstalled(InstalledObjects(i)) Then Response.Write InstalledObjects(i)&":<font color=red><b>√</b>服务器支持!</font>" Else Response.Write InstalledObjects(i)&"<b>×</b>服务器不支持!" 
	Response.Write "</div>"
Next
%>
<SCRIPT LANGUAGE="JavaScript">
<!--
function chkselect(s,divid)
{
var divname='Issubport';
var chkreport;
	s=Number(s)
	if (divid=="know1")
	{
	divname=divname+s;
	}
	if (divid=="know2")
	{
	s+=4;
	if (s==1003){s=999;}
	divname=divname+s;
	}
	if (divid=="know3")
	{
	s+=9;
	if (s==1008){s=999;}
	divname=divname+s;
	}
document.getElementById(divid).innerHTML=divname;
chkreport=document.getElementById(divname).innerHTML;
document.getElementById(divid).innerHTML=chkreport;
}
//-->
</SCRIPT>
<%
end Sub
'判断表单参数
Function checkinput(inputname,errmsg)'参1=表单名 参2=错误停息
Dim item,itemarr,i
If inputname="forum_setting" Then 
item="1,5,84,38,39,40,41,22,8,26,54,57,58,59,60,61,20,3,12,68,11,44,50,51,93,94,95,96,97,101"  '表单序号
Else 
item="1,5,10,11,12,14,15" '表单序号
End If 
itemarr=Split(item,",")
For Each i In itemarr
	If Request(inputname&"("&i&")")="" Or IsNull(Request(inputname&"("&i&")")) Or Not IsNumeric(Request(inputname&"("&i&")")) Then 
	errmsg=inputname&"("&i&")值为空或不为整数类型，请返回重写"
	Exit For 
	End If 
	If Request(inputname&"("&i&")")>2147483647 Then 
	errmsg=inputname&"("&i&")值超过2147483647,会导致溢出报错，请返回重写"
	Exit For 
	End If 
Next 
End function 

Sub saveconst()
	Dim Forum_copyright,Forum_info,forum_setting,iforum_setting,isetting
	Dim Forum_Maxonline,Forum_TopicNum,Forum_PostNum
	Dim Forum_UserNum,Forum_MaxPostNum,Forum_MaxPostDate,Forum_MaxonlineDate
	Dim Forum_pack
	Dim UploadSetting,Tempstr,i
	
	If not IsDate(Request.Form("Forum_Setting(74)")) Then 
		Errmsg=ErrMsg + "<li>论坛创建日期必须是一个有效日期。"
		Dvbbs_error()
		Exit Sub
	End If
	
	If not IsDate(Request.Form("Forum_MaxPostDate")) Then 
		Errmsg=ErrMsg + "<li>论坛最高日发贴发生时间日期必须是一个有效日期。"
		Dvbbs_error()
		Exit Sub
	Else
		Forum_MaxPostDate=Request.Form("Forum_MaxPostDate")
	End If
	
	If not IsDate(Request.Form("Forum_MaxonlineDate")) Then 
		Errmsg=ErrMsg + "<li>历史最高同时在线纪录发生时间日期必须是一个有效日期。"
		Dvbbs_error()
		Exit Sub
	Else
		Forum_MaxonlineDate=Request.Form("Forum_MaxonlineDate")
	End If
	
	
	Forum_Maxonline	= Request.Form("Forum_Maxonline")
	Forum_TopicNum	= Request.Form("Forum_TopicNum")
	Forum_PostNum	= Request.Form("Forum_PostNum")
	Forum_UserNum	= Request.Form("Forum_UserNum")
	Forum_MaxPostNum= Request.Form("Forum_MaxPostNum")
	Forum_pack	= Request.Form("Forum_pack(0)")&"|||"&Trim(Request.Form("Forum_pack(1)"))
	
	If Not ISNumeric(Forum_Maxonline&Forum_TopicNum&Forum_PostNum&Forum_UserNum&Forum_MaxPostNum) Then 
		Errmsg=ErrMsg + "<li>非法的参数，论坛系统数据出错，提交中止。"
		Dvbbs_error()
		Exit Sub
	End If
	
	'If not isnumeric(request.Form("cid")) or not isnumeric(request.Form("Sid")) Then
	'	Errmsg=ErrMsg + "<li>请选择模板与风格！"
	'	Dvbbs_error()
	'	Exit Sub
	'End IF
	
'新添加表单数字类型判断
checkinput "forum_setting",ErrMsg
checkinput "UploadSetting",ErrMsg
	If errmsg<>"" Then 
	Dvbbs_error()
	Exit Sub
	End If 
	
	UploadSetting = ""
	For i=0 To 20
		Tempstr = Trim(Request.Form("UploadSetting("&i&")"))
		If Tempstr = "" Then
			UploadSetting = UploadSetting & 0
		Else
			UploadSetting = UploadSetting & Replace(Replace(Tempstr,"|",""),",","")
		End If
		If i<20 Then
			UploadSetting = UploadSetting & "|"
		End If
	Next
	
	Dim setingdata,j,Rs,SQL
	If Forum_Maxonline="" Then Forum_Maxonline=0
	If Forum_TopicNum="" Then Forum_TopicNum=0
	If Forum_PostNum="" Then Forum_PostNum=0
	If Forum_UserNum="" Then Forum_UserNum=0
	If Forum_MaxPostNum="" Then Forum_MaxPostNum=0
	For i = 0 To 120
		If Trim(request.Form("Forum_Setting("&i&")"))="" Or i=70 or i = 7 Then
			'Response.Write "Forum_Setting("&i&")<br>"
			isetting=0
			If i=7 Then
				isetting = UploadSetting
			End If
			If i=70 Then
				isetting=""
				For j=0 to  23
					If isetting="" Then
						If Request.form("Forum_Setting(70)"&j)="1" Then
							isetting="1"
						Else
							isetting="0"
						End If
					Else
						If Request.form("Forum_Setting(70)"&j)="1" Then
							isetting=isetting&"|1"
						Else
							isetting=isetting&"|0"
						End If
					End If
				Next
			End If		
		Else
			isetting=Replace(Trim(request.Form("Forum_Setting("&i&")")),",","")
		End If
	
		If i = 0 Then
			forum_setting = isetting
		Else
			forum_setting = forum_setting & "," & isetting
		End If
	Next
	
	For i = 0 To 13
		If Trim(Request.Form("Forum_info("&i&")")) = "" And i <> 4 And i <> 12 And i<>13 Then
			'Response.Write "Forum_info("&i&")<br>"
			isetting=0
		Else
			isetting=Replace(Trim(request.Form("Forum_info("&i&")")),",","")
		End If
		If i = 0 Then
			Forum_info = isetting
		Else
			Forum_info = Forum_info & "," & isetting
		End If
	Next
	Forum_copyright=request("copyright")
	'forum_info|||forum_setting|||forum_user|||copyright|||splitword|||stopreadme
	Set rs=Dvbbs.execute("select forum_setting from dv_setup")
	iforum_setting=split(rs(0),"|||")
	forum_setting=forum_info & "|||" & forum_setting & "|||" & iforum_setting(2) & "|||" & Forum_copyright & "|||" & iforum_setting(4) & "|||" & request.Form("StopReadme")
	forum_setting=Replace(forum_setting,"'","''")
	Dim Forum_AdminFolder
	Forum_AdminFolder=Request("Forum_AdminFolder")
	If Forum_AdminFolder<>"" Then
		Forum_AdminFolder=Forum_AdminFolder&"/"
		Forum_AdminFolder=replace(Forum_AdminFolder,"\","/")
		Forum_AdminFolder=replace(Forum_AdminFolder,"//","/")
	Else
		Forum_AdminFolder=Dvbbs.CacheData(33,0)
	End If
	
	sql="update Dv_setup set Forum_AdminFolder='"&Dvbbs.Checkstr(Forum_AdminFolder)&"',Forum_Setting='"&forum_setting&"',forum_sid="&Dvbbs.CheckNumeric(request.Form("Sid"))
	sql=sql+",Forum_Maxonline="&Forum_Maxonline&",Forum_TopicNum="&Forum_TopicNum&",Forum_PostNum="&Forum_PostNum &",Forum_UserNum="&Forum_UserNum&",Forum_MaxPostNum="&Forum_MaxPostNum&",Forum_MaxPostDate='"&Forum_MaxPostDate &"',Forum_MaxonlineDate='"&Forum_MaxonlineDate&"',Forum_pack='"&Forum_pack&"'"
	dvbbs.execute(sql)
	Dvbbs.loadSetup()
	Dvbbs.Loadstyle()
	Dvbbs.Name="CustomIndex"
	Dvbbs.RemoveCache()
	Dv_suc("设置论坛常规信息成功")
end sub

'恢复默认设置
Sub restore()
	Dim Forum_setting
	'forum_setting="  动网先锋论坛,http://bbs.dvbbs.net,动网先锋,http://www.aspsky.net/,,eway@aspsky.net,images/logo.gif,http://www.aspsky.cn/email.asp,aspsky|dvbbs|动网|动网论坛|asp|论坛|插件,北京时间,动网论坛是使用量最多、覆盖面最广的免费中文论坛，也是国内知名的技术讨论站点，希望我们辛苦的努力可以为您带来很多方便,index.asp,,|||0,300,0,60,2|20,1,1,2|100|0|999|bbs.dvbbs.net|12|#FF0000|Arial|0|images/WaterMap.gif|0.7|110|35|4|120|100|1|2|#0066cc|0|0,40,dvbbs|sql|aspsky|asp|php|cgi|jsp|htm,0,20,500,20|200,0,0,1,1,1,0,30,0,7200,0,1,0,0,1,1,0,1,1,1,1,1,1,0,1,32,32,1,10,1,0,10,0,1,0,1,1,0,0,0,1,10,1,0,120,30,9,15,4,0,0,0,1,0,1,20,0,1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1,0,0,0,2000-3-26,0,UploadFile/,object|EMBED|,1,1,1,1,0,0,5,0,0,0,0,0,1,1,0,50,30,20,5,100,1,0,0,0,1,0,1|||100,15,12,12,8,60,10,5,5,6,30,6,2,2,3,25,15,20|||Copyright &copy;2000 - 2005  <a href=http://www.dvbbs.net><font face=Verdana, Arial, Helvetica, sans-serif><b>Aspsky<font color=#CC0000>.Net</font></b></font></a>|||!,@,#,$,%,^,&,*,(,),{,},[,],|,\,.,/,?,`,~|||论坛暂停使用"

	Forum_setting="动网先锋论坛,http://bbs.dvbbs.net,动网先锋,http://www.dvbbs.net/,,eway@aspsky.net,images/logo.gif,http://www.dvbbs.net/contact.asp,aspsky|dvbbs|动网|动网论坛|asp|论坛|插件,北京时间,动网论坛是使用量最多、覆盖面最广的免费中文论坛，也是国内知名的技术讨论站点，希望我们辛苦的努力可以为您带来很多方便,index.asp,,|||0,300,1,60,2|20,1,1,2|100|0|999|bbs.dvbbs.net|12|#FF0000|Arial|0|images/WaterMap.gif|0.7|110|35|4|120|100|1|2|#0066cc|0|0,20,dvbbs|sql|aspsky|asp|php|cgi|jsp|htm,0,20,500,20|200,0,0,1,1,1,0,30,0,7200,0,1,0,0,1,1,0,1,1,0,1,1,1,0,1,48,48,1,12,1,0,10,0,1,0,1,1,0,0,0,1,10,1,0,120,30,9,15,4,0,0,0,1,0,1,20,0,1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1,0,0,0,2000-3-26,0,UploadFile/,0,1,1,1,1,0,0,5,0,0,0,0,1,1,1,0,50,30,20,0.2,100,1,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0|||100,15,12,12,8,60,10,5,5,6,30,6,2,2,3,25,15,20|||Copyright &copy; 2000 - 2008  <a href=""http://www.dvbbs.net""><font face=""Verdana, Arial, Helvetica, sans-serif""><b>Dvbbs<font color=""#CC0000"">.Net</font></b></font></a>|||!,@,#,$,%,^,&,*,(,),{,},[,],|,\,.,/,?,`,~|||论坛暂停使用."

	Conn.Execute("update Dv_setup set Forum_Setting='"&forum_setting&"'")
	Dv_suc("还原论坛常规设置成功")
	Dvbbs.loadSetup()
	Dvbbs.Loadstyle()
End Sub

Function IsObjInstalled(strClassString)
	On Error Resume Next
	IsObjInstalled = False
	Err = 0
	Dim xTestObj
	Set xTestObj = Dvbbs.iCreateObject(strClassString)
	If Err = 0 Then IsObjInstalled = True
	If Err = -2147352567 Then IsObjInstalled = True
	Set xTestObj = Nothing
	Err = 0
End Function
%>