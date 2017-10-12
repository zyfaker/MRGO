/**
 * 
 */

	function GetQueryString(name){
     var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
     var r = window.location.search.substr(1).match(reg);
     if(r!=null)return  unescape(r[2]); return null;
	}
	function lanjump(lan){
		var mylan=GetQueryString("lan");
		if(mylan !=null && mylan.toString().length>1){
		   myurl = window.location.href;
		   myurl1 = myurl.replace("lan="+mylan, "lan="+lan);
		   window.location.href = myurl1;
		}
		
	}