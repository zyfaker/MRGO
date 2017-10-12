<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- BEGIN STYLESHEET -->
<link href="css/bootstrap.min.css" rel="stylesheet">
<!-- BOOTSTRAP CSS -->
<link href="css/bootstrap-reset.css" rel="stylesheet">

</head>
<body>
	<iframe width="425" height="350" frameborder="0" scrolling="no"
		marginheight="0" marginwidth="0" src="http://www.google.cn"></iframe>
	<br />

	<div class="form-group" id="nav-accordion"></div>
	<!-- BEGIN JS -->
	<script src="js/jquery.js"></script>
	<!-- BASIC JS LIABRARY -->
	<script src="js/bootstrap.min.js"></script>
	<!-- BASIC JQUERY LIB. JS -->
	<script type="text/javascript">
		var url = "";
		$(document).ready(function() {
			//方法二：
			(function($) {
				$.getUrlParam = function(name) {
					var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
					var r = window.location.search.substr(1).match(reg);
					if (r != null)
						return unescape(r[2]);
					return null;
				}
			})(jQuery);

			url = $.getUrlParam('url');

			showRoutes(url);
		});

		function showRoutes(url) {
			$
					.post(
							"mrgo",
							{
								"url" : "http://www.google.cn/maps/dir/Ginza,+%E4%B8%AD%E5%A4%AE%E5%8C%BA%E4%B8%9C%E4%BA%AC%E9%83%BD+1040061%E6%97%A5%E6%9C%AC/%E5%B7%9D%E5%B4%8E%E5%B8%82+%E6%97%A5%E6%9C%AC%E7%A5%9E%E5%A5%88%E5%B7%9D%E5%8E%BF/@35.601391,139.7371818,10z/data=!4m8!4m7!1m2!1m1!1s0x60188be701836fbb:0x604685b30ba99851!1m2!1m1!1s0x60185f7b01bd5057:0x88c9f317cacfd3cb!3e3?hl=ja"
							//"url" : url
							},
							function(data) {

								var routeInfos = data.rows;

								for (var i = 0; i < routeInfos.length; i++) {
									$('#nav-accordion').append('第'+i+"条线路</br>");
									var routeInfo = routeInfos[i].rows1;
									for (var j = 0; j < routeInfo.length; j++) {
										$('#nav-accordion')
												.append(
														'<label for="exampleInputEmail1">'
																+ routeInfo[j].lineInfo
																+ '</label></br><label for="exampleInputEmail1">起点：'
																+ routeInfo[j].startStation
																+ '</label></br><label for="exampleInputEmail1">终点：'
																+ routeInfo[j].endStation
																+ '</label></br>');
									}
								
								}

							});
		}
	</script>
</body>
</html>