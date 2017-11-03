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
<link rel="stylesheet" type="text/css" href="<l:asset path='lib/prism.min.css'/>" />
<style type="text/css">
  pre {
    margin: 0;
    border: none;
    border-radius: 0px;
    word-break: break-all; 
	word-wrap: break-word;
	white-space: pre;
	white-space: -moz-pre-wrap;
	white-space: pre-wrap;
	white-space: pre\9;
  }
  
  table thead {
    border-bottom: 1px solid black;
    vertical-align: bottom;
  }
  
  table thead th {
    text-align: right;
    vertical-align: middle;
    padding: 0.5em 0.5em;
  }
  
  table tbody tr {
    border-bottom: solid 1px #ddd;
    text-align: right;
    vertical-align: middle;
    padding: 0.5em 0.5em;
  }
  
  table tbody tr:nth-child(odd) {
    background: #eee;
  }
  
</style>
</head>
<body>
  <div class="container">
    <div class="clearfix" style="margin:1em auto; max-width: 960px;">
      <div class="pull-left">
        <h4 id="filename"></h4>
      </div>
      <div class="pull-right">
        <button id="backBtn" class="btn ue-btn"><spring:message code="back" text="返回"></spring:message></button>
      </div>
    </div>
	<div id="nbviewer">
	  
	</div>
  </div>
</body>
<script type="text/javascript" src="<l:asset path='jquery.js'/>"></script>
<script type="text/javascript" src="<l:asset path='dsw/lib/jquery.base64.min.js'/>"></script>
<script type="text/javascript" src="<l:asset path='dsw/lib/marked.min.js'/>"></script>
<script type="text/javascript" src="<l:asset path='dsw/lib/prism.min.js'/>"></script>
<script type="text/javascript" src="<l:asset path='dsw/lib/prism-python.min.js'/>"></script>
<script type="text/javascript" src="<l:asset path='dsw/lib/prism-r.min.js'/>"></script>
<script type="text/javascript" src="<l:asset path='dsw/lib/prism-markdown.min.js'/>"></script>
<script type="text/javascript" src="<l:asset path='dsw/lib/prism-latex.min.js'/>"></script>
<script type="text/javascript" src="<l:asset path='dsw/lib/nbv.js'/>"></script>
<script type="text/javascript">
var context = '<%=request.getContextPath()%>';
var filepath = '<%=request.getParameter("filepath")%>';
var depth = '<%=request.getParameter("depth")%>';
var decodePath = null;

$(function() {
    initPageDom();
    
    initPageEvent();
});

function initPageDom() {
	decodePath = $.base64.decode(filepath);
	$("#filename").html(decodePath.substring(decodePath.lastIndexOf('/') + 1));
	$.get(context + "/service/shared/nbviewer?filepath=" + filepath)
	 .done(function(data) {
		 nbv.render(data, document.getElementById('nbviewer'));
	 });
}

function initPageEvent() {
	$("#backBtn").on("click", function() {
		window.location.href = context + "/jsp/kl/dsw/shared-files.jsp?filepath=" 
				             + decodePath.substring(0, decodePath.lastIndexOf('/'))
				             + "&depth=" + depth;
	});
}
</script>
</html>