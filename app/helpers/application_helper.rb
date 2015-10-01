module ApplicationHelper

  def glyph_and_text glyph_args, text
    "#{ glyph glyph_args } #{ text }".html_safe
  end

  def compose_app_dir app_name
    "#{ DockerManager::Application::DOCKER_DIR }/#{ app_name }/compose"
  end

  def upstart_app_dir app_name
    "#{ DockerManager::Application::DOCKER_DIR }/#{ app_name }/upstart"
  end

  def version_array array
    array.map do |name|
      num = name.split('version').last.split('.').first
      ["version #{ num }", num]
    end
  end
end
