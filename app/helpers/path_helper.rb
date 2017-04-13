module PathHelper

  # ~/harbour-crane/compose/app1/
  def compose_app_dir app_name
    "#{ HarbourCrane::Application::COMPOSES_DIR }/#{ app_name }"
  end

  # ~/harbour-crane/app/app1/
  def app_dir app_name
    "#{ HarbourCrane::Application::APP_DIR }/#{ app_name }"
  end

  # ~/harbour-crane/compose/app-1/docker-compose.yml
  def compose_app_file app_slug_name
    "#{ compose_app_dir(app_slug_name) }/docker-compose.yml"
  end

  # ~/harbour-crane/upstart/app1/app.yml
  def app_file app_name
    "#{ app_dir(app_name) }/app.yml"
  end

  # public/templates/file.erb
  def template_file file_name
    "#{ HarbourCrane::Application::TEMPLATE_DIR }/#{ file_name }"
  end

  def nginx_template_file file_name
    "#{ nginx_template_dir }/#{ file_name }"
  end

  def nginx_template_dir
    "#{ HarbourCrane::Application::PROXY_DIR }/templates"
  end

  # ~/harbour-crane/logs/app-1.log
  def log_app_file app_slug_name
    "#{ log_app_dir(app_slug_name) }/production.log"
  end

  def log_app_dir app_slug_name
    "#{ HarbourCrane::Application::LOGS_DIR }/#{ app_slug_name }"
  end

  # ~/harbour-crane/volumes/app-1
  def volumes_app_dir app_slug_name
    "#{ HarbourCrane::Application::VOLUMES_DIR }/#{ app_slug_name }"
  end

end
