#
# JQuery for results.haml
#

ready = ->

  comparer = (index) ->
    (a, b) ->
      valA = getCellValue(a, index)
      valB = getCellValue(b, index)
      if $.isNumeric(valA) and $.isNumeric(valB) then valA - valB else valA.localeCompare(valB)

  getCellValue = (row, index) ->
    $(row).children('td').eq(index).html()

  # Code to toggle display of checkboxes
  $('.glyphicon-th-list').click ->
    $('.checks ul').toggleClass 'hide-list'
    return
  # Checboxes for column display
  $('input:checkbox:not(:checked)').each ->
    column = $('.col' + @className)
    $(column).hide()
    return
  $('input:checkbox').click ->
    $(this).removeClass 'user-success'
    column = $('.col' + @className)
    $(column).toggle()
    return
  # Table sorting
  $('th').click ->
    table = $(this).parents('table').eq(0)
    rows = table.find('tr:gt(0)').toArray().sort(comparer($(this).index()))
    @asc = !@asc
    if !@asc
      rows = rows.reverse()
    i = 0
    while i < rows.length
      table.append rows[i]
      i++
    return
  return

$(document).ready ready
$(document).on 'page:load', ready
