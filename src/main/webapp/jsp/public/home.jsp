<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/tags/loushang-web" prefix="l"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><spring:message code="idsw.fullname" text="数据科学家工作台"/></title>
<link rel="stylesheet" type="text/css" href="<l:asset path='css/bootstrap.css'/>" />
<link rel="stylesheet" type="text/css" href="<l:asset path='css/font-awesome.css'/>" />
<link rel="stylesheet" type="text/css" href="<l:asset path='css/form.css'/>" />
<link rel="stylesheet" type="text/css" href="<l:asset path='css/datatables.css'/>" />
<link rel="stylesheet" type="text/css" href="<l:asset path='dsw/css/home.css'/>" />
</head>
<body>
  <div id="wrapper" class="toggled">
    <div id="sidebar-wrapper" >
      <div class="sidebar-brand">
        <a href="<%=request.getContextPath() %>/jsp/kl/dsw/navigation.jsp" target="mainframe">
          <img src="<l:asset path="dsw/img/logo.png"/>" alt="logo">
          <span><spring:message code="idsw" text="数据科学家工作台"/></span>
        </a>
      </div>
      <div class="sidebar-toggle">
        <a href="#">
          <i class="fa fa-list"></i>
          <span><spring:message code="collapse" text="收起"/></span>
        </a>
      </div>
      <ul id="top-menu" class="sidebar-nav">
        <li>
          <a href="<%=request.getContextPath() %>/jsp/kl/dsw/projects.jsp" target="mainframe">
            <i class="fa fa-folder" aria-hidden="true"></i>
            <span><spring:message code="menu.projects" text="项目"/></span>
          </a>
        </li>
        <li>
          <a href="<%=request.getContextPath() %>/jsp/kl/dsw/workflow.jsp" target="mainframe">
            <i class="fa fa-flask" aria-hidden="true"></i>
            <span><spring:message code="menu.experiment" text="实验"/></span>
          </a>
        </li>
        <li>
          <a href="../kl/dsw/notebook.jsp" target="mainframe">
            <i class="fa fa-book" aria-hidden="true"></i>
            <span><spring:message code="menu.notebook" text="笔记本"/></span>
          </a>
        </li>
        <li>
          <a href="<%=request.getContextPath() %>/jsp/kl/dsw/monitor.jsp" target="mainframe">
            <i class="fa fa-dashboard" aria-hidden="true"></i>
            <span><spring:message code="menu.monitor" text="监控"/></span>
          </a>
        </li>
        <li>
          <a href="<%=request.getContextPath() %>/jsp/kl/dsw/shared-files.jsp" target="mainframe">
            <i class="fa fa-share-alt" aria-hidden="true"></i>
            <span><spring:message code="menu.sharedlib" text="共享库"/></span>
          </a>
        </li>
      </ul>
      
      <ul class="sidebar-nav" style="position: absolute; bottom: 0px; width:100%">
          <li>
             <a href="<%=request.getContextPath() %>/jsp/kl/dsw/shared-files.jsp" target="mainframe">
	           <i class="fa fa-user" aria-hidden="true"></i>
	           <span><spring:message code="menu.user" text="管理员"/></span>
	         </a>
          </li>
          <li>
             <a href="<%=request.getContextPath() %>/jsp/kl/dsw/shared-files.jsp" target="mainframe">
	           <i class="fa fa-globe" aria-hidden="true"></i>
	           <span><spring:message code="menu.lang" text="简体中文"/></span>
	         </a>
          </li>
          <li>
             <a href="<%=request.getContextPath() %>/jsp/kl/dsw/shared-files.jsp" target="mainframe">
	           <i class="fa fa-question-circle" aria-hidden="true"></i>
	           <span><spring:message code="menu.help" text="帮助"/></span>
	         </a>
          </li>
      </ul>
    </div>
    <div id="page-content-wrapper">
      <ul class="list-inline top-bar">
        <li><a href="#"><spring:message code="menu.project" text="项目"/></a></li>
      </ul>
      <div class="main-content">
        <iframe id="mainframe" name="mainframe" width="100%" height="100%" frameborder="0" src="<%=request.getContextPath() %>/jsp/kl/dsw/navigation.jsp"></iframe>
      </div>
    </div> 
  </div>
</body>
<script type="text/javascript" src="<l:asset path='jquery.js'/>"></script>
<script type="text/javascript" src="<l:asset path='bootstrap.js'/>"></script>
<script type="text/javascript" src="<l:asset path='form.js'/>"></script>
<script type="text/javascript" src="<l:asset path='datatables.js'/>"></script>
<script type="text/javascript" src="<l:asset path='loushang-framework.js'/>"></script>
<script type="text/javascript" src="<l:asset path='i18n.js'/>"></script>
<script type="text/javascript">
var context = '<%=request.getContextPath()%>';
var $mask = $("#wrapper");
$(function() {
  initPageDom();
  
  initPageEvent();
});

function initPageDom() {
	$.get(context + "/service/env/navigations")
	 .done(function(data) {
	   $("#jupyter-url").attr("href", data['JUPYTER_URL']);
	   $("#airflow-url").attr("href", data['AIRFLOW_URL']);
	   $("#tensorboard-url").attr("href", data['TENSORBOARD_URL']);
	   $("#shared-url").attr("href", context + "/jsp/kl/dsw/shared-files.jsp");
	 })
}

function initPageEvent() {
  $("#top-menu").on("click", "a", function() {
	  $(this).closest("ul").find("li").removeClass("active");
	  $(this).parent().addClass("active");
	  
  })
  $(".sidebar-nav").on("click", "a", function() {
	  setBreadCrumbs($(this).attr("id"));
  });
  
  $(".sidebar-toggle").on("click", "a", function() {
    $("#wrapper").toggleClass("toggled");
  });
  
  $("#tensorboard-url").on("click", function() {
	 // 加载遮罩层
	 setMask();
  })
  
  // 面包屑点击事件
  $(document).on("click", "#bread-crumbs a", function() {
	 var $p = $(this).closest("li");
	 $p.nextAll().remove();
	 if($p.index() == 0) {
	   $(".sidebar-nav").find("li").removeClass("active");
	 }
	 
	 if($(this).text() == 'TensorBoard') {
		// 加载遮罩层
		setMask();
	 }
  });
  
  $("#mainframe").on("load", function() {
	  try {
		  $mask.unloading();
	  } catch (e) {
		  
	  }
  });
}

function setBreadCrumbs(id) {
  var arr = ['<li><a href="' + context + '/jsp/kl/dsw/navigation.jsp" target="mainframe">' + L.getLocaleMessage('homepage', "主页") + '</a></li>'];
  var $that = $('#' + id);
  var link = $that.attr("href");
  var text = $that.find("span").text();
  arr.push('<li><a href="' + link +'" target="mainframe">' + text + '</a></li>');
  $("#bread-crumbs > ul").empty().append(arr.join(""));
  
  $that.closest("ul").find("li").removeClass("active");
  $that.parent().addClass("active");
}

function setMask() {
   $mask.loading({
      isShowMask: true,
      lines: 8,
      length: 0,
      width: 10,
      radius: 15,
      maskOpacity: '0.4',
      loadingText: '加载中...'
   });
}
</script>
</html>