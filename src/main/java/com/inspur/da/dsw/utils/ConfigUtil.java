package com.inspur.da.dsw.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class ConfigUtil {
	public static final String JUPYTER_URL = "JUPYTER_URL";
	public static final String AIRFLOW_URL = "AIRFLOW_URL";
	public static final String TENSORBOARD_URL = "TENSORBOARD_URL";
	public static final String K8S_URL = "K8S_URL";
	public static final String HDFS_URL = "HDFS_URL";
	public static final String SHARED_PATH = "SHARED_PATH";
	public static final String LOGDIR_HDFS = "LOGDIR_HDFS";
	public static final String LOGDIR_LOCALE = "LOGDIR_LOCALE";
	public static final String KERBEROS_PRINCIPAL = "KERBEROS_PRINCIPAL";
	public static final String KERBEROS_ENABLE = "KERBEROS_ENABLE";

	private static Properties prop = new Properties();
	private static boolean hasLoad = false;

	private static void loadProperties() {
		InputStream is = ConfigUtil.class.getClassLoader().getResourceAsStream("idsw.properties");
		try {
			prop.load(is);
			hasLoad = true;
		} catch (IOException e) {
			e.printStackTrace();
			hasLoad = false;
		}
	}

	public static String getString(String key) {
		// 优先加载环境变量
		String value = System.getenv(key);
		if (null == value) {
			if (!hasLoad) {
				loadProperties();
			}
			value = prop.getProperty(key);
		}
		return value == null ? null : value.trim();
	}

	public static String getString(String key, String defaultStr) {
		String value = getString(key);
		return null == value ? defaultStr : value;
	}

}
