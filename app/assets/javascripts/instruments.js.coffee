# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('#instrument_subcategory_id').parent().hide()
  subcategories = $("#instrument_subcategory_id").html()
  $("#instrument_category_id").change ->
    category = $("#instrument_category_id :selected").text()
    console.log(category)
    escaped_category = category.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(subcategories).filter("optgroup[label='#{escaped_category}']").html()
    console.log(options)
    if options
      $('#instrument_subcategory_id').html(options)
      $('#instrument_subcategory_id').parent().show()
    else
      $('#instrument_subcategory_id').empty()
      $('#instrument_subcategory_id').parent().hide()