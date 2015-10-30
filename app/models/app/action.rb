module App::Action

  def start
    rm
    system("#{ docker_compose_action } up -d")
    running!
  end

  def stop
    system("#{ docker_compose_action } stop")
    stopped!
  end

  def rm
    system("#{ docker_compose_action } rm --force")
  end

  def restart
    stop
    stopped!
    start
    running!
  end

  def destroy
    destroy_upstart_file
    destroy_compose_file
    destroy_app_file
  end

  private

  def docker_compose_action
    "COMPOSE_FILE=#{ compose_app_file(id) } /usr/local/bin/docker-compose"
  end

end
