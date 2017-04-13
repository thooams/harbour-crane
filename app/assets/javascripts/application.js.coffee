#= require 'ui_bibz'

class Table

  constructor: ->
    # variables
    @select_all_checkbox = $('#select_all')
    @all_checkboxes      = $('td input[type=checkbox]')
    @delete_button       = $('#delete_btn')

    # functions
    @select_all_checkboxes()
    @delete_button_in_table()

  select_all_checkboxes: ->
    me = this
    @select_all_checkbox.on "click", () ->
      select_all_checkbox = $(this)
      me.all_checkboxes.each () ->
        $(this).prop('checked', select_all_checkbox.prop('checked'))

    @all_checkboxes.on "change", (event) ->
      me.select_all_checkbox.prop('checked', false) if $('#select_all').prop('checked')

  delete_button_in_table: ->
    console.log @delete_button.length > 0
    if @delete_button.length > 0
      @delete_button.on "click", (event) ->
        event.preventDefault()
        form = $('form')
        form.attr('action', $(this).attr('href'))
        form.submit()

class App

  constructor: ->
    # variables
    @app_name    = $('.app_name')
    @app_volumes = $('.app_volumes')
    @app_slug    = $('.app_slug')

    # functions
    @insert_text_in_slug_input()
    @parameterize_slug_input()
    @insert_volume_in_hidden_field()
    @add_tooltip_with_title()

  add_tooltip_with_title: ->
    console.log 'otot'
    $('.btn').each () ->
      $(this).attr('data-toggle', "tooltip") if $(this).attr('title')?

  parameterize: (text) ->
    text.parameterize

  insert_text_in_slug_input: ->
    if @app_slug.length > 0
      @app_name.on "keyup", (event) ->
        app_slug.value = parameterize event.element.value
        puts app_volumes_path
        app_volumes_path.attr "text", "/usr/srv/docker/#{ parameterize(event.element.value) }/storage :"

  insert_volume_in_hidden_field: ->
    if @app_volumes.length > 0
      @app_volume_1().on 'input', (event) ->
        @app_volumes.value = write_volume

      @app_volume_2().on 'input', (event) ->
        @app_volumes.value = write_volume

  write_volume: ->
    "/usr/srv/docker/#{ app_volume_1.value }/storage:#{ app_volume_2.value }"

  parameterize_slug_input: ->
    if @app_slug.length > 0
      @app_slug.on 'input', (event) ->
        event.element.value = parameterize event.element.value

  app_volume_1: ->
    @app_volumes.parent.parent.find('.volume_1').first

  app_volume_2: ->
    @app_volumes.parent.parent.find('.volume_2').first

  app_volumes_path: ->
    @app_volumes.find('.path').first

ready = ->
  new App
  new Table

$(document).ready(ready)
