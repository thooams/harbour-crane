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
  end

  def parameterize text
    text.parameterize
  end

  def insert_text_in_slug_input
    app_name.on :keyup do |event|
      app_slug.value = parameterize event.element.value
    end
  end

  def parameterize_slug_input
    app_slug.on :input do |event|
      event.element.value = parameterize event.element.value
    end
  end

  def app_slug
    Element.id 'app_slug'
  end

  def app_name
    Element.id 'app_name'
  end

end
