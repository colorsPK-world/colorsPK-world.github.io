<%
Rem 除首页外通用函数
'Dvbbs.Board_Setting(40)是否继承上级版主，顺带取出上级论坛版面信息
'最多只取向上的10级版面信息
'输出导航菜单字串
If Request("poststyle")="1" Then
	Dvbbs.ErrType=1
End If

Sub CheckBoardInfo()
	Dim parentstr,parentboard,XpathSQL,i,Maxdepth,Node,NavStr
	parentstr = Application(Dvbbs.CacheName&"_boardlist").documentElement.selectSingleNode("board[@boardid='"&Dvbbs.BoardID&"']/@parentstr").text
	parentboard=Split(parentstr,",")
	If Dvbbs.UserID > 0 and Not Dvbbs.BoardMaster And CLng(Dvbbs.UserGroupID)=3 Then
		If Dvbbs.Board_Setting(40)="1" And Dvbbs.BoardParentID > 0 Then
			For i=0 to UBound(parentboard)
				If parentboard(i) <> "0" Then XpathSQL=XpathSQL &" or @boardid = " & parentboard(i)
			Next
		End If
		XpathSQL="boardmaster[@boardid = "& Dvbbs.Boardid & XpathSQL &"]/master[ . ='"& Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@username").text &"']"
		Dvbbs.BoardMaster=Not Application(Dvbbs.CacheName&"_boardmaster").documentElement.selectSingleNode(XpathSQL) Is Nothing
	End If
	If Dvbbs.BoardParentID > 0 Then
		Maxdepth=9
		If Ubound(parentboard) < Maxdepth+1 Then
			Maxdepth=Ubound(parentboard)
		End If
		For i=0 to Maxdepth
			If parentboard(i) <> "0"  Then
				Set Node=Application(Dvbbs.CacheName&"_boardlist").documentElement.selectSingleNode("board[@boardid='"& parentboard(i) &"']")
				If Node Is Nothing Then Exit For
				If i=0 Then
						NavStr=" <a href=""index.asp?boardid="& parentboard(i) &""" onmouseover=""showmenu(event,BoardJumpList("&Node.selectSingleNode("@boardid").text&"),'',0);"">"& Node.selectSingleNode("@boardtype").text &"</a> "
					Else
						NavStr=NavStr& "→ <a href=""index.asp?boardid="& parentboard(i) &""">"& Node.selectSingleNode("@boardtype").text &"</a> "
					End If
			End If
		Next
	End If
	Dvbbs.BoardInfoData=NavStr
	GetBoardPermission()
End Sub
Sub GetBoardPermission()
	Dim Rs,IsGroupSetting
	If Not Application(Dvbbs.CacheName &"_boarddata_" & Dvbbs.Boardid).documentElement.selectSingleNode("boarddata/@isgroupsetting") is nothing Then IsGroupSetting = Application(Dvbbs.CacheName &"_boarddata_" & Dvbbs.Boardid).documentElement.selectSingleNode("boarddata/@isgroupsetting").text
	If IsGroupSetting <> ""  Then
		IsGroupSetting = "," & IsGroupSetting & ","
		If InStr(IsGroupSetting,"," & Dvbbs.UserGroupID & ",")>0 Then
			Set Rs=Dvbbs.Execute("Select PSetting From Dv_BoardPermission Where Boardid="&Dvbbs.Boardid&" And GroupID="&Dvbbs.UserGroupID)
			If Not (Rs.Eof And Rs.Bof) Then
				Dvbbs.GroupSetting = Split(Rs(0),",")
			End If
			Set Rs=Nothing
		End If
		If Dvbbs.UserID>0 And InStr(IsGroupSetting,",0_"&Dvbbs.UserID&",")>0 Then
			Set Rs=Dvbbs.execute("Select Uc_Setting From Dv_UserAccess Where Uc_Boardid="&Dvbbs.BoardID&" And uc_UserID="&Dvbbs.Userid)
			If Not(Rs.Eof And Rs.Bof) Then
				Dvbbs.UserPermission=Split(Rs(0),",")
				Dvbbs.GroupSetting = Split(Rs(0),",")
				Dvbbs.FoundUserPer=True
			End If
			Set Rs=Nothing
		If Dvbbs.GroupSetting(70)="1"  Then
				Dvbbs.Master = True
			Else
				Dvbbs.Master = False
			End If
		End If
	End If
	If Not Dvbbs.BoardMaster Then Chkboardlogin()
End Sub
Rem 能否进入论坛的判断
Public Sub Chkboardlogin()
	If Dvbbs.Board_Setting(1)="1" And Dvbbs.GroupSetting(37)="0" Then Dvbbs.AddErrCode(26)
	If Dvbbs.GroupSetting(0)="0"  Then Dvbbs.AddErrCode(27)
	'访问论坛限制(包括文章、积分、金钱、魅力、威望、精华、被删数、注册时间)
	Dim BoardUserLimited
	BoardUserLimited = Split(Dvbbs.Board_Setting(54),"|")
	If Ubound(BoardUserLimited)=8 Then
		'文章
		If Trim(BoardUserLimited(0))<>"0" And IsNumeric(BoardUserLimited(0)) Then
			If Dvbbs.UserID = 0 Then Response.redirect "showerr.asp?ShowErrType="&Dvbbs.ErrType&"&ErrCodes=<li>本版面设置了用户发贴最少为 <B>"&BoardUserLimited(0)&"</B> 才能进入&action=OtherErr"
			If Clng(Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@userpost").text)<Clng(BoardUserLimited(0)) Then Response.redirect "showerr.asp?ShowErrType="&Dvbbs.ErrType&"&ErrCodes=<li>本版面设置了用户发贴最少为 <B>"&BoardUserLimited(0)&"</B> 才能进入&action=OtherErr"
		End If
		'积分
		If Trim(BoardUserLimited(1))<>"0" And IsNumeric(BoardUserLimited(1)) Then
			If Dvbbs.UserID = 0 Then Response.redirect "showerr.asp?ShowErrType="&Dvbbs.ErrType&"&ErrCodes=<li>本版面设置了用户积分最少为 <B>"&BoardUserLimited(1)&"</B> 才能进入&action=OtherErr"
			If Clng(Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@userep").text)<Clng(BoardUserLimited(1)) Then Response.redirect "showerr.asp?ShowErrType="&Dvbbs.ErrType&"&ErrCodes=<li>本版面设置了用户积分最少为 <B>"&BoardUserLimited(1)&"</B> 才能进入&action=OtherErr"
		End If
		'金钱
		If Trim(BoardUserLimited(2))<>"0" And IsNumeric(BoardUserLimited(2)) Then
			If Dvbbs.UserID = 0 Then Response.redirect "showerr.asp?ShowErrType="&Dvbbs.ErrType&"&ErrCodes=<li>本版面设置了用户金钱最少为 <B>"&BoardUserLimited(2)&"</B> 才能进入&action=OtherErr"
			If Clng(Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@userwealth").text)<Clng(BoardUserLimited(2)) Then Response.redirect "showerr.asp?ShowErrType="&Dvbbs.ErrType&"&ErrCodes=<li>本版面设置了用户金钱最少为 <B>"&BoardUserLimited(2)&"</B> 才能进入&action=OtherErr"
		End If
		'魅力
		If Trim(BoardUserLimited(3))<>"0" And IsNumeric(BoardUserLimited(3)) Then
			If Dvbbs.UserID = 0 Then Response.redirect "showerr.asp?ShowErrType="&Dvbbs.ErrType&"&ErrCodes=<li>本版面设置了用户魅力最少为 <B>"&BoardUserLimited(3)&"</B> 才能进入&action=OtherErr"
			If Clng(Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@usercp").text)<Clng(BoardUserLimited(3)) Then Response.redirect "showerr.asp?ShowErrType="&Dvbbs.ErrType&"&ErrCodes=<li>本版面设置了用户魅力最少为 <B>"&BoardUserLimited(3)&"</B> 才能进入&action=OtherErr"
		End If
		'威望
		If Trim(BoardUserLimited(4))<>"0" And IsNumeric(BoardUserLimited(4)) Then
			If Dvbbs.UserID = 0 Then Response.redirect "showerr.asp?ShowErrType="&Dvbbs.ErrType&"&ErrCodes=<li>本版面设置了用户威望最少为 <B>"&BoardUserLimited(4)&"</B> 才能进入&action=OtherErr"
			If Clng(Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@userpower").text)<Clng(BoardUserLimited(4)) Then Response.redirect "showerr.asp?ShowErrType="&Dvbbs.ErrType&"&ErrCodes=<li>本版面设置了用户威望最少为 <B>"&BoardUserLimited(4)&"</B> 才能进入&action=OtherErr"
		End If
		'精华
		If Trim(BoardUserLimited(5))<>"0" And IsNumeric(BoardUserLimited(5)) Then
			If Dvbbs.UserID = 0 Then Response.redirect "showerr.asp?ShowErrType="&Dvbbs.ErrType&"&ErrCodes=<li>本版面设置了用户精华最少为 <B>"&BoardUserLimited(5)&"</B> 才能进入&action=OtherErr"
			If Clng(Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@userisbest").text)<Clng(BoardUserLimited(5)) Then Response.redirect "showerr.asp?ShowErrType="&Dvbbs.ErrType&"&ErrCodes=<li>本版面设置了用户精华最少为 <B>"&BoardUserLimited(5)&"</B> 才能进入&action=OtherErr"
		End If
		'删贴
		If Trim(BoardUserLimited(6))<>"0" And IsNumeric(BoardUserLimited(6)) Then
			If Dvbbs.UserID = 0 Then Response.redirect "showerr.asp?ShowErrType="&Dvbbs.ErrType&"&ErrCodes=<li>本版面设置了用户被删贴少于 <B>"&BoardUserLimited(6)&"</B> 才能进入&action=OtherErr"
			If Clng(Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@userdel").text)>Clng(BoardUserLimited(6)) Then Response.redirect "showerr.asp?ShowErrType="&Dvbbs.ErrType&"&ErrCodes=<li>本版面设置了用户被删贴少于 <B>"&BoardUserLimited(6)&"</B> 才能进入&action=OtherErr"
		End If
		'注册时间
		If Trim(BoardUserLimited(7))<>"0" And IsNumeric(BoardUserLimited(7)) Then
			If Dvbbs.UserID = 0 Then Response.redirect "showerr.asp?ShowErrType="&Dvbbs.ErrType&"&ErrCodes=<li>本版面设置了用户注册时间大于 <B>"&BoardUserLimited(7)&"</B> 分钟才能进入&action=OtherErr"
			If DateDiff("s",Dvbbs.UserSession.documentElement.selectSingleNode("userinfo/@joindate").text,Now)<Clng(BoardUserLimited(7))*60 Then Response.redirect "showerr.asp?ShowErrType="&Dvbbs.ErrType&"&ErrCodes=<li>本版面设置了用户注册时间大于 <B>"&BoardUserLimited(7)&"</B> 分钟才能进入&action=OtherErr"
		End If
		
	End If
	'认证版块判断Board_Setting(2)
	If Dvbbs.Board_Setting(2)="1" Then
		Dim Get_BoardUser_Money,Canlogin,Boarduser,i,BoardUser_Money
		Get_BoardUser_Money = False
		If Clng(Dvbbs.Board_Setting(62))>0 Or Clng(Dvbbs.Board_Setting(63))>0 Then Get_BoardUser_Money = True
			Canlogin = False
		If Dvbbs.UserID=0 Then
			Dvbbs.AddErrCode(24)
			Dvbbs.showerr()
		Else
			If Not Application(Dvbbs.CacheName &"_boarddata_" & Dvbbs.Boardid).documentElement.selectSingleNode("boarddata/@boarduser") Is Nothing Then boarduser=Application(Dvbbs.CacheName &"_boarddata_" & Dvbbs.Boardid).documentElement.selectSingleNode("boarddata/@boarduser").text
			If Boarduser=""  Then	
				Canlogin = False
			Else
				Boarduser=Split(Boarduser,",")
				For i = 0 To Ubound(Boarduser)
					If Get_BoardUser_Money Then
						BoardUser_Money = Split(Boarduser(i),"=")
						If Trim(Lcase(BoardUser_Money(0))) = Trim(Lcase(Dvbbs.MemberName)) Then
							'修改判断支付金币或点券进入版面的有效期 2004-8-29 Dv.Yz
							If Not DateDiff("d",BoardUser_Money(1),Now()) > Cint(Dvbbs.Board_Setting(64))*30 Then
								Canlogin = True
								Exit For
							End If
						End If
					Else
						If Trim(Lcase(Boarduser(i))) = Trim(Lcase(Dvbbs.MemberName)) Then
							Canlogin = True
							Exit For
						End If
					End If
				Next
			End If
		End If
		If Get_BoardUser_Money And Instr(Lcase(Dvbbs.ScriptName),"pay_boardlimited")=0 And (Not Canlogin) Then Response.Redirect "pay_boardlimited.asp?boardid=" & Dvbbs.BoardID
		If Instr(Lcase(Dvbbs.ScriptName),"pay_boardlimited")=0 And (Not Canlogin) Then
			Dvbbs.AddErrCode(25)	
		End If
	End If
	Dvbbs.showerr()
End Sub
'得到论坛文字广告位部分内容,PageID=0为首页,=1为帖子列表页面,=2为帖子内容页面
Rem 论坛文字广告已经由 Sub 改为 Function 需要Response.Write 输出 2007-10-10 By Dv.唧唧
Function GetForumTextAd(PageID)
	If Dvbbs.Forum_ads(12) = "1" Then
		 Select Case PageID
			Case 0
				
			Case 1
				If Not(Dvbbs.Forum_ads(15) = "0" Or Dvbbs.Forum_ads(15) = "2") Then Exit Function
			Case 2
			 If Not((Dvbbs.Forum_ads(15) = "1" Or Dvbbs.Forum_ads(15) = "2")) Or (Dvbbs.Forum_ads(15) = "3") Then Exit Function
			Case Else
				Exit Function	
		 End Select
		 Dvbbs.Name = "Text_ad_"&Dvbbs.BoardID&"_"& Dvbbs.SkinID
		If Dvbbs.ObjIsEmpty() Then LoardTextAd()
		GetForumTextAd =  Dvbbs.Value
	End If	
End Function
Sub LoardTextAd()
	Dim XmlAds,Adstext,textvalue,XMLStyle,proc
		If IsObject(Application(Dvbbs.CacheName & "_TextAdservices")) Then
			Set XmlAds=Application(Dvbbs.CacheName & "_TextAdservices").cloneNode(True)
		Else
			Set XmlAds=Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument" & MsxmlVersion)
			XmlAds.appendChild(XmlAds.createElement("xml"))
		End If
	Adstext=split(Dvbbs.Forum_ads(16),"#####")
	If Dvbbs.Forum_ads(17)="" Or Not IsNumeric(Dvbbs.Forum_ads(17)) Then  Dvbbs.Forum_ads(17)=4
	Dvbbs.Forum_ads(17)=Abs(Dvbbs.Forum_ads(17))
	If Dvbbs.Forum_ads(17)=0 Then Dvbbs.Forum_ads(17)=4
	XmlAds.documentElement.attributes.setNamedItem(XmlAds.createNode(2,"tdcount","")).text=Dvbbs.Forum_ads(17)
	For Each textvalue In adstext
		XmlAds.documentElement.appendChild(XmlAds.createNode(1,"text","")).text=textvalue
	Next
	If not IsObject(Application(Dvbbs.CacheName & "_showtextads_"& Dvbbs.SkinID)) Then
		Set Application(Dvbbs.CacheName & "_showtextads_"& Dvbbs.SkinID)=Dvbbs.iCreateObject("Msxml2.XSLTemplate" & MsxmlVersion)
		Set XMLStyle=Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument"  & MsxmlVersion)
		XMLStyle.loadxml Dvbbs.mainhtml(22)
		Application(Dvbbs.CacheName & "_showtextads_"& Dvbbs.SkinID).stylesheet=XMLStyle
	End If
	Set proc = Application(Dvbbs.CacheName & "_showtextads_"& Dvbbs.SkinID).createProcessor()
	proc.input = XmlAds
  proc.transform()
  Dvbbs.Name = "Text_ad_"&Dvbbs.BoardID&"_"& Dvbbs.SkinID
  Dvbbs.Value=proc.output
  Set XmlAds=Nothing 
  Set proc=Nothing
End Sub
Sub LoadBoardNews_Paper()
	Dim Rs,node
	Set Rs=Dvbbs.Execute("select S_ID,S_BoardID,S_UserName,S_Title,S_Addtime From Dv_Smallpaper Order By S_ID DESC")
	If Not Rs.EOF Then
		Set Application(Dvbbs.CacheName & "_smallpaper")=Dvbbs.RecordsetToxml(rs,"smallpaper","xml")
		For Each Node in Application(Dvbbs.CacheName & "_smallpaper").documentElement.SelectNodes("smallpaper")
			Node.selectSingleNode("@s_username").text=Dvbbs.ChkBadWords(Node.selectSingleNode("@s_username").text)
			Node.selectSingleNode("@s_title").text=Server.HTMLEnCode(Dvbbs.ChkBadWords(Node.selectSingleNode("@s_title").text))
		Next
	Else
		Set Application(Dvbbs.CacheName & "_smallpaper")=Dvbbs.CreateXmlDoc("Msxml2.FreeThreadedDOMDocument" & MsxmlVersion)
		Application(Dvbbs.CacheName & "_smallpaper").appendChild(Application(Dvbbs.CacheName & "_smallpaper").createElement("xml"))
	End If
End Sub
%>