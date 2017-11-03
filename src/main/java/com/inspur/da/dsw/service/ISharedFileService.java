package com.inspur.da.dsw.service;

import java.util.List;
import java.util.Map;

public interface ISharedFileService {

	List<Map<String, String>> loadFileList(String fullpath);

	String downloadFile(String[] filepath, String tempDir);

	String downloadFile(String filepath, String tempDir);
}
