<%
'-----------------------------------------------------------------------
'--- EMAIL�ʼ�������ģ��
'--- Copyright (c) 2004 Aspsky, Inc.
'--- Mail: Sunwin@artbbs.net   http://www.aspsky.net
'--- 2004-12-18
'-----------------------------------------------------------------------
'--- ������
'-----------------------------------------------------------------------
'--- ServerLoginName	���������ʼ���������¼��
'--- ServerLoginPass	���õ�¼����
'--- SendSMTP			����SMTP�ʼ���������ַ
'--- SendFromEmail		���÷����˵�E-MAIL��ַ
'--- SendFromName		���÷���������
'--- ContentType		�����ʼ����� Ĭ�ϣ�text/html
'--- CharsetType		���ñ������� Ĭ�ϣ�gb2312
'--- SendObject			����ѡȡ��� 1=Jmail,2=Cdonts,3=Aspemail
'-----------------------------------------------------------------------
'--- ����
'-----------------------------------------------------------------------
'--- SendMail Email, Topic, MailBody	�ռ��˵�ַ�����⣬�ʼ�����
'-----------------------------------------------------------------------
'--- ��ȡ��Ϣ
'-----------------------------------------------------------------------
'--- ErrCode			��Ϣ��� 0=����
'--- Description		��Ӧ������Ϣ
'--- Count				�����ʼ���
'-----------------------------------------------------------------------
Class Dv_SendMail
	Public Count,ErrCode,ErrMsg
	Private LoginName,LoginPass,SMTP,FromEmail,FromName,Object,Content_Type,Charset_Type
	Private Obj,cdoConfig

	Private Sub Class_Initialize()
		Object = 0
		Count = 0
		ErrCode = 0
		Content_Type = "text/html"
		Charset_Type = "gb2312"
	End Sub

	Private Sub Class_Terminate()
		If Isobject(Obj) Then
			Set Obj = Nothing
		End If
		If IsObject(cdoConfig) Then
			Set cdoConfig = Nothing
		End If
	End Sub

	'���������ʼ���������¼��
	Public Property Let ServerLoginName(Byval Value)
		LoginName = Value
	End Property

	'���õ�¼����
	Public Property Let ServerLoginPass(Byval Value)
		LoginPass = Value
	End Property
	'����SMTP�ʼ���������ַ
	Public Property Let SendSMTP(Byval Value)
		SMTP = Value
	End Property
	'���÷����˵�E-MAIL��ַ
	Public Property Let SendFromEmail(Byval Value)
		FromEmail = Value
	End Property
	'���÷���������
	Public Property Let SendFromName(Byval Value)
		FromName = Value
	End Property
	'�����ʼ�����
	Public Property Let ContentType(Byval Value)
		Content_Type = Value
	End Property
	'���ñ�������
	Public Property Let CharsetType(Byval Value)
		Charset_Type = Cstr(Value)
	End Property
	'��ȡ������Ϣ
	Public Property Get Description()
		Description = ErrMsg
	End Property
	'����ѡȡ��� SendObject 0=Jmail,1=Cdonts,2=Aspemail
	Public Property Let SendObject(Byval Value)
		Object = Value
		On Error Resume Next
		Select Case Object
			Case 1
				Set Obj = Dvbbs.iCreateObject("JMail.Message")
			Case 2
				Set Obj = Dvbbs.iCreateObject("CDONTS.NewMail")
			Case 3
				Set Obj = Dvbbs.iCreateObject("Persits.MailSender")
			Case 4
				Set Obj = Dvbbs.iCreateObject("CDO.Message")	'window 2003 new SendMailCom Object
			Case Else
				ErrNumber = 2
		End Select
		If Err<>0 Then
			ErrNumber = 3
		End If
	End Property

	Private Property Let ErrNumber(Byval Value)
		ErrCode = Value
		ErrMsg = ErrMsg & Msg
	End Property
	Private Function Msg()
		Dim MsgValue
		Select Case ErrCode
		Case 1
			MsgValue = "δѡȡ�ʼ�������������֧�ָ������"
		Case 2
			MsgValue = "��ѡ����������ڣ�"
		Case 3
			MsgValue = "���󣺷�������֧�ָ����!"
		Case 4
			MsgValue = "����ʧ��!"
		Case Else
			MsgValue = "������"
		End Select
		Msg = MsgValue
	End Function

	Public Sub SendMail(Byval Email,Byval Topic,Byval MailBody)
		If ErrCode <> 0 Then
			Exit Sub
		End If
		If Email="" or ISNull(Email) Then Exit Sub
		If Object>0 Then
			Select Case Object
				Case 1
					Jmail Email,Topic,MailBody
				Case 2
					Cdonts Email,Topic,Mailbody
				Case 3
					Aspemail Email,Topic,Mailbody
				Case 4
					CDOMessage Email,Topic,Mailbody
				Case Else
					ErrNumber = 2
			End Select
		Else
			ErrNumber = 1
		End If
	End Sub

	Private Sub Jmail(Email,Topic,Mailbody)
		On Error Resume Next
		Obj.Silent = True
		Obj.Logging = True
		Obj.Charset = Charset_Type
		If Not(LoginName = "" Or LoginPass = "") Then
			Obj.MailServerUserName = LoginName '�����ʼ���������¼��
			Obj.MailServerPassword = LoginPass '��¼����
		End If
		Obj.ContentType = Content_Type
		Obj.Priority = 1
		Obj.From = FromEmail
		Obj.FromName = FromName
		Obj.AddRecipient Email
		Obj.Subject = Topic
		Obj.Body = Mailbody
		If Err<>0 Then
			ErrMsg = ErrMsg & "����ʧ��!ԭ��" & Err.Description
			ErrNumber = 4
		Else
			Obj.Send (SMTP)
			Obj.ClearRecipients()
			If Err<>0 Then
				ErrMsg = ErrMsg & "����ʧ��!ԭ��" & Err.Description
				ErrNumber = 4
			Else
				Count = Count + 1
				ErrMsg = ErrMsg & "���ͳɹ�!"
			End If
		End If
	End Sub
		
	Private Sub Cdonts(Email,Topic,Mailbody)
		On Error Resume Next
		Obj.From = FromEmail
		Obj.To = Email
		Obj.Subject = Topic
		Obj.BodyFormat = 0 
		Obj.MailFormat = 0 
		Obj.Body = Mailbody
		If Err<>0 Then
			ErrMsg = ErrMsg & "����ʧ��!ԭ��" & Err.Description
			ErrNumber = 4
		Else
			Obj.Send
			If Err<>0 Then
				ErrMsg = ErrMsg & "����ʧ��!ԭ��" & Err.Description
				ErrNumber = 4
			Else
				Count = Count + 1
				ErrMsg = ErrMsg & "���ͳɹ�!"
			End If
		End If
	End Sub

	Private Sub Aspemail(Email,Topic,Mailbody)
		On Error Resume Next
		Obj.Charset = Charset_Type
		Obj.IsHTML = True
		Obj.username = LoginName	'����������Ч���û���
		Obj.password = LoginPass	'����������Ч������
		Obj.Priority = 1
		Obj.Host = SMTP
		'Obj.Port = 25			' �����ѡ.�˿�25��Ĭ��ֵ
		Obj.From = FromEmail
		Obj.FromName = FromName	' �����ѡ
		Obj.AddAddress Email,Email
		Obj.Subject = Topic
		Obj.Body = Mailbody
		If Err<>0 Then
			ErrMsg = ErrMsg & "����ʧ��!ԭ��" & Err.Description
			ErrNumber = 4
		Else
			Obj.Send
			If Err<>0 Then
				ErrMsg = ErrMsg & "����ʧ��!ԭ��" & Err.Description
				ErrNumber = 4
			Else
				Count = Count + 1
				ErrMsg = ErrMsg & "���ͳɹ�!"
			End If
		End If
	End Sub

	Private Sub CDOMessage(Email,Topic,Mailbody)
		On Error Resume Next
		If Not IsObject(cdoConfig) Then
			Call CreatCDOConfig()
		End If
		Set Obj = Dvbbs.iCreateObject("CDO.Message") 
		With Obj 
			Set .Configuration = cdoConfig 
			'.From = FromEmail
			.To = Email
			.Subject = Topic 
			.TextBody = Mailbody
			.Send
		End With
		If Err<>0 Then
			ErrMsg = ErrMsg & "����ʧ��!ԭ��" & Err.Description
			ErrNumber = 4
		Else
			Count = Count + 1
			ErrMsg = ErrMsg & "���ͳɹ�!"
		End If
	End Sub

	Private Sub CreatCDOConfig()
		On Error Resume Next
		Dim Sch
		sch = "http://schemas.microsoft.com/cdo/configuration/"
		Set cdoConfig = Dvbbs.iCreateObject("CDO.Configuration")
		With cdoConfig.Fields 
			.Item(sch & "smtpserver") = SMTP
			'.Item(sch & "smtpserverport") = 25
			.Item(sch & "sendusing") = 2					'cdoSendUsingPort CdoSendUsing enum value =  2
			.Item(sch & "smtpaccountname") = FromName		'"My Name"
			.Item(sch & "sendemailaddress") = FromEmail		'"""MySelf"" <example@example.com>"
			.Item(sch & "smtpuserreplyemailaddress") = 25	'"""Another"" <another@example.com>"
			'.Item(sch & "smtpauthenticate") = cdoBasic
			.Item(sch & "sendusername") = LoginName
			.Item(sch & "sendpassword") = LoginPass
			.update 
		End With
		If Err<>0 Then
			ErrMsg = ErrMsg & "����ʧ��!ԭ��" & Err.Description
			ErrNumber = 4
		End If
	End Sub
End Class
%>