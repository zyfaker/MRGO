<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- 新 Bootstrap 核心 CSS 文件 -->
<link rel="stylesheet" href="dist/css/bootstrap.min.css">

<!-- 可选的Bootstrap主题文件（一般不用引入） -->
<link rel="stylesheet" href="dist/css/bootstrap-theme.min.css">

<!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
<script src="dist/jquery/jquery.min.js"></script>
<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
<script src="dist/js/bootstrap.min.js"></script>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
<meta charset="utf-8">
<title>婴儿车GO</title>
<style>
html, body {
	height: 100%;
	margin: 0;
	padding: 0;
}

#map {
	height: 70%;
	float: left;
	width: 100%;
}

#directions-panel {
	margin-top: 20px;
	background-color: #FFEE77;
	padding: 10px;
}

.bannerstyle li div.form-group {
	text-align: center;
	font-size: 14px;
	line-height: 1.6em;
	margin: 5px 0 0 0;
}

.bannerstyle li div.form-group strong {
	font-size: 16px;
}

.bannerstyle .btns {
	text-align: center;
}

.rightpanel {
	position: fixed;
	top: 0;
	right: 0;
	width: 200px;
	padding: 15px;
	background-color: rgba(250, 250, 250, 0.6);
	border: 1px solid #BBB;
	font-size: 14px;
}

.rightpanel label {
	color: #444;
}

.rightpanel legend {
	font-size: 16px;
	font-weight: 600;
	margin-bottom: 15px;
}

.rightpanel button {
	width: 100%;
}
.clickdown{
display:none;
}
</style>
<link rel="stylesheet" href="css/base.css">
<link rel="stylesheet" href="css/bannerList.css">
<script src="http://www.jq22.com/jquery/jquery-1.10.2.js"></script>
</head>
<body>

	<div id="map"></div>
	<div class="rightpanel">

		<fieldset class="clickup">
			<legend>位置信息</legend>
			<div class="form-group">
				<div>
					<label>从这里出发</label>
				</div>
				<div>
					<input type="text" class="form-control" id="start" value="北京大学">
				</div>
			</div>
			<div class="form-group">
				<div>
					<label>目的地</label>
				</div>
				<div>
					<input type="text" class="form-control" id="end" value="南开大学">
				</div>

			</div>
			<div>
				<button id="search" class="btn btn-primary btnup">提交</button>
			</div>
		</fieldset>
		<div class="clickdown">
				<button id="search" class="btn btn-primary btndown">向下</button>
			</div>
		
	</div>
	<script  type="text/javascript">
		$('.btnup').click(function(){
			$('.clickup').css('display','none');
			$('.clickdown').css('display','block');
		});
		$('.btndown').click(function(){
			$('.clickup').css('display','block');
			$('.clickdown').css('display','none');
		});
		</script>
	<div class="banner">
		<ul class="bannerstyle" id="res">

		</ul>
		<div class="left-btn"></div>
		<div class="right-btn"></div>

	</div>

	<script type="text/javascript">
		var map;
		function initMap() {
			var markerArray = [];
			map = new google.maps.Map(document.getElementById('map'), {
				zoom : 5,
				center : "beijing",
			});
			var directionsService = new google.maps.DirectionsService;

			var directionsDisplay = new google.maps.DirectionsRenderer({
				map : map
			});
			var stepDisplay = new google.maps.InfoWindow;

			calculateAndDisplayRoute(directionsDisplay, directionsService,
					markerArray, stepDisplay, map);

			var onChangeHandler = function() {
				$('#res').empty();
				calculateAndDisplayRoute(directionsDisplay, directionsService,
						markerArray, stepDisplay, map);
			};
			document.getElementById('search').addEventListener('click',
					onChangeHandler);

		}

		function calculateAndDisplayRoute(directionsDisplay, directionsService,
				markerArray, stepDisplay, map) {

			for (var i = 0; i < markerArray.length; i++) {
				markerArray[i].setMap(null);
			}
			var start = document.getElementById('start').value;
			var end = document.getElementById('end').value;

			directionsService
					.route(
							{
								origin : start,
								destination : end,
								travelMode : google.maps.TravelMode.TRANSIT,
								transitOptions : {
									modes : [ google.maps.TransitMode.RAIL,
											google.maps.TransitMode.BUS ],
									departureTime : new Date(
											Date.now() + 1800000),
									routingPreference : google.maps.TransitRoutePreference.LESS_WALKING
								},
								unitSystem : google.maps.UnitSystem.IMPERIAL,
							//optimizeWaypoints : true,
							//provideRouteAlternatives : true
							},
							function(response, status) {
								if (status === google.maps.DirectionsStatus.OK) {

									directionsDisplay.setDirections(response);
									showSteps(response, markerArray,
											stepDisplay, map);
								}
							});
		}
		function showSteps(directionResult, markerArray, stepDisplay, map) {

			var myRoute = directionResult.routes[0].legs[0];
			for (var i = 0; i < myRoute.steps.length; i++) {
				if (directionResult.routes[0].legs[0].steps[i].travel_mode != "TRANSIT") {
					$('#res')
							.append(
									'<li onmouseover="SetCenter('
											+ directionResult.routes[0].legs[0].steps[i].start_point
													.lat()
											+ ','
											+ directionResult.routes[0].legs[0].steps[i].start_point
													.lng()
											+ ')"><div class="form-group"><label></label></div><div class="form-group"><label></label></div><div class="form-group"><label><strong>'
											+ directionResult.routes[0].legs[0].steps[i].instructions
											+ '</strong></label></div><div class="form-group"><label>'
											+ directionResult.routes[0].legs[0].steps[i].duration.text
											+ '</label></div><div class="form-group"><label>'
											+ directionResult.routes[0].legs[0].steps[i].distance.text
											+ '</label></div><div class="form-group"><label></label></div><div class="btns"><button type="button" class="btn btn-success">图片</button> <button type="button" class="btn btn-info">视频</button></div></li>');

				} else {
					$('#res')
							.append(
									'<li onmouseover="SetCenter('
											+ directionResult.routes[0].legs[0].steps[i].start_point
													.lat()
											+ ','
											+ directionResult.routes[0].legs[0].steps[i].start_point
													.lng()
											+ ')"><div class="form-group"><label></label></div><div class="form-group"><label></label></div><div class="form-group"><label><strong>'
											+ directionResult.routes[0].legs[0].steps[i].transit.line.short_name
											+ "-"
											+ directionResult.routes[0].legs[0].steps[i].instructions
											+ '</strong></label></div><div class="form-group"><label>'
											+ directionResult.routes[0].legs[0].steps[i].transit.departure_time.text
											+ "-"
											+ directionResult.routes[0].legs[0].steps[i].transit.arrival_time.text
											+ '</label></div><div class="form-group"><label>'
											+ directionResult.routes[0].legs[0].steps[i].duration.text
											+ '-'
											+ directionResult.routes[0].legs[0].steps[i].distance.text
											+ '</label></div><div class="form-group"><label></label></div><div class="btns"><button type="button" class="btn btn-success">图片</button> <button type="button" class="btn btn-info">视频</button></div></li>');

				}

				/* var marker = markerArray[i] = markerArray[i]
						|| new google.maps.Marker;
				marker.setMap(map);
				marker.setPosition(myRoute.steps[i].start_location);
				attachInstructionText(stepDisplay, marker,
						myRoute.steps[i].instructions, map); */
			}
			$('#res')
					.append(
							'<li><div class="form-group"><label></label></div><div class="form-group"><label></label></div><div class="form-group"><label><strong>导航结束</strong></label></div><div class="form-group"><label></label></div><div class="btns"><button type="button" class="btn btn-success">图片</button> <button type="button" class="btn btn-info">视频</button></div></li>');
			bannerListFn($(".banner"), $(".img-btn-list"), $(".left-btn"),
					$(".right-btn"), 2000, false);
		}
		function attachInstructionText(stepDisplay, marker, text, map) {
			google.maps.event.addListener(marker, 'click', function() {

				stepDisplay.setContent(text);
				stepDisplay.open(map, marker);
			});
		}
	</script>
	<script
		src="http://ditu.google.cn/maps/api/js?key=AIzaSyAxO-evQaWEZUuzvzIjD23THpixyPgb_nc&callback=initMap"></script> 
		
	<script src="js/bannerList.js"></script>
	<script>
		/*=======================
		调用方法：
		传递参数方法如下：
		对象1：banner最大容器====================必填
		对象2：banner======>按钮父容器============必填
		对象3，4：banner====>左右按钮对象名===========必填
		对象5：banner滚动时间==================>可选项=======>默认为2000
		对象6：是否需要自动轮播需要==========true============不需要false:必填
		=============================*/

		function SetCenter(lat, lng) {
			//var newCenter=new google.maps.LatLng(51.508742,-0.120850);

			console.log(lat + "," + lng);
			map.setCenter(new google.maps.LatLng(lat, lng));
			map.setZoom(14);

		}
	</script>

</body>
</html>