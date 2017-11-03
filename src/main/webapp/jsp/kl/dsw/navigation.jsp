<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/tags/loushang-web" prefix="l"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<l:asset path='css/bootstrap.css'/>" />
<link rel="stylesheet" type="text/css" href="<l:asset path='css/font-awesome.css'/>" />
<link rel="stylesheet" type="text/css" href="<l:asset path='dsw/css/home.css'/>" />
</head>
<body>
  <div id="wrapper" style="padding: 10px;">
    <ul id="block-list" class="list-unstyled clearfix">
      <li class="col-md-4 col-xs-6">
        <a id="jupyter-url">
          <img src="<l:asset path="/dsw/img/jupyter.png"/>">
          <span></span>
        </a>
      </li>
      <li class="col-md-4 col-xs-6">
        <a id="tensorboard-url" href="#">
          <img width="150" src="<l:asset path="/dsw/img/tensorboard.jpg"/>">
          <span><spring:message code="tensorboard.label" text="深度学习"/></span>
        </a>
      </li>
      <li class="col-md-4 col-xs-6">
        <a id="airflow-url">
          <img width="100" src="<l:asset path="/dsw/img/airflow.png"/>">
          <span><spring:message code="airflow" text="流程编排"/></span>
        </a>
      </li>
      <li class="col-md-4 col-xs-6">
        <a id="shared-url" href="shared-files.jsp">
          <img width="75" src="<l:asset path="/dsw/img/shared.png"/>">
          <span><spring:message code="shared" text="共享库"/></span>
        </a>
      </li>
      <%-- <li class="col-md-4 col-xs-6">
        <a id="deploy-url">
          <img width="100" src="<l:asset path="/dsw/img/kubernetes.png"/>">
          <span><spring:message code="deploy" text="部署"/></span>
        </a>
      </li> --%>
      <li class="col-md-4 col-xs-6 last">
        <a href="#">
          <i class="fa fa-plus fa-2x"></i>
          <span><spring:message code="addapp" text="添加新应用"/></span>
        </a>
      </li>
    </ul>
  </div>
  <script type="text/javascript" src="<l:asset path='jquery.js'/>"></script>
  <script type="text/javascript" src="<l:asset path='bootstrap.js'/>"></script>
  <script type="text/javascript" src="<l:asset path='i18n.js'/>"></script>
  <script type="text/javascript">
  var context = '<%=request.getContextPath()%>';
  $(function() {
	initPageDom();
	  
	initPageEvent();
  });
	
  function initPageDom() {
	$.get(context + "/service/env/navigations")
	 .done(function(data) {
	   $("#jupyter-url").attr("href", data['JUPYTER_URL']);
	   $("#airflow-url").attr("href", data['AIRFLOW_URL']);
	   $("#tensorboard-url").attr("data-url", data['TENSORBOARD_URL']);
	   $("#deploy-url").attr("href", data["K8S_URL"]);
	 })
  }
	
  function initPageEvent() {
	$("#block-list li").on("click", "a", function() {
	  var arr = ['<li><a href="' + context + '/jsp/kl/dsw/navigation.jsp" target="mainframe">' + L.getLocaleMessage('homepage', "主页") + '</a></li>'];
	  var link = $(this).attr("href");
	  var text = $(this).find("span").text();
	  arr.push('<li><a href="' + link +'" target="mainframe">' + text + '</a></li>');
	  parent.setBreadCrumbs($(this).attr("id"));
	});
	
	$("#tensorboard-url").on("click", function() {
		parent.setMask();
		window.location.href = $(this).attr("data-url");
	})
  }
  </script>
</body>
</html>