<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>婴儿车GO</title>
<!-- BEGIN STYLESHEET -->
<link href="css/bootstrap.min.css" rel="stylesheet">
<!-- BOOTSTRAP CSS -->
<link href="css/bootstrap-reset.css" rel="stylesheet">
<!--FONT AWESOME ICON STYLESHEET -->
<link href="css/style.css" rel="stylesheet">
<!-- THEME BASIC CSS  -->
<!-- END STYLESHEET -->
<style type="text/css">
ul.sidebar-menu {
	margin-top: 0px;
}

ul.sidebar-menu li {
	margin-bottom: 5px;
	margin-left: 0px;
	margin-right: 0px;
	padding: 0px 10px;
}

.fa {
	display: inline-block;
	width: 16px;
	height: 16px;
}

.fa-walk {
	background: url("img/walk.png") no-repeat center center;
}

.fa-rail {
	background: url("img/rail2.png") no-repeat center center;
}
</style>
</head>
<body>



	<div id="sidebar" Style="width: 500px; heigh: auto; background: #fff"
		class="nav-collapse">

		<ul class="sidebar-menu" id="nav-accordion">

			<li style="background-color: #4285F4; color: #FFF;"><strong><span
					id="byway"></span></strong></li>
			<li><span Style="color: blue" id="ctime"></span></li>
			<li><span Style="color: green" id="distance"></span><span
				Style="color: green; float: right" id="spendtime"></span></li>
			<li><span Style="color: blue" id="stime"></span><span
				Style="color: blue; float: right" id="etime"></span></li>

		</ul>
	</div>
	<input type="text" Style="display: none" id="url" value="${param.url }" />
	<!-- BEGIN JS -->
	<script src="js/jquery.js"></script>
	<!-- BASIC JS LIABRARY -->
	<script src="js/bootstrap.min.js"></script>
	<!-- ACCORDING JS -->
	<script src="js/common-scripts.js"></script>
	<!-- BASIC COMMON JS  -->
	<script src="js/mngjs/index.js"></script>
	<!-- BOOTSTRAP JS -->
	<script type="text/javascript" src="js/bootstrap-select.js"></script>

	<script type="text/javascript">
		showRoutes($('#url').val());
		
		function showRoutes(url) {
			$
					.post(
							"mrgo",
							{
								"url" : url
							},
							function(data) {
								var routeInfos = data.rows;
								for (var i = 0; i < routeInfos.length; i++) {
									var byways = routeInfos[i].totalInfo;
									var byway = "开始->";
									for (var j = 0; j < byways.length; j++) {
										if (byways[j].totalinfoline != undefined) {
											byway += byways[j].totalinfoway
													+ "("
													+ byways[j].totalinfoline
													+ ")" + "->";
										} else {
											byway += byways[j].totalinfoway
													+ "->";
										}

									}
									byway += "结束";
									//byway.substring(0,byway.length-2);
									$("#byway").val(byway);
									document.getElementById("byway").innerText = byway;
									document.getElementById("distance").innerText = routeInfos[i].distance;
									document.getElementById("spendtime").innerText = routeInfos[i].spendtime;
									document.getElementById("stime").innerText = routeInfos[i].starttime;
									document.getElementById("etime").innerText = routeInfos[i].endtime;
									document.getElementById("ctime").innerText = routeInfos[i].swtime;

									var routeItem = routeInfos[i].listWayInfo;
									for (var z = 0; z < routeItem.length; z++) {
										if (routeItem[z].routeWay == "步行") {
											$('#nav-accordion')
													.append(
															'<li class="sub-menu"><a href="javascript:;" style="background-color:#39C; color:#FFF;"> <i class="fa fa-walk"></i> <span><strong>步行</strong></span> <span class="label label-info span-sidebar">'
																	+ routeItem[z].spendTime
																	+ '</span></a></li>');
										} else {

											var iteminfo = routeItem[z].wayinfo;
											$('#nav-accordion')
													.append(
															'<li><a style="background-color:#39C; color:#FFF;"> <i class="fa fa-rail"></i> <span><strong>'
																	+ routeItem[z].routeWay
																	+ '</strong></span> <span class="label label-success span-sidebar">'
																	+ routeItem[z].spendTime
																	+ '</span></a><ul id="list'+z+'"></ul></li>');
											$('#list' + z)
													.append(
															'<li><span Style="color: green"><strong>'
																	+ routeItem[z].startStation
																	+ '</strong></span><span Style="color: green; float: right">'
																	+ routeInfos[i].starttime
																	+ '</span></li>');
											for (var w = 0; w < iteminfo.length; w++) {
												if (iteminfo[w].stationName.length > 0
														|| iteminfo[w].stationName != "undefined") {
													$('#list' + z)
															.append(
																	'<li><span Style="color: green">'
																			+ iteminfo[w].stationName
																			+ '</span><span Style="color: green; float: right">'
																			+ iteminfo[w].stationTime
																			+ '</span></li>');
												}
											}
											$('#list' + z)
													.append(
															'<li><span Style="color: green"><strong>'
																	+ routeItem[z].endStation
																	+ '</strong></span><span Style="color: green; float: right">'
																	+ routeInfos[i].endtime
																	+ '</span></li>');

										}
									}

								}
							});

		}
	</script>
</body>
</html>