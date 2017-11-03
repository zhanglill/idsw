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
</head>
<body>
  <div class="container">
  	<div class="btn-group pull-right" style="margin:10px 0px;">
  	    <button class="btn ue-btn"><i class="fa fa-download"></i>&nbsp;Download</button>
  	    <button class="btn ue-btn"><i class="fa fa-upload"></i>&nbsp;Upload</button>
  		<button class="btn ue-btn dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
  			<span>New</span>
  			<span class="caret"></span>
  		</button>
  		<ul class="dropdown-menu dropdown-menu-right ue-dropdown-menu">
  			<li role="presentation">
  				<a role="menuitem" tabindex="-1" href="#"  onclick="newFile()">Text File</a>
  			</li>
  			<li role="presentation">
  				<a role="menuitem" tabindex="-1" href="#" onclick="newFolder()">Folder</a>
  			</li>
  			<li role="presentation" class="divider"></li>
  			<li role="presentation" class="dropdown-header">Visualization</li>
  			<li role="presentation">
  				<a role="menuitem" tabindex="-1" href="#" onclick="newFolder()">Visualize Pipeline</a>
  			</li>
  			<li role="presentation" class="divider"></li>
  			<li role="presentation" class="dropdown-header">Notebooks</li>
  		</ul>
  	</div>
  	<table id="fileTree" class="table table-bordered table-hover">
  	  <thead>
  	    <tr>
  	      <th width="5%" data-field="path" data-render="checkbox"><input type="checkbox"></th>
  	      <th width="40%" data-field="name" data-render="renderFileName">Name</th>
  	      <th width="30%" data-field="last_modified" data-render="renderModified">Last Modified</th>
  	      <th width="25%" data-field="path" data-render="renderOperations">Operations</th>
  	    </tr>
  	  </thead>
  	  <tbody></tbody>
  	</table>
  </div>
</body>
<script type="text/javascript" src="<l:asset path='jquery.js'/>"></script>
<script type="text/javascript" src="<l:asset path='bootstrap.js'/>"></script>
<script type="text/javascript" src="<l:asset path='form.js'/>"></script>
<script type="text/javascript" src="<l:asset path='datatables.js'/>"></script>
<script type="text/javascript" src="<l:asset path='dsw/lib/loushang-framework-custom.js'/>"></script>
<script type="text/javascript" src="<l:asset path='i18n.js'/>"></script>
<script type="text/javascript">
var global = {
	path:null,
	jupyterUrl: "http://10.110.18.19:8888",
	token: "4a51cec86e769e4ef999feff37b3c4002b9891f049e85e98"
}
$(function() {
	var url = global.jupyterUrl + "/api/contents?token=" + global.token;
	grid = new L.FlexGrid("fileTree", url);
	grid.init({
		paging: false,
		bInfo: false,
		keywords: {
		  data: "content"
		}
	});
	// 动态获取notebook类型名称
	$.ajax({
		url: global.jupyterUrl +"/api/kernelspecs?token=" + global.token,
		type: "GET",
	}).done(function(data) {
		$("ul").append('<li><a href="#" onclick="newPython()">'+ data["kernelspecs"]["conda-root-py"]["spec"]["display_name"] +'</a></li>');
		$("ul").append('<li><a href="#" onclick="newPython3()">'+ data["kernelspecs"]["python3"]["spec"]["display_name"] +'</a></li>');
	});
});

// 新建Text File
function newFile() {
	$.ajax({
		url: global.jupyterUrl + "/api/contents/"+ global.path,
		type: "POST",
		contentType: "json",
		data: JSON.stringify({"ext": ".txt", "type": "file"})
	}).done(function(data) {
		window.location.href= global.jupyterUrl + "/edit/"+ data.path;
	});  
}

// 新建Folder
 function newFolder() {
	$.ajax({
		url: global.jupyterUrl + "/api/contents/"+ global.path,
		type: "POST",
		contentType: "json",
		data: JSON.stringify({"type": "directory"})
	}).done(function() {
		grid.reload();
	});
 }
  
// 新建python[conda root]
function newPython() {
	$.ajax({
		url: global.jupyterUrl + "/api/contents/"+ global.path,
		type: "POST",
		contentType: "json",
		data: JSON.stringify({"type": "notebook"})
	}).done(function(data) {
		window.location.href= global.jupyterUrl + "/notebooks/"+ data.path +"?kernel_name=conda-root-py";
	});
}

// 新建python[default]
function newPython3() {
	$.ajax({
		url: global.jupyterUrl + "/api/contents/"+ global.path,
		type: "POST",
		contentType: "json",
		data: JSON.stringify({"type": "notebook"})
	}).done(function(data) {
		window.location.href= global.jupyterUrl + "/notebooks/"+ data.path +"?kernel_name=python3";
	});
}
		
// 进入下一级目录
function listDict(path) {
	var url = global.jupyterUrl + "/api/contents/"+ path + "?token=" + global.token;
	grid.reload(url);
}

// 删除
function removeClick(path) {
	$.dialog({
	   type: 'confirm',
	   content: '确定删除？',
	   ok: function () {
		   $.ajax({
				type: "DELETE",
			    url: global.jupyterUrl + "/api/contents/"+ path,
			}).done(function() {
				grid.reload();
			});
		},	
 		cancel: function () {}
	});
}	

//重命名
function renameClick(path) {
	var oldName = $(this).parent().prev().prev().children("a").text();
	$.dialog({
		type: 'confirm',
		content: '<form class="form-horizontal">' + 
		         '<div class="form-group">' + 
		         '<span class="col-xs-4 col-md-4 control-label">重命名：</span>' + 
		         '<div class="col-xs-8 col-md-8" style="padding-left:0px"><input id ="fileName" class="form-control ue-form" value="'+ oldName +'"></div>' + 
		         '</div>'+ '</form>',
		ok: function() {
			var newName = $("#fileName").val();
			 $.ajax({
			       type: "PATCH",
				   url: global.jupyterUrl + "/api/contents/"+ path,
				   contentType: "json",
				   data: JSON.stringify({"name": newName})
			 }).done(function() {
				grid.reload();
			});
		},
		cancel: function() {}
    });
}

function renderFileName(data, type, row) {
	global.path = row.path
	if(row.type == "directory") {
		return '<a herf="#" class="pull-left" style="margin-left: 10px;" onclick="listDict(\''+ row.path +'\')"><i class="fa fa-folder-o" aria-hidden="true"></i>&nbsp;' + data + '</a>';
	} else {
    	return '<a herf="#" class="pull-left" style="margin-left: 10px;" class="data-name" onclick="listDict(\''+ row.path +'\')"><i class="fa fa-file" aria-hidden="true"></i>&nbsp;' + data + '</a>';
	} 
}

function renderModified(data, type, row) {
	return moment(data).format('YYYY-MM-DD HH:mm:ss');
}
  
function renderOperations(data, type, row) {
	var arr = [];
	arr.push('<a onclick="removeClick(\''+ data +'\')">' + L.getLocaleMessage("delete", "删除") + '</a>');
	arr.push('<a onclick="renameClick(\''+ data +'\')">Rename</a>');
	arr.push('<a>Shared</a>');
	return arr.join("&emsp;");
}

</script>

</html>


