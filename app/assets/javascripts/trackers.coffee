# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

`
//
// JQuery for results.haml
//
var ready = function() {
  // Code to toggle display of checkboxes
  $(".glyphicon-th-list").click(function() {
    $(".checks ul").toggleClass("hide-list");
  });

  // Checboxes for column display
  $("input:checkbox:not(:checked)").each(function() {
    var column = $(".col" + this.className);
    $(column).hide();
  });

  $("input:checkbox").click(function(){
    $(this).removeClass("user-success")
    var column = $(".col" + this.className);
    $(column).toggle();
  });

  // Table sorting
  $('th').click(function(){
    var table = $(this).parents('table').eq(0)
    var rows = table.find('tr:gt(0)').toArray().sort(comparer($(this).index()))
    this.asc = !this.asc
    if (!this.asc){rows = rows.reverse()}
    for (var i = 0; i < rows.length; i++){table.append(rows[i])}
  });

  function comparer(index) {
    return function(a, b) {
        var valA = getCellValue(a, index), valB = getCellValue(b, index)
        return $.isNumeric(valA) && $.isNumeric(valB) ? valA - valB : valA.localeCompare(valB)
    }
  }

  function getCellValue(row, index){
    return $(row).children('td').eq(index).html()
  }
};

$(document).ready(ready);
$(document).on('page:load', ready);

`
