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
<!-- BOOTSTRAP CSS -->
<link href="css/font-awesome/css/font-awesome.min.css" rel="stylesheet">
<!--FONT AWESOME ICON STYLESHEET -->
<link href="css/style.css" rel="stylesheet">
<!-- THEME BASIC CSS  -->
<link href="css/mngcss/mngindex.css" rel="stylesheet">
<!-- END STYLESHEET -->
</head>
<body>

	<div class="form-group">
		<label id="byway">乘车方式</label>
	</div>
	<div class="form-group">
		<form class="form-inline">
			<div class="form-group col-md-1" Style="color: blue">
				<label id="ctime">列车间隔时间</label>
			</div>
			<div class="form-group col-md-1" Style="color: green">
				<label id="distance">距离</label>
			</div>
			<div class="form-group col-md-1" Style="color: green">
				<label id="spendtime">耗时</label>
			</div>
			<div class="form-group col-md-1" Style="color: blue">
				<label id="stime">开始时间</label>
			</div>
			<div class="form-group col-md-1" Style="color: blue">
				<label id="etime">结束时间</label>
			</div>

		</form>
	</div>

	<div class="form-group">

		<table class="table table-striped">
			<thead Style="display: none">
				<tr>
					<th>方式</th>
					<th>时间</th>
					<th></th>
				</tr>
			</thead>
			<tbody id="routeItem">
			</tbody>
		</table>
	</div>
	<!-- BEGIN SIDEBAR -->
	<div id="sidebar" class="nav-collapse">

		<ul class="sidebar-menu" id="nav-accordion">
			
			<li class="sub-menu"><a href="javascript:;"> <i
					class="fa fa-book"></i> <span>政策管理</span> <span
					class="label label-info span-sidebar">4</span>
			</a>
				<ul class="sub">
					<li><a href="">基本操作</a></li>
					<li><a href="">文件上传</a></li>
					<li><a href="">解读分类</a></li>
					<li><a href="">标签管理</a></li>
				</ul></li>
			<li class="sub-menu"><a href="javascript:;" class="active">
					<i class="fa fa-laptop"></i> <span>行业动态管理</span> <span
					class="label label-success span-sidebar">3</span>
			</a>
				<ul class="sub">
					<li><a href="mngnewsbase.html" target="myframe">基本操作</a></li>
					<li><a href="mngnewsload.html" target="myframe">批量上传</a></li>
					<li><a href="mngnewstag.html" target="myframe">标签管理</a></li>
				</ul></li>

			<li class="sub-menu"><a href="javascript:;"> <i
					class="fa fa-cogs"></i> <span>文件下载管理</span> <span
					class="label label-primary span-sidebar">3</span>
			</a>
				<ul class="sub">
					<li><a href="mngdownbase.html" target="myframe">基本操作</a></li>
					<li><a href="mngdownadd.html" target="myframe">文件上传</a></li>
					<li><a href="mngdowntag.html" target="myframe">分类管理</a></li>
				</ul></li>

			<li class="sub-menu"><a href="javascript:;"> <i
					class="fa fa-tasks"></i> <span>用户权限管理</span> <span
					class="label label-danger span-sidebar">2</span>
			</a>
				<ul class="sub">
					<li><a href="">权限分配</a></li>
					<li><a href="">新增用户</a></li>
				</ul></li>

			<li class="sub-menu"><a href="javascript:;"> <i
					class="fa fa-tasks"></i> <span>内部用户管理</span> <span
					class="label label-warning span-sidebar">2</span>
			</a>
				<ul class="sub">
					<li><a href="">基本操作</a></li>
					<li><a href="">新增用户</a></li>
				</ul></li>
		</ul>
	</div>
	<input type="text" Style="display: none" id="url" value="${param.url }" />
	<!-- BEGIN JS -->
	<script src="js/jquery.js"></script>
	<!-- BASIC JS LIABRARY -->
	<script src="js/bootstrap.min.js"></script>
	<!-- BOOTSTRAP JS  -->
	<script src="js/jquery.dcjqaccordion.2.7.js"></script>
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
											$('#routeItem')
													.append(
															'<tr><td>'
																	+ routeItem[z].routeWay
																	+ '</td><td>'
																	+ routeItem[z].spendTime
																	+ '</td><td></td></tr>');
										} else {

											var iteminfo = routeItem[z].wayinfo;
											var iteminfostring = routeItem[z].startStation
													+ "("
													+ routeInfos[i].starttime
													+ ")->";

											for (var w = 0; w < iteminfo.length; w++) {
												if (iteminfo[w].stationName.length > 0
														|| iteminfo[w].stationName != "undefined") {
													iteminfostring += iteminfo[w].stationName
															+ "("
															+ iteminfo[w].stationTime
															+ ")->";
												}
											}

											iteminfostring += routeItem[z].endStation
													+ "("
													+ routeInfos[i].endtime
													+ ")";
											$('#routeItem')
													.append(
															'<tr><td>'
																	+ routeItem[z].routeWay
																	+ '</td><td>'
																	+ routeItem[z].spendTime
																	+ '</td><td>'
																	+ iteminfostring
																	+ '</td></tr>');
										}
									}

								}

								console.log(data);
							});

		}

		option = {
			title : {
				text : '本次路线'
			},
			legend : {
				data : [ '步行', '地铁', '火车' ]
			},
			xAxis : [ {
				type : 'value',
				scale : true,
				axisLabel : {
					formatter : '{value}'
				}
			} ],
			yAxis : [ {
				type : 'value',
				scale : true,
				axisLabel : {
					formatter : '{value} '
				}
			} ],
			series : [ {
				name : '步行',
				type : 'scatter',
				data : [ [ 161.2, 0 ], [ 163.4, 0 ] ],
				markPoint : {
					data : [ {
						type : 'max',
						name : '最大值'
					}, {
						type : 'min',
						name : '最小值'
					} ]
				}

			}, {
				name : '火车',
				type : 'scatter',
				data : [ [ 166.2, 0 ], [ 170.4, 0 ] ],
				markPoint : {
					data : [ {
						type : 'max',
						name : '最大值'
					}, {
						type : 'min',
						name : '最小值'
					} ]
				}

			}, {
				name : '地铁',
				type : 'scatter',
				data : [ [ 174.0, 0 ], [ 175.3, 0 ] ],
				markPoint : {
					data : [ {
						type : 'max',
						name : '最大值'
					}, {
						type : 'min',
						name : '最小值'
					} ]
				}
			} ]
		};
	</script>
</body>
</html>