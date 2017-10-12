<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="css/route.css" rel="stylesheet">
</head>
<body>
	<iframe width="425" height="350" frameborder="0" scrolling="no"
		marginheight="0" marginwidth="0"
		src="http://www.google.cn"></iframe>
	<br/>

	<div class="linearea" id="nav-accordion"></div>
	<script src="js/jquery.js"></script>
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
									var byways = routeInfos[i].totalInfo;
									$('#nav-accordion')
											.append(
													'<div class="route"><span class="left">'
															+ routeInfos[i].starttime
															+ '</span><div class="place">开始</div></div>');

									var routeItem = routeInfos[i].listWayInfo;
									for (var z = 0; z < routeItem.length; z++) {
										if (routeItem[z].routeWay == "步行") {

											$('#nav-accordion')
													.append(
															'<div class="route"><span class="left"></span><div class="place"></div></div><section class="walk"><span class="left"><i class="icon i_walk"></i></span><div class="line"><div class="base"><span>步行'
																	+ routeItem[z].spendTime
																	+ '</span><i class="icondown"></i></div></div></section>');
										} else {
											var iteminfo = routeItem[z].wayinfo;
											if (iteminfo != null) {
												var itemInfoLength = iteminfo.length;
												$('#nav-accordion')
														.append(
																'<div class="subway"><span class="left">'
																		+ routeInfos[i].starttime
																		+ '</span><div class="place">'
																		+ routeItem[z].startStation
																		+ '</div></div><section class="subway"><span class="left"><i class="iconsubway"></i></span><div class="line"><div class="base"><span class="subname">'
																		+ byways[z].totalinfoline
																		+ '</span><span>经停'
																		+ itemInfoLength
																		+ '站</span> <i class="icondown"></i></div><ul id="list'+z+'"></ul></div></section>');

												$('#list' + z)
														.append(
																'<li>'
																		+ routeItem[z].startStation
																		+ '&nbsp;&nbsp;'
																		+ routeInfos[i].starttime
																		+ '</li>');
												for (var w = 0; w < itemInfoLength; w++) {
													if (iteminfo[w].stationName.length > 0
															|| iteminfo[w].stationName != "undefined") {
														$('#list' + z)
																.append(
																		'<li>'
																				+ iteminfo[w].stationName
																				+ '&nbsp;&nbsp;'
																				+ iteminfo[w].stationTime
																				+ '</li>');
													}
												}
												$('#list' + z)
														.append(
																'<li>'
																		+ routeItem[z].endStation
																		+ '&nbsp;&nbsp;'
																		+ routeInfos[i].endtime
																		+ '</li>');
											}

										}
									}
									$('#nav-accordion')
											.append(
													'<div class="route"><span class="left">'
															+ routeInfos[i].endtime
															+ '</span><div class="place">结束</div></div>');

								}

							});
		}
		$('.linearea').on('click', '.base', function() {
			$(this).next('ul').slideToggle();
			var i = $(this).children('i');
			var name = i.attr('class');
			if (name == "icondown") {
				i.addClass("iconup");
				i.removeClass("icondown");
			} else {
				i.addClass("icondown");
				i.removeClass("iconup");
			}
		});
	</script>
</body>
</html>