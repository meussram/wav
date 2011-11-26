$(document).ready(function() {
	// Onload we start with 800
	var defaultZoom = $(".default").attr("zoom");
	fetchData(defaultZoom);
	
	$(".zoom").click(function () {
		//setCurrent($(this));
		var plotpoints = $(this).attr("zoom");
		//resizeCanvas(plotpoints);
		fetchData(plotpoints);
	});
});

function setCurrent($e) {
//	$(".zoom")
}



function fetchData(plotpoints) {
	//resizeCanvas(plotpoints)
	var options = {
		lines: { 
			show: true,
			//steps:0.1,
			fill: false,
			fillColor: "rgb(0,0,0)",
			lineWidth: 1
			//fillColor: "rgb(0,0,0)"
		},
		selection: { mode: "x" },
		colors: "#000000",
		shadowSize: 0,
		points: { show: false },
		xaxis: { tickDecimals: 0, tickSize: 0 },
		legend: {
			show: true,
			labelFormatter: null,// or (fn: string, series object -> string)
			labelBoxBorderColor: "rgb(255,255,255)",
			//noColumns: number
			//position: "ne" or "nw" or "se" or "sw"
			//margin: number of pixels or [x margin, y margin]
			backgroundColor: null, //or color
			backgroundOpacity: 0,
			container: null,// or jQuery object/DOM element/jQuery expression
		},
		xaxis: { show: false},
		yaxis: { show: false},
		selection: { mode: "x" },
		grid: {
			show: false,
			color: "rgb(255,255,255)",
			backgroundColor: "rgb(255,255,255)",
			borderWidth: 0,
			borderColor: "rgb(255,255,255)"
		}
	};
	
	var data = [];
    var $placeholder = $("#placeholder");
	var url = window.location.pathname;
	url = url.split("/")[2];
	url = "/data/"+url+"."+ plotpoints +".json";
	//console.log(url);
	
	$.ajax({
        url: url,
        method: 'GET',
        dataType: 'json',
        success: onDataReceived,
		error: function(e){
			console.log(e);
		}
    });

	function onDataReceived(series) {
		data = [ series ];
        $.plot($placeholder, data, options);
	}
	
	$placeholder.bind("plotselected", function (event, ranges) {
        $("#selection").text(ranges.xaxis.from.toFixed(1) + " to " + ranges.xaxis.to.toFixed(1));

        var zoom = $("#zoom").attr("checked");
        if (zoom)
            plot = $.plot($placeholder, data,
                          $.extend(true, {}, options, {
                              xaxis: { min: ranges.xaxis.from, max: ranges.xaxis.to }
                          }));
    });

	$placeholder.bind("plotunselected", function (event) {
        $("#selection").text("");
    });
    
    var plot = $.plot($placeholder, data, options);

    $("#clearSelection").click(function () {
        plot.clearSelection();
    });
	
}