// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//= require jquery
//= require_tree .


function toggleDropdown(event) {
  $('.profile').toggleClass('expanded');
}
function dontClearDropdown(event) {
  event.stopPropagation();
}
function clearDropdown(event) {
  $('.profile').removeClass('expanded');
}

$(function() {
  $('body').on('click', clearDropdown);
  $('.profile').on('click', dontClearDropdown);
  $('.profile .expand').on('click', toggleDropdown);
})


// Colors
var colors = {
  darkgrey: "#404041",
  midgrey: "#808284",
  lightgrey2: "#bbbdc0",
  lightgrey: "#e6e7e8",
  backgroundgrey: "#f1f1f2",
  blue: "#49a8de",
  white: "#ffffff"
}

// Donut charts
function drawDonutCharts(data, elementId) {
  // Constructor functions and parameters
  var width = 80,
      height = 80,
      thickness = 8,
      radius = Math.min(width, height) / 2;

  var color = d3.scale.ordinal()
      .range([colors.backgroundgrey, colors.blue]);

  var arc = d3.svg.arc()
      .outerRadius(radius)
      .innerRadius(radius - thickness);

  var pie = d3.layout.pie()
      .sort(null)
      .value(function(d) { return d.percentage; });

  // Create <div> containers
  var donuts = d3.select(elementId).selectAll(".chart.donut")
      .data(data)
    .enter().append("div")
      .attr("class", "chart donut")

  // Add <svg> tags
  var svg = donuts.append("svg")
      .attr("width", width)
      .attr("height", height)
    .append("g")
      .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

  // Create <g> tags inside svg
  var g = svg.selectAll(".arc")
      .data(function(d) {
        return pie([ {percentage: (1-d.value)}, {percentage: d.value} ])
      })
    .enter().append("g")
      .attr("class", "arc");

  // Draw actual donut shapes
  g.append("path")
      .attr("d", arc)
      .style("fill", function(d, i) { return color(i); });

  // Add text inside donut
  var text = svg.append("text")
      .attr("dy", ".35em")
      .style("text-anchor", "middle")
      .text(function(d) { return Math.round(d.value*100) + "%" });

  // Add caption below chart
  donuts.append("p")
      .html(function(d) {return d.name});


  // }
};


// Funnel chart
function drawFunnelChart(data, elementId) {

  // Basic variables
  var n = data.length,
    stack = d3.layout.stack().offset("wiggle"),
    dataset = data.map(function(d, i) { return {x: i, y: d.value}; })
    layers0 = stack([ dataset ]);

  var completionRate = (100 * data[n-1].value / data[0].value).toFixed(1) + "%";

  var width = $(elementId).width(),
    columnWidth = width / n,
    height = 165,
    offset = 30;

  // d3 setup
  var x = d3.scale.linear()
      .domain([0, n - 1])
      .range([0, (n-1) * columnWidth]);

  var y = d3.scale.linear()
      .domain([0, d3.max(layers0, function(layer) { return d3.max(layer, function(d) { return d.y0 + d.y; }); })])
      .range([height - offset, 0 + offset]);

  var line = d3.svg.line()
      .x(function(d) { return d.x; })
      .y(function(d) { return d.y; })
      .interpolate("basis");

  var area = d3.svg.area()
      .x(function(d) { return x(d.x); })
      .y0(function(d) { return y(d.y0); })
      .y1(function(d) { return y(d.y0 + d.y); });

  // Make the SVG object
  var svg = d3.select(elementId).append("div")
      .attr("class", "chart funnel")
    .append("svg")
      .attr("width", width)
      .attr("height", height);

  // Completion rate text
  svg.append("text")
      .attr("dy", height - 30)
      .attr("dx", width )
      .style("text-anchor", "end")
      .attr("fill", colors.blue)
      .attr("font-size", "18")
      .text(completionRate)
  svg.append("text")
      .attr("dy", height - 15)
      .attr("dx", width )
      .style("text-anchor", "end")
      .attr("fill", colors.midgrey)
      .attr("font-size", "11")
      .text("Completion")
  svg.append("text")
      .attr("dy", height - 2)
      .attr("dx", width )
      .style("text-anchor", "end")
      .attr("fill", colors.midgrey)
      .attr("font-size", "11")
      .text("Rate")

  // Funnel shape
  var funnel = svg.selectAll("path")
      .data(layers0)
    .enter().append("path")
      .attr("d", area)
      .style("fill", colors.blue);

  // Write values over funnel
  var values = svg.selectAll(".number")
      .data(data)
    .enter().append("text")
      .attr("class", "number")
      .attr("dy", (height - 2*offset) / 2 + offset + 8)
      .attr("dx", function(d, i) { return (i + 0.5) * columnWidth })
      .style("text-anchor", "middle")
      .attr("font-size", "18")
      .style("fill", function(d, i) { return (i == n-1) ? colors.darkgrey : colors.white } )
      .text(function(d) { return d.value })

  // Stage names
  var names = svg.selectAll(".name")
      .data(data)
    .enter().append("text")
      .attr("class", "name")
      .attr("dy", 20)
      .attr("dx", function(d, i) { return (i + 0.5) * columnWidth })
      .style("text-anchor", "middle")
      .attr("font-size", "11")
      .attr("fill", colors.midgrey)
      .text(function(d) { return d.name })

  // Grid lines
  var lines = svg.selectAll(".line")
      .data(data)
    .enter().append("line")
      .attr("class", "line")
      .attr("x1", function(d,i) { return i*columnWidth; })
      .attr("y1", 0)
      .attr("x2", function(d,i) { return i*columnWidth; })
      .attr("y2", height)
      .attr("stroke", colors.lightgrey2)
      .attr("stroke-width", 1)
      .attr("stroke-dasharray", "4,4");
}

function drawBarChart(data, elementId) {

  var margin = {top: 20, right: 20, bottom: 30, left: 30},
      width = $(elementId).width() - margin.left - margin.right,
      height = 180 - margin.top - margin.bottom,
      barWidth = 16;

  var formatPercent = d3.format(".0%");

  var x = d3.scale.ordinal()
      .rangePoints([0, width], 1);

  var y = d3.scale.linear()
      .range([height, 0]);

  var labels = data.map(function(d) {return d.label});
  var xAxis = d3.svg.axis()
      .scale(x)
      .tickFormat(function(d) {return labels[d]})
      .tickPadding(10)
      .orient("bottom");

  var yAxis = d3.svg.axis()
      .scale(y)
      .ticks(5)
      .tickPadding(5)
      .orient("left");

  var svg = d3.select(elementId).append("div")
      .attr("class", "chart bar")
    .append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  x.domain(data.map(function(d, i) { return i; }));
  y.domain([0, d3.max(data, function(d) { return d.value; })]);

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)

  var gridPositions = y.ticks(5);
  svg.selectAll(".grid")
      .data(gridPositions.slice(1, gridPositions.length))
    .enter().append("line")
      .attr("class", "grid")
      .attr("x1", 0)
      .attr("x2", width)
      .attr("y1", y)
      .attr("y2", y)
      .style("stroke", "#ccc")
      .attr("stroke-dasharray", "1,4");

  svg.selectAll(".bar")
      .data(data)
    .enter().append("rect")
      .attr("class", function(d) { return d.bold ? "bar sunday" : "bar" })
      .attr("x", function(d, i) { return x(i)-barWidth/2; })
      .attr("width", barWidth)
      .attr("y", function(d) { return y(d.value); })
      .attr("height", function(d) { return height - y(d.value); });

  var line = d3.svg.line()
      .x(function(d, i) { return x(i); })
      .y(function(d) { return y(d.value); });
  svg.append("path")
      .attr("d", line(data))
      .attr("stroke", colors.blue)
      .attr("stroke-width", 2)
      .attr("fill", "none");

  svg.selectAll("circle")
      .data(data)
    .enter().append("circle")
      .attr("cx", function(d, i) { return x(i); })
      .attr("cy", function(d) { return y(d.value); })
      .attr("r", 4)
      .attr("stroke", colors.blue)
      .attr("stroke-width", 2)
      .attr("fill", colors.white);

  // <div class="tooltip">
  //   <strong>119</strong><span> ^ 11%</span><br />
  //   <em>Wed 3 Aug</em>
  // </div>
  var chart = $(elementId + ' .chart');
  var tooltip = $("<div class=\"tooltip\"><strong></strong> <span></span><br /><em></em></div>");
  chart.append(tooltip);

  $('svg', chart).on("mousemove", function(event) {
    var xPos = event.offsetX - margin.left - (0.5*width/data.length);
    var index = Math.round( (xPos / width) * data.length);
    index = Math.max(index, 0);
    index = Math.min(index, data.length-1);

    var datum = data[index];
    $('strong', tooltip).html(datum.value);
    var change = '';
    if (index > 0) {
      var previous = data[index-1].value;
      if (previous != 0) {
        change = Math.round(100 * (datum.value - previous) / previous);
        if (change == 0)
          change = '';
        else if (change > 0)
          change = '<span>^</span> ' + change + '%';
        else
          change = '<span class="upside-down">^</span> ' + Math.abs(change) + '%';
      }
    }
    $('span', tooltip).html(change);
    $('em', tooltip).html(datum.tooltip);

    tooltip.css({
      "left": Math.round(x(index)-barWidth/2) + "px",
      "top": Math.round(y(datum.value)) + "px"
    });

    var bars = $('rect.bar', chart);
    for (var i = 0; i < bars.length; i++) {
      var classString = bars.eq(i).attr("class")
      if (i == index) {
        if (classString.indexOf("hover") == -1)
          bars.eq(i).attr("class", classString + " hover");
      } else {
        bars.eq(i).attr("class", classString.replace(" hover", ""));
      }
    }
  });

}
