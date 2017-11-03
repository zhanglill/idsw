<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/tags/loushang-web" prefix="l"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Projects</title>
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
         <ul class="list-inline bread-crumbs">
		   <li><a onclick="loadFileList()"><i class="fa fa-home"></i></a></li>
		 </ul>
         <div class="btn-group pull-right">
           <button id="newProjectBtn" type="button" class="btn ue-btn">
             <i class="fa fa-plus"></i>
             <spring:message code="label.newProject" text="新建项目"></spring:message>
           </button>
         </div>
	   </div>
	   <div class="row">
	     <table id="projectList" class="table table-bordered table-hover">
	       <thead>
	         <tr>
	           <th width="50px" data-field="path" data-render="index">序号</th>
	           <th width="40%" data-field="name" data-render="renderFileName">
	             <spring:message code="filename" text="文件名"></spring:message>
	           </th>
	           <th width="30%" data-field="last_modified" data-render="renderModified">
	             <spring:message code="label.modification" text="修改时间"></spring:message>
	           </th>
	           <th data-field="path" data-render="renderOperation">
	             <spring:message code="label.actions" text="操作"></spring:message>
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
  <script type="text/javascript" src="<l:asset path='dsw/lib/loushang-framework-custom.js'/>"></script>
  <script type="text/javascript" src="<l:asset path='i18n.js'/>"></script>
  <script type="text/javascript">
  var global = {
	path:null,
	grid: null,
    jupyterUrl: "http://10.110.18.19:8888",
	token: "4a51cec86e769e4ef999feff37b3c4002b9891f049e85e98"
  }
  var contextPath = "<%=request.getContextPath()%>";
  
  $(function() {
	  initPageDom();
	  initPageEvent();
  });
  
  function initPageDom() {
	var url = global.jupyterUrl + "/api/contents?token=" + global.token;
	var grid = new L.FlexGrid("projectList", url);
	grid.init({
	  paging: false,
	  bInfo: false,
	  keywords: {
		data: "content"
	  }
	});
	global.grid = grid;
  }
  
  function initPageEvent() {
	  $("#newProjectBtn").on("click", function() {
		  $.dialog({
	        type: 'confirm',
	        content: '<form class="form-horizontal">' + 
	                 '<div class="form-group">' + 
	                 '<div class="col-xs-8 col-md-8" style="padding-left:0px"><input id="projectName" class="form-control ue-form"></div>' + 
	                 '</div>'+ '</form>',
	        ok: function () {
	           newProject($("#projectName").val());
	        },
	        cancel: function () {}
	      });
		  
	  });
  }
  
  function newProject(name) {
	  $.ajax({
		url: global.jupyterUrl + "/api/contents?token=" + global.token,
		type: "POST",
		contentType: "application/json",
		data: JSON.stringify({"type": "directory"})
	  }).done(function(msg) {
		// 新建项目
		if(msg && typeof(msg.created) === 'string') {
		  $.ajax({
	        url: global.jupyterUrl + "/api/contents/" + msg.path + "?token=" + global.token,
		    type: "PATCH",
		    contentType: "application/json",
		    data: JSON.stringify({"path": name})
		  }).done(function() {
			global.grid.reload();
		  });
		}
	  });
  }
  
  function renderFileName(data) {
	  return '<a href="' + contextPath + '/jsp/kl/dsw/project.jsp?path=' + data + '">' + data + '</a>';
  }
  
  function renderModified(data) {
	  return moment(data).format('YYYY-MM-DD HH:mm:ss');
  }
  
  function renderOperation(data) {
	  var arr = [];
	  arr.push('<a onclick="editClick()">Edit</a>');
	  arr.push('<a onclick="removeClick(\'' + data + '\')">Remove</a>');
	  arr.push('<a onclick="sharedClick()">Shared</a>')
	  
	  return arr.join("&emsp;");
  }
  
  function removeClick(path) {
	  $.ajax({
		  type: "delete",
		  url: global.jupyterUrl + "/api/contents/" + path + "?token=" + global.token
	  }).done(function(msg) {
		  if(!msg) {
			 global.grid.reload();
		  } else {
			$.dialog({
		      type: 'alert',
		      content: "删除文件夹失败"
		    });
		  }
	  }).fail(function(msg) {
		  $.dialog({
		      type: 'alert',
		      content: "文件夹不为空"
		  });
	  });
  }
  </script>
</body>
</html>