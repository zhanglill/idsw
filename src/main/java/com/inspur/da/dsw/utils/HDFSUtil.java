package com.inspur.da.dsw.utils;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.security.UserGroupInformation;

public class HDFSUtil {

	private final static Log logger = LogFactory.getLog(HDFSUtil.class);

	public static FileSystem getFileSystem() {
		Configuration conf = new Configuration();
		FileSystem fs = null;
		String kbsEnable = ConfigUtil.getString(ConfigUtil.KERBEROS_ENABLE);
		conf.set("fs.default.name", ConfigUtil.getString(ConfigUtil.HDFS_URL));
		try {
			if ("true".equalsIgnoreCase(kbsEnable)) {
				// 初始化配置文件
				conf.set("hadoop.security.authentication", "kerberos");
				conf.set("hadoop.security.authorization", "true");

				System.clearProperty("java.security.krb5.conf");
				// 获取krb5.conf文件
				String krbStr = Thread.currentThread().getContextClassLoader().getResource("krb5.conf").getFile();
				String userkeytab = Thread.currentThread().getContextClassLoader().getResource("hdfs.headless.keytab")
						.getFile();
				// 初始化配置文件
				System.setProperty("java.security.krb5.conf", krbStr);
				// 使用票据和凭证进行认证
				UserGroupInformation.setConfiguration(conf);
				String principal = ConfigUtil.getString(ConfigUtil.KERBEROS_PRINCIPAL);
				UserGroupInformation.loginUserFromKeytab(principal, userkeytab);
			}
			fs = FileSystem.get(conf);
		} catch (IOException e) {
			if (logger.isDebugEnabled()) {
				logger.debug("获取FileSystem出错:", e);
			}
			e.printStackTrace();
		}
		return fs;
	}

	public static FileSystem getFileSystem(String url) {
		if (StringUtils.isBlank(url)) {
			return null;
		}

		Configuration conf = new Configuration();
		FileSystem fs = null;
		try {
			URI uri = new URI(url.trim());
			fs = FileSystem.get(uri, conf);
		} catch (URISyntaxException | IOException e) {
			e.printStackTrace();
		}
		return fs;
	}

	public static String getZip(String src, String tempDir) {
		try {
			Files.createDirectories(Paths.get(tempDir));
			FileSystem fs = getFileSystem();
			fs.copyToLocalFile(new Path(src), new Path(tempDir));
			fs.close();
			return FileUtil.zip(tempDir + "/" + src.substring(src.lastIndexOf("/") + 1));
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static String getZip(String[] paths, String tempDir) {
		try {
			Files.createDirectories(Paths.get(tempDir));
			FileSystem fs = getFileSystem();
			for (String path : paths) {
				fs.copyToLocalFile(new Path(path), new Path(tempDir));
			}
			fs.close();
			return FileUtil.zip(tempDir);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static FileStatus[] listFile(String path) {
		FileSystem fs = getFileSystem();
		try {
			logger.debug("fs == null ? " + (fs == null));
			FileStatus[] status = fs.listStatus(new Path(path));
			fs.close();
			return status;
		} catch (IllegalArgumentException | IOException e) {
			e.printStackTrace();
		}
		return null;
	}
}
