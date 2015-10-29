module App::Action

  def start
    #command 'start'
    system("COMPOSE_FILE=#{ compose_app_file(id) } /usr/local/bin/docker-compose rm --force")
    fu = "COMPOSE_FILE=#{ compose_app_file(id) } /usr/local/bin/docker-compose up"
    ap fu
    system(fu)
  end

  def stop
    command 'stop'
  end

  def restart
    command 'restart'
  end

  def destroy
    destroy_upstart_file
    destroy_compose_file
    destroy_app_file
  end

  private

  def command action
    func = "#{ action } #{ upstart_name }"
    ap func
    #system("sudo #{ action } #{ upstart_name }")
    if system(func)
      ap 'ca fonctionne'
      true
    else
      ap 'ca fonctionne po !!'
      errors.add(:system, "Command system '#{ func }' fail")
    end
  end

end
