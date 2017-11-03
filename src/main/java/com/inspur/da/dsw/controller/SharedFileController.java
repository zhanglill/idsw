package com.inspur.da.dsw.controller;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.loushang.framework.util.UUIDGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.inspur.da.dsw.service.ISharedFileService;
import com.inspur.da.dsw.utils.HDFSUtil;
import com.inspur.da.dsw.utils.JSONUtil;

@Controller
@RequestMapping("/shared")
public class SharedFileController {
	private final static Log log = LogFactory.getLog(SharedFileController.class);

	@Autowired
	private ISharedFileService hdfsFileService;

	@RequestMapping(value = "/files", method = RequestMethod.POST, params = { "using=flexgrid" })
	@ResponseBody
	public Map<String, Object> loadFileList(@RequestBody Map<String, String> params) {
		List<Map<String, String>> list = hdfsFileService.loadFileList(params.get("filepath"));
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("data", list);
		result.put("total", list.size());

		return result;
	}

	@RequestMapping(value = "/zip", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, String> zipFile(HttpServletRequest request) throws IOException, URISyntaxException {
		String filepath = request.getParameter("filepath");
		try {
			filepath = new String(Base64.decodeBase64(filepath), "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		String tempDir = request.getSession().getServletContext().getRealPath("/WEB-INF/download") + File.separator
				+ UUIDGenerator.getUUID();
		if (log.isDebugEnabled()) {
			log.debug("temp dir: " + tempDir);
		}
		String filename = null;
		String zipFile = null;
		if (filepath.contains(",")) {
			String[] paths = filepath.split(",");
			filename = new Date().getTime() + "";
			zipFile = hdfsFileService.downloadFile(paths, tempDir + "/" + filename);
		} else {
			filename = filepath.substring(filepath.lastIndexOf("/") + 1);
			zipFile = hdfsFileService.downloadFile(filepath, tempDir);
		}

		Map<String, String> result = new HashMap<String, String>();
		if (null != zipFile) {
			result.put("file", zipFile.substring(tempDir.lastIndexOf(File.separator) + 1));
		}

		return result;
	}

	@RequestMapping(value = "/download", method = RequestMethod.GET, params = "action=zip", produces = "application/zip")
	public void downloadFile(HttpServletRequest request, HttpServletResponse response)
			throws IOException, URISyntaxException {
		String filepath = request.getParameter("filepath");
		try {
			filepath = new String(Base64.decodeBase64(filepath), "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		String tempDir = request.getSession().getServletContext().getRealPath("/WEB-INF/download") + File.separator;
		String filename = filepath.substring(filepath.lastIndexOf("/") + 1);
		response.addHeader("Content-Disposition", "attachment; filename=" + filename);
		OutputStream os = response.getOutputStream();
		Files.copy(Paths.get(tempDir + filepath), os);
		os.close();
		response.flushBuffer();
		// 删除临时文件
		FileUtils.deleteDirectory(new File(tempDir));
	}

	@RequestMapping(value = "/download", method = RequestMethod.GET)
	public void downloadFile(@RequestParam String filepath, HttpServletResponse response) {
		try {
			filepath = new String(Base64.decodeBase64(filepath), "UTF-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		FileSystem fs = HDFSUtil.getFileSystem();
		try {
			FSDataInputStream fis = fs.open(new Path(filepath));
			byte[] buffer = new byte[fis.available()];
			fis.readFully(0, buffer);
			fis.close();
			fs.close();

			String filename = filepath.substring(filepath.lastIndexOf("/") + 1);
			response.setHeader("Content-Disposition", "attachment; filename=" + filename);
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Length", "" + buffer.length);

			OutputStream out = response.getOutputStream();
			out.write(buffer);
			out.close();
			out.flush();
		} catch (IllegalArgumentException | IOException e) {
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/nbviewer", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> nbviewer(@RequestParam String filepath) {
		try {
			filepath = new String(Base64.decodeBase64(filepath), "UTF-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		FileSystem fs = HDFSUtil.getFileSystem();
		try {
			FSDataInputStream fis = fs.open(new Path(filepath));
			byte[] buffer = new byte[fis.available()];
			fis.readFully(0, buffer);
			fis.close();
			fs.close();

			return JSONUtil.json2map(new String(buffer, "utf-8"));
		} catch (IllegalArgumentException | IOException e) {
			e.printStackTrace();
		}
		return Collections.emptyMap();
	}
}
