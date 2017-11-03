<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/tags/loushang-web" prefix="l"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<l:asset path='css/bootstrap.css'/>" />
<link rel="stylesheet" type="text/css" href="<l:asset path='css/font-awesome.css'/>" />
<link rel="stylesheet" type="text/css" href="<l:asset path='css/form.css'/>" />
<link rel="stylesheet" type="text/css" href="<l:asset path='css/datatables.css'/>" />
<link rel="stylesheet" type="text/css" href="<l:asset path='css/ui.css'/>" />
<link rel="stylesheet" type="text/css" href="<l:asset path='dsw/css/home.css'/>" />
<style type="text/css">

.bread-crumbs {
  display: inline-block;
  margin-bottom: 0px;
  line-height: 30px;
}
.bread-crumbs li+li:before {
    content: "/";
    margin-right: 7px;
    color: #aaa;
}

.container-custom {
    overflow-y: auto;
    height: calc(100% - 15px);
    margin-top: 10px;
}
</style>
</head>
<body>
  <div class="container-fluid container-custom">
     <div class="col-xs-12 col-md-12">
       <div class="row clearfix">
         <ul id="pathNav" class="list-inline bread-crumbs">
		   <li><a onclick="loadFileList()"><i class="fa fa-home"></i></a></li>
		 </ul>
         <div class="btn-group pull-right">
           <button id="downloadBtn" type="button" class="btn ue-btn" disabled>
             <span class="fa fa-download"></span><spring:message code="download" text="下载"></spring:message>
           </button>
         </div>
	   </div>
	   <div class="row">
	     <table id="fileList" class="table table-bordered table-hover">
	       <thead>
	         <tr>
	           <th width="50px" data-field="path" data-render="checkbox">
	             <input type="checkbox"/>
	           </th>
	           <th width="70%" data-field="name" data-render="renderFileName">
	             <spring:message code="filename" text="文件名"></spring:message>
	           </th>
	           <th data-field="modified" data-render="renderModified">
	             <spring:message code="modification.time" text="修改时间"></spring:message>
	           </th>
	         </tr>
	       </thead>
	     </table>
	   </div>
     </div>
  </div>
  <script type="text/javascript" src="<l:asset path='jquery.js'/>"></script>
  <script type="text/javascript" src="<l:asset path='bootstrap.js'/>"></script>
  <script type="text/javascript" src="<l:asset path='form.js'/>"></script>
  <script type="text/javascript" src="<l:asset path='datatables.js'/>"></script>
  <script type="text/javascript" src="<l:asset path='loushang-framework.js'/>"></script>
  <script type="text/javascript" src="<l:asset path='i18n.js'/>"></script>
  <script type="text/javascript" src="<l:asset path='dsw/lib/jquery.base64.min.js'/>"></script>
  <script type="text/javascript">
  var context = '<%=request.getContextPath()%>';
  var filepath = '<%=request.getParameter("filepath")%>';
  var depth = '<%=request.getParameter("depth")%>';
  var urls = [];
  var grid = null;
  $(function() {
	initPageDom();
	  
	initPageEvent();
  });
  	
  function initPageDom() {
	var url = context + "/service/shared/files?using=flexgrid";
	var options = {
	  "paging" : false,
	  "info" : false,
	  "ordering" : false
	};
	grid = new L.FlexGrid("fileList", url);
	if(filepath && filepath != 'null') {
		grid.setParameter("filepath", filepath);
		var tmpPath = filepath;
		if(depth && depth != 'null') {
			// 重新构建urls
			for(var i = depth; i > 0; i--) {
				var last = tmpPath.lastIndexOf('/')
				urls.unshift(tmpPath);
				tmpPath = tmpPath.substring(0, last);
			}
			buildBreadcrums();
		}
	}
	grid.init(options);
  }

  // 初始化页面事件
  function initPageEvent() {
	// 当前选中记录非空时, download按钮才能处于可用状态
	$(document).on("click", 'input[type="checkbox"]', function() {
		var len = $('tbody input[type="checkbox"]:checked').length;
		if(len) {
		  $("#downloadBtn").prop("disabled",false);
		} else {
		  $("#downloadBtn").prop("disabled",true);
		}
	});
	
	$("#downloadBtn").on("click", function() {
	  var ids = [];
	  var $checked = $('tbody input[type="checkbox"]:checked');
	  $checked.each(function() {
		  ids.push($(this).val());
	  });
	  // 如果是单个文件执行单文件下载
	  if(ids.length == 1) {
		  var isFile = $checked.closest('tr').find('input[name="isFile"]').val();
		  if(isFile == '1') {
			  downloadFile(ids[0]);
		  } else {
			  zipAndDownload(ids.join(","));
		  }
	  } else {
		  zipAndDownload(ids.join(","));
	  }
	});
  }
  
  function zipAndDownload(filepath) {
	 var $mask = $("html");
	 $mask.loading({
	    isShowMask: true,
	    lines: 8,
	    length: 0,
	    width: 10,
	    radius: 15,
	    maskOpacity: '0.4',
	    loadingText: '正在创建压缩包...'
	 });
	 $.get(context + "/service/shared/zip?filepath=" + $.base64.encode(filepath))
	  .done(function(msg) {
		  if(msg && msg['file']) {
			 window.location.href = context + "/service/shared/download?action=zip&filepath=" + $.base64.encode(msg['file']);
		  }
		  $mask.unloading();
	  })
  }
  
  // 渲染文件名
  function renderFileName(data, type, full) {
	// 文件类型使用fa-file图标,文件夹类型使用fa-folder图标
	if(full.isFile == '1') {
	  var html = '<a class="pull-left" style="margin-left: 15px;" onclick="preview(\'' + full.path + '\')">' 
	           + '  <span class="fa fa-file">&ensp;' + data + '</span>'
	           + '</a>';
	} else {
	  var html = '<a class="pull-left" style="margin-left: 15px;" onclick="loadFileList(\'' + full.path + '\')">' 
               + '  <span class="fa fa-folder">&ensp;' + data + '</span>'
               + '</a>';
	}
	html += '<input type="hidden" name="isFile" value="' + full.isFile + '" />';
	return html;
  }
  
  // 将long型的时间转换成YYYY-MM-DD HH:mm:ss格式的字符串
  function renderModified(data) {
	return moment(+data).format('YYYY-MM-DD HH:mm:ss');
  }
  
  // 加载文件列表
  function loadFileList(filepath) {
	urls.push(filepath);
	grid.setParameter("filepath", filepath);
	grid.reload();
	
	// 构建面包屑导航
	buildBreadcrums();
  }
  
  // 面包屑导航事件
  function loadFileListByIndex(index) {
	if(index != -1) {
	  // 避免发生字符串与数字相加返回字符串的问题,通过+操作将字符串转成数字
	  urls = urls.slice(0, +index + 1);
	  grid.setParameter("filepath", urls[index]);
	} else {
	  urls.length = 0;
	  grid.setParameter("filepath", '');
	}
	grid.reload();
	// 重新构建面包屑导航
	buildBreadcrums();
  }
  
  // 构建面包屑导航
  function buildBreadcrums() {
	var arr = ['<li><a onclick="loadFileListByIndex(-1)"><i class="fa fa-home"></i></a></li>'];
	if(urls.length) {
		for(var i = 0; i < urls.length - 1; i++) {
		  arr.push('<li><a onclick="loadFileListByIndex(' + i + ')">' + urls[i].substring(urls[i].lastIndexOf("/") + 1) + '</a></li>');
		}
		// 最后一级导航禁止鼠标点击
		arr.push('<li><span>' + urls[urls.length - 1].substring(urls[urls.length - 1].lastIndexOf("/") + 1) + '</span></li>');
	}
	$("#pathNav").empty().append(arr.join(''));
  }
  
  // 单文件下载
  function downloadFile(path) {
	  window.location.href = context + "/service/shared/download?filepath=" + $.base64.encode(path);
  }
  
  function preview(path) {
	  var depth = $("#pathNav").find("li").length - 1;
	  if(path.match('.ipynb$')) {
		  window.location.href = context + "/jsp/kl/dsw/nbviewer.jsp?filepath=" + $.base64.encode(path) + "&depth=" + depth;
	  } else {
		  // TODO 提示不支持预览
		  $.dialog({
	        type: 'confirm',
	        content: L.getLocaleMessage('error.preview', '此文件不支持预览，是否下载？'),
	        ok: function () {
	        	downloadFile(path);
	        },
	        cancel: function () {}
	      });
	  }
  }
  </script>
</body>
</html>