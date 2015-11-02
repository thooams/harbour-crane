module App::Aasm
  extend ActiveSupport::Concern

  included do
    include AASM

    RUNNING = :running
    STOPPED = :stopped
    STATES  = [RUNNING, STOPPED]

    aasm do
      state :stopped
      state :running

      event :run do
        transitions :from => :stopped, :to => :running
      end

      event :stop do
        transitions :from => :running, :to => :stopped
      end
    end

    def compose_start
      compose_rm
      system("#{ docker_compose_action } up -d")
      run!
    end

    def compose_stop
      system("#{ docker_compose_action } stop")
      stop!
    end

    def compose_rm
      system("#{ docker_compose_action } rm --force")
    end

    def compose_restart
      compose_stop
      stop!
      compose_start
      run!
    end

    private

    def docker_compose_action
      "COMPOSE_FILE=#{ compose_app_file(id) } /usr/local/bin/docker-compose"
    end

  end

end
