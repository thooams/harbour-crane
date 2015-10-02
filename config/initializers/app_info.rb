module DockerManager
  class Application
    VERSION          = '1.0.0.beta'
    NAME             = 'Harbour Crane'
    SLUG             = 'harbour-crane'
    DESCRIPTION      = 'Manage you apps through Docker containers.'
    DOCKER_DIR       = "#{ ENV['HOME'] }/#{ SLUG }"
    COMPOSE_DIR      = "#{ DOCKER_DIR }/compose"
    UPSTART_DIR      = "#{ DOCKER_DIR }/upstart"
    VOLUME_DIR       = "/srv/docker"
    INIT_DIR         = "/etc/init"


    class Glyph
      # Glyphs
      APP       = 'cube'
      CONTAINER = 'cloud'
      IMAGE     = 'camera'
    end
  end

end
