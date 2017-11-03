var workflow = {
	nodes: {}
};
$(function() {
	var svg = d3.select("svg");
	// 绑定拖拽
	$('#left-wrapper .node').draggable({
	    helper: "clone",
	    addClass: false,
	    connectToSortable: "#idsw-bpmn",
	    start: function (e, ui) {
	        ui.helper.addClass("ui-draggable-helper");
	    },
	    stop: function (e, ui) {
	    	var node = {
	    		id: new Date().getTime(),
	    		dataId: ui.helper.attr('data-id'),
	    		x: ui.position.left - 250,
	    		y: ui.position.top - 40,
	    		text: ui.helper.text(),
	    		inputs: 1,
	    		outputs: 2
	    	};
	    	// 计算节点编号
	    	if(workflow.nodes[node.dataId]) {
	    		workflow.nodes[node.dataId] += 1;
	    	} else {
	    		workflow.nodes[node.dataId] = 1;
	    	}
	    	var g = addNode(svg, node);

			g.call(d3.drag()
			  	     .on("start", dragstarted)
			  	     .on("drag", dragged)
			  	     .on("end", dragended)
			);

			g.selectAll("circle.output").call(d3.drag()
				                      .on("start", linestarted)
				                      .on("drag", linedragged)
				                      .on("end", lineended)
			);

			g.selectAll("circle.input")
			 .on("mouseover", function() {
			 	if(drawLine) {
			 		d3.selectAll("circle.end").classed("end", false);
			 	    d3.select(this).classed("end", true);
			 	}
			 });
	    }
	});
});

var activeLine = null;
var points = [];
var translate = null;
var drawLine = false;
function linestarted() {
	drawLine = false;
	var node = d3.select(this.parentNode);
	var transform = node.attr("transform");
    translate = transform.substring(transform.indexOf("(")+1, transform.indexOf(")")).split(",");
	points.push([+d3.event.x + (+translate[0]), +d3.event.y + (+translate[1])]);
	activeLine = d3.select("svg")
	  .append("path")
	  .attr("class", "cable")
	  .attr("from", node.attr("id"))
	  .attr("output", d3.select(this).attr("output"))
	  .attr("marker-end", "url(#arrowhead)");
}

function linedragged() {
	drawLine = true;
	points[1] = [+d3.event.x + (+translate[0]), +d3.event.y + (+translate[1])];
	activeLine.attr("d", function() {
		return "M" + points[0][0] + "," + points[0][1]
        + "C" + points[0][0] + "," + (points[0][1] + points[1][1]) / 2
        + " " + points[1][0] + "," +  (points[0][1] + points[1][1]) / 2
        + " " + points[1][0] + "," + points[1][1];
	});
}

function lineended(d) {
	drawLine = false;
	var anchor = d3.selectAll("circle.end");
	if(anchor.empty()) {
		activeLine.remove();
	} else {
		anchor.classed("end", false);
		activeLine.attr("to", d3.select(anchor.node().parentNode).attr("id"));
		activeLine.attr("input", anchor.attr("input"));
	}
	activeLine = null;
	points.length = 0;
	translate = null;
}

var dx = 0;
var dy = 0;
function dragstarted() {
	var transform = d3.select(this).attr("transform");
    var translate = transform.substring(transform.indexOf("(")+1, transform.indexOf(")")).split(",");
    dx = d3.event.x - translate[0];
    dy = d3.event.y - translate[1];
}

function dragged() {
  d3.select(this).attr("transform", "translate(" + (d3.event.x - dx) + ", " + (d3.event.y - dy) + ")");
  // TODO 更新连接线
}

function dragended() {
	dx = dy = 0;
	
}

function addNode(svg, node) {
	var g = svg.append("g")
	           .attr("class", "node")
	           .attr("data-id", node.dataId)
	           .attr("id", node.id)
	           .attr("transform", 'translate(' + node.x + ', ' + node.y + ')');

	var rect = g.append("rect")
	 .attr("rx", 5)
	 .attr("ry", 5)
	 .attr("stroke-width", 2)
	 .attr("stroke", "#333")
	 .attr("fill", "#fff");

	var bound = rect.node().getBoundingClientRect();
	var width = bound.width;
	var height = bound.height;

	// text
	g.append("text")
	 .text(node.text)
	 .attr("x", width / 2)
	 .attr("y", height / 2)
	 .attr("dominant-baseline", "central") 
	 .attr("text-anchor", "middle");

	// left icon
	g.append('text')
	 .attr("x", 18)
	 .attr("y", height / 2)
	 .attr("dominant-baseline", "central") 
	 .attr("text-anchor", "middle")
	 .attr('font-family', 'FontAwesome')
		 .text('\uf1c0');

	// right icon
	g.append('text')
	 .attr("x", width - 18)
	 .attr("y", height / 2)
	 .attr("dominant-baseline", "central") 
	 .attr("text-anchor", "middle")
	 .attr('font-family', 'FontAwesome')
		 .text('\uf00c');

	// input circle
	var inputs = node.inputs || 0;
	for(var i = 0; i < inputs; i++) {
		g.append("circle")
	 	 .attr("class", "input")
	 	 .attr("input", i)
	     .attr("cx", width * (i + 1) / (inputs + 1))
	     .attr("cy", 0)
	     .attr("r", 5);
	}

	// output circle
	var outputs = node.outputs || 0;
	for(i = 0; i < outputs; i++) {
		g.append("circle")
		 .attr("output", i)
	 	 .attr("class", "output")
	     .attr("cx", width * (i + 1) / (outputs + 1))
	     .attr("cy", height)
	     .attr("r", 5);
	}

	return g;
}

function removeNode(id) {
	d3.selectAll("g.node[id='" + id + "']").remove();
}

function runNode(id) {

}