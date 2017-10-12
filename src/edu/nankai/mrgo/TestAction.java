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
public class TestAction extends ActionSupport {
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
		Map<String, Object> mapall = new HashMap<String, Object>();
		
		String realPath = ServletActionContext.getServletContext().getRealPath("");
		System.out.println("realPath:" + url);
		File file = new File(realPath + "\\file\\cutInfo.txt");
		List<String> strings = readTxtFile(file);
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
			System.out.println("info->"+s);
			//String[] info = s.split("公交数据");
			String[] info = s.split("乗換案内データ");
			System.out.println("info->"+info.length);
			if (info.length > 1) {
				List<Map<String, Object>> listttall = new ArrayList<Map<String, Object>>();
				for (int i = 0; i < info.length; i++) {
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("id", i+1);
					String[] infodetail = info[i].split("\"");
					
					List<String> lists = new ArrayList<String>();
					for (int j = 0; j < infodetail.length; j++) {
						if (infodetail[j].contains("線") || infodetail[j].contains("駅")) {
							boolean isShow = true;
							for (String string : strings) {
								if (infodetail[j].contains(string)) {
									isShow = false;
								}
							}
							if (isShow) {
								lists.add(infodetail[j]);
							}
						}
					}
					System.out.println("info->"+lists.size());
					List<Map<String, Object>> listtt3 = new ArrayList<Map<String, Object>>();
					for (String string : lists) {
						Map<String, Object> mdetail = new HashMap<String, Object>();
						mdetail.put("info", string);
						listtt3.add(mdetail);
						System.out.println("info->"+string);
					}
					
					//map.put("listAllInfo", listtt3);
					System.out.println("info->"+map);
					List<String> listlines = new ArrayList<String>();
					int idfind = 0;
					if(!lists.isEmpty()){
						for (int z=0;z<lists.size();z++) {
							if(lists.get(z).contains("線")&&!listlines.contains(lists.get(z))){
								listlines.add(lists.get(z));
								idfind ++;
							}else{
								if(idfind!=0){
									break;
								}else{
									continue;
								}
							}
						}
					}
					System.out.println("info->"+i+listlines.size());
					if(!listlines.isEmpty()){
						for(int z=0;z<idfind;z++){
							lists.remove(0);
						}
					}
					List<Map<String, Object>> listtt = new ArrayList<Map<String, Object>>();

			    	if(!listlines.isEmpty()){
						
						for(int z=0;;){
							
							Map<String, Object> mdetail = new HashMap<String, Object>();
							mdetail.put("lineInfo", listlines.get(z));
							
							mdetail.put("startStation", lists.get(0));
							
							lists.remove(0);
							if(lists.get(0).equals(mdetail.get("startStation"))){
								lists.remove(0);
							}
							mdetail.put("endStation", lists.get(0));
							lists.remove(0);
							listtt.add(mdetail);
							z++;
							if(listlines.size()>z){
								int spoint = 0;
								for(int n=0;n<lists.size();n++){
									if(lists.get(n).equals(listlines.get(z-1))){
										spoint = n;
									}
								}
								System.out.println("info->"+spoint);
								int deleteLength = spoint;
								for(;deleteLength>0;deleteLength--){
									lists.remove(0);
								}
								lists.remove(0);
								for (;lists.size()>0;) {
									if(!lists.get(0).equals(listlines.get(z))){
										lists.remove(0);
										//System.out.println("***daxiao333"+lists.size());
									}else{
										lists.remove(0);
										break;
									}
								}
								continue;
							}else{
								break;
							}
						}
					}
			    	map.put("rows1", listtt);
					listttall.add(map);
				}
				mapall.put("rows",listttall);
			}
			// ActionContext.getContext().put("s", s);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println(mapall);
		this.setResponseJson(mapall);

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
