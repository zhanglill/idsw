package com.inspur.da.dsw.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.hadoop.fs.FileStatus;
import org.springframework.stereotype.Service;

import com.inspur.da.dsw.service.ISharedFileService;
import com.inspur.da.dsw.utils.ConfigUtil;
import com.inspur.da.dsw.utils.HDFSUtil;

@Service("hdfsFileService")
public class HdfsFileServiceImpl implements ISharedFileService {

	@Override
	public List<Map<String, String>> loadFileList(String fullpath) {
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		if (null == fullpath || fullpath.trim().length() == 0) {
			fullpath = ConfigUtil.getString(ConfigUtil.HDFS_URL) + "/" + ConfigUtil.getString(ConfigUtil.SHARED_PATH);
		}
		FileStatus[] fileStatus = HDFSUtil.listFile(fullpath);
		if (null != fileStatus) {
			for (FileStatus status : fileStatus) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("name", status.getPath().getName());
				map.put("path", status.getPath().toString());
				map.put("isFile", status.isFile() ? "1" : "0");
				map.put("modified", status.getModificationTime() + "");
				list.add(map);
			}
		}

		return list;
	}

	@Override
	public String downloadFile(String filepath, String tempDir) {
		return HDFSUtil.getZip(filepath, tempDir);
	}

	@Override
	public String downloadFile(String[] filepath, String tempDir) {
		return HDFSUtil.getZip(filepath, tempDir);
	}

}
