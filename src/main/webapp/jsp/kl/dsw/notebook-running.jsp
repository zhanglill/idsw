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
  	<table id="running-list" class="table table-bordered table-hover">
  	  <thead>
  	    <tr>
  	      <th width="50%" data-field="path" data-render="renderNotebook">Name</th>
  	      <th width="30%" data-field="name" data-render="renderType">Kernel</th>
  	      <th data-field="id" data-render="renderOperation">Operation</th>
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
<script type="text/javascript" src="<l:asset path='nlp/ka/tag/loushang-framework-custom.js'/>"></script>
<script type="text/javascript">

$(function() {
	var url = "http://10.110.18.19:8888/api/sessions?token=be2e099409000721440ec60b5071cdbeb7d21af527ccbbd8";
	grid = new L.FlexGrid("running_list", url);
	grid.init({
		paging: false,
		bInfo: false,
		keywords: {
		  data: null
		}
	});
});

function submitClick(id) {
	$.ajax({
		type : "DELETE",
	    url: "http://10.110.18.19:8888/api/sessions/"+ id +"?token=be2e099409000721440ec60b5071cdbeb7d21af527ccbbd8",
	    success : function() {
			grid.reload();
        },
  	  });
}

function renderNotebook(data, type, row) {
	return '<a herf="#"><i class="fa fa-file" aria-hidden="true" ></i>&emsp;' + row.notebook.path + '</a>';
}

 function renderType(data, type, row) {
	return '<span>' + row.kernel.name + '</span>';
}  
 
function renderOperation(data, type, row) {
	return '<button class="btn btn-warning btn-xs" onclick="submitClick(\''+ data +'\')">Shutdown</button>';
}

</script>

</html>


