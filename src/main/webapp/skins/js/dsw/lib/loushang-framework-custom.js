L= {
  version: '2.0'
};

L.FlexGrid = function(elem, url) {
  this.elem = elem;
  this.url = url;
  this.columnList = [];   // 列属性表
  this.params = {};       // 参数列表
  this.total = 0;         // 总记录数
  // 默认参数列表
  this.defaults = {
	aLengthMenu: [10,25,50,100],
	iDisplayLength: 10,
	bLengthChange:true,
	ordering: false,
	paging: true,
	bPaginate: true,
	bServerSide: true,
	searching: false,
	colResize: false,
	bInfo: true,
	sDom: 'f<"H"r>t<"F"ipl><"clearfix">',
	keywords: {
	  start: "start",
	  limit: "limit",
	  total: "total",
	  data: "data"
	},
	"pagingType": "full_numbers",
	"language": {
		"processing": "",
	    "lengthMenu": " _MENU_ ",
	    "loadingRecords": L.FlexGrid.locale['loadingRecords'],            
	    "zeroRecords": L.FlexGrid.locale['zeroRecords'],
	    "info": L.FlexGrid.locale['info'],
	    "infoEmpty": "",
	    "sSearch": L.FlexGrid.locale['sSearch'],
	    "emptyTable":"<span class='norecord'></span>",
	    "paginate": {//分页的样式文本内容。
	        "previous": "《",
	        "next": "》",
	        "first": "",
	        "last": ""
	    }
	},
  };
  this.oTable = null;
};

// 国际化
L.FlexGrid.locale = {
    "loadingRecords": "加载中...",
    "zeroRecords": "未查询到记录",
    "info": "显示 _START_ 到 _END_ 条 共 _TOTAL_ 条记录",
    'sSearch': "搜索"
};

L.FlexGrid.prototype = {
	locale: {
		"loadingRecords": "加载中...",
	    "zeroRecords": "未查询到记录",
	    "info": "显示 _START_ 到 _END_ 条 共 _TOTAL_ 条记录",
	    'sSearch': "搜索"
	},
	init: function(options) {
	  var that = this;
	  $.extend(true, that.defaults, options);

	  var thead = [];
	  var $thead = $("#" + that.elem + " thead");
	  var rows = $thead.find("tr").length;
	  var cols = $thead.find("th").filter(function(thindex, thelement) {
          return !($(thelement).attr("colspan") > 1);
        }).length;
	  // 初始化二维数组
	  for(var row = 0; row < rows; row++) {
	  	thead.push([]);
	  	for(var col = 0; col < cols; col++) {
	  	  thead[row][col] = null;
	  	}
	  }

	  for(row = 0; row < rows; row++) {
	  	// 遍历表头中的每一行
		for(var row = 0; row < rows; row++) {
		  // 遍历每行中的每个单元格
		  $("tr:eq(" + row + ") th", $thead).each(function() {
		    for(var col = 0; col < cols; col++) {
		      // 将单元格根据行列号放置在二维数组thead中
		      if(thead[row][col] == null) {
		        thead[row][col] = this;
		        // 如果有合并行,将合并行的值赋值为0
		        if($(this).attr("rowspan")) {
		          thead[row][col] = this;
		          var rowspan = parseInt($(this).attr("rowspan"), 10);
		          while(rowspan > 1) {
		            thead[row + rowspan - 1][col] = 0;
		            rowspan--;
		          }
		        }
		        // 如果有合并列，将合并列的值赋值为0
		        if($(this).attr("colspan")) {
		          thead[row][col] = this;
		          var colspan = parseInt($(this).attr("colspan"), 10);
                  while(colspan > 1) {
                    thead[row][col + colspan - 1] = 0;
                    colspan--;
                  }
		        }
		        break;
		      }
		    }
		  });
		}
	  }

	  $.each(thead, function(trindex, tr) {
	  	$.each(tr, function(thindex, th) {
	  		var colMap = {};
	  		var colDefMap = {};

	  		if(th) {
	  			var $th = $(th);
	  			colMap["data"] = $th.attr("data-field");
	  			colMap["bSortable"] = $th.attr("data-sortable") === 'true';
	  			colMap['visible'] = $th.attr("data-hidden") !== 'true';

	  			var render = $th.attr("data-render");
	  			if(render) {
	  			  if(render == 'checkbox' && typeof render == 'string') {
	  				colMap['render'] = function(data) {
	  			  	  return '<input type="checkbox" value="' + data + '" title="' + data + '"/>';
	  			  	}
	  			  } else if (render == 'radio' && typeof render == 'string') {
	  				colMap['render'] = function(data) {
	  			  	  return '<input type="radio" value="' + data + '" title="' + data + '"/>';
	  			  	}
	  			  } else if ((render == 'num' || render == 'index') && typeof render == 'string') {
	  				colMap['render'] = function(data, type, full, meta) {
					  return meta.settings._iDisplayStart + meta.row + 1;
	  			  	}
	  			  } else {
	  				colMap["render"] = eval(render);
	  			  }
	  			}
	  			if(!$.isEmptyObject(colMap)) {
	  			  that.columnList[thindex] = colMap;
	  			}
	  		}
	  	});
	  });
	  
	  var opt = {
		ajax: {
		  url: that.url,
		  type: "GET",
		  data: $.isEmptyObject(that.params) ? "" : JSON.stringify(that.params),
		  dataSrc: that.defaults.keywords.data
		},
	    aoColumns: that.columnList
	  };
	  $.extend(true, that.defaults, opt);
	  that.oTable = $("#" + that.elem).dataTable(that.defaults);
	  
	  // 绑定checkbox事件
	  if($thead.find('input[type="checkbox"]').length) {
		  $(document).on("click", '#' + that.elem + ' thead th > input[type="checkbox"]', function() {
			  $(this).closest('table').find('input:checkbox').not(this).prop('checked', this.checked);
		  });
		  
		  $(document).on("click", '#' + that.elem + ' tbody input[type="checkbox"]', function() {
			  if (!$(this).is('input:checkbox')) {
	            var $checkbox = $(this).closest('tr').find('input:checkbox');
	            $checkbox.prop('checked', !$checkbox.is(":checked"));
	          }
	          var $table = $(this).closest('table');
	          var $checkboxes = $table.find('tbody input:checkbox');
	          var $checked = $table.find('tbody input:checked');
	          var $checkAll = $table.find('thead input:checkbox');
	          var curStatus = $checked.length === $checkboxes.length;
	          if ($checkAll.is(":checked") ^ curStatus) {
	              $checkAll.prop('checked', curStatus);
	          }
		  });
	  }
	  
	  $(window).on("resize", function() {
		  that.oTable.api().columns.adjust()
	  });
	},
	reload: function(url, params, resetPaging) {
		var that = this;
		var ajax = that.oTable.api().ajax;
		if(url){
			that.url = url;
			ajax.url(url);
		}
		if(params){
			that.params = params;
		}
		if(resetPaging){
			that.resetPaging = resetPaging;
		}
		ajax.params($.isEmptyObject(that.params) ? null : that.params);
		ajax.reload(null, resetPaging); //resetPaging true从地一页开始加载，resetPaging false 从本页加载
	},
	setParameter: function(key, value) {
		var that = this;
		if(key && value) {
			that.params[key] = value;
		} else if ($.isPlainObject(key)) {
			$.extend(that.params, key);
		} else {
			console.log("设置参数错误{'key': " + key + ", 'value': " + value + "}");
		}
	}
}