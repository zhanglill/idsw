<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/tags/loushang-web" prefix="l"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<title>流程设计工具</title>
	<link href="https://cdn.bootcss.com/bootstrap/4.0.0-beta/css/bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.bootcss.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
	<link href="https://cdn.bootcss.com/jqueryui/1.12.1/jquery-ui.min.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="<l:asset path='dsw/css/workflow/design.css'/>" />
	<script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
	<script src="https://cdn.bootcss.com/popper.js/1.12.5/umd/popper.min.js"></script>
	<script src="https://cdn.bootcss.com/bootstrap/4.0.0-beta/js/bootstrap.min.js"></script>
	<script src="https://cdn.bootcss.com/jqueryui/1.12.1/jquery-ui.min.js"></script>
	<script src="https://cdn.bootcss.com/d3/4.11.0/d3.min.js"></script>
	<script src="https://cdn.bootcss.com/d3-transform/1.0.4/d3-transform.min.js"></script>
</head>
<body style="overflow:hidden;">
    <div class="container-fuild">
    	<div id="left-wrapper" class="left-wrapper">
    		<ul class="sidebar-nav">
    			<li>
    				<a class="open">
    					<i class="fa fa-folder-o"></i>
    					<span>源/目标</span>
    				</a>
    				<ul>
    					<li class="node" data-id="101">
    						<a href="">
    							<i class="fa fa-database"></i>
    							<span>读数据</span>
    						</a>
    					</li>
    					<li class="node" data-id="102">
    						<a href="">
    							<i class="fa fa-database"></i>
    							<span>写数据</span>
    						</a>
    					</li>
    				</ul>
    			</li>
    			<li>
    				<a>
    					<i class="fa fa-folder-o"></i>
    					<span>数据预处理</span>
    				</a>
    				<ul>
    					<li class="node" data-id="211">
    						<a href="">
    							<i class="fa fa-crosshairs" aria-hidden="true"></i>
    							<span>类型转换</span>
    						</a>
    					</li>
    					<li class="node" data-id="212">
    						<a href="">
    							<i class="fa fa-crosshairs" aria-hidden="true"></i>
    							<span>拆分</span>
    						</a>
    					</li>
    					<li class="node" data-id="213">
    						<a href="">
    							<i class="fa fa-crosshairs" aria-hidden="true"></i>
    							<span>缺失值填充</span>
    						</a>
    					</li>
    					<li class="node" data-id="214">
    						<a href="">
    							<i class="fa fa-crosshairs" aria-hidden="true"></i>
    							<span>归一化</span>
    						</a>
    					</li>
    					<li class="node" data-id="215">
    						<a href="">
    							<i class="fa fa-crosshairs" aria-hidden="true"></i>
    							<span>标准化</span>
    						</a>
    					</li>
    				</ul>
    			</li>
    			<li>
    				<a>
    					<i class="fa fa-folder-o"></i>
    					<span>特征工程</span>
    				</a>
    			</li>
    			<li>
    				<a>
    					<i class="fa fa-folder-o"></i>
    					<span>机器学习</span>
    				</a>
    				<ul>
    					<li>
    						<a>
		    					<i class="fa fa-folder-o"></i>
		    					<span>二分类</span>
		    				</a>
    						<ul>
    							<li class="node">
    								<a href="">
    									<i class="fa fa-circle-o"></i>
    									<span>GBDT二分类</span>
    								</a>
    							</li>
    							<li class="node">
    								<a href="">
    									<i class="fa fa-circle-o"></i>
    									<span>PS-SMART</span>
    								</a>
    							</li>
    							<li class="node">
    								<a href="">
    									<i class="fa fa-circle-o"></i>
    									<span>线性支持向量机</span>
    								</a>
    							</li>
    							<li class="node">
    								<a href="">
    									<i class="fa fa-circle-o"></i>
    									<span>逻辑回归二分类</span>
    								</a>
    							</li>
    						</ul>
    					</li>
    					<li>
    						<a>
		    					<i class="fa fa-folder-o"></i>
		    					<span>聚类</span>
		    				</a>
    						<ul>
    							<li class="node">
    								<a href="">
    									<i class="fa fa-circle-o"></i>
    									<span>K均值聚类</span>
    								</a>
    							</li>
    						</ul>
    					</li>
    					<li>
    						<a>
    							<i class="fa fa-folder-o"></i>
    							<span>回归</span>
    						</a>
    						<ul>
    							<li class="node">
    								<a href="">
    									<i class="fa fa-circle-o"></i>
    									<span>GBDT回归</span>
    								</a>
    							</li>
    							<li class="node">
    								<a href="">
    									<i class="fa fa-circle-o"></i>
    									<span>线性回归</span>
    								</a>
    							</li>
    							<li class="node">
    								<a href="">
    									<i class="fa fa-circle-o"></i>
    									<span>PS_SMART回归</span>
    								</a>
    							</li>
    							<li class="node">
    								<a href="">
    									<i class="fa fa-circle-o"></i>
    									<span>PS线性回归</span>
    								</a>
    							</li>
    						</ul>
    					</li>
    				</ul>
    			</li>
    		</ul>
    	</div>
    	<div class="middle-wrapper">
    		<h4>实验名称</h4>
    		<div id="idsw-bpmn" class="bpmn" style="position: relative; width: 100%; height: 100%;">
    			<svg width="100%" height="100%">
					<defs>
						<marker id="arrowhead" viewBox="0 0 10 10" refX="10" refY="5" markerWidth="6" markerHeight="6" orient="auto">
							<path d="M 0 0 L 10 5 L 0 10 z" stroke-width="0" stroke="#333"></path>
						</marker>
					</defs>
				</svg>
    		</div>
    		<div style="height: 40px; border-top: solid 1px #e7e7e7; text-align: center; line-height: 40px; position: absolute;bottom: 2px; width: 100%">
    			<a class="btn btn-link" href="#"><i class="fa fa-play-circle-o" aria-hidden="true"></i>&nbsp;运行</a>
    			<a class="btn btn-link" href="#"><i class="fa fa-cloud-upload" aria-hidden="true"></i>&nbsp;部署</a>
    			<a class="btn btn-link" href="#"><i class="fa fa-share-alt" aria-hidden="true"></i>&nbsp;分享</a>
    		</div>
    	</div>
    	<div class="right-wrapper">
    		<h4>实验属性</h4>
    	</div>
    </div>
</body>
<script type="text/javascript" src="<l:asset path='dsw/workflow/design.js'/>"></script>
</html>