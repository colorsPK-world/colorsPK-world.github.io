<SCRIPT LANGUAGE="JavaScript">
<!--
function MM_showHideLayers() { //v6.0

  var i,p,v,obj,args=MM_showHideLayers.arguments;
  obj=parent.document.getElementById("MagicFace");
  for (i=0; i<(args.length-2); i+=3) if (obj) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v=='hide')?'hidden':v; }
    obj.visibility=v; }
}

function DispMagicEmot(event,MagicID,H,W){
	if (event.button!=2){return false;}
	MagicFaceUrl = "Dv_plus/tools/magicface/swf/" + MagicID + ".swf";
	var obj = parent.document.getElementById("MagicFace");
	obj.innerHTML = '<OBJECT codeBase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=4,0,2,0" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="' + W + '" height="' + H + '"><PARAM NAME=movie VALUE="'+ MagicFaceUrl +'"><param name=menu value=false><PARAM NAME=quality VALUE=high><PARAM NAME=play VALUE=false><param name="wmode" value="transparent"><embed src="' + MagicFaceUrl +'" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="' + W + '" height="' + H + '"></embed>';
	obj.style.top = (parent.document.body.scrollTop+((parent.document.body.clientHeight-300)/2))+"px";
	obj.style.left = (parent.document.body.scrollLeft+((parent.document.body.clientWidth-480)/2))+"px";
	obj.style.visibility = 'visible';
	MagicID += Math.random();
	setTimeout("MM_showHideLayers('MagicFace','','hidden')",8000);
	NowMeID = MagicID;
}
//-->
</SCRIPT>