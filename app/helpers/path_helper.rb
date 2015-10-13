module PathHelper

  # ~/harbour-crane/compose/app1/
  def compose_app_dir app_name
    "#{ HarbourCrane::Application::COMPOSE_DIR }/#{ app_name }"
  end

  # ~/harbour-crane/upstart/app1/
  def upstart_app_dir app_name
    "#{ HarbourCrane::Application::UPSTART_DIR }/#{ app_name }"
  end

  # ~/harbour-crane/app/app1/
  def app_dir app_name
    "#{ HarbourCrane::Application::APP_DIR }/#{ app_name }"
  end

  # ~/harbour-crane/compose/app1/docker-compose.yml
  def compose_app_file app_name
    "#{ compose_app_dir(app_name) }/docker-compose.yml"
  end

  # ~/harbour-crane/upstart/app1/upstart.conf
  def upstart_app_file app_name
    "#{ upstart_app_dir(app_name) }/upstart.conf"
  end

  # ~/harbour-crane/upstart/app1/app.yml
  def app_file app_name
    "#{ app_dir(app_name) }/app.yml"
  end

  # public/templates/file.erb
  def template_file file_name
    "#{ HarbourCrane::Application::TEMPLATE_DIR }/#{ file_name }"
  end

  # /var/log/harbour-crane/app1.log
  def log_app_file app_name
    "/var/log/#{ HarbourCrane::Application::SLUG }/#{ app_name }.log"
  end

end
