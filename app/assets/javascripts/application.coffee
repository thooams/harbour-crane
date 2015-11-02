#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require ui_bibz

$(document).on 'ready page:load', ->

  $('#app_name').keyup ->
    $('#app_slug').val($(this).val().toLowerCase().replace(/[^a-z0-9]+/g,'-').replace(/(^-|-$)/g,''))
