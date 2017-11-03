package com.inspur.da.dsw.utils;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

public class JSONUtil {

	public static Map<String, Object> json2map(String json) {
		ObjectMapper mapper = new ObjectMapper();
		try {
			return mapper.readValue(json, new TypeReference<HashMap<String, Object>>() {
			});
		} catch (Exception e) {
			e.printStackTrace();
		}
		return Collections.emptyMap();
	}
}
