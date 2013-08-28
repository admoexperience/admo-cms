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
  $("abbr.timeago").timeago();
  });
