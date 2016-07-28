module HarbourCrane
  class Application
    # App Info
    VERSION          = '1.0.0.beta'
    NAME             = 'Harbour Crane'
    SLUG             = 'harbour-crane'
    APP_IMAGE_NAME   = 'harbour-crane:latest'
    DESCRIPTION      = 'Manage you apps through Docker containers.'

    # Directories
    DOCKER_DIR       = "#{ ENV['HOME'] }/#{ SLUG }"
    VOLUMES_DIR      = "#{ DOCKER_DIR }/volumes"
    COMPOSES_DIR     = "#{ DOCKER_DIR }/composes"
    PROXY_DIR        = "#{ DOCKER_DIR}/proxy"
    LOGS_DIR         = "#{ DOCKER_DIR}/logs"
    APP_DIR          = "#{ DOCKER_DIR }/app"
    TEMPLATE_DIR     = "public/templates"

    # Proxy
    PROXY_NAME       = 'Nginx Server'
    PROXY_IMAGE_NAME = 'jwilder/nginx-proxy:latest'

    # Date format
    DATE_FORMAT      = '%Y-%d-%m'
    TIME_FORMAT      = '%Y-%d-%m %H:%M:%S'


    class Glyph
      # Glyphs
      CONTAINER = 'cube'
      APP       = 'cloud'
      IMAGE     = 'camera'
      ABOUT     = 'info-circle'
      STORE     = 'shopping-cart'
    end
  end

end
