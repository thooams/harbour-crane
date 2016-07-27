module HarbourCrane
  class Application
    VERSION          = '1.0.0.beta'
    NAME             = 'Harbour Crane'
    SLUG             = 'harbour-crane'
    DESCRIPTION      = 'Manage you apps through Docker containers.'
    DOCKER_DIR       = "#{ ENV['HOME'] }/#{ SLUG }"
    VOLUMES_DIR      = "#{ DOCKER_DIR }/volumes"
    COMPOSES_DIR     = "#{ DOCKER_DIR }/composes"
    PROXY_DIR        = "#{ DOCKER_DIR}/proxy"
    LOGS_DIR         = "#{ DOCKER_DIR}/logs"
    APP_DIR          = "#{ DOCKER_DIR }/app"
    TEMPLATE_DIR     = "public/templates"
    PROXY_IMAGE_NAME = 'jwilder/nginx-proxy:latest'
    APP_IMAGE_NAME   = 'harbour-crane:latest'
    DATE_FORMAT      = '%Y-%d-%m'
    TIME_FORMAT      = '%Y-%d-%m %H:%M:%S'


    class Glyph
      # Glyphs
      CONTAINER = 'cube'
      APP       = 'cloud'
      IMAGE     = 'camera'
      ABOUT     = 'info-circle'
    end
  end

end
