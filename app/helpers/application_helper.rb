module ApplicationHelper

  def glyph_and_text glyph_args, text
    "#{ glyph glyph_args } #{ text }".html_safe
  end

  # ~/harbour-crane/compose/app1/
  def compose_app_dir app_name
    "#{ DockerManager::Application::COMPOSE_DIR }/#{ app_name }"
  end

  # ~/harbour-crane/upstart/app1/
  def upstart_app_dir app_name
    "#{ DockerManager::Application::UPSTART_DIR }/#{ app_name }"
  end

  # ~/harbour-crane/compose/app1/docker-compose.yml
  def compose_app_file app_name
    "#{ compose_app_dir(app_name) }/docker-compose.yml"
  end

  # ~/harbour-crane/upstart/app1/upstart.conf
  def upstart_app_file app_name
    "#{ upstart_app_dir(app_name) }/upstart.conf"
  end

  # /var/log/harbour-crane/app1.log
  def log_app_file app_name
    "/var/log/#{ DockerManager::Application::SLUG }/#{ app_name }.log"
  end

  def version_array array
    array.map do |name|
      num = name.split('version').last.split('.').first
      ["version #{ num }", num]
    end
  end
end
