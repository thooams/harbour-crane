require 'jquery'
require 'opal'
require 'opal_ujs'
require 'active_support'
require 'ui_bibz'
require 'turbolinks'

Document.ready? do
  app = App.new
end

class App

  def initialize
    insert_text_in_slug_input
    parameterize_slug_input
    insert_volume_in_hidden_field
  end

  def parameterize text
    text.parameterize
  end

  def insert_text_in_slug_input
    app_name.on :keyup do |event|
      app_slug.value = parameterize event.element.value
      app_volumes_path.text = "/usr/srv/docker/#{ parameterize(event.element.value) }/storage :"
    end
  end

  def insert_volume_in_hidden_field
    app_volume_1.on :input do |event|
      app_volumes.value = write_volume
    end
    app_volume_2.on :input do |event|
      app_volumes.value = write_volume
    end
  end

  def write_volume
    "/usr/srv/docker/#{ app_volume_1.value }/storage:#{ app_volume_2.value }"
  end

  def parameterize_slug_input
    app_slug.on :input do |event|
      event.element.value = parameterize event.element.value
    end
  end

  def app_volumes
    Element.id('app_volumes')
  end

  def app_volume_1
    app_volumes.parent.parent.find('.volume_1').first
  end

  def app_volume_2
    app_volumes.parent.parent.find('.volume_2').first
  end

  def app_volumes_path
    app_volumes.siblings('.path').first
  end

  def app_slug
    Element.id 'app_slug'
  end

  def app_name
    Element.id 'app_name'
  end

end
