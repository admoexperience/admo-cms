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
  backgroundgrey: "#f1f1f2",
  blue: "#49a8de",
  white: "#ffffff"
}

// Donut charts
function drawDonuts(values) {
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
  var donuts = d3.select("#donut-charts").selectAll(".chart.donut")
      .data(values)
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
