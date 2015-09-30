module DockerManager
  class Application
    VERSION          = '1.0.0.beta'
    NAME             = 'Harbour Crane'
    DESCRIPTION      = 'Manage you apps through Docker containers.'
    COMPOSE_FILE_DIR = "#{ ENV['HOME'] }/docker"
    VOLUME_DIR       = "/srv/docker"
    UPSTART_DIR      = "/etc/init"


    class Glyph
      # Glyphs
      APP       = 'cube'
      CONTAINER = 'cloud'
      IMAGE     = 'camera'
    end
  end

end
