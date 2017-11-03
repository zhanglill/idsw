package com.inspur.da.dsw.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.inspur.da.dsw.utils.ConfigUtil;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/env")
public class EnvController {

	@RequestMapping(value = "/navigations", method = { RequestMethod.GET })
	@ResponseBody
	public Map<String, String> listNavigations() {
		Map<String, String> envMap = new HashMap<String, String>();
		envMap.put(ConfigUtil.JUPYTER_URL, ConfigUtil.getString(ConfigUtil.JUPYTER_URL));
		envMap.put(ConfigUtil.AIRFLOW_URL, ConfigUtil.getString(ConfigUtil.AIRFLOW_URL));
		envMap.put(ConfigUtil.TENSORBOARD_URL, ConfigUtil.getString(ConfigUtil.TENSORBOARD_URL));
		return envMap;
	}
}
