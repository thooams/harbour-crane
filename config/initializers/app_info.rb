module HarbourCrane
  class Application
    VERSION          = '1.0.0.beta'
    NAME             = 'Harbour Crane'
    SLUG             = 'harbour-crane'
    DESCRIPTION      = 'Manage you apps through Docker containers.'
    DOCKER_DIR       = "#{ ENV['HOME'] }/#{ SLUG }"
    COMPOSE_DIR      = "#{ DOCKER_DIR }/compose"
    UPSTART_DIR      = "#{ DOCKER_DIR }/upstart"
    APP_DIR          = "#{ DOCKER_DIR }/app"
    VOLUME_DIR       = "/srv/docker"
    INIT_DIR         = "/etc/init"
    TEMPLATE_DIR     = "public/templates"
    PROXY_IMAGE_NAME = 'jwilder/nginx-proxy:latest'
    APP_IMAGE_NAME   = 'harbour-crane:latest'


    class Glyph
      # Glyphs
      CONTAINER = 'cube'
      APP       = 'cloud'
      IMAGE     = 'camera'
      ABOUT     = 'info-circle'
    end
  end

end
