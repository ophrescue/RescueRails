# Place all the behaviors and hooks related to the matching controller here.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#photos_sort').sortable
  	axis: 'y'
  	update: ->
  		$.post($(this).data('update-url'), $(this).sortable('serialize'))