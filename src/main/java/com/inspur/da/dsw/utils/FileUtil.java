package com.inspur.da.dsw.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.apache.commons.io.IOUtils;

public class FileUtil {

	public static String zip(String dir) throws IOException, FileNotFoundException {
		String dist = dir + ".zip";
		ZipOutputStream zipFile = new ZipOutputStream(new FileOutputStream(dist));
		Path srcPath = Paths.get(dir);
		compressDirectoryToZipfile(srcPath.getParent().toString(), srcPath.getFileName().toString(), zipFile);
		IOUtils.closeQuietly(zipFile);
		return dist;
	}

	private static void compressDirectoryToZipfile(String rootDir, String sourceDir, ZipOutputStream out)
			throws IOException, FileNotFoundException {
		String dir = Paths.get(rootDir, sourceDir).toString();
		for (File file : new File(dir).listFiles()) {
			if (file.isDirectory()) {
				compressDirectoryToZipfile(rootDir, Paths.get(sourceDir, file.getName()).toString(), out);
			} else {
				ZipEntry entry = new ZipEntry(Paths.get(sourceDir, file.getName()).toString());
				out.putNextEntry(entry);

				FileInputStream in = new FileInputStream(Paths.get(rootDir, sourceDir, file.getName()).toString());
				IOUtils.copy(in, out);
				IOUtils.closeQuietly(in);
			}
		}
	}
}
