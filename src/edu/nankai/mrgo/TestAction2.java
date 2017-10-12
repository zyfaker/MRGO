package edu.nankai.mrgo;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

@SuppressWarnings("unused")
public class TestAction2 extends ActionSupport {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public Map<String, Object> responseJson;

	public Map<String, Object> getResponseJson() {
		return responseJson;
	}

	public void setResponseJson(Map<String, Object> responseJson) {
		this.responseJson = responseJson;
	}

	private String name;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	private String url;

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String routes;

	public String getRoutes() {
		return routes;
	}

	public void setRoutes(String routes) {
		this.routes = routes;
	}

	public String execute() {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> listtt = new ArrayList<Map<String, Object>>();

		String realPath = ServletActionContext.getServletContext().getRealPath("");
		System.out.println("realPath:" + realPath);
		File file = new File(realPath + "\\file\\cutInfo.txt");
		List<String> strings = readTxtFile(file);
		System.out.println("realPath:" + strings.size());
		String regJP = "[^\u3040-\u309f]";
		
		String regCH = "[^\u4E00-\u9FA5]";
		
		ServletActionContext.getRequest();
		HttpRequester request = new HttpRequester();
		HttpRespons hr;
		try {
			hr = request.sendGet(url);
			String str = hr.getContent();
			String begin = "[\"wide_routes\"],";
			String end = "executeOgJs";
			String s = str.substring(str.indexOf(begin) + 1, str.indexOf(end));
			System.out.println("*****" + s);
			//String[] info = s.split("公交数据");
			String[] info = s.split("乗換案内データ");

			if (info.length > 1) {
				for (int i = 0; i < 1; i++) {
					Map<String, Object> m = new HashMap<String, Object>();
					String[] infodetail = info[i].split("\"");
					List<String> lists = new ArrayList<String>();
					for (int j = 0; j < infodetail.length; j++) {

						if (infodetail[j].replaceAll(regJP, "").length() > 1) {
							boolean isShow = true;
							for (String string : strings) {
								if (infodetail[j].contains(string)) {
									isShow = false;
								}
							}
							if (isShow) {
								lists.add(infodetail[j]);
							}
						}else if(infodetail[j].replaceAll(regCH, "").length() > 1){
							boolean isShow = true;
							for (String string : strings) {
								if (infodetail[j].contains(string)) {
									isShow = false;
								}
							}
							if (isShow) {
								lists.add(infodetail[j]);
							}
						}else if (infodetail[j].contains("Station")) {
							lists.add(infodetail[j]);
						}
					}
					if (i > 0 && !lists.isEmpty()) {
						lists.remove(0);
						lists.remove(1);

					}
					if (!lists.isEmpty()) {
						m.put("swtime", lists.get(0));
						m.put("distance", lists.get(1));
						m.put("spendtime", lists.get(2));
						m.put("starttime", lists.get(3));
						m.put("endtime", lists.get(4));
					}
					List<Map<String, Object>> listtt2 = new ArrayList<Map<String, Object>>();
					for (String string : lists) {
						Map<String, Object> mdetail = new HashMap<String, Object>();
						mdetail.put("info", string);
						listtt2.add(mdetail);
					}
					
					System.out.println("____0" + listtt2);
					m.put("listInfo", listtt2);

					// 介绍总体路线
					List<Map<String, Object>> totalRoutes = new ArrayList<Map<String, Object>>();
					List<Map<String, Object>> totalRoutes2 = new ArrayList<Map<String, Object>>();

					boolean isBreak = false;
					boolean isadd = false;
					boolean iswalk = true;
					int size = 6;
					for (; size < lists.size(); size++) {

						String string = lists.get(size);
						System.out.println("____0" + string);
						Map<String, Object> mdetail = new HashMap<String, Object>();

						if (!isadd && (string.contains("步行") || string.contains("火车") || string.contains("地铁"))) {
							isadd = true;
						}
						if (isadd && string.contains("步行")) {
							iswalk = true;
						} else if (isadd && !string.contains("步行")) {
							iswalk = false;
						}
						if (isadd && !isBreak && string.contains("分钟")) {
							isBreak = true;
						}
						if (isadd) {
							System.out.println("+++" + string);
							if (!isBreak) {
								mdetail.put("totalinfoway", string);
								if (!iswalk) {
									if (lists.get(++size).contains("线")) {
										mdetail.put("totalinfoline", lists.get(size));
									} else {
										size--;
									}
								}
								totalRoutes.add(mdetail);
								totalRoutes2.add(mdetail);
							} else {
								break;
							}
						}

					}
					m.put("totalInfo", totalRoutes);

					System.out.println(totalRoutes.size());
					// 介绍分段
					List<Map<String, Object>> totalRouteItem = new ArrayList<Map<String, Object>>();

					for (; !totalRoutes2.isEmpty();) {
						Map<String, Object> mdetailSRoutes = new HashMap<String, Object>();

						for (Map.Entry<String, Object> entry : totalRoutes2.get(0).entrySet()) {
							if (entry.getKey().equals("totalinfoway") && entry.getValue().equals("步行")) {
								System.out.println("^^^^" + entry.getKey() + entry.getValue());

								if (totalRoutes2.size() == totalRoutes.size()) {
									mdetailSRoutes.put("spendTime", lists.get(size++));
									mdetailSRoutes.put("routeWay", lists.get(size++));
									break;
								} else {
									if (totalRoutes2.size() > 1) {
										for (; size < lists.size(); size++) {
											if (lists.get(size).equals("步行")) {
												mdetailSRoutes.put("routeWay", lists.get(size--));
												mdetailSRoutes.put("spendTime", lists.get(size++));
												break;
											}
										}
									} else {
										for (int index = (lists.size() - 1); index > 0; index--) {
											System.out.println("00000" + lists.get(index));
											if (lists.get(index).equals("步行")) {
												mdetailSRoutes.put("routeWay", lists.get(index--));
												mdetailSRoutes.put("spendTime", lists.get(--index));
												break;
											}
										}
									}
								}

							} else if (entry.getKey().equals("totalinfoway") && entry.getValue().equals("地铁")) {
								System.out.println("%%" + entry.getKey() + entry.getValue());
								for (; size < lists.size(); size++) {
									if (lists.get(size).contains(":")) {
										size--;
										break;
									}
								}
								mdetailSRoutes.put("routeWay", "地铁");
								mdetailSRoutes.put("spendTime", lists.get(size++));
								mdetailSRoutes.put("startTime", lists.get(size++));
								mdetailSRoutes.put("endTime", lists.get(size++));
								size+=2;
								for (; size < lists.size(); size++) {
									if (lists.get(size).contains(":")) {
										size--;
										break;
									}
								}
								mdetailSRoutes.put("startStation", lists.get(size++));
								size++;
								for (; size < lists.size(); size++) {
									if (lists.get(size).contains(":")) {
										size--;
										break;
									}
								}
								mdetailSRoutes.put("endStation", lists.get(size++));
								size++;
								for (; size < lists.size(); size++) {
									if (lists.get(size).contains(":")) {
										size--;
										break;
									}
								}
								List<Map<String, Object>> subway = new ArrayList<Map<String, Object>>();

								for (; size < lists.size(); size++) {
									if (lists.get(size).equals("地铁")) {
										size++;
										break;
									}
									if (lists.get(size).contains("/")) {
										System.out.println(lists.get(size) + "\\\\\\\\");
										size++;
									}
									String a = lists.get(size++);
									String b = lists.get(size++);
									if (a.contains(":") && b.contains(":")) {
										continue;
									}
									Map<String, Object> subwaySRoutes = new HashMap<String, Object>();
									if (a.contains(":")) {
										subwaySRoutes.put("stationName", b);
										subwaySRoutes.put("stationTime", a);
									} else {
										subwaySRoutes.put("stationName", a);
										subwaySRoutes.put("stationTime", b);

									}
									subway.add(subwaySRoutes);
								}

								mdetailSRoutes.put("wayinfo", subway);
								int subwaytime = 0;
								for (; size < lists.size(); size++) {
									if (subwaytime == 2 && lists.get(size).equals("地铁")) {
										break;
									}
									if (subwaytime == 1 && lists.get(size).equals("地铁")) {
										subwaytime = 2;
									}
									if (subwaytime == 0 && lists.get(size).equals("地铁")) {
										subwaytime = 1;
									}
									
									
								}
								if ((lists.size() - size) > 10) {
									for (; size < lists.size(); size++) {
										System.out.println("9999" + lists.get(size));
										if (lists.get(size).contains(":")) {
											size--;
											break;
										}
									}
								}
							} else if (entry.getKey().equals("totalinfoway") && entry.getValue().equals("火车")) {
								System.out.println("##" + entry.getKey() + entry.getValue());
								for (; size < lists.size(); size++) {
									if (lists.get(size).contains(":")) {
										size--;
										break;
									}
								}

								mdetailSRoutes.put("routeWay", "火车");
								mdetailSRoutes.put("spendTime", lists.get(size++));
								mdetailSRoutes.put("startTime", lists.get(size++));
								mdetailSRoutes.put("endTime", lists.get(size++));
								size+=2;
								for (; size < lists.size(); size++) {
									if (lists.get(size).contains(":")) {
										size--;
										break;
									}
								}
								mdetailSRoutes.put("startStation", lists.get(size++));
								size++;
								for (; size < lists.size(); size++) {
									if (lists.get(size).contains(":")) {
										size--;
										break;
									}
								}
								mdetailSRoutes.put("endStation", lists.get(size++));
								size++;
								for (; size < lists.size(); size++) {
									if (lists.get(size).contains(":")) {
										size--;
										break;
									}
								}
								List<Map<String, Object>> subway = new ArrayList<Map<String, Object>>();

								for (; size < lists.size(); size++) {

									if (lists.get(size).equals("火车")) {
										size++;
										break;
									}
									String a = lists.get(size++);
									String b = lists.get(size++);

									Map<String, Object> subwaySRoutes = new HashMap<String, Object>();
									if (a.contains(":") && !b.contains(":")) {
										subwaySRoutes.put("stationName", b);
										subwaySRoutes.put("stationTime", a);
									} else if (b.contains(":") && !a.contains(":")) {
										subwaySRoutes.put("stationName", a);
										subwaySRoutes.put("stationTime", b);
									}
									subway.add(subwaySRoutes);
								}

								mdetailSRoutes.put("wayinfo", subway);
								int subwaytime = 0;
								for (; size < lists.size(); size++) {
									if (subwaytime == 1 && lists.get(size).equals("火车")) {
										break;
									}
									if (subwaytime == 0 && lists.get(size).equals("火车")) {
										subwaytime = 1;
									}
									
								}
								if ((lists.size() - size) > 10) {
									for (; size < lists.size(); size++) {
										if (lists.get(size).contains(":")) {
											size--;
											break;
										}
									}
								}
							}
						}
						totalRouteItem.add(mdetailSRoutes);
						totalRoutes2.remove(0);
					}
					m.put("listWayInfo", totalRouteItem);

					listtt.add(m);
				}
				map.put("rows", listtt);
			}
			// ActionContext.getContext().put("s", s);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(map);
		this.setResponseJson(map);

		return SUCCESS;
	}

	public static List<String> readTxtFile(File file) {
		List<String> strings = new ArrayList<String>();
		try {
			String encoding = "UTF-8";
			if (file.isFile() && file.exists()) { // 判断文件是否存在
				InputStreamReader read = new InputStreamReader(new FileInputStream(file), encoding);// 考虑到编码格式
				BufferedReader bufferedReader = new BufferedReader(read);
				String lineTxt = null;
				while ((lineTxt = bufferedReader.readLine()) != null) {
					strings.add(lineTxt);
				}
				read.close();
			} else {
				System.out.println("找不到指定的文件");
			}
		} catch (Exception e) {
			System.out.println("读取文件内容出错");
			e.printStackTrace();
		}
		return strings;
	}
}
