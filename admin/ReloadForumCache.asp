<!--#include file="../conn.asp"-->
<!--#include file="inc/Const.asp"-->
<%
Dim iCacheName,iCache,mCacheName
MyDbPath = "../"
'�����̳������Ϣ�ͼ���û���½״̬
'Dvbbs.GetForum_Setting
'Dvbbs.CheckUserLogin
'���¸����û��Ƿ�ɽ����̨Ȩ��
'If Dvbbs.GroupSetting(70)="1" Then Dvbbs.Master = True
CheckAdmin(",")
Head()
Dim CacheName
CacheName=Dvbbs.CacheName
Call delallcache()

Function  GetallCache()
	Dim Cacheobj
	For Each Cacheobj in Application.Contents
	If CStr(Left(Cacheobj,Len(CacheName)+1))=CStr(CacheName&"_") Then	
		GetallCache=GetallCache&Cacheobj&","
	End If
	Next
End Function
Sub delallcache()
	Dim cachelist,i
	Cachelist=split(GetallCache(),",")
	If UBound(cachelist)>1 Then
		For i=0 to UBound(cachelist)-1
			DelCahe Cachelist(i)
			Response.Write "���� <b>"&Replace(cachelist(i),CacheName&"_","")&"</b> ���<br>"		
		Next
		Response.Write "������"
		Response.Write UBound(cachelist)-1
		Response.Write "���������<br>"	
	Else
		Response.Write "���ж����Ѿ����¡�"
	End If
End Sub 
Sub DelCahe(MyCaheName)
	Application.Lock
	Application.Contents.Remove(MyCaheName)
	Application.unLock
End Sub
%>